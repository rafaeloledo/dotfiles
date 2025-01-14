{ pkgs, lib, ... }:

{
  networking = {
    networkmanager = {
      enable = true;
    };
    hostName = "nixos";
    useDHCP = lib.mkDefault true;
    nat = {
      enable = true;
    };
		firewall = {
			interfaces.wlp0s20f3.allowedTCPPorts = [ 3000 80 22 ];
		};
  };

	environment.systemPackages = [
		pkgs.networkmanagerapplet
	];
}
