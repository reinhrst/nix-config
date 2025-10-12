{ config, lib, pkgs, ... }:

{
  programs.nixvim.keymaps = [
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

    # Disable arrow keys
    {
      mode = [ "n" "i" "v" ];
      key = "<Up>";
      action = "<Nop>";
    }
    {
      mode = [ "n" "i" "v" ];
      key = "<Down>";
      action = "<Nop>";
    }
    {
      mode = [ "n" "i" "v" ];
      key = "<Left>";
      action = "<Nop>";
    }
    {
      mode = [ "n" "i" "v" ];
      key = "<Right>";
      action = "<Nop>";
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

    # Diagnostics
    {
      mode = "n";
      key = "<leader>cd";
      action = "<cmd>lua vim.diagnostic.open_float()<cr>";
      options.desc = "Show diagnostic at cursor";
    }

    # Trouble
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options.desc = "Symbols (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>cl";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      options.desc = "LSP Definitions / references / ... (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options.desc = "Location List (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      options.desc = "Quickfix List (Trouble)";
    }

    # Quickfix (native)
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

    # Tabs (normal mode)
    {
      mode = "n";
      key = "<C-,>";
      action = "<cmd>tabprevious<cr>";
      options.desc = "Previous Tab";
    }
    {
      mode = "n";
      key = "<C-.>";
      action = "<cmd>tabnext<cr>";
      options.desc = "Next Tab";
    }
    {
      mode = "n";
      key = "<C-S-,>";
      action = "<cmd>tabmove -1<cr>";
      options.desc = "Move tab left";
    }
    {
      mode = "n";
      key = "<C-S-.>";
      action = "<cmd>tabmove +1<cr>";
      options.desc = "Move tab right";
    }

    # Tabs from terminal mode (exit terminal mode first)
    {
      mode = "t";
      key = "<C-,>";
      action = "<C-\\><C-n><cmd>tabprevious<cr>";
      options.desc = "Previous Tab";
    }
    {
      mode = "t";
      key = "<C-.>";
      action = "<C-\\><C-n><cmd>tabnext<cr>";
      options.desc = "Next Tab";
    }

    # Tabs from insert mode (exit insert mode first)
    {
      mode = "i";
      key = "<C-,>";
      action = "<Esc><cmd>tabprevious<cr>";
      options.desc = "Previous Tab";
    }
    {
      mode = "i";
      key = "<C-.>";
      action = "<Esc><cmd>tabnext<cr>";
      options.desc = "Next Tab";
    }
    {
      mode = "n";
      key = "<leader>tn";
      action = "<cmd>tabnew<cr>";
      options.desc = "New Tab";
    }
    {
      mode = "n";
      key = "<leader>tc";
      action = "<cmd>tabclose<cr>";
      options.desc = "Close Tab";
    }

    # Quit
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>qa<cr>";
      options.desc = "Quit all";
    }

    # Claude Code
    {
      mode = "n";
      key = "<leader>a";
      action = "";
      options.desc = "AI/Claude Code";
    }
    {
      mode = "n";
      key = "<leader>ac";
      action = "<cmd>ClaudeCode<cr>";
      options.desc = "Toggle Claude";
    }
    {
      mode = "n";
      key = "<leader>af";
      action = "<cmd>ClaudeCodeFocus<cr>";
      options.desc = "Focus Claude";
    }
    {
      mode = "n";
      key = "<leader>ar";
      action = "<cmd>ClaudeCode --resume<cr>";
      options.desc = "Resume Claude";
    }
    {
      mode = "n";
      key = "<leader>aC";
      action = "<cmd>ClaudeCode --continue<cr>";
      options.desc = "Continue Claude";
    }
    {
      mode = "n";
      key = "<leader>am";
      action = "<cmd>ClaudeCodeSelectModel<cr>";
      options.desc = "Select Claude model";
    }
    {
      mode = "n";
      key = "<leader>ab";
      action = "<cmd>ClaudeCodeAdd %<cr>";
      options.desc = "Add current buffer";
    }
    {
      mode = "v";
      key = "<leader>as";
      action = "<cmd>ClaudeCodeSend<cr>";
      options.desc = "Send to Claude";
    }
    {
      mode = "n";
      key = "<leader>as";
      action = "<cmd>ClaudeCodeTreeAdd<cr>";
      options.desc = "Add file from tree";
    }
    {
      mode = "n";
      key = "<leader>aa";
      action = "<cmd>ClaudeCodeDiffAccept<cr>";
      options.desc = "Accept diff";
    }
    {
      mode = "n";
      key = "<leader>ad";
      action = "<cmd>ClaudeCodeDiffDeny<cr>";
      options.desc = "Deny diff";
    }

    # Terminal navigation - works in all terminals
    {
      mode = "t";
      key = "<C-w>h";
      action = "<C-\\><C-n><C-w>h";
      options.desc = "Go to left window from terminal";
    }
    {
      mode = "t";
      key = "<C-w>j";
      action = "<C-\\><C-n><C-w>j";
      options.desc = "Go to lower window from terminal";
    }
    {
      mode = "t";
      key = "<C-w>k";
      action = "<C-\\><C-n><C-w>k";
      options.desc = "Go to upper window from terminal";
    }
    {
      mode = "t";
      key = "<C-w>l";
      action = "<C-\\><C-n><C-w>l";
      options.desc = "Go to right window from terminal";
    }

    # Easy escape from terminal
    {
      mode = "t";
      key = "<C-Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
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

    # Format buffer
    {
      mode = "n";
      key = "<leader>cf";
      action = "<cmd>lua require('conform').format()<cr>";
      options.desc = "Format buffer";
    }

    # Gitsigns - Navigation
    {
      mode = "n";
      key = "]c";
      action.__raw = ''
        function()
          if vim.wo.diff then
            vim.cmd.normal({']c', bang = true})
          else
            require('gitsigns').nav_hunk('next')
          end
        end
      '';
      options.desc = "Next git hunk";
    }
    {
      mode = "n";
      key = "[c";
      action.__raw = ''
        function()
          if vim.wo.diff then
            vim.cmd.normal({'[c', bang = true})
          else
            require('gitsigns').nav_hunk('prev')
          end
        end
      '';
      options.desc = "Previous git hunk";
    }

    # Gitsigns - Hunk actions
    {
      mode = "n";
      key = "<leader>hs";
      action = "<cmd>Gitsigns stage_hunk<cr>";
      options.desc = "Stage hunk";
    }
    {
      mode = "n";
      key = "<leader>hr";
      action = "<cmd>Gitsigns reset_hunk<cr>";
      options.desc = "Reset hunk";
    }
    {
      mode = "n";
      key = "<leader>hS";
      action = "<cmd>Gitsigns stage_buffer<cr>";
      options.desc = "Stage buffer";
    }
    {
      mode = "n";
      key = "<leader>hu";
      action = "<cmd>Gitsigns undo_stage_hunk<cr>";
      options.desc = "Undo stage hunk";
    }
    {
      mode = "n";
      key = "<leader>hR";
      action = "<cmd>Gitsigns reset_buffer<cr>";
      options.desc = "Reset buffer";
    }
    {
      mode = "n";
      key = "<leader>hp";
      action = "<cmd>Gitsigns preview_hunk<cr>";
      options.desc = "Preview hunk";
    }
    {
      mode = "n";
      key = "<leader>hb";
      action = "<cmd>lua require('gitsigns').blame_line{full=true}<cr>";
      options.desc = "Blame line";
    }
    {
      mode = "n";
      key = "<leader>hd";
      action = "<cmd>Gitsigns diffthis<cr>";
      options.desc = "Diff file";
    }
    {
      mode = "n";
      key = "<leader>hD";
      action = "<cmd>lua require('gitsigns').diffthis('~')<cr>";
      options.desc = "Diff file (cached)";
    }

    # Gitsigns - Toggles
    {
      mode = "n";
      key = "<leader>tb";
      action = "<cmd>Gitsigns toggle_current_line_blame<cr>";
      options.desc = "Toggle line blame";
    }
    {
      mode = "n";
      key = "<leader>td";
      action = "<cmd>Gitsigns toggle_deleted<cr>";
      options.desc = "Toggle deleted";
    }

    # Gitsigns - Text object
    {
      mode = [ "o" "x" ];
      key = "ih";
      action = ":<C-U>Gitsigns select_hunk<CR>";
      options.desc = "Select hunk";
    }

    # System clipboard keymaps
    # Copy to system clipboard
    {
      mode = [ "n" "v" ];
      key = "<leader>y";
      action = "\"+y";
      options.desc = "Yank to system clipboard";
    }

    # Paste from system clipboard
    {
      mode = [ "n" "v" ];
      key = "<leader>p";
      action = "\"+p";
      options.desc = "Paste from system clipboard";
    }
    {
      mode = [ "n" "v" ];
      key = "<leader>P";
      action = "\"+P";
      options.desc = "Paste before from system clipboard";
    }
  ];
}