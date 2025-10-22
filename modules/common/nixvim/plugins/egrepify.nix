{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    plugins.telescope.settings.extensions.egrepify = {
      AND = true;
      permutations = true;
    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "telescope-egrepify";
        version = "master";
        src = pkgs.fetchFromGitHub {
          owner = "fdschmidt93";
          repo = "telescope-egrepify.nvim";
          rev = "master";
          sha256 = "sha256-Zimdnz+Jpb5eBPDjS6P2fIzJM/CbnQ9qNQFMQ92qrgM="; # Replace with actual sha256 from nix-prefetch-url or similar
        };
      })
    ];

    extraConfigLua = ''
      require("telescope").load_extension("egrepify")
    '';
  };
}
