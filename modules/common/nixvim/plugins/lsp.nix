{ config, lib, pkgs, ... }:

{
  programs.nixvim.plugins = {
    # LSP
    lsp = {
      enable = true;
      servers = {
        # Lua
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

        # JSON
        jsonls = {
          enable = true;
        };

        # Python
        basedpyright = {
          enable = true;
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true;
                diagnosticMode = "openFilesOnly";
                useLibraryCodeForTypes = true;
              };
            };
          };
        };

        # Rust
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
          settings = {
            "rust-analyzer" = {
              checkOnSave = {
                command = "clippy";
              };
              cargo = {
                features = "all";
              };
            };
          };
        };

        # TypeScript/JavaScript
        ts_ls = {
          enable = true;
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal";
                includeInlayParameterNameHintsWhenArgumentMatchesName = false;
                includeInlayFunctionParameterTypeHints = true;
                includeInlayVariableTypeHints = false;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
                includeInlayEnumMemberValueHints = true;
              };
            };
          };
        };

        # ESLint
        eslint = {
          enable = true;
        };

        # Go
        gopls = {
          enable = true;
          settings = {
            gopls = {
              analyses = {
                unusedparams = true;
              };
              staticcheck = true;
              gofumpt = true;
            };
          };
        };

        # C/C++
        clangd = {
          enable = true;
        };

        # YAML
        yamlls = {
          enable = true;
          settings = {
            yaml = {
              schemas = {
                "https://json.schemastore.org/github-workflow.json" = "/.github/workflows/*";
                "https://json.schemastore.org/github-action.json" = "/action.{yml,yaml}";
              };
            };
          };
        };

        # Bash
        bashls = {
          enable = true;
        };

        # Markdown
        marksman = {
          enable = true;
        };

        # TOML
        taplo = {
          enable = true;
        };

        # Nix
        nil_ls = {
          enable = true;
        };

        # Note: Swift sourcekit-lsp may not be available in nixvim yet
      };
    };
  };
}
