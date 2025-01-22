{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    pamixer
    waybar
    grim
    slurp
    ags
    swaybg
    anyrun
    wl-clipboard
    hyprpicker
    wlogout
    hyprpaper
  ];
}
