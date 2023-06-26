local plugins_to_install = {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },

        init = function()
            -- Disable netrw
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', { silent = true })
        end,

        opts = {
            sort_by = "case_sensitive",
            view = {
                width = 38,
            },
            on_attach = function(buf)
                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = buf, noremap = true, silent = true, nowait = true }
                end

                local api = require("nvim-tree/api")
                api.config.mappings.default_on_attach(buf)
                vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
                vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
            end,
        },
        config = function(_, opts)
            require("nvim-tree").setup(opts)
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("plugins/configs/lspconfig")
        end,
    },

    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup({})
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {},
    },

    {
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip").config.setup({})
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            require('plugins/configs/cmp')
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = "all",
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })

            require('nvim-treesitter').setup({})

            vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
                group = vim.api.nvim_create_augroup('TsFoldWorkaround', {}),
                callback = function()
                    vim.opt.foldmethod = 'expr'
                    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
                    vim.opt.foldenable = false
                end,
            })
        end,
    },

    {
        "simrat39/rust-tools.nvim",
    },
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()'
    },

    {
        "nvim-lualine/lualine.nvim",
        opts = {
            sections = {
                lualine_c = {
                    {
                        'filename',
                        file_status = true,
                        path = 1,
                    },
                },
            },
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local telescope_builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
        end
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },

    {
        "numToStr/Comment.nvim",
        opts = {},
    },
    {
        "lewis6991/gitsigns.nvim",
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            show_current_context = true,
            show_current_context_start = true,
            show_end_of_line = true,
            space_char_blankline = " ",
        },
    },

    {
        "github/copilot.vim",
    },

    {
        "akinsho/bufferline.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            options = {
                diagnostics = "nvim_lsp",
                offsets = { {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "left",
                } },
                separator_styple = "slant",
            },
        },
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        disabled = false,
        config = function()
            vim.cmd("set background=dark")
            vim.cmd("colorscheme catppuccin")
        end,
    },
}

require("lazy").setup(plugins_to_install, {
    defaults = { lazy = false },
    performance = {
        rtp = {
            disable_plugins = {},
        },
    },
})
