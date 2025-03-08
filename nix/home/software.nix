{ config, pkgs, ... }:

{
  imports = [
    ./wayland.nix
    ./terminal.nix
  ];

  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    mariadb

    arduino-ide
    neovim
    neovide
    jetbrains.idea-community-bin
    vscode-fhs
    gimp
    inkscape-with-extensions

    vlc # player
    easyeffects # audio post processing with CPU
    playerctl # hyprland cmd line audio handler

    pkg-config
    mission-center # windows task mananager copy
    postman # gui for making REST API requests
    discord
		lazygit
    nautilus
    gnome-tweaks
    papirus-icon-theme
    ngrok
    unixtools.xxd
    fastfetch # neofetch replacemente
    staruml # UML
		plantuml # text UML to image
    qemu_full # VM

    mtpfs # android
    android-file-transfer # android
    android-udev-rules # android
    libmtp # android
    android-tools # android
    android-studio # android IDE

    libvirt # dep for virt-manager
    jq # json processing
    pavucontrol # GUI audio manager
    nodePackages.pnpm # package manager
    awscli2 # cloud
    firebase-tools # cloud
		zip # why?
		maven # ..
		graphviz # complement to plantuml
    brightnessctl # change notebook monitor light
    kdePackages.kdeconnect-kde # sync android notifications

    ncdu # check disk usage

    mvnd # used when developing with java, why?

    eas-cli # react native

    flutter
    nodejs
    lua
    rustup
    python313

    pkgs.xorg.libXrender # why?
    dunst # just dunst
    rofi-wayland # rofi
    imagemagick # dep
    hyprshot # why?
    viewnior # lightweight image viewer
    nodePackages.live-server # why?
    ani-cli # animes
    sublime4 # quick annotation editor
    google-chrome # browser
    vial # keyboard
    bc # calculator for VIM
    blender # design and modeling
    ddcutil # change external monitor brightness
    brave

    qmk # keyboard
    gcc-arm-embedded # arm compiler

    distrobox # emulate other linux distros withtout leaving NixOS
    rembg # rem bg of images made with py
    # nix-serve

    lutris # translation layer
    vulkan-tools # graphics
    vulkan-loader # graphics

    tesseract # image to text
    pandoc # latex
    texliveFull # latex

    dconf-editor # gnome system gui manager

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

    gnome-calculator # GUI calculator

    gparted # TODO: search for auth daemon

    antimicrox # Gamepad
    mupdf # PDF reader
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
