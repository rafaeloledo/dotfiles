{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    pamixer
    waybar
    grim
    slurp
    swaybg
    wl-clipboard
    hyprpicker
    wlogout
    hyprpaper

    mako
  ];
}
