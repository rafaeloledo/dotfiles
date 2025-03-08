{ pkgs, config, ... }:

let
  bashAliases = {
    g = "git";
    ll = "eza -lga --icons";
    l = "eza -lga --icons";
    lt = "eza --tree";
    cls = "clear";
    phone = "scrcpy --disabel-screensaver --turn-screen-off --no-audio-playback -f";
    nf = "neofetch";
    v = "nvim";
    vd = "neovide";
    t = "tmux";
    ta = "tmux a";
    td = "tmux detach";
    cat = "bat -p";
    gci = "git commit";
    gst = "git status";
    gps = "git push";
    gpl = "git pull";
    gl = "git log";
    gcl = "git clone";
    gc = "git checkout -b";
    gco = "git checkout";
    gbr = "git branch";
    gd = "git diff";
    gad = "git add .";
    gf = "git fetch";
    grm = "git rm";
    lg = "lazygit";
    e = "emacsclient -c -n";
    view = "viewnior";
    naut = "nautilus";
    anime = "ani-cli";
    ".." = "cd ..";
  };

  programs = with pkgs; [
    starship
    tmux
    eza
    bat
    fd
    ripgrep
    fzf
    wezterm
    ghostty
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

  home.file = {
    ".inputrc".source = ./inputrc;
  };

  home.packages = programs;

  programs.zsh.enable = true;
  programs.zsh.dotDir = ".config/zshrc";

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;
    shellAliases = bashAliases;
  };

}
