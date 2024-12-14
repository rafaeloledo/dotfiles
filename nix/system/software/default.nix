{
	imports = [
		./i3.nix
	];
	
	users.groups.docker = {};

	virtualisation.docker = {
		enable = true;
		daemon.settings = {
			data-root = "/mnt/share/docker-img";
		};
	};

	users.users.rgnh55.extraGroups = [ "docker" ];
}
