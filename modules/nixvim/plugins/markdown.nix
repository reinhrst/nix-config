{ config, lib, pkgs, ... }:

let
  markdown-link = pkgs.vimUtils.buildVimPlugin {
    name = "markdown-link";
    src = pkgs.fetchFromGitHub {
      owner = "reinhrst";
      repo = "markdown-link";
      rev = "v0.5.0";
      sha256 = "sha256-Jz4cS4ntD0TYpjLzVuEvgQTWhQcatEp4hcXZB2FaYEw=";
    };
  };
in
{
  programs.nixvim = {
    extraPlugins = [ markdown-link ];

    # Keybinding for markdown-link
    keymaps = [
      {
        mode = [ "n" "v" "i" ];
        key = "<C-T>";
        action = "<cmd>lua require('markdown-link').PasteMarkdownLink()<cr>";
        options.desc = "Paste Markdown Link";
      }
    ];
  };
}
