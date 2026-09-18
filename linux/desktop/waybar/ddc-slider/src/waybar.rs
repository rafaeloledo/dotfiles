//! Waybar custom module: JSON on a pipe, pretty text on a TTY.

use std::io::{IsTerminal, Write};
use std::thread;
use std::time::Duration;

use crate::ddc::{self, Brightness, Monitor};
use crate::panel::{Panel, PanelInput};
use crate::theme::Theme;
use serde::Serialize;

/// Waybar refresh signal used by the sample module config (`signal: 10`).
const REFRESH_SIGNAL: &str = "-RTMIN+10";

/// Best-effort Waybar refresh. Failing is harmless when Waybar is not running.
pub fn request_refresh() {
    let _ = std::process::Command::new("pkill")
        .args([REFRESH_SIGNAL, "waybar"])
        .status();
}

#[derive(Debug, Clone, Serialize)]
pub struct WaybarOutput {
    pub text: String,
    pub tooltip: String,
    pub class: Class,
}

#[derive(Debug, Clone, Copy, Serialize, PartialEq, Eq)]
#[serde(rename_all = "lowercase")]
pub enum Class {
    Low,
    Mid,
    High,
    Critical,
    Unavailable,
    Stale,
}

impl WaybarOutput {
    fn to_json_line(&self) -> String {
        format!("{}\n", serde_json::to_string(self).unwrap_or_default())
    }

    fn unavailable(msg: &str) -> Self {
        Self {
            text: "󰃠 --".into(),
            tooltip: format!("Brightness unavailable\n{msg}"),
            class: Class::Unavailable,
        }
    }
}

/// Render brightness and print in the requested output mode. Always exits 0.
pub fn emit(display: u8, as_json: bool, watch: Option<u64>) -> i32 {
    if let Some(secs) = watch {
        return watch_loop(display, as_json, secs);
    }
    emit_once(display, as_json, &mut std::io::stdout());
    0
}

pub fn adjust(display: u8, delta: i32) -> anyhow::Result<()> {
    ddc::adjust_brightness(display, delta)?;
    request_refresh();
    Ok(())
}

pub fn set_percent(display: u8, percent: u8) -> anyhow::Result<()> {
    let brightness = ddc::get_brightness(display)?;
    let target = ((percent as u32 * brightness.max as u32) / 100).min(brightness.max as u32) as u16;
    ddc::set_brightness(display, target)?;
    request_refresh();
    Ok(())
}

fn watch_loop(display: u8, as_json: bool, secs: u64) -> i32 {
    let interval = Duration::from_secs(secs.max(1));
    let clear = std::io::stdout().is_terminal();
    loop {
        if clear {
            print!("\x1b[2J\x1b[H");
        }
        let _ = std::io::stdout().flush();
        emit_once(display, as_json, &mut std::io::stdout());
        println!();
        eprintln!("(re-rendering every {secs}s — press Ctrl-C to exit)");
        thread::sleep(interval);
    }
}

fn emit_once(display: u8, as_json: bool, out: &mut impl Write) {
    let output = build_output(display);
    if as_json {
        let _ = write!(out, "{}", output.to_json_line());
    } else {
        let _ = print_pretty(out, &output);
    }
}

fn build_output(display: u8) -> WaybarOutput {
    let theme = Theme::default();
    match ddc::get_brightness(display) {
        Ok(brightness) => {
            let (monitor, _) = ddc::cached_state(display);
            render(&monitor, &brightness, false, &theme)
        }
        Err(err) => {
            eprintln!("ddc-slider: {err}");
            let (monitor, brightness) = ddc::cached_state(display);
            brightness
                .map(|b| render(&monitor, &b, true, &theme))
                .unwrap_or_else(|| WaybarOutput::unavailable(&err.to_string()))
        }
    }
}

