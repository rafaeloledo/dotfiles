{ config, pkgs, ... }:

let
  xorg = with pkgs; [
    maim
    xclip
    feh
  ];

  db = with pkgs; [
    pgadmin4
    mariadb
  ];

  editor = with pkgs; [
    arduino-ide
    neovim
    neovide
    jetbrains.idea-community-bin
    ueberzugpp
    viu
    # for errors with LD
    stylua
    code-cursor
  ];

  multimedia = with pkgs; [
    vlc
    obs-studio
    easyeffects
  ];

  devops = with pkgs; [
    mission-center
    inkscape-with-extensions
    postman
    discord
		lazygit
    nautilus
    gnome-tweaks
    papirus-icon-theme
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
    pavucontrol
    nodePackages.pnpm
    android-tools
    awscli2
		zip
		maven
		plantuml
		# graphviz
    brightnessctl
    lmstudio
    kdePackages.kdeconnect-kde

    ncdu # check disk usage
    firebase-tools

    mvnd
    python313Packages.firebase-admin
    python313Packages.psycopg2

    eas-cli
  ];

  lang = with pkgs; [
    nodejs
    lua
    rustup
    pipx
    go
    php
    python3Full
    jdk
    flutter
    ruby
    sassc
  ];

  misc = with pkgs; [
    pkgs.xorg.libXrender
    picom
    dunst
    duf
    rofi-wayland
    imagemagick
    hyprshot
    viewnior
    nodePackages.live-server
    ani-cli
    sublime4
    obsidian
    google-chrome
    vial
    bc
    blender
    ddcutil
    brave
    # android-studio
  ];

  lsp = with pkgs; [
    svelte-language-server
    clang-tools
    jdt-language-server
    gopls
    kotlin-language-server
    lua-language-server
    phpactor
    pyright
  ];

  fmt = with pkgs; [
    stylua
  ];

  desktop-tools = with pkgs; [
    gnome-calculator
  ];
in

{
  imports = [
    ./wayland.nix
    ./terminal.nix
  ];

  home.enableNixpkgsReleaseCheck = false;

  home.packages = xorg ++ db ++ editor ++ multimedia
  ++ devops ++ lang ++ misc ++ lsp ++ fmt ++ desktop-tools;

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

  programs.firefox = {
    enable = true;
    profiles.default.extraConfig = ''
      user_pref("ui.key.menuAccessKeyFocuses", false);
      user_pref("extensions.pocket.enabled", false);
      user_pref("full-screen-api.transition-duration.enter", "0 0");
      user_pref("full-screen-api.transition-duration.leave", "0 0");
      user_pref("full-screen-api.transition.timeout", 0);
      user_pref("full-screen-api.warning.timeout", 0);
      user_pref("full-screen-api.warning.delay", -1);
      user_pref("browser.tabs.firefox-view", false);
      user_pref("browser.uitour.enabled", false);

      //user_pref("browser.cache.disk.enable", false);
      // Graphics
      //user_pref("gfx.webrender.all", true);
      //user_pref("gfx.webrender.precache-shaders", true);
      //user_pref("gfx.webrender.compositor", true);
      //user_pref("gfx.canvas.accelerated", true);
      //user_pref("layers.gpu-process.enabled", true);
      //user_pref("media.hardware-video-decoding.enabled", true);

      user_pref("browser.newtabpage.activity-stream.default.sites", "");
      user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
      user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
      user_pref("signon.rememberSignons", false);
    '';
  };

  home.file = {
    ".gitconfig".source = 
      config.lib.file.mkOutOfStoreSymlink /home/rgnh55/dotfiles/.gitconfig;
    "wallpapers".source = 
      config.lib.file.mkOutOfStoreSymlink /home/rgnh55/dotfiles/wallpapers;
  };
}
