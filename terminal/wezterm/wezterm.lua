local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

config.enable_wayland = false
config.font_size = 14
config.window_background_opacity = 1
config.enable_scroll_bar = false
config.initial_cols = 115
config.initial_rows = 30
config.default_cursor_style = "SteadyBar"

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "D:\\dev\\scoop\\apps\\pwsh\\current\\pwsh.exe", "-nologo" }
end

-- wezterm.on("gui-startup", function(cmd)
-- 	local screen = wezterm.gui.screens().main
-- 	local ratio = 0.7
-- 	local width, height = screen.width * ratio, screen.height * ratio
-- 	local tab, pane, window = wezterm.mux.spawn_window(cmd or {
-- 		position = { x = (screen.width - width) / 2, y = (screen.height - height) / 2 },
-- 	})
-- 	-- window:gui_window():maximize()
-- 	window:gui_window():set_inner_size(width, height)
-- end)

config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.keys = {
  -- Existing bindings
  { key = 'T', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  -- New bindings
  { key = 'E', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'O', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
}

return config
