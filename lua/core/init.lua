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
vim.api.nvim_create_autocmd("FileType", {
    pattern = "typescript",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "javascript",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end
})


-- UI
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true

-- Searching
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- undofile
vim.opt.undofile = true

-- NVIM Tree
-- disable netrw at the very start of your init.lua
-- see nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    serverity_sort = true,
    underline = true,
    float = {
        border = "rounded",
        source = "always",
    },
})

vim.opt.winborder='single'