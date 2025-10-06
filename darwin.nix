{ config, pkgs, ... }:

let
    system = "aarch64-darwin";
    pkgs = import nixpkgs { inherit system; };
    username = "reinoud";
    hostname = "mindy";
in
{
  programs.zsh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.optimise.automatic = true;
  system.stateVersion=6;
  system.primaryUser = username;

  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true;
    KeyRepeat = 2;
    InitialKeyRepeat = 15;
  };

  # Ensure zsh from Nix profile is available as a valid shell
  environment.shells = [ "/etc/profiles/per-user/${username}/bin/zsh" ];
  users.users.${username} = {
    home  = "/Users/${username}";
    shell = "/etc/profiles/per-user/${username}/bin/zsh";
  };
}

