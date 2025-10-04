{ config, lib, pkgs, ... }:

{
  programs.nixvim.opts = {
    number = true;
    relativenumber = false;
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    autoindent = true;
    wrap = false;
    ignorecase = false;
    smartcase = false;
    cursorline = true;
    termguicolors = true;
    background = "dark";
    signcolumn = "yes";
    backspace = "indent,eol,start";
    # clipboard = "unnamedplus";  # Disabled - use explicit keymaps for system clipboard
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
}