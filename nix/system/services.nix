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

  services = {
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    tlp.enable = false;

    flatpak.enable = true;

    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';

    keyd = {
      enable = true;

      keyboards.default.settings = {
        main = {
          capslock = "leftcontrol";
        };
      };
    };

    lvm.enable = false;

    postgresql = {
      enable = false;
      ensureDatabases = [ "postgres" "rgnh55" ];
      enableTCPIP = true;
      settings.port = 5432;
      authentication = pkgs.lib.mkOverride 10 ''
      local all       all     trust
      host  all      all     127.0.0.1/32   trust
      '';
    };

    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = false;

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = false;
    gnome.core-developer-tools.enable = false;
    gnome.games.enable = false;
  };

  environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];

}
