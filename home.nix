{ config, pkgs, ... }:

{
  # Import modules
  imports = [
    ./modules/nixvim
    ./modules/zsh.nix
    ./modules/fzf.nix
    ./modules/starship.nix
    ./modules/atuin.nix
    ./modules/git.nix
    ./modules/desktop.nix
    ./modules/colima.nix
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
  home.packages = with pkgs; [
    # Claude Code
    claude-code

    # Fonts
    nerd-fonts.jetbrains-mono

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
    ripgrep
    dust
    act
  ];
}
