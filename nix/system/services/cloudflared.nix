{ pkgs, ... }: {
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
