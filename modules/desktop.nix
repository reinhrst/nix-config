{ config, pkgs, ... }:

{
  # Ghostty configuration
  # (installed via Homebrew in darwin.nix, configured here)
  xdg.configFile."ghostty/config".text = ''
    # Add your Ghostty configuration here
    # Example:
    # theme = "catppuccin-mocha"
    # font-family = "JetBrains Mono NL"
    # font-size = 14
  '';
}
