{ config, ... }:

let
    system = "aarch64-darwin";
    username = "reinoud";
    hostname = "mindy";
    desktopApps = import ./modules/desktop-apps.nix;
in
{
  programs.zsh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.optimise.automatic = true;
  system.stateVersion = 6;

  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true;
    KeyRepeat = 2;
    InitialKeyRepeat = 15;
    AppleShowAllFiles = true;
  };

  system.defaults.finder = {
    AppleShowAllFiles = true;
    ShowPathbar = true;
    ShowStatusBar = true;
  };

  system.defaults.dock = {
    autohide = true;
  };

  system.primaryUser = username;

  # Configure user
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = "/etc/profiles/per-user/${username}/bin/zsh";
  };

  # Add zsh to available shells
  environment.shells = [ "/etc/profiles/per-user/${username}/bin/zsh" ];

  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Homebrew configuration
  homebrew = {
    enable = true;
    casks = desktopApps.casks;
  };
}
