//! Shared brightness panel — one visual model for the Waybar tooltip and GTK popup.

use crate::ddc::{Brightness, Monitor};
use crate::theme::{PanelRole, Theme};

/// Hint shown under the slider in the GTK popup.
pub const HINT: &str = "←/→ adjust · Esc to close";

/// Waybar scroll step and popup increment (VCP units).
pub const SCROLL_STEP: i32 = 5;

/// GTK popup window size (px).
pub const PANEL_WIDTH_PX: i32 = 336;
pub const PANEL_HEIGHT_PX: i32 = 88;

/// Inner content width (chars) — tooltip and popup lay out against this.
pub const PANEL_INNER_WIDTH: usize = 40;

/// Three-row snapshot shared by tooltip and popup.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Panel {
    pub title: String,
    pub value: String,
    pub hint: String,
    pub slider: SliderView,
    pub stale_note: Option<String>,
    pub error: Option<String>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct SliderView {
    pub percent: u8,
    pub current: u16,
    pub max: u16,
    pub available: bool,
}

pub struct PanelInput<'a> {
    pub monitor: &'a Monitor,
    pub brightness: Option<Brightness>,
    pub stale: bool,
    pub error: Option<&'a str>,
}

impl Panel {
    pub fn build(input: PanelInput<'_>) -> Self {
        Self {
            title: input.monitor.model.clone(),
            value: percent_label(input.brightness),
            hint: HINT.into(),
            slider: slider_view(input.brightness),
            stale_note: input.stale.then(|| "cached".into()),
            error: input.error.map(str::to_owned),
        }
    }

    /// Waybar / `--pretty` tooltip: same panel rows in a Pango box.
    pub fn tooltip_pango(&self, theme: &Theme) -> String {
        self.lines(PANEL_INNER_WIDTH).tooltip_pango(theme)
    }

    pub fn lines(&self, inner_width: usize) -> PanelLines {
        PanelLines {
            header: header_parts(self, inner_width),
            slider: slider_parts(self, inner_width),
            footer: footer_parts(self),
        }
    }
}

impl SliderView {
    /// Thumb index for a track `width` cells/units long.
    pub fn thumb_at(&self, width: usize) -> usize {
        if width == 0 {
            return 0;
        }
        if !self.available || self.max == 0 {
            return 0;
        }
        let fraction = self.current as f64 / self.max as f64;
        ((fraction * width as f64).round() as usize).min(width.saturating_sub(1))
    }
}

/// A styled fragment; GTK maps roles to Pango.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Part {
    pub text: String,
    pub role: PanelRole,
    pub bold: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PanelLines {
    pub header: Vec<Part>,
    pub slider: Vec<Part>,
    pub footer: Vec<Part>,
}

impl PanelLines {
    pub fn header_pango(&self, theme: &Theme) -> String {
        row_pango(&self.header, theme)
    }

    pub fn slider_pango(&self, theme: &Theme) -> String {
        row_pango(&self.slider, theme)
    }

    pub fn footer_pango(&self, theme: &Theme) -> String {
        row_pango(&self.footer, theme)
    }

    #[cfg(test)]
    fn header_text(&self) -> String {
        join_text(&self.header)
    }

    #[cfg(test)]
    fn slider_text(&self) -> String {
        join_text(&self.slider)
    }

    fn footer_text(&self) -> String {
        join_text(&self.footer)
    }

    /// Bordered Pango box (ai-usagebar tooltip style) around the three rows.
    pub fn tooltip_pango(&self, theme: &Theme) -> String {
        let inner = PANEL_INNER_WIDTH;
        let border = theme.panel_color(PanelRole::Border);
        let h = "─".repeat(inner);
        let edge = |ch: &str| format!("<span foreground='{border}'>{ch}</span>");
        let pad_footer = {
            let len = self.footer_text().chars().count();
            let pad = inner.saturating_sub(len);
            let spaces = " ".repeat(pad);
            let bg = theme.panel_color(PanelRole::Background);
            format!(
                "{}<span foreground='{bg}'>{spaces}</span>",
                self.footer_pango(theme)
            )
        };
        format!(
            "{top}\n{left}{header}{right}\n{left}{slider}{right}\n{left}{footer}{right}\n{bottom}",
            top = edge(&format!("╭{h}╮")),
            bottom = edge(&format!("╰{h}╯")),
            left = edge("│"),
            right = edge("│"),
            header = self.header_pango(theme),
            slider = self.slider_pango(theme),
            footer = pad_footer,
        )
    }
}

fn percent_label(brightness: Option<Brightness>) -> String {
    brightness
        .map(|b| format!("{}%", b.percent()))
        .unwrap_or_else(|| "--%".into())
}

fn slider_view(brightness: Option<Brightness>) -> SliderView {
    match brightness {
        Some(b) => SliderView {
            percent: b.percent(),
            current: b.current,
            max: b.max,
            available: true,
        },
        None => SliderView {
            percent: 0,
            current: 0,
            max: 100,
            available: false,
        },
    }
}

