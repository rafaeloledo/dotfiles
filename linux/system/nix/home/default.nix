{ lib, self, config, pkgs, inputs, ... }:

let
  dotfiles = [
    "linux/terminal/wezterm"
    "linux/desktop/dunst"
    "linux/shell/fish"
    "linux/desktop/hypr"
    "linux/desktop/rofi"
    "linux/terminal/tmux"
    "linux/terminal/yazi"
    "linux/terminal/ghostty"
    "linux/terminal/lazygit"
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

  home.file = (builtins.listToAttrs (map (name: {
    name = ".config/${builtins.baseNameOf name}";
    value = {
      source = mkOutOfStoreSymlink "/home/rgnh55/dotfiles/${name}";
    };
  }) dotfiles)) // {
    ".config/nvim".source = mkOutOfStoreSymlink "/home/rgnh55/dotfiles/linux/editor/nvim";
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs.home-manager.enable = true;

}
