{ pkgs, ... }:

{
  systemd.services.api_odara = {
    enable = false;
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

  services.displayManager.ly.enable = true;

  # services.xserver.desktopManager.gnome.enable = true;
  # services.pulseaudio.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.keyd.enable = true;
  services.keyd.keyboards.default.settings = {
    main = {
      capslock = "leftcontrol";
    };
  };
  environment.variables = {
    LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
    KEYD_HOME = "${pkgs.keyd}";
  };

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
}
