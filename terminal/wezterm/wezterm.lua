local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

config.enable_tab_bar = false
config.enable_wayland = false
config.font_size = 14
config.window_background_opacity = 0.9
config.enable_scroll_bar = false
config.initial_cols = 115
config.initial_rows = 30
config.default_cursor_style = "SteadyBar"

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:\\dev\\scoop\\apps\\pwsh\\current\\pwsh.exe", "-nologo" }
end

wezterm.on("gui-startup", function(cmd)
	local screen = wezterm.gui.screens().main
	local ratio = 0.7
	local width, height = screen.width * ratio, screen.height * ratio
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {
		position = { x = (screen.width - width) / 2, y = (screen.height - height) / 2 },
	})
	-- window:gui_window():maximize()
	window:gui_window():set_inner_size(width, height)
end)

config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.Nop,
	},
  {
    {
      key = "o",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SplitVertical,
    }
  }
}

-- config.keys = {
-- 	{
-- 		key = "Enter",
-- 		mods = "ALT",
-- 		action = wezterm.action.DisableDefaultAssignment,
-- 	},
-- }

return config
