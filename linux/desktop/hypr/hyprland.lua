local tablet_active = hl.get_monitor("TABLET") ~= nil

if tablet_active then
    hl.monitor({
        output   = "TABLET",
        mode     = "3200x2136@120",
        position = "0x0",
        scale    = 1.6,
        mirror   = "",
        disabled = false,
    })
    hl.monitor({
        output   = "DP-1",
        disabled = true,
    })
else
    hl.monitor({
        output   = "DP-1",
        mode     = "3840x2160@60",
        position = "0x0",
        scale    = 1.5,
        mirror   = "",
        disabled = false,
    })
end

hl.device({
    name   = "touch-passthrough-1",
    output = "TABLET",
})

hl.device({
    name   = "mouse-passthrough-(absolute)",
    output = "TABLET",
})

hl.device({
    name   = "touch-passthrough",
    output = "TABLET",
})

hl.device({
    name   = "pen-passthrough",
    output = "TABLET",
})

local terminal    = "ghostty"
local fileManager = "nautilus"
local menu        = "rofi -show run"

hl.on("hyprland.start", function()
    hl.exec_cmd("killall ddc-slider 2>/dev/null; killall waybar 2>/dev/null; waybar")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP && systemctl --user restart apollo.service")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal")
end)

hl.env("XCURSOR_SIZE",    "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    general = {
        gaps_in     = 1,
        gaps_out    = 1,
        border_size = 1,
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

    animations = { enabled = false },

    dwindle = { preserve_split = true },
    master  = { new_status     = "master" },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
        key_press_enables_dpms  = true,
        mouse_move_enables_dpms = true,
    },

    input = {
        kb_layout    = "us,br",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "grp:alt_shift_toggle,ctrl:nocaps",
        kb_rules     = "",
        follow_mouse = 1,
        sensitivity  = -0.7,
        touchpad     = { natural_scroll = false },
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

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


hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.bind("ALT + Q", hl.dsp.exec_cmd(terminal))
hl.bind("ALT + C", hl.dsp.window.close())
hl.bind("ALT + ESCAPE", hl.dsp.exec_cmd("makoctl dismiss --all"))
hl.bind("ALT + M", hl.dsp.exit())
hl.bind("ALT + E", hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("ALT + R", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + A",            hl.dsp.exec_cmd("ani-cli --rofi --vlc"))
hl.bind("ALT + SHIFT + A",    hl.dsp.exec_cmd("pavucontrol"))
hl.bind("ALT + B",            hl.dsp.exec_cmd("brave"))
-- hl.bind("SUPER + B",            hl.dsp.exec_cmd("google-chrome-stable"))
hl.bind("ALT + O", hl.dsp.exec_cmd("~/.local/scripts/extract_text"), { release = true, dont_inhibit = true })
hl.bind("SUPER + N",            hl.dsp.exec_cmd("flatpak run md.obsidian.Obsidian"))
hl.bind("SUPER + SHIFT + S",    hl.dsp.exec_cmd('mkdir -p ~/Screenshots && geom=$(slurp) && [ -n "$geom" ] && grim -g "$geom" - | tee ~/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png | wl-copy'))
hl.bind("SUPER + T",            hl.dsp.exec_cmd("pamixer --default-source -t"))
hl.bind("SUPER + W",            hl.dsp.exec_cmd("killall -SIGUSR1 waybar || waybar"))
hl.bind("SUPER + tab",           hl.dsp.focus({ workspace = "previous" }))
hl.bind("ALT + bracketright", hl.dsp.exec_cmd("~/.local/scripts/nextworkspace"))
hl.bind("ALT + bracketleft",  hl.dsp.exec_cmd("~/.local/scripts/previousworkspace"))
hl.bind("ALT + page_up",      hl.dsp.exec_cmd("~/.local/scripts/previousworkspace"))
hl.bind("ALT + page_down",    hl.dsp.exec_cmd("~/.local/scripts/nextworkspace"))
hl.bind("SUPER + left",         hl.dsp.exec_cmd("~/.local/scripts/previousworkspace"))
hl.bind("SUPER + right",        hl.dsp.exec_cmd("~/.local/scripts/nextworkspace"))
hl.bind("SUPER + up",           hl.dsp.exec_cmd("~/.local/scripts/previousworkspace"))
hl.bind("SUPER + down",         hl.dsp.exec_cmd("~/.local/scripts/nextworkspace"))
hl.bind("SUPER + F",            hl.dsp.window.fullscreen())
hl.bind("SUPER + D",            hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
-- hl.bind("ALT + ALT + L", hl.dsp.exec_cmd("~/.local/scripts/lock-screen"))
hl.bind("SUPER + SHIFT + P",                      hl.dsp.exec_cmd("grim - | wl-copy"))


for i = 1, 10 do
    local key = i % 10
    hl.bind("ALT + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind("ALT + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + S",          hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind("ALT + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("ALT + C",                 hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer --increase 5 --set-limit 100"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer --decrease 5"),                   { locked = true, repeating = true })
hl.bind("SUPER + SHIFT + D",     hl.dsp.exec_cmd("pamixer --default-source --toggle-mute"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("~/.local/scripts/monitor-brightness up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("~/.local/scripts/monitor-brightness down"), { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


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

hl.bind("CTRL + ALT + S",     hl.dsp.pass({ window = "class:com\\.obsproject\\.Studio" }))
hl.bind("Control_L",          hl.dsp.pass({ window = "class:discord" }))
hl.bind("Control_R",          hl.dsp.pass({ window = "class:discord" }))
