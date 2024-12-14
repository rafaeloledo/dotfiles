{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    nodejs
    lua
    rustup
    pipx
    go
    php

    nodePackages.pnpm
  ];
}
