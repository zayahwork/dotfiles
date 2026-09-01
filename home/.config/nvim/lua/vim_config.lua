-- Leader has to be set before lazy loads anything.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o = vim.opt

o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true

o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true

o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = false

o.splitright = true
o.splitbelow = true
o.scrolloff = 8
o.termguicolors = true
o.undofile = true
o.updatetime = 200
o.clipboard = "unnamedplus"
