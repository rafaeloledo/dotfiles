{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/desktop/interface".clock-show-seconds = true;
      "org/gnome/desktop/interface".clock-show-weekday = true;
      "org/gnome/desktop/notifications".show-banners = false;

      "org/gnome/desktop/wm/keybindings"."switch-input-source" = ["<Alt>Shift_L"];
      "org/gnome/desktop/wm/keybindings"."switch-input-source-backward" = [""];
      "org/gnome/desktop/wm/keybindings"."close" = ["<Super>Q"];
      "org/gnome/desktop/wm/keybindings"."panel-run-dialog" = ["<Super>R"];
      "org/gnome/shell/keybindings"."show-screenshot-ui" = ["<Shift><Super>s"];

      "org/gnome/shell/window-switcher".current-workspace-only = true;
      "org/gnome/shell/app-switcher".current-workspace-only = true;

      "org/gnome/desktop/wm/keybindings"."switch-to-workspace-right" = ["<Super>bracketright"];
      "org/gnome/desktop/wm/keybindings"."move-to-workspace-right" = ["<Shift><Super>bracketright"];
      "org/gnome/desktop/wm/keybindings"."switch-to-workspace-left" = ["<Super>bracketleft"];
      "org/gnome/desktop/wm/keybindings"."move-to-workspace-left" = ["<Shift><Super>bracketleft"];

      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
        show-hidden-files = true;
      };

      # current custom-keybindings in use
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };

      # folder `custom-keybindings` containing `custom0` field
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Open Nautilus";
        command = "nautilus";
        binding = "<Super>e";
      };
    };
  };
}
