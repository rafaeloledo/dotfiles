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

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  # services.pulseaudio.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.postgresql = {
    enable = false;
    ensureDatabases = [ "postgres" "rgnh55" ];
    enableTCPIP = true;
    settings.port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      local all       all     trust
      host  all      all     127.0.0.1/32   trust
    '';
  };


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
