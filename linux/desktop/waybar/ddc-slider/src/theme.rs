//! YoRHa palette aligned with waybar/style.css.

/// Semantic color roles for the shared brightness panel.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PanelRole {
    Background,
    Border,
    Title,
    Value,
    Hint,
    SliderTrack,
    SliderFill,
    SliderThumb,
    Stale,
    Error,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Theme {
    pub bg: String,
    pub border: String,
    pub fg: String,
    pub dim: String,
    pub accent: String,
    pub gold: String,
    pub critical: String,
}

impl Default for Theme {
    fn default() -> Self {
        Self {
            bg: "#13131a".into(),
            border: "#1d1d26".into(),
            fg: "#dcdce8".into(),
            dim: "#7a7a8e".into(),
            accent: "#4fc8c8".into(),
            gold: "#c8a86a".into(),
            critical: "#c04848".into(),
        }
    }
}

impl Theme {
    pub fn panel_color(&self, role: PanelRole) -> &str {
        match role {
            PanelRole::Background => &self.bg,
            PanelRole::Border => &self.border,
            PanelRole::Title => &self.fg,
            PanelRole::Value => &self.accent,
            PanelRole::Hint => &self.dim,
            PanelRole::SliderTrack => &self.dim,
            PanelRole::SliderFill => &self.accent,
            PanelRole::SliderThumb => &self.gold,
            PanelRole::Stale => &self.dim,
            PanelRole::Error => &self.critical,
        }
    }

    pub fn popup_css(&self) -> String {
        format!(
            r#"
window {{
    background-color: {bg};
    border: 1px solid {border};
    border-radius: 0;
}}
window:hover {{
    background-color: {bg};
}}
label {{
    font-family: "JetBrains Mono Nerd Font", "JetBrains Mono", monospace;
    font-size: 13px;
    background-color: transparent;
    padding: 0;
    margin: 0;
    min-height: 18px;
}}
label:hover {{
    background-color: transparent;
}}
label.header,
label.slider,
label.hint {{
    color: {fg};
}}
"#,
            bg = self.panel_color(PanelRole::Background),
            border = self.panel_color(PanelRole::Border),
            fg = self.panel_color(PanelRole::Title),
        )
    }
}
