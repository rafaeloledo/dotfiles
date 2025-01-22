{
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    flake-compat.url = "github:edolstra/flake-compat";

    nix-index-db.url = "github:Mic92/nix-index-database";
    nix-index-db.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "hm";
    agenix.inputs.systems.follows = "systems";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hypridle.url = "github:hyprwm/hypridle";
    hypridle.inputs.hyprlang.follows = "hyprland/hyprlang";
    hypridle.inputs.nixpkgs.follows = "hyprland/nixpkgs";
    hypridle.inputs.systems.follows = "hyprland/systems";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprlock.inputs.hyprlang.follows = "hyprland/hyprlang";
    hyprlock.inputs.nixpkgs.follows = "hyprland/nixpkgs";
    hyprlock.inputs.systems.follows = "hyprland/systems";
    hyprland-hyprspace.url = "github:KZDKM/Hyprspace";
    hyprland-hyprspace.inputs.hyprland.follows = "hyprland";
    hyprswitch.url = "github:h3rmt/hyprswitch/release";

    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    waybar.url = "github:Alexays/Waybar";

    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";

    nvf.url = "github:notashelf/nvf";
  };

  outputs = { flake-parts, nixpkgs, hm, hyprland, nix-index-db, ... } @ inputs:

  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    userhostname = "rgnh55@nixos";

    hmConfig = hm.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
      inherit pkgs;
      modules = [
        { nixpkgs.config.allowUnfree = true; }
        inputs.nvf.homeManagerModules.default
        nix-index-db.hmModules.nix-index
        ./home
      ];
    };

    noConfig = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.config.allowUnfree = true; }
          ./system
        ];
      };
    };
  
    # nix develop .#myShell
    myShell = pkgs.mkShell {
      buildInputs = with pkgs; [
      ];

      shellHook = ''
        echo ${pkgs.keyd}
      '';
    };
  in

  flake-parts.lib.mkFlake { inherit inputs; } {
    flake = { homeConfigurations.${userhostname} = hmConfig; nixosConfigurations = noConfig; };
    systems = [ system ];
    perSystem = { packages.myshell = myShell; };
  };
}