fn header_parts(panel: &Panel, inner_width: usize) -> Vec<Part> {
    let value_len = panel.value.chars().count();
    let title = truncate_end(
        &panel.title,
        inner_width.saturating_sub(value_len.saturating_add(1)),
    );
    let pad = inner_width.saturating_sub(title.chars().count() + value_len);
    vec![
        Part {
            text: title,
            role: PanelRole::Title,
            bold: true,
        },
        Part {
            text: " ".repeat(pad),
            role: PanelRole::Background,
            bold: false,
        },
        Part {
            text: panel.value.clone(),
            role: PanelRole::Value,
            bold: true,
        },
    ]
}

fn slider_parts(panel: &Panel, width: usize) -> Vec<Part> {
    if width == 0 {
        return Vec::new();
    }
    if !panel.slider.available {
        return vec![Part {
            text: "─".repeat(width),
            role: PanelRole::SliderTrack,
            bold: false,
        }];
    }

    let thumb = panel.slider.thumb_at(width);
    let mut parts = Vec::new();
    if thumb > 0 {
        parts.push(Part {
            text: "━".repeat(thumb),
            role: PanelRole::SliderFill,
            bold: false,
        });
    }
    parts.push(Part {
        text: "●".into(),
        role: PanelRole::SliderThumb,
        bold: false,
    });
    let rest = width.saturating_sub(thumb + 1);
    if rest > 0 {
        parts.push(Part {
            text: "─".repeat(rest),
            role: PanelRole::SliderTrack,
            bold: false,
        });
    }
    parts
}

fn footer_parts(panel: &Panel) -> Vec<Part> {
    let mut parts = vec![Part {
        text: panel.hint.clone(),
        role: PanelRole::Hint,
        bold: false,
    }];
    if let Some(note) = &panel.stale_note {
        parts.push(Part {
            text: "  ".into(),
            role: PanelRole::Hint,
            bold: false,
        });
        parts.push(Part {
            text: note.clone(),
            role: PanelRole::Stale,
            bold: false,
        });
    }
    if let Some(err) = &panel.error {
        parts.push(Part {
            text: "\n".into(),
            role: PanelRole::Hint,
            bold: false,
        });
        parts.push(Part {
            text: err.clone(),
            role: PanelRole::Error,
            bold: false,
        });
    }
    parts
}

fn row_pango(parts: &[Part], theme: &Theme) -> String {
    parts
        .iter()
        .map(|part| {
            let color = theme.panel_color(part.role);
            let text = escape_pango(&part.text);
            if part.bold {
                format!("<span foreground='{color}' font_weight='bold'>{text}</span>")
            } else {
                format!("<span foreground='{color}'>{text}</span>")
            }
        })
        .collect()
}

fn join_text(parts: &[Part]) -> String {
    parts.iter().map(|p| p.text.as_str()).collect()
}

fn escape_pango(text: &str) -> String {
    text.replace('&', "&amp;")
        .replace('<', "&lt;")
        .replace('>', "&gt;")
}

fn truncate_end(text: &str, max: usize) -> String {
    if text.chars().count() <= max {
        return text.to_string();
    }
    if max <= 1 {
        return "…".to_string();
    }
    let head: String = text.chars().take(max - 1).collect();
    format!("{head}…")
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample() -> Panel {
        Panel {
            title: "LG ULTRAFINE".into(),
            value: "60%".into(),
            hint: HINT.into(),
            slider: SliderView {
                percent: 60,
                current: 60,
                max: 100,
                available: true,
            },
            stale_note: None,
            error: None,
        }
    }

    #[test]
    fn build_matches_display_helpers() {
        let monitor = Monitor {
            display: 1,
            model: "Test Display".into(),
        };
        let brightness = Brightness {
            current: 60,
            max: 100,
        };
        let panel = Panel::build(PanelInput {
            monitor: &monitor,
            brightness: Some(brightness),
            stale: false,
            error: None,
        });
        assert_eq!(panel.title, "Test Display");
        assert_eq!(panel.value, "60%");
        assert_eq!(panel.hint, HINT);
        assert_eq!(panel.slider.percent, 60);
    }

    #[test]
    fn slider_thumb_uses_raw_fraction_not_percent_rounding() {
        let slider = SliderView {
            percent: 60,
            current: 3,
            max: 5,
            available: true,
        };
        assert_eq!(slider.thumb_at(10), 6);
    }

    #[test]
    fn lines_match_three_row_panel() {
        let lines = sample().lines(40);
        assert!(lines.header_text().starts_with("LG ULTRAFINE"));
        assert!(lines.header_text().ends_with("60%"));
        assert_eq!(lines.header_text().chars().count(), 40);
        assert_eq!(lines.slider_text().chars().count(), 40);
        assert!(lines.slider_text().contains('●'));
        assert!(lines.footer[0].text.contains("adjust"));
    }

    #[test]
    fn slider_pango_uses_theme_roles() {
        let theme = Theme::default();
        let pango = sample().lines(40).slider_pango(&theme);
        assert!(pango.contains("●"));
        assert!(pango.contains(theme.panel_color(PanelRole::SliderFill)));
        assert!(pango.contains(theme.panel_color(PanelRole::SliderThumb)));
    }

    #[test]
    fn tooltip_is_a_bordered_box() {
        let mut panel = sample();
        panel.hint = "60/100".into();
        let out = panel.lines(40).tooltip_pango(&Theme::default());
        assert!(out.contains("╭"));
        assert!(out.contains("╰"));
        assert!(out.contains("LG ULTRAFINE"));
        assert!(out.contains("60%"));
        assert!(out.contains("●"));
    }
}
