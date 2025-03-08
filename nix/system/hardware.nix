{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./nitro5_nvidia.nix
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci" "ahci" "nvme" "uas" "usbhid" "sd_mod" "vmd" "i2c_dev"
    "nvidia_drm" "nvidia_modeset" "nvidia" "nvidia_uvm"
  ];

  boot.kernelModules = [
    # "kvm-amd"
    "kvm-intel"
  ];

  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [ "nvidia_drm.modeset=1" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" "nvidia_drm.fbdev=1" ];

  # boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
  # boot.initrd.kernelModules = [  ];
  # boot.kernelModules = [ ];
  # boot.extraModulePackages = [ ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  hardware.i2c.enable = true;
  hardware.xone.enable = true;

	services.blueman.enable = true;
}
