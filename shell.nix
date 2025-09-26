{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Nix development tools
    nixpkgs-fmt
    nil # Nix LSP

    # Documentation and helpers
    jq

    # Development utilities
    git
    gnumake
  ];

  shellHook = ''
    echo "🏠 Home Manager Development Shell"
    echo "Available commands:"
    echo "  make help     - Show all make targets"
    echo "  make check    - Check configuration"
    echo "  make switch   - Apply configuration"
    echo "  nixpkgs-fmt   - Format nix files"
    echo ""
  '';
}