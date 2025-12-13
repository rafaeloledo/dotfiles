{ pkgs, config, ... }:

let
  bashAliases = {
    g = "git";
    l = "eza -lga --icons";
    cls = "clear";
    v = "nvim";
    t = "tmux";
    cat = "bat -p";
    gci = "git commit";
    gst = "git status";
    gps = "git push";
    gpl = "git pull";
    gl = "git log";
    gcl = "git clone";
    gbr = "git branch";
    ".." = "cd ..";
  };

  programs = with pkgs; [
    tmux
    eza
    bat
    fd
    ripgrep
    fzf
    ghostty
    yazi
    gh-dash
    gh
    zoxide
  ];
in

{
  home.file = {
    ".local/scripts".source = config.lib.file.mkOutOfStoreSymlink /home/rgnh55/dotfiles/scripts;
  };

  home.file = {
    ".inputrc".source = ./inputrc;
  };

  home.packages = programs;

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;
    shellAliases = bashAliases;
  };

}
