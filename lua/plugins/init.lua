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
            vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', { silent = true, desc = 'Nvim[T]ree [T]oggle' })
            vim.keymap.set('n', '<leader>tf', ':NvimTreeFindFile<CR>', { silent = true, desc = 'Nvim[T]ree [F]ind File' })
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
                preset = 'default',

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
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function()
            require("bqf").setup {}
        end,
    },

    {
        'nvimdev/lspsaga.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons'      -- optional
        },
        config = function()
            require('lspsaga').setup({})
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
                    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = '[{] Aerial Prev' })
                    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = '[}] Aerial Next' })
                end
            })
            vim.keymap.set('n', '<leader>at', '<cmd>AerialToggle!<CR>', { desc = '[A]erial [T]oggle' })
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
                on_attach = function(_, _)
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
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        enabled = true,
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = true,       -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false,       -- add a border to hover docs and signature help
                },
            })
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
        tag = "0.1.2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                -- `build` is used to run some command when the plugin is installed/updated.
                build = 'make',

                -- `cond` is a condition used to determine whether this plugin should be installed and loaded.
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            "nvim-telescope/telescope-project.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "ThePrimeagen/harpoon",

        },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").load_extension('project')
            require("telescope").load_extension('harpoon')
            local project_actions = require("telescope._extensions.project.actions")
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
                extensions = {
                    project = {
                        base_dirs = {
                            { path = '~/Workspace', max_depth = 2 },
                        },
                        hidden_files = true,
                        sync_with_nvim_tree = true,
                        on_project_selected = function(prompt_bufnr)
                            project_actions.change_working_directory(prompt_bufnr, false)
                            require("harpoon.ui").nav_file(1)
                        end
                    },
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }
            local telescope_builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = '[F]ind [F]iles' })
            vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = '[F]ind by [G]rep' })
            vim.keymap.set('n', '<leader>fa', ":lua require 'telescope'.extensions.live_grep_args.live_grep_args()<CR>",
                { noremap = true, desc = '[F]ind by Grep with [A]rgs' })
            vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = '[F]ind [B]uffers' })
            vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = '[F]ind [H]elp' })
            vim.keymap.set('n', '<leader>fw', telescope_builtin.grep_string, { desc = '[F]ind by current [W]ord' })
            vim.keymap.set('n', '<leader>fk', telescope_builtin.keymaps, { desc = '[F]ind [K]eymaps' })
            vim.keymap.set('n', '<leader>fs', telescope_builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
            vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
            vim.keymap.set('n', '<leader>fp',
                ":lua require'telescope'.extensions.project.project{ display_type = full}<CR>",
                { noremap = true, silent = true, desc = '[F]ind [P]rojects' })
            vim.keymap.set('n', '<leader>/', function()
                telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })
            vim.keymap.set('n', '<leader>f/', function()
                telescope_builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end, { desc = '[F]ind [/] in Open Files' })
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
        config = function()
            require('gitsigns').setup {
                signs = {
                    add = { hl = 'GitGutterAdd', text = '+' },
                    change = { hl = 'GitGutterChange', text = '~' },
                    delete = { hl = 'GitGutterDelete', text = '-' },
                    topdelete = { hl = 'GitGutterDelete', text = '‾' },
                    changedelete = { hl = 'GitGutterChange', text = '~' },
                },
            }
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            -- local hooks = require "ibl.hooks"
            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
            -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            --     vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            --     vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            --     vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            --     vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            --     vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            --     vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            --     vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            -- end)
            -- require("ibl").setup({
            --     indent = {
            --         highlight = {
            --             "RainbowRed",
            --             "RainbowYellow",
            --             "RainbowBlue",
            --             "RainbowOrange",
            --             "RainbowGreen",
            --             "RainbowViolet",
            --             "RainbowCyan",
            --         }
            --     },
            -- })
            require("ibl").setup {}
        end
    },

    {
        "github/copilot.vim",
        enabled = false,
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
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        enabled = true,
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

            require("plugins/configs/lazygit")
        end,
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        enabled = false,
        build = ":CatppuccinCompile",
        opts = {
            -- flavour = "mocha", -- "mocha", "latte", "frappe", "macchiato"
            transparent_background = false,
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
        'projekt0n/github-nvim-theme',
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        enabled = false,
        config = function()
            require('github-theme').setup({
                -- ...
            })

            vim.cmd('colorscheme github_dark')
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
        "EdenEast/nightfox.nvim",
        priority = 1000,
        enabled = true,
        config = function()
            require('nightfox').setup {

            }
            vim.cmd("colorscheme nightfox")
        end,
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
    },
    require('plugins.configs.debug'),
}

local status, bytedance = pcall(require, 'plugins.bytedance')
if status then
    Echo "bytedance plugin loaded"
    -- 关闭 codeverse 内置自动补全
    vim.g.codeverse_disable_autocompletion = true
    -- 关闭 codeverse 内置 tab 映射
    vim.g.codeverse_no_map_tab = true
    -- 关闭 codeverse 内置补全映射
    vim.g.codeverse_disable_bindings = true
    plugins_to_install[#plugins_to_install + 1] = bytedance
end

require("lazy").setup(plugins_to_install, {
    defaults = { lazy = false },
    performance = {
        rtp = {
            disable_plugins = {},
        },
    },
})
