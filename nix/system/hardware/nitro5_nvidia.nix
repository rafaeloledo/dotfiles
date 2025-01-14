{ config, lib, pkgs, modulesPath, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "vmd" "ahci" "nvme" "uas" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        sync.enable = true;
        # offload = {
        #   enable = true;
        #   enableOffloadCmd = true;
        # };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}