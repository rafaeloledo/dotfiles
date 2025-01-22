{ pkgs, ... }:

{
  # cloudflare
  # systemd.services.my_tunnel = {
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel run rafaeloledo";
  #     Restart = "always";
  #     User = "rgnh55";
  #     Group = "users";
  #   };
  # };

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

}
