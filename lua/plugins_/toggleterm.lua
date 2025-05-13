return {
    "akinsho/toggleterm.nvim",
    opts = {
        size = 12,
        open_mapping = [[<c-\>]],
        shade_filetypes = {},
        shade_terminals = true,
        start_in_inset = true,
        persist_size = true,
        direction = 'horizontal',
        autochdir = true,
    },
    config = function(opts)
        require("toggleterm").setup(opts)

        vim.keymap.set('n', '<leader>tc', function()
            local current_file_path = vim.fn.expand('%:p:h')
            vim.cmd("ToggleTerm " .. "dir=" .. current_file_path)
        end, { desc = 'Toggle [T]erm in current dir' })
    end,
}
