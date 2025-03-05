{ lib, self, config, pkgs, inputs, ... }:

let
  # i don't inherit neovim setup because it's dynamic
  # just run make vim/<type>
  # type: default or vanilla
  dotfiles = [
    "terminal/wezterm"
    "editor/doom"
    "dunst"
    "shell/fish"
    "wayland/hypr"
    "xorg/i3"
    "xorg/picom"
    "rofi"
    # delegate vim setupts to Makefile cause i may change it frequently
    # so, don't need to `make hs`
    # "editors/lazyvim"
    # "editors/vim"
    "terminal/tmux"
    "wayland/waybar"
    "terminal/yazi"
    "terminal/ghostty"
    "terminal/lazygit"
  ];
  
  # i think its the same of 
  # mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink
  # just a alias to not type the full path
  # TODO: check this (i've just picked up from docs)
  inherit (config.lib.file) mkOutOfStoreSymlink;
in

{ 
  imports = [ 
    ./software.nix
    ./services.nix
    # ./nvf.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    # sublime text problems
    "openssl-1.1.1w"
  ];

  home = {
    username = "rgnh55";
    homeDirectory = "/home/rgnh55";
    stateVersion = "24.11";
  };

  home.file = builtins.listToAttrs (map (name: {
    name = ".config/${builtins.baseNameOf name}";
    value = {
      # i don't want to rewrite my entire config files to be specific to nixos
      # keep these distro-agnostic
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
