{ pkgs, lib, config, ... }:

{
  # syncthing
  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
  };
}

