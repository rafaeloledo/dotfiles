{ config, lib, pkgs, ... }:

{
  services = {
    openssh.enable = true;
    xserver = {
	    displayManager.gdm.enable = true;
	    desktopManager.gnome.enable = true;
      enable = true;
      windowManager.i3.enable = true;
      xkb.layout = "us,br";
      xkb.variant = "";
			xkb.options= "ctrl:nocaps";
      videoDrivers = [ "nvidia" ];
    };
    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
      };
      touchpad = {
        accelProfile = "flat";
      };
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
