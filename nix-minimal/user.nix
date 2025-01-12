{ config, pkgs, ... }:

let
  devops = with pkgs; [
    git
    fzf
    ripgrep
    wl-clipboard
    gnumake
    lazygit
    live-server
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

    tmux
    eza
    bat
    fd
    htop
    yazi
    gh-dash
    gh
    zoxide

    nodePackages.pnpm
    pipx
  ];

  editor = with pkgs; [
    neovim
    wezterm
    arduino-ide
    vscode-fhs
    zed-editor
    neovide
    helix
    emacs
    lmstudio
  ];

  multimedia = with pkgs; [
    vlc
    obs-studio
    davinci-resolve
  ];

  lsp = with pkgs; [
    typescript-language-server
    nls
    clang-tools
    jdt-language-server
    gopls
    kotlin-language-server
    lua-language-server
    phpactor
    pyright
  ];

  misc = with pkgs; [
    xorg.libXrender
    picom
    dunst
    duf
    rofi
    viewnior
    rnnoise
    rnnoise-plugin
  ];

  programming = with pkgs; [
    nodejs
    lua
    rustup
    php
    go
  ];
in

{
  users.users.rgnh55 = {
    isNormalUser = true;
    description = "rgnh55";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = devops ++ editor ++ multimedia ++ lsp ++ misc ++ programming;
  };

  fonts.packages = with pkgs; [
    roboto-mono
    noto-fonts-cjk-sans
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-serif
    ubuntu_font_family
    jetbrains-mono
    fira-code
    nerdfonts
  ];

  programs.firefox.enable = true;
}
