//! DDC/CI monitor control via `ddcutil`, with cross-process locking and caching.

use std::fs::OpenOptions;
use std::process::Command;
use std::thread;
use std::time::Duration;

use fs2::FileExt;

use crate::cache::Cache;
use crate::error::{AppError, Result};

const BRIGHTNESS_VCP: &str = "10";
const RETRIES: usize = 4;
const RETRY_DELAY: Duration = Duration::from_millis(350);

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct Monitor {
    pub display: u8,
    pub model: String,
}

#[derive(Debug, Clone, Copy, serde::Serialize, serde::Deserialize)]
pub struct Brightness {
    pub current: u16,
    pub max: u16,
}

impl Brightness {
    pub fn percent(&self) -> u8 {
        if self.max == 0 {
            return 0;
        }
        ((self.current as u32 * 100) / self.max as u32).min(100) as u8
    }
}

impl Monitor {
    pub fn fallback(display: u8) -> Self {
        Self {
            display,
            model: format!("Display {display}"),
        }
    }
}

pub fn cached_brightness(display: u8) -> Option<Brightness> {
    Cache::for_display(display)
        .ok()
        .and_then(|cache| cache.read().map(|payload| payload.brightness))
}

pub fn cached_monitor(display: u8) -> Option<Monitor> {
    Cache::for_display(display)
        .ok()
        .and_then(|cache| cache.read().map(|payload| payload.monitor))
}

/// Cached monitor + brightness without talking to the display.
pub fn cached_state(display: u8) -> (Monitor, Option<Brightness>) {
    (
        cached_monitor(display).unwrap_or_else(|| Monitor::fallback(display)),
        cached_brightness(display),
    )
}

pub fn monitor_label(display: u8) -> String {
    cached_monitor(display).map(|m| m.model).unwrap_or_else(|| {
        detect_monitors()
            .ok()
            .and_then(|monitors| {
                monitors
                    .into_iter()
                    .find(|m| m.display == display)
                    .map(|m| m.model)
            })
            .unwrap_or_else(|| format!("Display {display}"))
    })
}

pub fn detect_monitors() -> Result<Vec<Monitor>> {
    with_lock(0, || {
        retry(|| {
            let monitors = parse_monitors(&ddcutil(&["detect"])?)?;
            for monitor in &monitors {
                if let Ok(cache) = Cache::for_display(monitor.display) {
                    if let Ok(brightness) = read_vcp(monitor.display) {
                        let _ = cache.write(monitor, brightness);
                    }
                }
            }
            Ok(monitors)
        })
    })
}

pub fn get_brightness(display: u8) -> Result<Brightness> {
    with_lock(display, || {
        retry(|| {
            let brightness = read_vcp(display)?;
            let monitor = Monitor {
                display,
                model: monitor_label(display),
            };
            Cache::for_display(display)?.write(&monitor, brightness)?;
            Ok(brightness)
        })
    })
}

pub fn set_brightness(display: u8, value: u16) -> Result<()> {
    with_lock(display, || {
        retry(|| {
            ddcutil(&[
                "--display",
                &display.to_string(),
                "setvcp",
                BRIGHTNESS_VCP,
                &value.to_string(),
            ])?;
            if let Ok(cache) = Cache::for_display(display) {
                if let Some(payload) = cache.read() {
                    let _ = cache.write(
                        &payload.monitor,
                        Brightness {
                            current: value.min(payload.brightness.max),
                            max: payload.brightness.max,
                        },
                    );
                }
            }
            Ok(())
        })
    })
}

pub fn adjust_brightness(display: u8, delta: i32) -> Result<Brightness> {
    with_lock(display, || {
        retry(|| {
            let sign = if delta >= 0 { "+" } else { "-" };
            ddcutil(&[
                "--display",
                &display.to_string(),
                "setvcp",
                BRIGHTNESS_VCP,
                sign,
                &delta.unsigned_abs().to_string(),
            ])?;
            let brightness = read_vcp(display)?;
            let monitor = Monitor {
                display,
                model: monitor_label(display),
            };
            Cache::for_display(display)?.write(&monitor, brightness)?;
            Ok(brightness)
        })
    })
}

