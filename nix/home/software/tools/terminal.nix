{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
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
}
