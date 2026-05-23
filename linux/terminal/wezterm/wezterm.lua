local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:\\scoop\\shims\\nu.exe" }
end

config.font_size = 12
config.initial_cols = 140
config.initial_rows = 38
config.window_background_opacity = 1
config.enable_scroll_bar = false
config.enable_tab_bar = false
config.default_cursor_style = "SteadyBar"
config.cursor_blink_rate = 0
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 1

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.keys = {
	{ key = "T", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "E", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "O", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "R", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
}

return config
