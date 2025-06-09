return {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("aerial").setup({
            layout = {
                max_width = { 60, 0.2 },
                width = nil,
                min_width = 20,
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = '[{] Aerial Prev' })
                vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = '[}] Aerial Next' })
            end
        })
        vim.keymap.set('n', '<leader>ot', '<cmd>AerialToggle!<CR>', { desc = 'Aerial Toggle' })
    end,
}
