.PHONY: b s hb hs

b:
	sudo nixos-rebuild build --flake .
s:
	sudo nixos-rebuild switch --flake .
hb:
	home-manager build --flake . -b backup
hs:
	home-manager switch --flake . -b backup
