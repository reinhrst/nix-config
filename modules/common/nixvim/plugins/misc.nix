{ config, lib, pkgs, ... }:

{
  programs.nixvim.plugins = {
    # Comments
    comment = {
      enable = true;
    };

    # Surround
    nvim-surround = {
      enable = true;
    };
  };
}