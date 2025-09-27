{ config, lib, pkgs, ... }:

{
  programs.nixvim.plugins = {
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
  };
}