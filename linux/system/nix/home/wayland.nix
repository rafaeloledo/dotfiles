{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    pamixer
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
