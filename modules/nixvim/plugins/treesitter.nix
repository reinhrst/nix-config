{ config, lib, pkgs, ... }:

{
  programs.nixvim.plugins = {
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
        c_sharp
        css
        csv
        dockerfile
        git_config
        git_rebase
        gitcommit
        gitignore
        go
        html
        javascript
        json
        latex
        lua
        make
        markdown
        markdown_inline
        nix
        objc
        python
        query
        regex
        rst
        rust
        scss
        sql
        swift
        toml
        tsx
        typescript
        vim
        xml
        yaml
      ];
    };
  };
}