{ config, pkgs, ... }:

{
  imports = [
    ./wayland.nix
    ./terminal.nix
  ];

  home.enableNixpkgsReleaseCheck = false;

  home.packages = [
    maim
    xclip
    feh

    pgadmin4
    mariadb

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

    vlc
    obs-studio
    easyeffects
    loupe
    playerctl

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

    flutter
    nodejs
    lua
    rustup
    python313

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
    stylua

    gnome-calculator
    fastfetch
    kitty
    warp-terminal
  ];

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
