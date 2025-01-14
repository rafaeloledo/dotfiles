{ pkgs, ... }:

{
	services.xserver.windowManager.i3 = {
    	enable = true;
  	};
	
	users.groups.docker = {};

	virtualisation.docker = {
		enable = true;
		daemon.settings = {
			data-root = "/mnt/share/docker-img";
		};
	};

	users.users.rgnh55.extraGroups = [ "docker" ];
}
