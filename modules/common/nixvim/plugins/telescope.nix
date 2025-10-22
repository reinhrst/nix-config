{ config, lib, pkgs, ... }:

{
  programs.nixvim.plugins = {
    # Telescope
    telescope = {
      enable = true;
      extensions = {
        fzf-native = {
          enable = true;
        };
      };
      settings = {
        defaults = {
          file_ignore_patterns = [ "node_modules/" ".git/" ];
          hidden = true;
          vimgrep_arguments = [
            "rg"
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--smart-case"
            "--hidden"
          ];
          layout_strategy = "vertical";
          layout_config = {
            vertical = {
              width = 0.9;
              height = 0.9;
              preview_height = 0.7;
              prompt_position = "top";
              mirror = true;
            };
          };
          sorting_strategy = "ascending";
          mappings = {
            i = {
              "<C-p>" = { __raw = "require('telescope.actions.layout').toggle_preview"; };
            };
            n = {
              "<C-p>" = { __raw = "require('telescope.actions.layout').toggle_preview"; };
            };
          };
        };
      };
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options.desc = "[f]iles";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "[b]uffers";
        };
        "<leader>fa" = {
          action = "egrepify";
          options.desc = "egrepify (enhanced grep with permutations)";
        };
        "<leader>fC" = {
          action = "command_history";
          options.desc = "[C]ommand history";
        };
        "<leader>fc" = {
          action = "commands";
          options.desc = "[c]ommands";
        };
        "<leader>fR" = {
          action = "resume";
          options.desc = "[R]esume last search";
        };
        "<leader>fr" = {
          action = "registers";
          options.desc = "[r]egisters";
        };
        "<leader>flref" = {
          action = "lsp_references";
          options.desc = "[l]sp [ref]erences";
        };
        "<leader>ftree" = {
          action = "treesitter";
          options.desc = "[tree]sitter";
        };
        "<leader>fB" = {
          action = "builtin";
          options.desc = "[B]uiltins (select any telescope command)";
        };
        "<leader>fh" = {
          action = "help_tags";
          options.desc = "[h]elp tags";
        };
        "<leader>fo" = {
          action = "oldfiles";
          options.desc = "[o]pen recent file";
        };
        "<leader>fgc" = {
          action = "git_commits";
          options.desc = "[g]it [c]ommits";
        };
        "<leader>fgbh" = {
          action = "git_bcommits";
          options.desc = "[g]it [b]uffer [h]istory";
        };
        "<leader>fp" = {
          action = "pickers";
          options.desc = "previous [p]ickers";
        };
      };
    };
  };
}
