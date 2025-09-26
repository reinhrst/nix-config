{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    # Disable documentation generation to avoid warnings
    enableMan = false;

    globals.mapleader = " ";
    globals.maplocalleader = " ";

    colorschemes.gruvbox = {
      enable = true;
    };

    plugins = {

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

      # LSP
      lsp = {
        enable = true;
        servers = {
          lua_ls = {
            enable = true;
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false;
                };
                completion = {
                  callSnippet = "Replace";
                };
              };
            };
          };
          jsonls = {
            enable = true;
          };
        };
      };


      # Treesitter
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent = {
            enable = true;
            disable = [ "python" ];
          };
          # Disable auto install - let nixvim handle it
          auto_install = false;
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "<C-space>";
              node_incremental = "<C-space>";
              scope_incremental = "<nop>";
              node_decremental = "<bs>";
            };
          };
        };
        # Let nixvim handle grammar installation
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          c
          html
          javascript
          json
          lua
          markdown
          markdown_inline
          python
          query
          regex
          rust
          swift
          tsx
          typescript
          vim
          yaml
        ];
      };

      # Completion
      cmp = {
        enable = true;
        settings = {
          completion = {
            completeopt = "menu,menuone,noinsert,noselect";
          };
          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };
          mapping = {
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = false })";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
          formatting = {
            format = ''
              function(_, item)
                local icons = {
                  Array = " ";
                  Boolean = " ";
                  Class = " ";
                  Color = " ";
                  Constant = " ";
                  Constructor = " ";
                  Copilot = " ";
                  Enum = " ";
                  EnumMember = " ";
                  Event = " ";
                  Field = " ";
                  File = " ";
                  Folder = " ";
                  Function = " ";
                  Interface = " ";
                  Key = " ";
                  Keyword = " ";
                  Method = " ";
                  Module = " ";
                  Namespace = " ";
                  Null = " ";
                  Number = " ";
                  Object = " ";
                  Operator = " ";
                  Package = " ";
                  Property = " ";
                  Reference = " ";
                  Snippet = " ";
                  String = " ";
                  Struct = " ";
                  Text = " ";
                  TypeParameter = " ";
                  Unit = " ";
                  Value = " ";
                  Variable = " ";
                }
                if icons[item.kind] then
                  item.kind = icons[item.kind] .. item.kind
                end
                return item
              end
            '';
          };
          experimental = {
            ghost_text = {
              hl_group = "LspCodeLens";
            };
          };
        };
      };

      # Snippets
      luasnip = {
        enable = true;
      };

      # Status line
      lualine = {
        enable = true;
        settings = {
          options = {
            icons_enabled = true;
            theme = "auto";
            component_separators = { left = ""; right = ""; };
            section_separators = { left = ""; right = ""; };
            disabled_filetypes = [];
            always_divide_middle = true;
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [ "branch" "diff" "diagnostics" ];
            lualine_c = [ { __unkeyed-1 = "filename"; path = 1; } ];
            lualine_x = [ "encoding" "fileformat" "filetype" ];
            lualine_y = [ "progress" ];
            lualine_z = [ "location" ];
          };
          inactive_sections = {
            lualine_a = [];
            lualine_b = [];
            lualine_c = [ "filename" ];
            lualine_x = [ "location" ];
            lualine_y = [];
            lualine_z = [];
          };
          tabline = {};
          extensions = [];
        };
      };

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

      # Comments
      comment = {
        enable = true;
      };

      # Surround
      nvim-surround = {
        enable = true;
      };

      # Which-key
      which-key = {
        enable = true;
      };

      # Web devicons
      web-devicons = {
        enable = true;
      };

      # Notifications
      notify = {
        enable = true;
      };

      # Indent blankline
      indent-blankline = {
        enable = true;
      };
    };

    # Key mappings
    keymaps = [
      # Better up/down
      {
        mode = "n";
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = { expr = true; silent = true; };
      }
      {
        mode = "n";
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = { expr = true; silent = true; };
      }

      # Window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Go to left window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Go to lower window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Go to upper window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Go to right window";
      }

      # Window resizing
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options.desc = "Increase window height";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options.desc = "Decrease window height";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options.desc = "Decrease window width";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options.desc = "Increase window width";
      }

      # Clear search
      {
        mode = [ "i" "n" ];
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        options.desc = "Escape and clear hlsearch";
      }

      # Save file
      {
        mode = [ "i" "v" "n" "s" ];
        key = "<C-s>";
        action = "<cmd>w<cr><esc>";
        options.desc = "Save file";
      }

      # Better indenting
      {
        mode = "v";
        key = "<";
        action = "<gv";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
      }

      # New file
      {
        mode = "n";
        key = "<leader>fn";
        action = "<cmd>enew<cr>";
        options.desc = "New File";
      }

      # Quickfix
      {
        mode = "n";
        key = "<leader>xl";
        action = "<cmd>lopen<cr>";
        options.desc = "Location List";
      }
      {
        mode = "n";
        key = "<leader>xq";
        action = "<cmd>copen<cr>";
        options.desc = "Quickfix List";
      }

      # Windows
      {
        mode = "n";
        key = "<leader>ww";
        action = "<C-W>p";
        options.desc = "Other window";
      }
      {
        mode = "n";
        key = "<leader>wd";
        action = "<C-W>c";
        options.desc = "Delete window";
      }
      {
        mode = "n";
        key = "<leader>w-";
        action = "<C-W>s";
        options.desc = "Split window below";
      }
      {
        mode = "n";
        key = "<leader>w|";
        action = "<C-W>v";
        options.desc = "Split window right";
      }
      {
        mode = "n";
        key = "<leader>-";
        action = "<C-W>s";
        options.desc = "Split window below";
      }
      {
        mode = "n";
        key = "<leader>|";
        action = "<C-W>v";
        options.desc = "Split window right";
      }

      # Tabs
      {
        mode = "n";
        key = "<leader><tab>l";
        action = "<cmd>tablast<cr>";
        options.desc = "Last Tab";
      }
      {
        mode = "n";
        key = "<leader><tab>f";
        action = "<cmd>tabfirst<cr>";
        options.desc = "First Tab";
      }
      {
        mode = "n";
        key = "<leader><tab><tab>";
        action = "<cmd>tabnew<cr>";
        options.desc = "New Tab";
      }
      {
        mode = "n";
        key = "<leader><tab>]";
        action = "<cmd>tabnext<cr>";
        options.desc = "Next Tab";
      }
      {
        mode = "n";
        key = "<leader><tab>d";
        action = "<cmd>tabclose<cr>";
        options.desc = "Close Tab";
      }
      {
        mode = "n";
        key = "<leader><tab>[";
        action = "<cmd>tabprevious<cr>";
        options.desc = "Previous Tab";
      }

      # Quit
      {
        mode = "n";
        key = "<leader>qq";
        action = "<cmd>qa<cr>";
        options.desc = "Quit all";
      }

      # LuaSnip
      {
        mode = [ "s" "i" ];
        key = "<C-tab>";
        action = "<cmd>lua require('luasnip').jump(1)<cr>";
      }
      {
        mode = [ "i" "s" ];
        key = "<S-C-tab>";
        action = "<cmd>lua require('luasnip').jump(-1)<cr>";
      }
    ];

    # Options
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      cursorline = true;
      termguicolors = true;
      background = "dark";
      signcolumn = "yes";
      backspace = "indent,eol,start";
      clipboard = "unnamedplus";
      splitright = true;
      splitbelow = true;
      swapfile = false;
      backup = false;
      undofile = true;
      updatetime = 300;
      timeoutlen = 1000;
      completeopt = "menuone,noselect";
      conceallevel = 0;
      fileencoding = "utf-8";
      hlsearch = true;
      pumheight = 10;
      showmode = false;
      showtabline = 2;
      smartindent = true;
      writebackup = false;
      mouse = "a";
      guifont = "monospace:h17";
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
            hint = " ";
            info = " ";
          };
        };
      };
    };
  };
}