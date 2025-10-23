{ config, lib, pkgs, ... }:

{
  imports = [
    ./plugins/telescope.nix
    ./plugins/lsp.nix
    ./plugins/cmp.nix
    ./plugins/formatting.nix
    ./plugins/treesitter.nix
    ./plugins/ui.nix
    ./plugins/git.nix
    ./plugins/misc.nix
    ./plugins/markdown.nix
    ./plugins/egrepify.nix
    ./plugins/nui.nix
    ./plugins/telescope-symbols.nix
    ./config/options.nix
    ./config/keymaps.nix
    ./config/autocmds.nix
    ./config/lua-functions.nix
  ];

  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";
    globals.maplocalleader = " ";

    colorschemes.gruvbox = {
      enable = true;
    };

    # Diagnostics
    diagnostic = {
      settings = {
        underline = true;
        update_in_insert = false;
        virtual_text = {
          spacing = 4;
          prefix = "●";
        };
        severity_sort = true;
        signs = {
          text = {
            error = " ";
            warn = " ";
          };
        };
      };
    };

    extraConfigLua = ''
      vim.api.nvim_set_hl(0, "TelescopePromptCounter", { fg = "#d5c4a1" })
    '';
  };
}
