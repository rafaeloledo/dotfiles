{ pkgs, ... }:

{
  # cloudflare
  systemd.services.api_odara = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel run api-odara";
      Restart = "always";
      User = "rgnh55";
      Group = "users";
      RestartSec = 5;
    };
  };

  # plasma
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;

  # gnome
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  
  # pulseaudio
  # services.pulseaudio.enable = true;

  # keyd
  services.keyd.enable = true;
  services.keyd.keyboards.default.settings = {
    main = {
      capslock = "leftcontrol";
      leftmeta = "leftalt";
      leftalt = "leftmeta";
    };
    alt = {
      h = "left";
      j = "down";
      k = "up";
      l = "right";
      d = "pagedown";
      u = "pageup";
    };
  };
  environment.variables.KEYD_HOME = "${pkgs.keyd}";

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
  
}
