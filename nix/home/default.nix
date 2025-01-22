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
    # "editors/lazyvim"
    # "editors/vim"
    "terminal/tmux"
    "wayland/waybar"
    "terminal/yazi"
    "terminal/ghostty"
    "terminal/lazygit"
  ];
  
  inherit (config.lib.file) mkOutOfStoreSymlink;
in

{ 
  imports = [ 
    ./software.nix
    ./services.nix
    # ./nvf.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
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
