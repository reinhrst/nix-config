{ config, pkgs, ... }:

let
  commonPackages = import ./modules/common/packages.nix { inherit pkgs; };
  desktopFonts = import ./modules/desktop/fonts.nix { inherit pkgs; };
  desktopApps = import ./modules/desktop/desktop-apps.nix { inherit pkgs; };
in
{
  # Import modules
  imports = [
    # Common modules (shared with docker)
    ./modules/common/nixvim
    ./modules/common/zsh.nix
    ./modules/common/fzf.nix
    ./modules/common/starship.nix
    ./modules/common/atuin.nix
    ./modules/common/aider-chat.nix
    ./modules/common/git.nix
    ./modules/common/grok-cli.nix
    ./modules/common/tmux.nix
    ./modules/common-config.nix

    # Desktop-only modules
    ./modules/desktop/colima.nix
    ./modules/desktop/ghostty.nix
    ./modules/desktop/maccy.nix
  ];

  # Allow specific unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "claude-code"
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
    commonPackages.packages.desktop
    ++ desktopFonts.packages
    ++ desktopApps.packages;
}
