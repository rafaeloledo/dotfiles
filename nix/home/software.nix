{ config, pkgs, ... }:

let
  xorg = with pkgs; [
    maim
    xclip
    feh
  ];

  browser = with pkgs; [
    brave
    google-chrome
  ];

  db = with pkgs; [
    postgresql
    pgadmin4
    mysql
    mysql-workbench
  ];

  editor = with pkgs; [
    arduino-ide
    helix
    vscode-fhs
    zed-editor
    neovim
    neovide
  ];

  multimedia = with pkgs; [
    vlc
    obs-studio
    davinci-resolve
  ];

  devops = with pkgs; [
    psensor
    inkscape-with-extensions
    postman
    discord
		lazygit
    xfce.thunar
    ngrok
    unixtools.xxd
    fastfetch
    staruml
    qemu_full
    libvirt
    mtpfs
    android-file-transfer
    android-udev-rules
    libmtp
    jq
    chromium
    stow
    lmstudio
    
    pavucontrol

    nodePackages.pnpm
  ];

  lang = with pkgs; [
    nodejs
    lua
    rustup
    pipx
    go
    php
  ];

  framework = with pkgs; [
    flutter
  ];

  misc = with pkgs; [
    pkgs.xorg.libXrender

    picom
    dunst
    duf
    rofi
    viewnior
    nodePackages.live-server
    rnnoise-plugin
    rnnoise
  ];

  lsp = with pkgs; [
    nodePackages_latest.typescript-language-server
    nls
    clang-tools
    jdt-language-server
    gopls
    kotlin-language-server
    lua-language-server
    phpactor
    pyright
  ];
in

{
  imports = [
    ./firefox.nix
    ./git.nix
    ./wayland.nix
    ./terminal.nix
  ];

  home.packages = xorg ++ browser ++ db ++ editor ++ multimedia
  ++ devops ++ lang ++ framework ++ lsp ++ misc;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };
}
