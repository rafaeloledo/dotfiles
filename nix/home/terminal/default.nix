{ pkgs, config, ... }:

{
  imports = [
    ./shell/bash.nix
    ./shell/zsh.nix
  ];

  home.file = {
    ".local/scripts".source = 
      config.lib.file.mkOutOfStoreSymlink /mnt/share/.dotfiles/scripts;
  };

  home.packages = with pkgs; [
    starship
    wezterm
  ];
}
