# change this file specs as you want
# git update-index --assume-unchanged system/disk.nix
# change this file to the current boot real boot UUIDs
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
}
