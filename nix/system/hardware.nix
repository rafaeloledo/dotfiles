{ config, lib, pkgs, modulesPath, ... }:

{ 
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./desktop_amd.nix
    # ./nitro5_nvidia.nix
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.pulseaudio.enable = false;
  hardware.graphics.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

	services.blueman.enable = true;
}