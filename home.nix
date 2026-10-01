{ config, pkgs, ... }:

let
  commonPackages = import ./modules/common/packages.nix { inherit pkgs; };
  desktopFonts = import ./modules/desktop/fonts.nix { inherit pkgs; };
  allowUnfree = import ./modules/allow-unfree.nix;
in
{
  # Import modules
  imports = [
    # Common modules (shared with docker, see modules/common/default.nix)
    ./modules/common

    # macOS-only modules
    ./modules/common/tmux.nix
    ./modules/common/yazi.nix
    ./modules/common-config.nix

    # Desktop-only modules
    ./modules/desktop/ghostty.nix
    ./modules/desktop/maccy.nix
    ./modules/desktop/hammerspoon.nix
  ];

  # Allow specific unfree packages (see modules/allow-unfree.nix)
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) allowUnfree;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "reinoud";
  home.homeDirectory = "/Users/reinoud";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # Activation scripts
  home.activation.rebuildZshCompinit = config.lib.dag.entryAfter ["linkGeneration"] ''
    # Explicitly provide atuin to avoid PATH issues during activation
    export PATH="${pkgs.atuin}/bin:${pkgs.zsh}/bin:$PATH"
    ${pkgs.zsh}/bin/zsh -lic "
    set -euo pipefail
    rm -f ~/.config/zsh/.zcompdump
    compinit
    zcompile ~/.config/zsh/.zcompdump
    chmod u-w ~/.config/zsh/.zcompdump*
    echo generated compinit files:
    ls -la ~/.config/zsh/.zcompdump*"
  '';

  # Install packages
  home.packages =
    commonPackages.packages.mac
    ++ desktopFonts.packages;
}
