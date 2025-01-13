{
  description = "My minimal flake";

  inputs = {
    pkgslts.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgsold = inputs.pkgslts.legacyPackages.${system};
    customNeovim = inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [./nvf-configuration.nix];
    };
  in {
    packages.${system}.my-neovim = customNeovim.neovim;

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        {environment.systemPackages = [customNeovim.neovim];}
      ];
    };

    # just a snippet of nix shell using flakes for me to remember
    myshell = pkgs.mkShell {
      buildInputs = with pkgs; [
        cowsay
        nodejs
      ];

      shellHook = ''
        cowsay hello
        node -v
      '';
    };
  };
}
