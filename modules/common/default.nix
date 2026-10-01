# Single source of truth for modules shared between macOS (home.nix) and the
# docker config (flake.nix). Platform-specific modules stay in their entry
# point so the shared set can never drift silently.
{
  imports = [
    ./nixvim
    ./zsh.nix
    ./fzf.nix
    ./starship.nix
    ./atuin.nix
    ./git.nix
  ];
}
