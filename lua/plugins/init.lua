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
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },

        init = function()
            -- Disable netrw
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', { silent = true })
            vim.keymap.set('n', '<leader>tf', ':NvimTreeFindFile<CR>', { silent = true })
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
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require("luasnip").config.setup({})
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            require('plugins/configs/cmp')
        end,
    },

    {
        "onsails/lspkind.nvim",
        config = function()
            require("lspkind").init({
                -- defines how annotations are shown
                -- default: symbol
                -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
                mode = 'symbol_text',

                -- default symbol map
                -- can be either 'default' (requires nerd-fonts font) or
                -- 'codicons' for codicon preset (requires vscode-codicons font)
                --
                -- default: 'default'
                preset = 'codicons',

                -- override preset symbols
                --
                -- default: {}
                symbol_map = {
                    Text = "󰉿",
                    Method = "󰆧",
                    Function = "󰊕",
                    Constructor = "",
                    Field = "󰜢",
                    Variable = "󰀫",
                    Class = "󰠱",
                    Interface = "",
                    Module = "",
                    Property = "󰜢",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Enum = "",
                    Keyword = "󰌋",
                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈙",
                    Reference = "󰈇",
                    Folder = "󰉋",
                    EnumMember = "",
                    Constant = "󰏿",
                    Struct = "󰙅",
                    Event = "",
                    Operator = "󰆕",
                    TypeParameter = "",
                },
            })
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "c",
                    "cpp",
                    "lua",
                    "vim",
                    "go",
                    "rust",
                    "bash",
                    "c_sharp",
                    "css",
                    "html",
                    "json",
                    "python",
                    "proto"
                },
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
        "kosayoda/nvim-lightbulb",
        config = function()
            require("nvim-lightbulb").setup({
                autocmd = { enabled = true }
            })
        end
    },

    {
        "stevearc/aerial.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("aerial").setup({
                on_attach = function(bufnr)
                    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
                    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
                end
            })
            vim.keymap.set('n', '<leader>at', '<cmd>AerialToggle!<CR>')
        end,
    },

    {
        "simrat39/rust-tools.nvim",
        opts = {
            tools = {
                runnables = {
                    use_telescope = true,
                },
                inlay_hints = {
                    auto = true,
                    show_parameter_hints = false,
                    parameter_hints_prefix = "",
                    other_hints_prefix = "",
                },
            },
            server = {
                -- on_attach is a callback called when the language server attachs to the buffer
                on_attach = function(client, _)
                end,
                settings = {
                    -- to enable rust-analyzer settings visit:
                    -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                    ["rust-analyzer"] = {
                        -- enable clippy on save
                        checkOnSave = {
                            command = "clippy",
                        },
                    },
                },
            },
        },
    },
    {
        "saecki/crates.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("crates").setup({})
        end,
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
        "theHamsta/nvim-dap-virtual-text",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        opts = {},
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
        end
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
            "nvim-telescope/telescope-project.nvim",
        },
        config = function()
            local telescope_builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
            vim.keymap.set('n', '<leader>fs', telescope_builtin.grep_string, {})
            local actions = require("telescope.actions")
            require("telescope").setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                        n = { q = actions.close },
                    },
                },
            }
            require("telescope").load_extension('project')
        end
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
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
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

            vim.g.copilot_filetypes = {
                ["*"] = false,
                ["javascript"] = true,
                ["typescript"] = true,
                ["lua"] = false,
                ["rust"] = true,
                ["c"] = true,
                ["c#"] = true,
                ["c++"] = true,
                ["go"] = true,
                ["markdown"] = true,
                ["python"] = true,
            }
        end
    },

    {
        "akinsho/bufferline.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        enabled = false,
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
        lazy = false,
        priority = 1000,
        build = ":CatppuccinCompile",
        opts = {
            -- flavour = "mocha", -- "mocha", "latte", "frappe", "macchiato"
            transparent_background = true,
            background = {
                light = "latte",
                dark = "mocha",
            },
            term_colors = true,
            styles = {
                comments = { "italic" },
                conditionals = {},
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
            },

        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 10002,
        enabled = false,
        opts = {
            bold = false,
            transparent_mode = false,
        },
    },
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        lazy = false,
        priority = 10001,
        enabled = false,
        build = ":KanagawaCompile",
        opts = {
            statementStype = {
                bold = false,
            },
            transparent = false,
        },
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 10002,
        enabled = false,
        opts = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        init = function() vim.g.mkdp_filetypes = { "markdown" } end,
        ft = { "markdown" }
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                -- config
                theme = "hyper",
                config = {
                    header = {
                        '   ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣴⣶⣶⣶⣶⣶⠶⣶⣤⣤⣀⠀⠀⠀⠀⠀⠀ ',
                        ' ⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⠁⠀⢀⠈⢿⢀⣀⠀⠹⣿⣿⣿⣦⣄⠀⠀⠀ ',
                        ' ⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⠿⠀⠀⣟⡇⢘⣾⣽⠀⠀⡏⠉⠙⢛⣿⣷⡖⠀ ',
                        ' ⠀⠀⠀⠀⠀⣾⣿⣿⡿⠿⠷⠶⠤⠙⠒⠀⠒⢻⣿⣿⡷⠋⠀⠴⠞⠋⠁⢙⣿⣄ ',
                        ' ⠀⠀⠀⠀⢸⣿⣿⣯⣤⣤⣤⣤⣤⡄⠀⠀⠀⠀⠉⢹⡄⠀⠀⠀⠛⠛⠋⠉⠹⡇ ',
                        ' ⠀⠀⠀⠀⢸⣿⣿⠀⠀⠀⣀⣠⣤⣤⣤⣤⣤⣤⣤⣼⣇⣀⣀⣀⣛⣛⣒⣲⢾⡷ ',
                        ' ⢀⠤⠒⠒⢼⣿⣿⠶⠞⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⣼⠃ ',
                        ' ⢮⠀⠀⠀⠀⣿⣿⣆⠀⠀⠻⣿⡿⠛⠉⠉⠁⠀⠉⠉⠛⠿⣿⣿⠟⠁⠀⣼⠃⠀ ',
                        ' ⠈⠓⠶⣶⣾⣿⣿⣿⣧⡀⠀⠈⠒⢤⣀⣀⡀⠀⠀⣀⣀⡠⠚⠁⠀⢀⡼⠃⠀⠀ ',
                        ' ⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣷⣤⣤⣤⣤⣭⣭⣭⣭⣭⣥⣤⣤⣤⣴⣟⠁    ',
                    },
                    weak_header = {
                        enable = true,
                    },
                    shortcut = {
                        { desc = "Files",  group = "DashboardShortCut", key = "f", action = "Telescope find_files" },
                        { desc = "Config", group = "DashboardShortCut", key = "e", action = "edit $MYVIMRC" },
                    },


                },

            }
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    }
}

require("lazy").setup(plugins_to_install, {
    defaults = { lazy = false },
    performance = {
        rtp = {
            disable_plugins = {},
        },
    },
})
