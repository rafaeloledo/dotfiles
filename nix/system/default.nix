{ pkgs, ... }:

{
  imports = [
    ./core.nix
    ./network.nix
		./software.nix
    ./hardware.nix
    ./fonts.nix
		./cloudflared.nix
  ];

  # environment.variables.NIXOS_OZONE_WL = "1";

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "postgres" ];
    enableTCPIP = true;
    settings.port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
    '';
  };
}
