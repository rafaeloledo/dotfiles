{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
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
}
