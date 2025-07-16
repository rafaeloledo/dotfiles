{ lib, self, config, pkgs, inputs, ... }:

let
  dotfiles = [
    "terminal/wezterm"
    "editor/doom"
    "dunst"
    "shell/fish"
    "wayland/hypr"
    "rofi"
    "editor/nvim"
    "terminal/tmux"
    "wayland/waybar"
    "terminal/yazi"
    "terminal/ghostty"
    "terminal/lazygit"
  ];

  inherit (config.lib.file) mkOutOfStoreSymlink;
in

{
  programs.obs-studio.package = (pkgs.obs-studio.override {
    cudaSupport = true;
  });

  imports = [
    ./software.nix
    ./services.nix
    ./gnome.nix
    ./terminal.nix
   ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  home = {
    username = "rgnh55";
    homeDirectory = "/home/rgnh55";
    stateVersion = "25.05";
  };

  home.file = builtins.listToAttrs (map (name: {
    name = ".config/${builtins.baseNameOf name}";
    value = {
      source = mkOutOfStoreSymlink "/home/rgnh55/dotfiles/${name}";
    };
  }) dotfiles);

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs.home-manager.enable = true;

}
