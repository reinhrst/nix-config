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
        "<leader>fA" = {
          action = "live_grep";
          options.desc = "rg (regex-search all files)";
        };
        "<leader>fa" = {
          action = "grep_string";
          options.desc = "fzf (fuzzy-search all files)";
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