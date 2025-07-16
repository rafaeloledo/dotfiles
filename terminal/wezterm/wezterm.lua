local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

config.font_size = 14
config.window_background_opacity = 1
config.enable_scroll_bar = false
config.enable_tab_bar = false
config.default_cursor_style = "SteadyBar"
config.window_background_opacity = 0.9

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:\\dev\\scoop\\apps\\pwsh\\current\\pwsh.exe", "-nologo" }
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
  { key = 'T', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'E', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'O', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'R', mods = 'CTRL|SHIFT', action = wezterm.action.ReloadConfiguration },
}

for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "ALT",
    action = wezterm.action.ActivateTab(i - 1)
  })
end

wezterm.on('window-config-reloaded', function(window, pane)
  local active = wezterm.gui.screens().active

  local overrides = {}

  if active.width == 3840 and active.height == 2160 then
    overrides.dpi = 385
    window:set_config_overrides(overrides)
  else
    overrides.dpi = 96
    window:set_config_overrides(overrides)
  end

end)

return config
