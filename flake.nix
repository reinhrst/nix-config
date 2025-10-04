{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixvim, ... }:
    let
      system = "aarch64-darwin"; # Change to x86_64-darwin if on Intel Mac, or x86_64-linux if on Linux
      pkgs = nixpkgs.legacyPackages.${system};

      # Define checks for a given system
      makeChecks = system: let
        pkgs = nixpkgs.legacyPackages.${system};
        hmConfig = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            nixvim.homeModules.nixvim
            ./home.nix
          ];
        };
      in {
        # Check that the configuration builds
        build = hmConfig.activationPackage;
      };
    in {
      homeConfigurations."reinoud" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nixvim.homeModules.nixvim
          ./home.nix
        ];
      };

      # Checks for nix flake check
      checks = {
        aarch64-darwin = makeChecks "aarch64-darwin";
        x86_64-linux = makeChecks "x86_64-linux";
      };
    };
}