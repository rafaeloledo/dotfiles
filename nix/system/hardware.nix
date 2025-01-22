{ config, lib, pkgs, modulesPath, ... }:

{ 
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./nitro5_nvidia.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "uas" "usbhid" "sd_mod" "vmd" ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.graphics.enable = true;

	services.blueman.enable = true;
}
