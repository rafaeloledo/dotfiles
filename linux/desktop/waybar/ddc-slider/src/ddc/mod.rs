//! DDC/CI monitor control via `ddcutil`, with cross-process locking and caching.

mod cache;

use anyhow::{bail, Context, Result};
use fs2::FileExt;
use std::fs::OpenOptions;
use std::process::Command;
use std::thread;
use std::time::Duration;

use crate::util::runtime_file;

pub use cache::{brightness as cached_brightness, monitor_name as cached_monitor_name};
pub use cache::{store_brightness, store_monitors};

const BRIGHTNESS_VCP: &str = "10";
const RETRIES: usize = 4;
const RETRY_DELAY: Duration = Duration::from_millis(350);
const LOCK_FILE: &str = "ddc-slider-ddc.lock";

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

/// Resolve a display label from cache, live detect, or a generic fallback.
pub fn monitor_label(display: u8) -> String {
    cached_monitor_name(display).unwrap_or_else(|| {
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
    with_lock(|| {
        retry(|| {
            let monitors = parse_monitors(&ddcutil(&["detect"])?)?;
            store_monitors(&monitors);
            Ok(monitors)
        })
    })
}

pub fn get_brightness(display: u8) -> Result<Brightness> {
    with_lock(|| {
        retry(|| {
            let brightness = read_vcp(display)?;
            store_brightness(display, brightness);
            Ok(brightness)
        })
    })
}

pub fn set_brightness(display: u8, value: u16) -> Result<()> {
    with_lock(|| {
        retry(|| {
            ddcutil(&[
                "--display",
                &display.to_string(),
                "setvcp",
                BRIGHTNESS_VCP,
                &value.to_string(),
            ])?;
            if let Some(prev) = cached_brightness(display) {
                store_brightness(
                    display,
                    Brightness {
                        current: value.min(prev.max),
                        max: prev.max,
                    },
                );
            }
            Ok(())
        })
    })
}

pub fn adjust_brightness(display: u8, delta: i32) -> Result<Brightness> {
    with_lock(|| {
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
            store_brightness(display, brightness);
            Ok(brightness)
        })
    })
}

fn read_vcp(display: u8) -> Result<Brightness> {
    let output = ddcutil(&[
        "--display",
        &display.to_string(),
        "getvcp",
        BRIGHTNESS_VCP,
        "-t",
    ])?;
    parse_brightness(&output).with_context(|| format!("parse brightness for display {display}"))
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
        bail!("no DDC/CI displays detected");
    }
    Ok(monitors)
}

fn parse_brightness(output: &str) -> Result<Brightness> {
    let line = output.lines().next().unwrap_or_default();
    let parts: Vec<&str> = line.split_whitespace().collect();
    if parts.len() >= 5 && parts[0] == "VCP" && parts[2] == "C" {
        return Ok(Brightness {
            current: parts[3].parse().context("current brightness")?,
            max: parts[4].parse().context("max brightness")?,
        });
    }
    bail!("unexpected ddcutil output: {line}");
}

fn ddcutil(args: &[&str]) -> Result<String> {
    let output = Command::new("ddcutil")
        .args(args)
        .output()
        .context("spawn ddcutil")?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        let stdout = String::from_utf8_lossy(&output.stdout);
        bail!("ddcutil {} failed: {stderr}{stdout}", args.join(" "));
    }

    Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
}

fn with_lock<T>(action: impl FnOnce() -> Result<T>) -> Result<T> {
    let file = OpenOptions::new()
        .create(true)
        .write(true)
        .open(runtime_file(LOCK_FILE))
        .context("open ddc lock file")?;
    file.lock_exclusive().context("acquire ddc lock")?;
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
