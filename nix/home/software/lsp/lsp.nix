{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodePackages_latest.typescript-language-server
    nls
    clang-tools
    jdt-language-server
    gopls
    kotlin-language-server
    lua-language-server
    phpactor
    pyright
  ];
}
