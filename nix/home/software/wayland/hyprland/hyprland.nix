{inputs, pkgs, ...}: {
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
}
