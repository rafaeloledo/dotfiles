{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    pavucontrol
    pamixer
    waybar
    grim
    slurp
    swaybg
    anyrun
    wl-clipboard
    hyprpicker
    wlogout
    hyprpaper
  ];

  wayland.windowManager.hyprland  = {
    enable = false;
    extraConfig = ''
      monitor=eDP-1, 1920x1080@144, 0x0, 1
      monitor=HDMI-A-1, 1920x1080@120, 1920x0, 1

      exec-once = dunst
      exec-once = sleep 2 & emacs --daemon & dunstify "Started emacs daemon"

      exec = sleep 1 & randwall & dunstify "Set a random background"
      exec = toggle_inner_display_automatically & dunstify "Toggled inner display"

      windowrulev2 = workspace 1, class:(firefox)
      windowrulev2 = workspace 2, class:(Emacs)
      windowrulev2 = workspace 3, title:(wezterm)
      windowrulev2 = workspace 4, class:(android-studio) # TODO
      windowrulev2 = workspace 5, class:(scrcpy) # TODO
      windowrulev2 = workspace 6, class:(com.obsproject.Studio)

      general { 
          gaps_in = 1
          gaps_out = 0
          border_size = 1
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)
          resize_on_border = false 
          allow_tearing = false
          layout = dwindle
      }

      decoration {
          rounding = 0
          active_opacity = 1
          inactive_opacity = 1
          drop_shadow = false
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
          blur {
              enabled = false
              size = 3
              passes = 1
              vibrancy = 0.1696
          }
      }

      animations {
          enabled = false
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
      }

      master {
          new_is_master = true
      }

      misc { 
          force_default_wallpaper = 0
          disable_hyprland_logo = true 
      }

      input {
          kb_layout = us, br
          kb_variant =
          kb_model =
          kb_options = grp:alt_shift_toggle
          kb_rules =
          follow_mouse = 1
          sensitivity = 0 # defaults for touchpad usage without external mouse
          touchpad {
              natural_scroll = true
          }
      }

      gestures {
          workspace_swipe = false
      }

      device {
          name = epic-mouse-v1
          sensitivity = -1
      }

      # windowrule = float, ^(kitty)$
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

      windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.

      $mainMod = ALT 

      bind = $mainMod, Return, exec, wezterm start --always-new-process
      bind = $mainMod, Q, killactive,
      # bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, pkill thunar || thunar
      # bind = $mainMod, R, exec, killall .anyrun-wrapped || anyrun
      bind = $mainMod, R, exec, pkill rofi || rofi -show run
      # bind = $mainMod, P, pseudo, # dwindle
      # bind = $mainMod, J, togglesplit, # dwindle
      bind = $mainMod, B, exec, firefox
      bind = SUPER, h, exec, current_datetime
      bind = $mainMod, F, fullscreen
      bind = SUPER_SHIFT, P, exec, select_wallpaper
      bind = SUPER_SHIFT, Q, exec, wlogout
      bind = SUPER_SHIFT, S, exec, screenshtarea
      bind = $mainMod, SPACE, togglefloating
      # bind = $mainMod, w, exec, rofi -show window
      bind = SUPER_SHIFT, W, exec, pkill waybar || waybar
      bind = SUPER, e, exec, emacsclient -c -a ""

      bind = ALT, 1, workspace, 1
      bind = ALT, 2, workspace, 2
      bind = ALT, 3, workspace, 3
      bind = ALT, 4, workspace, 4
      bind = ALT, 5, workspace, 5
      bind = ALT, 6, workspace, 6
      bind = ALT, 7, workspace, 7
      bind = ALT, 8, workspace, 8
      bind = ALT, 9, workspace, 9
      bind = ALT, 0, workspace, 10

      bind = SUPER_SHIFT, 1, movetoworkspace, 1
      bind = SUPER_SHIFT, 2, movetoworkspace, 2
      bind = SUPER_SHIFT, 3, movetoworkspace, 3
      bind = SUPER_SHIFT, 4, movetoworkspace, 4
      bind = SUPER_SHIFT, 5, movetoworkspace, 5
      bind = SUPER_SHIFT, 6, movetoworkspace, 6
      bind = SUPER_SHIFT, 7, movetoworkspace, 7
      bind = SUPER_SHIFT, 8, movetoworkspace, 8
      bind = SUPER_SHIFT, 9, movetoworkspace, 9
      bind = SUPER_SHIFT, 0, movetoworkspace, 10

      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      bind = ALT CTRL, left, resizeactive, -50 0
      bind = ALT CTRL, right, resizeactive, 50 0
      bind = ALT CTRL, up, resizeactive, 0 -50
      bind = ALT CTRL, down, resizeactive, 0 50

      bind = ALT, Tab, cyclenext,
      bind = ALT, Tab, bringactivetotop,

      windowrulev2 = float, class:(Rofi)
      windowrulev2 = float, class:^(org.wezfurlong.wezterm)$
      windowrulev2 = tile, class:^(org.wezfurlong.wezterm)$
    '';
  };
}
