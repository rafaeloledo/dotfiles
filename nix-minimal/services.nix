{ config, pkgs, ... }:

{
  # default services
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.printing.enable = true;
  services.openssh.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.libinput.enable = true;
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "rgnh55";
    };
  };
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # postgresql
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "postgresql" ];
    enableTCPIP = true;
    settings.port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
    	local all all trust
    '';
  };

  # docker
  users.groups.docker = {};
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/home/rgnh55/docker-images";
    };
  };
  users.users.rgnh55.extraGroups = [ "docker" ];

  # i3
  services.xserver.windowManager.i3 = {
    enable = true;
  };

  # cloudflared
  systemd.services.my_tunnel = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel run rafaeloledo";
      Restart = "always";
      User = "rgnh55";
      Group = "users";
    };
  };
}
