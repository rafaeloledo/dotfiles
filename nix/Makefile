.PHONY: b s hb hs clean ub us kill

b:
	sudo nixos-rebuild build --flake . --impure
s:
	sudo nixos-rebuild switch --flake . --impure
hb:
	home-manager build --flake .
hs:
	home-manager switch --flake .
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
