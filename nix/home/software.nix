{ config, pkgs, ... }:

{
  imports = [
    ./wayland.nix
    ./terminal.nix
  ];

  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    notion-app-enhanced
    # xdotool
    discord
    blender
    # code-cursor-fhs
    wezterm
    exiftool
    btop
    mariadb

    neovim neovide vscode-fhs arduino-ide

    inkscape-with-extensions

    vlc # player
    easyeffects # audio post processing with CPU
    playerctl # hyprland cmd line audio handler
    pkg-config
		# lazygit
    nautilus
    gnome-tweaks
    papirus-icon-theme
    ngrok
    unixtools.xxd
    # fastfetch # neofetch replacement
		plantuml # text UML to image
    # qemu_full # VM

    mtpfs # android
    android-file-transfer # android
    android-udev-rules # android
    libmtp # android
    android-tools # android
    android-studio # android IDE

    jq # json processing
    pavucontrol # GUI audio manager

		zip # why?
		graphviz # complement to plantuml
    brightnessctl # change notebook monitor light

    ncdu # check disk usage

    eas-cli # react native

    nodejs
    lua
    rustup
    python313

    pkgs.xorg.libXrender # why?
    dunst # just dunst
    rofi # rofi
    imagemagick # dep
    hyprshot # why?
    viewnior # lightweight image viewer

    ani-cli # animes
    sublime4 # quick annotation editor
    vial # keyboard
    bc # calculator for VIM

    ddcutil # change external monitor brightness
    brave

    qmk # keyboard
    # gcc-arm-embedded # arm compiler

    distrobox # emulate other linux distros withtout leaving NixOS
    rembg # rem bg of images made with py

    vulkan-tools # graphics
    vulkan-loader # graphics

    tesseract # image to text
    pandoc # latex
    texliveFull # latex

    dconf-editor # gnome system gui manager

    # svelte-language-server
    # clang-tools
    # jdt-language-server
    # gopls
    # kotlin-language-server
    # lua-language-server
    # typescript-language-server
    # phpactor
    # pyright
    # emmet-ls
    # ruby-lsp
    # nixfmt-rfc-style
    # stylua

    gnome-calculator # GUI calculator

    # gparted # TODO: search for auth daemon

    hyprcursor

    # nix-serve
    # jellyfin
    # antimicrox # Gamepad
    # awscli2 # cloud1
    # firebase-tools # cloud
    # blender # design and modeling
    # mvnd # used when developing with java, why?
    # gimp
    # jetbrains.idea-community-bin # java IDE, why?
    # nodePackages.live-server # why?
    # maven # ..
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  home.file = {
    ".gitconfig".source =
      config.lib.file.mkOutOfStoreSymlink /home/rgnh55/dotfiles/.gitconfig;
    "wallpapers".source =
      config.lib.file.mkOutOfStoreSymlink /home/rgnh55/dotfiles/wallpapers;
  };
}
