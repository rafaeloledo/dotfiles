{ lib, self, config, pkgs, inputs, ... }:

let
  dotfiles = [
    "shared/terminal/wezterm"
    "linux/desktop/dunst"
    "shared/shell/fish"
    "linux/desktop/hypr"
    "linux/desktop/waybar"
    "linux/desktop/rofi"
    "shared/terminal/tmux"
    "shared/terminal/yazi"
    "shared/terminal/ghostty"
    "shared/terminal/lazygit"
    "shared/editor/nvim"
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

  home = {
    username = "rgnh55";
    homeDirectory = "/home/rgnh55";
    stateVersion = "25.05";
  };

  home.file = (builtins.listToAttrs (map (name: {
    name = ".config/${builtins.baseNameOf name}";
    value = {
      source = mkOutOfStoreSymlink "/home/rgnh55/dotfiles/${name}";
    };
  }) dotfiles));

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs.home-manager.enable = true;

}
