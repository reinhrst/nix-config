{ config, pkgs, ... }:

{
  # Import modules
  imports = [
    ./modules/nixvim.nix
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "reinoud";
  home.homeDirectory = "/Users/reinoud";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";
}