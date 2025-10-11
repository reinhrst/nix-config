{ config, pkgs, ... }:

{
  # Ghostty configuration
  # (installed via Homebrew in darwin.nix, configured here)
  xdg.configFile."ghostty/config".text = ''
    # Shell integration
    shell-integration = zsh

    theme = Snazzy

    # Font configuration
    font-family = "JetBrainsMono Nerd Font"
    font-size = 13
    font-feature = -calt, -liga, -dlig

    window-show-tab-bar = always
    clipboard-paste-protection = true

    # Keybindings
    keybind = super+z=undo

  '';
}
