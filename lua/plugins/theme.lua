return {
    {
        "EdenEast/nightfox.nvim",
        priority = 1000,
        enabled = false,
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = true,
                },
            })
            vim.cmd("colorscheme nightfox")
        end,
    },
    {
        "morhetz/gruvbox",
        enabled = false,
        config = function()
            vim.cmd("set background=dark")
            vim.cmd.colorscheme("gruvbox")
        end,
    },
    {
        "altercation/vim-colors-solarized",
        enabled = false,
        config = function()
            vim.g.solarized_termcolors = 256
            vim.cmd("set background=light")
            vim.cmd("colorscheme solarized")
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        enabled = false,
        config = function()
            vim.cmd("colorscheme rose-pine-dawn")
        end,
    },
    {
        "overcache/NeoSolarized",
        enabled = false,
        config = function()
            vim.cmd("set background=light")
            vim.cmd("colorscheme NeoSolarized")
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        enabled = true,
        config = function()
            require("catppuccin").setup({
                flavor = "auto",
                background = { -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                default_integrations = false,
                integrations = {
                    blink_cmp = true,
                    fzf = false,
                    native_lsp = {
                        enabled = true,
                        inlay_hints = {
                            background = true,
                        },
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            information = { "italic" },
                            ok = { "italic" },
                            warnings = { "italic" },
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            information = { "underline" },
                            ok = { "underline" },
                            warnings = { "underline" },
                        },
                    },
                    treesitter = true,
                },
                term_colors = true,
                transparent_background = true,
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
}
