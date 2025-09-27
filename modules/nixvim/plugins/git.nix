{ config, lib, pkgs, ... }:

{
  programs.nixvim.plugins = {
    # Git integration
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = { text = " "; };
          change = { text = " "; };
          delete = { text = " "; };
        };
      };
    };
  };
}