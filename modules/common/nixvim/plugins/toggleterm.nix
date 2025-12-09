{ config, lib, pkgs, ... }:

{
  programs.nixvim.plugins.toggleterm = {
    enable = true;
    settings = {
      open_mapping = ''"<C-T>"'';
      direction = "float";
    };
  };
}
