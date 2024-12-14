{ inputs, pkgs, ... }:
{
  imports = [
    ./config.nix
    # ./hyprland.nix
  ];

  wayland.windowManager.hyprland = {
    enable = false;
  };

}
