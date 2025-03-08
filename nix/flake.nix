{
  inputs = {
    systems.url = "github:nix-systems/default-linux";

    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/master";

    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    flake-compat.url = "github:edolstra/flake-compat";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-db.url = "github:Mic92/nix-index-database";
    nix-index-db.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "hm";
    agenix.inputs.systems.follows = "systems";

    hyprland.url = "github:hyprwm/hyprland/9b51d73a1e22c86e8d6ec78750e622da9242e32f";
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

    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    waybar.url = "github:Alexays/Waybar";

    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";

    nvf.url = "github:notashelf/nvf";

    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    flake-parts,
    nixpkgs,
    hm,
    hyprland,
    nix-index-db,
    nur,
    nix-snapd,
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
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.android_sdk.accept_license = true;
            nixpkgs.config.cudaSupport = true;
            nixpkgs.config.nvidia.acceptLicense = true;
          }

          ./system

          nix-snapd.nixosModules.default {
            services.snap.enable = true;
          }
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
