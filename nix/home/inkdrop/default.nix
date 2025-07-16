let
  pkgs = import <nixpkgs> { config = { allowUnfree = true; }; overlays = []; };
in

{
  inkdrop = pkgs.callPackage ./inkdrop.nix { };
}