/// `ddcutil detect` for the CLI (`--json` or a one-line table).
pub fn run_detect(json: bool) -> i32 {
    match detect_monitors() {
        Ok(monitors) => {
            if json {
                match serde_json::to_string_pretty(&monitors) {
                    Ok(body) => println!("{body}"),
                    Err(err) => {
                        eprintln!("ddc-slider: serialize: {err}");
                        return 1;
                    }
                }
            } else if monitors.is_empty() {
                println!("No DDC/CI displays detected.");
            } else {
                for monitor in &monitors {
                    let brightness = cached_brightness(monitor.display)
                        .map(|b| format!("{}%", b.percent()))
                        .unwrap_or_else(|| "--".into());
                    println!(
                        "Display {}  {:<24}  brightness {brightness}",
                        monitor.display, monitor.model
                    );
                }
            }
            0
        }
        Err(err) => {
            eprintln!("ddc-slider: {err}");
            1
        }
    }
}

fn read_vcp(display: u8) -> Result<Brightness> {
    let output = ddcutil(&[
        "--display",
        &display.to_string(),
        "getvcp",
        BRIGHTNESS_VCP,
        "-t",
    ])?;
    parse_brightness(&output).map_err(|e| AppError::message(format!("display {display}: {e}")))
}

fn parse_monitors(output: &str) -> Result<Vec<Monitor>> {
    let mut monitors = Vec::new();
    let mut display = None;
    let mut model = String::new();

    for line in output.lines() {
        if let Some(num) = line.strip_prefix("Display ") {
            if let Some(d) = display.take() {
                monitors.push(Monitor {
                    display: d,
                    model: std::mem::take(&mut model),
                });
            }
            display = num.trim().parse().ok();
            model.clear();
        } else if let Some(name) = line.split("Model:").nth(1) {
            model = name.trim().to_string();
        }
    }

    if let Some(d) = display {
        monitors.push(Monitor { display: d, model });
    }

    if monitors.is_empty() {
        return Err(AppError::message("no DDC/CI displays detected"));
    }
    Ok(monitors)
}

fn parse_brightness(output: &str) -> Result<Brightness> {
    let line = output.lines().next().unwrap_or_default();
    let parts: Vec<&str> = line.split_whitespace().collect();
    if parts.len() >= 5 && parts[0] == "VCP" && parts[2] == "C" {
        let current = parts[3]
            .parse()
            .map_err(|e| AppError::message(format!("current brightness: {e}")))?;
        let max = parts[4]
            .parse()
            .map_err(|e| AppError::message(format!("max brightness: {e}")))?;
        return Ok(Brightness { current, max });
    }
    Err(AppError::message(format!(
        "unexpected ddcutil output: {line}"
    )))
}

fn ddcutil(args: &[&str]) -> Result<String> {
    let output = Command::new("ddcutil")
        .args(args)
        .output()
        .map_err(|e| AppError::message(format!("spawn ddcutil: {e}")))?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        let stdout = String::from_utf8_lossy(&output.stdout);
        return Err(AppError::message(format!(
            "ddcutil {} failed: {stderr}{stdout}",
            args.join(" ")
        )));
    }

    Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
}

fn with_lock<T>(display: u8, action: impl FnOnce() -> Result<T>) -> Result<T> {
    let file = if display == 0 {
        let path = crate::util::runtime_file("ddc-slider-ddc.lock");
        let file = OpenOptions::new()
            .create(true)
            .write(true)
            .truncate(false)
            .open(&path)
            .map_err(|e| AppError::io_at(&path, e))?;
        file.lock_exclusive()
            .map_err(|e| AppError::message(format!("acquire ddc lock: {e}")))?;
        file
    } else {
        Cache::for_display(display)?.acquire_lock()?
    };
    let result = action();
    let _ = file.unlock();
    result
}

fn retry<T>(mut action: impl FnMut() -> Result<T>) -> Result<T> {
    let mut last_err = None;
    for attempt in 0..RETRIES {
        match action() {
            Ok(value) => return Ok(value),
            Err(err) => {
                last_err = Some(err);
                if attempt + 1 < RETRIES {
                    thread::sleep(RETRY_DELAY);
                }
            }
        }
    }
    Err(last_err.unwrap())
}
