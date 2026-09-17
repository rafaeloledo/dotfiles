//! Waybar custom module JSON output and refresh signaling.

use crate::ddc::{self, Brightness, Monitor};
use anyhow::Result;
use serde::Serialize;
use std::process::Command;

/// Real-time signal configured in `config.jsonc` (`signal: 10`).
pub const SIGNAL: i32 = 10;

#[derive(Serialize)]
struct Output {
    text: String,
    tooltip: String,
    class: String,
    percentage: u8,
    alt: String,
}

/// Print one JSON line for the `custom/brightness` module.
pub fn print_status(display: u8) -> Result<()> {
    let monitor = Monitor {
        display,
        model: ddc::monitor_label(display),
    };

    match ddc::get_brightness(display) {
        Ok(brightness) => emit(&format_module(&monitor, &brightness, "ok")),
        Err(err) => {
            eprintln!("ddc-slider: {err:#}");
            emit(&Output {
                text: "󰃠 --".into(),
                alt: "unavailable".into(),
                tooltip: format!("{}\nBrightness unavailable", monitor.model),
                class: "unavailable".into(),
                percentage: 0,
            });
        }
    }
    Ok(())
}

/// Ask Waybar to re-run the module exec handler.
pub fn refresh() {
    let signal = format!("-RTMIN+{SIGNAL}");
    let _ = Command::new("pkill")
        .args([signal.as_str(), "waybar"])
        .status();
}

fn emit(output: &Output) {
    if let Ok(json) = serde_json::to_string(output) {
        println!("{json}");
    }
}

fn format_module(monitor: &Monitor, brightness: &Brightness, class: &str) -> Output {
    let percent = brightness.percent();
    Output {
        text: format!("{} {percent}%", icon(percent)),
        alt: monitor.model.clone(),
        tooltip: format!(
            "{}\nBrightness: {}% ({}/{})",
            monitor.model, percent, brightness.current, brightness.max
        ),
        class: class.into(),
        percentage: percent,
    }
}

fn icon(percent: u8) -> &'static str {
    match percent {
        0 => "󰃚",
        1..=25 => "󰃛",
        26..=50 => "󰃜",
        51..=75 => "󰃝",
        _ => "󰃠",
    }
}
