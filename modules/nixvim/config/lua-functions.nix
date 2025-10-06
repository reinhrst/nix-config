{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    extraConfigLua = ''
      -- Async run function
      local M = {}

      function M.async_run(cmd)
        local output = {}

        vim.fn.jobstart(cmd, {
          stdout_buffered = true,
          stderr_buffered = true,

          on_stdout = function(_, data)
            vim.list_extend(output, data)
          end,

          on_stderr = function(_, data)
            vim.list_extend(output, data)
          end,

          on_exit = function(_, status)
            if status ~= 0 then
              require('notify')(table.concat(output, '\n'), 'error', { title = 'AsyncRun failed!' })
            end
          end,
        })
      end

      -- Make it globally available
      _G.async_run = M.async_run
    '';
  };
}
