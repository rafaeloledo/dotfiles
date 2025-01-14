{ config, pkgs, ... }:

{
  imports = [
    ./tools
    ./wayland
    ./browsers
    ./xorg
    ./lsp
  ];


  home.packages = with pkgs; [
    brave
    google-chrome
    psensor
    inkscape-with-extensions
    vlc
    obs-studio 
    postman
    postgresql
    pgadmin4
    mysql
    mysql-workbench
    discord
		lazygit
    xfce.thunar
		arduino-ide
  ];

}
