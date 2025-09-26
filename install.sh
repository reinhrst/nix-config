#!/usr/bin/env bash
set -euo pipefail

# Home Manager Installation Script
# This script installs home-manager using flakes

echo "🏠 Installing Home Manager with flakes..."

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo "❌ Nix is not installed. Please install Nix first:"
    echo "   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
    exit 1
fi

# Check if flakes are enabled
if ! nix show-config | grep -q "experimental-features.*flakes" 2>/dev/null; then
    echo "⚠️  Warning: Nix flakes may not be enabled."
    echo "   If you get errors, enable flakes by adding to ~/.config/nix/nix.conf:"
    echo "   experimental-features = nix-command flakes"
    echo ""
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📁 Using configuration from: $SCRIPT_DIR"

# Check if we're in the right directory
if [[ ! -f "$SCRIPT_DIR/flake.nix" ]]; then
    echo "❌ flake.nix not found in $SCRIPT_DIR"
    echo "   Please run this script from the home-manager config directory."
    exit 1
fi

# Determine the username
USERNAME=${USER:-$(whoami)}
echo "👤 Installing for user: $USERNAME"

# Install home-manager
if command -v home-manager &> /dev/null; then
    echo "✅ Home Manager is already installed."
    echo "   Version: $(home-manager --version 2>/dev/null || echo 'Unknown')"
else
    echo "📦 Installing Home Manager..."
    nix run nixpkgs#home-manager -- --help > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ Home Manager installed successfully via nix run."
        echo "   You can now use: nix run nixpkgs#home-manager -- <command>"
    else
        echo "❌ Failed to verify home-manager installation."
        echo "   You may need to install it manually."
        exit 1
    fi
fi

echo ""
echo "🎉 Home Manager installation completed!"
echo ""
echo "📝 Next steps:"
echo "   1. To apply your configuration, run:"
echo "      nix run nixpkgs#home-manager -- switch --flake $SCRIPT_DIR"
echo "      (or use: make switch)"
echo ""
echo "   2. To make changes, edit files in: $SCRIPT_DIR"
echo "      - Edit home config: $SCRIPT_DIR/home.nix"
echo ""
echo "   3. To install home-manager permanently (optional):"
echo "      nix profile install nixpkgs#home-manager"
echo ""
echo "🔧 Available commands:"
echo "   - make switch      # Apply configuration"
echo "   - make update      # Update and apply"
echo "   - make check       # Check configuration"
echo "   - make help        # Show all commands"