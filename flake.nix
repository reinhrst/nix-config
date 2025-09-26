{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin"; # Change to x86_64-darwin if on Intel Mac, or x86_64-linux if on Linux
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."reinoud" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
        ];
      };

      devShells.${system}.default = import ./shell.nix { inherit pkgs; };
    };
}