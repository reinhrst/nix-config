{ config, lib, pkgs, ... }:

{
  # Enable Maccy (toggle if needed in the future)
  options.programs.maccy.enable = true;

  config = {
    # Add Maccy to user packages
    home.packages = [ pkgs.maccy ];

    # Activation script: Set clipboard check interval (runs on home-manager switch)
    home.activation.setMaccyDefaults = config.lib.dag.entryAfter ["writeBoundary"] ''
      /usr/bin/defaults write org.p0deje.Maccy clipboardCheckInterval 0.1
    '';
  };
}

