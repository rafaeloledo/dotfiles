{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./nitro5_nvidia.nix
  ];

  hardware.uinput.enable = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci" "ahci" "nvme" "uas" "usbhid" "sd_mod" "vmd" "i2c_dev" "usb_storage"
    "nvidia_drm" "nvidia_modeset" "nvidia" "nvidia_uvm"
  ];

  boot.kernelModules = [
    "kvm-amd"
    "kvm-intel"
  ];

  boot.supportedFilesystems = [ "ntfs" ];

  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "nvidia_drm.modeset=1" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" "nvidia_drm.fbdev=1"
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  hardware.i2c.enable = true;
  hardware.xone.enable = true;

	services.blueman.enable = true;
}
