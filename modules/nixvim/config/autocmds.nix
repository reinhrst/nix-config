{ config, lib, pkgs, ... }:

{
  programs.nixvim.extraConfigLua = ''
    -- Auto-enter insert mode when entering terminal
    local terminal_group = vim.api.nvim_create_augroup("terminal_auto_insert", { clear = true })

    -- When a new terminal is opened
    vim.api.nvim_create_autocmd("TermOpen", {
      group = terminal_group,
      callback = function()
        vim.cmd("startinsert")
      end,
    })

    -- When entering a terminal buffer (covers window switching)
    vim.api.nvim_create_autocmd({"BufEnter", "WinEnter"}, {
      group = terminal_group,
      callback = function()
        if vim.bo.buftype == "terminal" then
          vim.cmd("startinsert")
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
  '';
}