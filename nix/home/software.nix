{ config, pkgs, ... }:

let
  xorg = with pkgs; [
    maim
    xclip
    feh
  ];

  browser = with pkgs; [
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
}
