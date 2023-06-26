-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Encoding
vim.g.encoding = "UTF-8"

vim.o.autoread = true
vim.bo.autoread = true
vim.o.backup = false
vim.o.swapfile = false

-- Clipboard
vim.opt.clipboard = 'unnamedplus' -- use system clipboard
-- vim.opt.completeopt = { 'menu', 'menuon', 'noselect' }
vim.opt.mouse = 'a'               -- allow the mouse to be used in nvim

-- Tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true

-- Searching
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- undofile
vim.opt.undofile = true

-- NVIM Tree
-- disable netrw at the very start of your init.lua
-- see nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
