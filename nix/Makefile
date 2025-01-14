.PHONY: b s hb hs

b:
	sudo nixos-rebuild build --flake .
s:
	sudo nixos-rebuild switch --flake .
hb:
	home-manager build --flake .
hs:
	home-manager switch --flake . -b backup
