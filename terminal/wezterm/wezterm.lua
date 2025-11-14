local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:\\dev\\scoop\\apps\\pwsh\\current\\pwsh.exe", "-nologo" }
end

config.font_size = 12
config.window_background_opacity = 1
config.enable_scroll_bar = false
config.enable_tab_bar = false
config.default_cursor_style = "SteadyBar"
config.window_background_opacity = 0.9
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.keys = {
  { key = 'T', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'E', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'O', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'R', mods = 'CTRL|SHIFT', action = wezterm.action.ReloadConfiguration },
}

return config
