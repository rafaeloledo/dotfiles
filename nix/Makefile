.PHONY: b s hb hs clean ub us kill

b:
	sudo nixos-rebuild build --flake .
s:
	sudo nixos-rebuild switch --flake .
hb:
	home-manager build --flake . -b backup
hs:
	home-manager switch --flake . -b backup
ub:
	sudo nixos-rebuild --upgrade build --flake .
us:
	sudo nixos-rebuild --upgrade switch --flake .
uboot:
	sudo nixos-rebuild --upgrade boot --flake .
cleanu:
	nix-collect-garbage -d
clean:
	sudo nix-collect-garbage -d
update:
	nix flake update
