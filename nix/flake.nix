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

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-db.url = "github:Mic92/nix-index-database";
    nix-index-db.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "hm";
    agenix.inputs.systems.follows = "systems";

    hyprland.url = "github:hyprwm/hyprland/main";
    hypridle.url = "github:hyprwm/hypridle";
    hypridle.inputs.hyprlang.follows = "hyprland/hyprlang";
    hypridle.inputs.nixpkgs.follows = "hyprland/nixpkgs";
    hypridle.inputs.systems.follows = "hyprland/systems";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
    hyprland-hyprspace.url = "github:KZDKM/Hyprspace";
    hyprland-hyprspace.inputs.hyprland.follows = "hyprland";

    waybar.url = "github:Alexays/Waybar";

    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
  };

  outputs = {
    self,
    nix-ld,
    flake-parts,
    nixpkgs,
    hm,
    hyprland,
    nix-index-db,
    nur,
    ...
    } @ inputs:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system}.extend nur.overlays.default;
      userhostname = "rgnh55@nixos";

      hmConfig = hm.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs; };
        inherit pkgs;
        modules = [
          { nixpkgs.config.allowUnfree = true; }
          nix-index-db.homeModules.nix-index
          ./home
        ];
      };

      noConfig = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; outputs = self.outputs; };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.config.android_sdk.accept_license = true;
              nixpkgs.config.cudaSupport = true;
              nixpkgs.config.nvidia.acceptLicense = true;
            }

            # nix-ld.nixosModules.nix-ld

            ./system
          ];
        };
      };
    in

      flake-parts.lib.mkFlake { inherit inputs; } {
        flake = {
          homeConfigurations.${userhostname} = hmConfig;
          nixosConfigurations = noConfig;
        };
        systems = [ system ];
      };
}