fn render(monitor: &Monitor, brightness: &Brightness, stale: bool, theme: &Theme) -> WaybarOutput {
    let percent = brightness.percent();
    let class = if stale {
        Class::Stale
    } else {
        severity_for_percent(percent)
    };

    let mut panel = Panel::build(PanelInput {
        monitor,
        brightness: Some(*brightness),
        stale,
        error: None,
    });
    panel.hint = format!("{}/{}", brightness.current, brightness.max);

    WaybarOutput {
        text: bar_text(brightness),
        tooltip: panel.tooltip_pango(theme),
        class,
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

fn severity_for_percent(percent: u8) -> Class {
    match percent {
        0 => Class::Critical,
        1..=15 => Class::High,
        16..=40 => Class::Mid,
        _ => Class::Low,
    }
}

fn bar_text(brightness: &Brightness) -> String {
    let percent = brightness.percent();
    format!("{} {percent}%", icon(percent))
}

fn print_pretty(w: &mut impl Write, out: &WaybarOutput) -> std::io::Result<()> {
    writeln!(w, "{}", pango_to_ansi(&out.text))?;
    writeln!(w)?;
    writeln!(w, "{}", pango_to_ansi(&out.tooltip))?;
    writeln!(w)?;
    let dim = "\x1b[2m";
    let reset = "\x1b[0m";
    writeln!(w, "{dim}class: {:?}{reset}", out.class)?;
    Ok(())
}

fn pango_to_ansi(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    let mut chars = s.chars().peekable();
    while let Some(c) = chars.next() {
        if c == '<' {
            let mut tag = String::new();
            for nc in chars.by_ref() {
                if nc == '>' {
                    break;
                }
                tag.push(nc);
            }
            apply_tag(&tag, &mut out);
        } else if c == '&' {
            if let Some(decoded) = decode_entity(&mut chars) {
                out.push(decoded);
            } else {
                out.push(c);
            }
        } else if c.is_control() && c != '\n' {
            if c == '\t' || c == '\r' {
                out.push(' ');
            }
        } else {
            out.push(c);
        }
    }
    out.push_str("\x1b[0m");
    out
}

fn decode_entity(chars: &mut std::iter::Peekable<std::str::Chars<'_>>) -> Option<char> {
    let mut lookahead = chars.clone();
    let mut entity = String::new();
    while let Some(c) = lookahead.next() {
        if c == ';' {
            let decoded = match entity.as_str() {
                "amp" => Some('&'),
                "lt" => Some('<'),
                "gt" => Some('>'),
                "quot" => Some('"'),
                "apos" => Some('\''),
                _ => None,
            };
            if decoded.is_some() {
                *chars = lookahead;
            }
            return decoded;
        }
        entity.push(c);
    }
    None
}

fn apply_tag(tag: &str, out: &mut String) {
    if tag.starts_with('/') {
        out.push_str("\x1b[0m");
        return;
    }
    let mut fg = None;
    let mut bold = false;
    for part in tag.split_whitespace() {
        if part == "b" || part.starts_with("font_weight='bold'") {
            bold = true;
        }
        if let Some(color) = part.strip_prefix("foreground='") {
            fg = color.strip_suffix('\'');
        }
    }
    if bold {
        out.push_str("\x1b[1m");
    }
    if let Some(hex) = fg {
        if let Some((r, g, b)) = parse_hex(hex) {
            out.push_str(&format!("\x1b[38;2;{r};{g};{b}m"));
        }
    }
}

fn parse_hex(hex: &str) -> Option<(u8, u8, u8)> {
    let hex = hex.strip_prefix('#').unwrap_or(hex);
    if hex.len() != 6 {
        return None;
    }
    let r = u8::from_str_radix(&hex[0..2], 16).ok()?;
    let g = u8::from_str_radix(&hex[2..4], 16).ok()?;
    let b = u8::from_str_radix(&hex[4..6], 16).ok()?;
    Some((r, g, b))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn strips_bold_span() {
        let out = pango_to_ansi("<b>LG ULTRAFINE</b>");
        assert!(out.contains("LG ULTRAFINE"));
    }
}
