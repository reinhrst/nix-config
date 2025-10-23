{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "telescope-symbols";
        version = "2023-11-24";
        src = pkgs.fetchFromGitHub {
          owner = "nvim-telescope";
          repo = "telescope-symbols.nvim";
          rev = "a6d0127a53d39b9fc2af75bd169d288166118aec";
          sha256 = "sha256-zYON9z3ELwjfqZ11LD6E7M+bymuBHxrSjYXhsCPEwR8=";
        };
      })
    ];
  };
}
