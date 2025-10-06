{
  description = "Reinoud's macOS + Home Manager (single repo)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url  = "github:LnL7/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";
    nixvim.url = "github:nix-community/nixvim";

    # keep everyone on the same nixpkgs
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, nixvim, ... }:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs { inherit system; };
    username = "reinoud";
    hostname = "mindy";
  in {
    # 1) System config (sudo): `sudo darwin-rebuild switch --flake .#mindy`
    darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useUserPackages = true;

          home-manager.users.${username} = {
            imports = [
              nixvim.homeModules.nixvim
              ./home.nix
            ];
          };
        }
      ];
    };

    # 2) User config (no sudo): `home-manager switch --flake .#reinoud@mindy`
    homeConfigurations."${username}@${hostname}" =
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          # Reuse the SAME user module as above
          ({ config, pkgs, ... }: {
            # When HM runs standalone, set these explicitly:
            home.username = username;
            home.homeDirectory = "/Users/${username}";
          })
          ./home.nix
        ];
      };
  };
}
