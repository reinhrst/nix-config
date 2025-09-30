{ config, pkgs, ... }:

{
  # Import modules
  imports = [
    ./modules/nixvim
    ./modules/zsh.nix
    ./modules/fzf.nix
    ./modules/starship.nix
    ./modules/atuin.nix
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

  # Install packages
  home.packages = with pkgs; [
    # Claude Code
    claude-code

    # Formatters (for conform.nvim)
    prettier
    stylua
    shfmt
    taplo

    # Linters (for nvim-lint) - only tools without LSP coverage
    shellcheck
    hadolint

    # Python formatting (ruff_format used by conform.nvim)
    ruff

    # Other useful CLI tools
    fd
    bat
    delta
    jq
  ];
}