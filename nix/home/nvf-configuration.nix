{ pkgs, lib, ... }:

{
  config.vim = {
    theme.enable = true;
    theme.name = "gruvbox";
    theme.style = "dark";
  };
}
