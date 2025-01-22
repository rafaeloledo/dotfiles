{ lib, self, config, pkgs, inputs, ... }:

let
  dotfiles = [
    "wezterm"
    "doom"
    "dunst"
    "fish"
    "hypr"
    "i3"
    "nvim"
    "picom"
    "rofi"
    "starship"
    "tmux"
    "viewnior"
    "waybar"
    "yazi"
    "ghostty"
  ];
  
  inherit (config.lib.file) mkOutOfStoreSymlink;
in

{ 
  imports = [ ./software.nix ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  home = {
    username = "rgnh55";
    homeDirectory = "/home/rgnh55";
    stateVersion = "24.11";
  };

  home.file = builtins.listToAttrs (map (name: {
    name = ".config/${name}";
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
