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
        version = "5e6fb91f52a595a0dd554c7eea022c467ff80d86";
        src = pkgs.fetchFromGitHub {
          owner = "fdschmidt93";
          repo = "telescope-egrepify.nvim";
          rev = "5e6fb91f52a595a0dd554c7eea022c467ff80d86";
          sha256 = "sha256-Zimdnz+Jpb5eBPDjS6P2fIzJM/CbnQ9qNQFMQ92qrgM=";
        };
      })
    ];

    extraConfigLua = ''
      require("telescope").load_extension("egrepify")
    '';
  };
}
