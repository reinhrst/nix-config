{ config, lib, pkgs, ... }:

{
  # Add Maccy to user packages
  home.packages = [ pkgs.maccy ];

  # Activation script: Set clipboard check interval (runs on home-manager switch)
  home.activation.setMaccyDefaults = lib.hm.dag.entryAfter ["writeBoundary"] ''
      /usr/bin/defaults write org.p0deje.Maccy clipboardCheckInterval 0.1|| echo "Trying to set clipboardCheckInterval in Maccy to 100ms failed, probably because of Full Disk Access restrictions. Do it manually, or ignore" 1>&2
  '';
}

