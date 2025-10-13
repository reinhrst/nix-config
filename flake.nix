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

    # Linux packages for docker
    linuxSystem = "aarch64-linux";
    linuxPkgs = import nixpkgs {
      system = linuxSystem;
      config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
        "claude-code"
      ];
    };
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
          nixvim.homeModules.nixvim
          ./home.nix
        ];
      };

    # 3) Docker config (aarch64-linux): `home-manager switch --flake .#reinoud@docker`
    homeConfigurations."${username}@docker" =
      home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        modules = [
          ({ config, pkgs, ... }: {
            home.username = username;
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "24.05";

            # Allow specific unfree packages
            nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
              "claude-code"
            ];

            programs.home-manager.enable = true;

            # Import only common modules (no desktop)
            imports = [
              nixvim.homeModules.nixvim
              ./modules/common/nixvim
              ./modules/common/zsh.nix
              ./modules/common/fzf.nix
              ./modules/common/starship.nix
              ./modules/common/atuin.nix
              ./modules/common/git.nix
              ./modules/common/grok-cli.nix
            ];

            # Docker packages only (no desktop/fonts)
            home.packages = (import ./modules/common/packages.nix { inherit pkgs; }).packages.docker;

            # Enable for non-NixOS Linux systems (sources Nix profile automatically)
            targets.genericLinux.enable = true;

            # Set locale for proper character width calculation
            home.sessionVariables = {
              LANG = "C.UTF-8";
            };
          })
        ];
      };
  };
}
