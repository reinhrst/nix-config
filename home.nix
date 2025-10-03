{ config, pkgs, ... }:

{
  # Import modules
  imports = [
    ./modules/nixvim
    ./modules/zsh.nix
    ./modules/fzf.nix
    ./modules/starship.nix
    ./modules/atuin.nix
    ./modules/tmux.nix
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

    # Basic Unix utilities
    coreutils      # Basic file, shell and text manipulation utilities
    findutils      # File finding utilities (find, xargs, etc.)
    gnused         # Stream editor
    gnugrep        # Text search utility
    gawk           # Text processing programming language
    diffutils      # File comparison utilities
    gnutar         # Archive utility
    gzip           # Compression utility
    which          # Locate a command
    file           # File type identification
    less           # Text pager
    curl           # Data transfer tool
    wget           # Network downloader
    git            # Version control system

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
    eza
    bat
    ripgrep
    dust
    colima
    docker
    act
  ];
}
