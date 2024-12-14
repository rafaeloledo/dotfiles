{ pkgs, ... }: let
  myAliases = {
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
in {
  programs.bash = {
    enable = true;
    shellAliases = myAliases;
  };
}
