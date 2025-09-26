# Home Manager Configuration

This repository contains a system-wide Home Manager configuration for managing development tools and applications.

## 📁 Structure

```
home-manager/
├── flake.nix           # Main flake configuration
├── home.nix            # Home Manager configuration
├── install.sh          # Installation script
├── Makefile            # Management commands
├── README.md           # This file
├── shell.nix           # Development shell
└── modules/
    └── nixvim.nix      # Neovim configuration
```

## 🚀 Quick Start

### Prerequisites

1. **Nix Package Manager**: Install using the Determinate Systems installer:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Enable Flakes**: Add to your Nix configuration:
   ```bash
   # User-level (recommended)
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

### Installation

1. **Clone or navigate to this configuration**:
   ```bash
   cd ~/.config/home-manager
   ```

2. **Run the installation script**:
   ```bash
   ./install.sh
   ```

   Or use the Makefile:
   ```bash
   make install
   ```

3. **Apply the configuration**:
   ```bash
   make switch
   ```

## 🛠️ Management

Use the provided Makefile for easy management:

```bash
make help           # Show all available commands
make switch         # Apply configuration changes
make update         # Update packages and apply
make check          # Check configuration syntax
make generations    # List all generations
make rollback       # Rollback to previous generation
make clean          # Clean up old generations
```

### Manual Commands

If you prefer to use home-manager directly:

```bash
# Apply changes
home-manager switch --flake ~/.config/home-manager

# Or if home-manager isn't installed permanently:
nix run nixpkgs#home-manager -- switch --flake ~/.config/home-manager

# List generations
home-manager generations

# Rollback
home-manager rollback

# Update packages
nix flake update && home-manager switch --flake ~/.config/home-manager
```

## 📝 Configuration

### Included Packages

This configuration currently includes:

#### Development Tools
- **Neovim (nixvim)**: Complete IDE setup with:
  - Gruvbox colorscheme
  - LSP servers (lua_ls, jsonls)
  - Telescope + FZF for file navigation
  - Treesitter syntax highlighting (Swift, Rust, TypeScript, etc.)
  - nvim-cmp completion with LuaSnip snippets
  - Lualine statusline
  - Git integration (gitsigns)
  - All custom keybindings preserved

_Additional packages will be added over time to reach the goal of 20+ managed applications._

### Customization

1. **Edit Neovim configuration**:
   ```bash
   $EDITOR modules/nixvim.nix
   ```

2. **Edit home configuration**:
   ```bash
   $EDITOR home.nix
   ```

3. **Apply changes**:
   ```bash
   make switch
   ```

4. **Add new programs**: Edit `home.nix` to add more programs managed by Home Manager:

```nix
{
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
  };

  programs.zsh = {
    enable = true;
    # ... zsh configuration
  };
}
```

## 🔧 Platform Configuration

### System Detection

The flake is currently configured for `aarch64-darwin` (Apple Silicon Mac). If you're on a different platform:

1. **Intel Mac**: Change `system = "aarch64-darwin";` to `system = "x86_64-darwin";`
2. **Linux**: Change to `system = "x86_64-linux";`

Edit the system in `flake.nix`.

## 🐛 Troubleshooting

### Common Issues

1. **Flakes not enabled**:
   ```bash
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

2. **Permission issues**:
   ```bash
   sudo chown -R $(whoami) ~/.config/home-manager
   ```

3. **Configuration errors**:
   ```bash
   make check  # Check syntax without building
   make validate  # Validate all nix files
   ```

### Getting Help

- Check configuration: `make check`
- System info: `make info`
- Validate files: `make validate`

## 🔄 Updating

### Update Packages
```bash
make update
```

### Update Home Manager
The flake automatically tracks the latest Home Manager release. Run `make update` to get the latest version.

### Rollback
If something breaks:
```bash
make rollback
```

## 📚 Resources

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nixvim Documentation](https://nix-community.github.io/nixvim/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)

## 🤝 Contributing

To modify or extend this configuration:

1. Edit the relevant files
2. Test with `make check`
3. Apply with `make switch`
4. Commit your changes

Happy Nix-ing! 🎉