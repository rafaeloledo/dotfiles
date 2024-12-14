{pkgs, ...}: {
  home.packages = with pkgs; [
    helix
    vscode-fhs
    zed-editor
    neovim
    neovide
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };
}
