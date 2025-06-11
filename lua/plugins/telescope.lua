return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
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

    },
    config = function()
        local actions = require("telescope.actions")

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
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                aerial = {
                    -- Set the width of the first two columns (the second
                    -- is relevant only when show_columns is set to 'both')
                    col1_width = 4,
                    col2_width = 30,
                    -- How to format the symbols
                    format_symbol = function(symbol_path, filetype)
                        if filetype == "json" or filetype == "yaml" then
                            return table.concat(symbol_path, ".")
                        else
                            return symbol_path[#symbol_path]
                        end
                    end,
                    -- Available modes: symbols, lines, both
                    show_columns = "both",
                }
            },
        }
        require("telescope").load_extension('project')
        require("telescope").load_extension('fzf')
        require("telescope").load_extension('aerial')
        local telescope_builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = '[F]ind [F]iles' })
        vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = '[F]ind by [G]rep' })
        vim.keymap.set('n', '<leader>fa', ":lua require 'telescope'.extensions.live_grep_args.live_grep_args()<CR>",
            { noremap = true, desc = '[F]ind by Grep with [A]rgs' })
        vim.keymap.set('n', '<leader>fs', ":lua require('telescope').extensions.aerial.aerial()<CR>",
            { noremap = true, desc = '[F]ind [S]ymbols' })
        vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = '[F]ind [B]uffers' })
        vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = '[F]ind [H]elp' })
        vim.keymap.set('n', '<leader>fw', telescope_builtin.grep_string, { desc = '[F]ind by current [W]ord' })
        vim.keymap.set('n', '<leader>fk', telescope_builtin.keymaps, { desc = '[F]ind [K]eymaps' })
        vim.keymap.set('n', '<leader>ft', telescope_builtin.builtin, { desc = '[F]ind Select [T]elescope' })
        vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
        vim.keymap.set('n', '<leader>fq', '<cmd>Telescope quickfix<CR>', { desc = '[F]ind [Q]uickfix' })
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
}
