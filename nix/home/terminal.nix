{ pkgs, config, ... }:

let
  bashAliases = {
    g = "git";
    cls = "clear";
    la = "ls -la";
    t = "tmux";
    ta = "tmux a";
    td = "tmux detach";
    ll = "eza -lga --icons";
    cat = "bat -p";
    v = "nvim";
    nf = "neofetch";
  };
  
  programs = with pkgs; [
    starship
    wezterm

    tmux
    eza
    bat
    fd
    ripgrep
    fzf
    wezterm
    starship
    htop
    yazi
    gh-dash
    gh
    zoxide
  ];
in

{
  home.file = {
    ".local/scripts".source = 
      config.lib.file.mkOutOfStoreSymlink /home/rgnh55/dotfiles/scripts;
  };

  home.packages = programs;

  programs.zsh.enable = true;
  programs.zsh.dotDir = ".config/zshrc";

  programs.bash.enable = true;
  programs.bash.shellAliases = bashAliases;
}
