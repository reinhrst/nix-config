{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      # Formatting with conform.nvim
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            javascriptreact = [ "prettier" ];
            typescriptreact = [ "prettier" ];
            tsx = [ "prettier" ];
            jsx = [ "prettier" ];
            json = [ "prettier" ];
            jsonc = [ "prettier" ];
            css = [ "prettier" ];
            scss = [ "prettier" ];
            html = [ "prettier" ];
            markdown = [ "prettier" ];
            yaml = [ "prettier" ];
            python = [ "ruff_format" ];
            lua = [ "stylua" ];
            sh = [ "shfmt" ];
            bash = [ "shfmt" ];
            zsh = [ "shfmt" ];
            toml = [ "taplo" ];
            rust = [ "rustfmt" ];
            go = [ "gofumpt" ];
          };

          # Disable format on save (only format when explicitly requested)
          format_on_save = null;

          # Notify when no formatters available (useful for debugging)
          notify_no_formatters = true;
          notify_on_error = true;
          log_level = "error";
        };
      };
    };

    # Additional plugins not natively supported by nixvim
    extraPlugins = with pkgs.vimPlugins; [
      nvim-lint
      (pkgs.vimUtils.buildVimPlugin {
        name = "claudecode-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "coder";
          repo = "claudecode.nvim";
          rev = "main";
          sha256 = "sha256-sOBY2y/buInf+SxLwz6uYlUouDULwebY/nmDlbFbGa8=";
        };
      })
    ];

    # Lua configuration for nvim-lint (minimal - only tools without LSP coverage)
    extraConfigLua = ''
      -- Configure nvim-lint for tools without LSP coverage
      local lint = require("lint")

      -- Only linters that don't have LSP equivalents
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
        dockerfile = { "hadolint" },
      }

      -- Create autocmd for linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      -- Configure Claude Code
      require("claudecode").setup({
        -- Configuration will be added here if needed
      })
    '';
  };
}