{ config, lib, pkgs, ... }:

{
  programs.nixvim.extraConfigLua = ''
    -- Terminal background highlighting based on mode
    local terminal_group = vim.api.nvim_create_augroup("terminal_visual_mode", { clear = true })

    -- Set terminal background when entering terminal in normal mode
    vim.api.nvim_create_autocmd({"TermEnter", "BufEnter"}, {
      group = terminal_group,
      callback = function()
        if vim.bo.buftype == "terminal" then
          -- Use theme's CursorLine color for subtle distinction
          vim.cmd("highlight link TerminalNormal CursorLine")
          vim.wo.winhighlight = "Normal:TerminalNormal"
        end
      end,
    })

    -- Clear terminal background highlighting when entering insert mode
    vim.api.nvim_create_autocmd("TermLeave", {
      group = terminal_group,
      callback = function()
        if vim.bo.buftype == "terminal" then
          -- Reset to normal background
          vim.wo.winhighlight = ""
        end
      end,
    })

    -- Also handle mode changes within terminal
    vim.api.nvim_create_autocmd("ModeChanged", {
      group = terminal_group,
      callback = function()
        if vim.bo.buftype == "terminal" then
          if vim.fn.mode() == "t" then
            -- Insert mode in terminal - normal background
            vim.wo.winhighlight = ""
          else
            -- Normal mode in terminal - use theme's CursorLine color
            vim.cmd("highlight link TerminalNormal CursorLine")
            vim.wo.winhighlight = "Normal:TerminalNormal"
          end
        end
      end,
    })

    -- Highlight yanked text briefly
    vim.api.nvim_create_autocmd("TextYankPost", {
      group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
      callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
      end,
    })

    -- Restore cursor position when opening files
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = vim.api.nvim_create_augroup("restore_cursor", { clear = true }),
      callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
          pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
      end,
    })
  '';
}