------------------
---- MONITORS ----
------------------
hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@60", position = "auto", scale = 1.5 })
hl.monitor({ output = "DP-1",     mode = "1920x1080@144", position = "auto", scale = 1 })


---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "ghostty"
local fileManager = "nautilus"
local menu        = "hyprlauncher"


-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("nm-applet &")
    hl.exec_cmd("qs &")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE",    "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in     = 4,
        gaps_out    = 14,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 10,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = { enabled = true },

    dwindle = { preserve_split = true },
    master  = { new_status     = "master" },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },

    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",
        follow_mouse = 1,
        sensitivity  = -0.9,
        touchpad     = { natural_scroll = false },
    },
})

-- Animation curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}   } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })


----------------
---- INPUT  ----
----------------
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.device({ name = "epic-mouse-v1", sensitivity = -0.9 })


---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Dotfiles binds
hl.bind("PRINT",                      hl.dsp.exec_cmd("~/.local/scripts/print_screen"))
hl.bind(mainMod .. " + A",            hl.dsp.exec_cmd("ani-cli --rofi --vlc"))
hl.bind(mainMod .. " + SHIFT + A",    hl.dsp.exec_cmd("pavucontrol"))
hl.bind(mainMod .. " + B",            hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + O",            hl.dsp.exec_cmd("~/.local/scripts/extract_text"))
hl.bind(mainMod .. " + N",            hl.dsp.exec_cmd("flatpak run md.obsidian.Obsidian"))
hl.bind(mainMod .. " + SHIFT + S",    hl.dsp.exec_cmd("~/.local/scripts/print_area"))
hl.bind(mainMod .. " + T",            hl.dsp.exec_cmd("pamixer --default-source -t"))
hl.bind(mainMod .. " + W",            hl.dsp.exec_cmd("killall waybar || waybar"))
hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd("~/.local/scripts/nextworkspace"))
hl.bind(mainMod .. " + bracketleft",  hl.dsp.exec_cmd("~/.local/scripts/previousworkspace"))
hl.bind(mainMod .. " + page_up",      hl.dsp.exec_cmd("~/.local/scripts/previousworkspace"))
hl.bind(mainMod .. " + page_down",    hl.dsp.exec_cmd("~/.local/scripts/nextworkspace"))
hl.bind(mainMod .. " + F",            hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + D",            hl.dsp.window.float({ action = "toggle" }))
-- hl.bind(mainMod .. " + G",            hl.dsp.window.toggle_group())
-- hl.bind(mainMod .. " + Tab",          hl.dsp.cycle_next())
-- hl.bind(mainMod .. " + SHIFT + Tab",  hl.dsp.change_group_active("b"))

-- Focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S",          hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("ALT + C",                 hl.dsp.window.resize(), { mouse = true })

-- Multimedia
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer --increase 5 --set-limit 100"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer --decrease 5"),                   { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pamixer --toggle-mute"),                  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pamixer --default-source --toggle-mute"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),          { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),          { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
