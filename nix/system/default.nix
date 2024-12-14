{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./core
    ./network
		./software
    ./hardware
    ./fonts
		./services
  ];

  # environment.variables.NIXOS_OZONE_WL = "1";

  config.services.postgresql = {
    enable = true;
    ensureDatabases = [ "postgres" ];
    enableTCPIP = true;
    settings.port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
    '';
  };

}
