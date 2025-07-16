{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us,br";
      xkb.variant = "";
			xkb.options= "ctrl:nocaps";
    };
    
    openssh.enable = true;

    pipewire.enable = true;
    pipewire.alsa.enable = true;
    pipewire.alsa.support32Bit = true;
    pipewire.pulse.enable = true;

    libinput.enable = true;
    libinput.mouse.accelProfile = "flat";
    libinput.touchpad.accelProfile = "flat";
    
    printing.enable = true;
  };
}
