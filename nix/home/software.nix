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
    stylua
    vscode-fhs
    gimp
    inkscape-with-extensions
    joplin-desktop
  ];

  multimedia = with pkgs; [
    vlc
    obs-studio
    easyeffects
    loupe
    playerctl
  ];

  devops = with pkgs; [
    pkg-config
    mission-center
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
    kdePackages.kdeconnect-kde

    ncdu # check disk usage
    firebase-tools

    mvnd

    eas-cli
  ];

  lang = with pkgs; [
    flutter
    nodejs
    lua
    rustup
    python313
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
    google-chrome
    vial
    bc
    blender
    ddcutil
    brave
    # android-studio

    qmk
    gcc-arm-embedded

    distrobox
    rembg
    nix-serve
    torzu

    lutris
    vulkan-tools
    vulkan-loader

    tesseract
    pandoc
    texliveFull

    dconf-editor
    gnome-screenshot

    code-cursor
    jellyfin
  ];

  lsp = with pkgs; [
    svelte-language-server
    clang-tools
    jdt-language-server
    gopls
    kotlin-language-server
    lua-language-server
    typescript-language-server
    phpactor
    pyright
    emmet-ls
    ruby-lsp
    nixfmt-rfc-style
  ];

  fmt = with pkgs; [
    stylua
  ];

  desktop-tools = with pkgs; [
    gnome-calculator
    fastfetch
    kitty
    warp-terminal
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

  home.file = {
    ".gitconfig".source =
      config.lib.file.mkOutOfStoreSymlink /home/rgnh55/dotfiles/.gitconfig;
    "wallpapers".source =
      config.lib.file.mkOutOfStoreSymlink /home/rgnh55/dotfiles/wallpapers;
  };
}
