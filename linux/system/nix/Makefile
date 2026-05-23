.PHONY: b s hb hs ub us kill

b:
	sudo nixos-rebuild build --flake . --impure

s:
	sudo nixos-rebuild switch --flake . --impure

hb:
	home-manager build --flake . --impure

hs:
	home-manager switch --flake . --impure

ub:
	sudo nixos-rebuild --upgrade build --flake .

us:
	sudo nixos-rebuild --upgrade switch --flake .

uboot:
	sudo nixos-rebuild --upgrade boot --flake .

nix/cleanu:
	nix-collect-garbage -d

nix/clean:
	sudo nix-collect-garbage -d

nix/update:
	nix flake update
