return {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("aerial").setup({
            on_attach = function(bufnr)
                vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = '[{] Aerial Prev' })
                vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = '[}] Aerial Next' })
            end
        })
        vim.keymap.set('n', '<leader>at', '<cmd>AerialToggle!<CR>', { desc = '[A]erial [T]oggle' })
    end,
}
