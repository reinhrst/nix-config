{ pkgs, ... }:

{
  packages = rec {
    # CLI utilities
    cli = with pkgs; [
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

      # Terminal multiplexer
      tmux

      # Other useful CLI tools
      fd
      bat
      delta
      jq
      eza
      ripgrep
      dust
      gh
    ];

    # Development tools
    dev = with pkgs; [
      claude-code
      aider-chat
      ffmpeg-full
      terminal-notifier

      # Formatters (for conform.nvim)
      prettier
      stylua
      shfmt
      taplo

      # Linters (for nvim-lint)
      shellcheck
      hadolint

      # Python formatting (ruff_format used by conform.nvim)
      ruff

      # Other
      act
    ];

    # All packages for docker (cli + dev, no desktop-specific)
    docker = cli ++ dev;

    # All packages for desktop (will be combined with desktop-specific packages in home.nix)
    desktop = docker;
  };
}
