local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

wezterm.on("gui-startup", function(cmd)
	local screen = wezterm.gui.screens().main
	local ratio = 0.7
	local width, height = screen.width * ratio, screen.height * ratio
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {
		position = { x = (screen.width - width) / 2, y = (screen.height - height) / 2 },
	})

	if wezterm.target_triple ~= "x86_64-pc-windows-msvc" then
		window:gui_window():toggle_fullscreen()
		return
	end

	window:gui_window():set_inner_size(width, height)
end)

config.enable_tab_bar = false -- toggle comment if want it
config.enable_wayland = false
config.font_size = 14
config.font = wezterm.font("BlexMono Nerd Font")
config.window_background_opacity = 0.9
config.enable_scroll_bar = false
config.initial_cols = 119
config.initial_rows = 36
config.default_cursor_style = "SteadyBar"

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:\\dev\\scoop\\apps\\pwsh\\current\\pwsh.exe", "-nologo" }
end

config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"

config.window_padding = {
	left = 0,
	right = 0,
	top = 1,
	bottom = 0,
}

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.Nop,
	},
}

return config
