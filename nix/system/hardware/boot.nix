{ ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/16aebad7-8b44-4441-8589-e1fab97045f8";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7875-C267";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
  swapDevices = [ ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}