return {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    enabled = true,
    config = function()
        require('nightfox').setup {
            options = {
                transparent = true,
            },
        }
        vim.cmd("colorscheme nightfox")
    end,
}
