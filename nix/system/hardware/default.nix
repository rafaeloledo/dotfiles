{ config, lib, pkgs, modulesPath, ... }:

{ 
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

fileSystems."/" =
    { device = "/dev/disk/by-uuid/5171a467-978f-4561-880f-08759fe5fe62";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/1EA9-232F";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };


  fileSystems."/mnt/share" =
  {
    device = "/dev/sda1";
    fsType = "ext4";
  };
  fileSystems."/mnt/share1" = {
    device = "/dev/sdb1";
    fsType = "ext4";
  };

  swapDevices = [ ];

  hardware = {
    pulseaudio.enable = false;
    graphics.enable = true;
		bluetooth.enable = true;
		bluetooth.powerOnBoot = true;

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

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "vmd" "ahci" "nvme" "uas" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

	services.blueman.enable = true;
}
