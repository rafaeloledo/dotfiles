{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./nitro5_nvidia.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "uas" "usbhid" "sd_mod" "vmd" "i2c_dev" ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.graphics.enable = true;
  hardware.i2c.enable = true;

	services.blueman.enable = true;
}
