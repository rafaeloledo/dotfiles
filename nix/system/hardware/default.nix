{ config, lib, pkgs, modulesPath, ... }:

{ 
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./desktop_amd.nix
    ./boot.nix
    # ./nitro5_nvidia.nix
  ];

  hardware = {
    bluetooth.enable = true;
		bluetooth.powerOnBoot = true;
    pulseaudio.enable = false;
    graphics.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

	services.blueman.enable = true;
}