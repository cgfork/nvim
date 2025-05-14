return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
        keymap = { preset = 'default' },
        appearance = {
            nerd_font_variant = 'mono',
            kind_icons = {
                Text = '󰉿',
                Method = '󰊕',
                Function = '󰊕',
                Constructor = '󰒓',

                Field = '󰜢',
                Variable = '󰆦',
                Property = '󰖷',

                Class = '󱡠',
                Interface = '󱡠',
                Struct = '󱡠',
                Module = '󰅩',

                Unit = '󰪚',
                Value = '󰦨',
                Enum = '󰦨',
                EnumMember = '󰦨',

                Keyword = '󰻾',
                Constant = '󰏿',

                Snippet = '󱄽',
                Color = '󰏘',
                File = '󰈔',
                Reference = '󰬲',
                Folder = '󰉋',
                Event = '󱐋',
                Operator = '󰪚',
                TypeParameter = '󰬛',
            },
        },
        completion = {
            documentation = {
                auto_show = false,
                auto_show_delay_ms = 500,
                treesitter_highlighting = true,
            },
            keyword = {
                range = "prefix",
            },
            trigger = {
                show_on_keyword = true,
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = false,
                },
            },
            accept = {
                dot_repeat = false,
                create_undo_point = true,
                resolve_timeout_ms = 500,
                auto_brackets = {
                    enabled = false,
                },
            },
            ghost_text = {
                enabled = true,
            },
            menu = {
                enabled = true,
                auto_show = true,
                draw = {
                    treesitter = {
                        "lsp"
                    },
                    columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
                }
            }
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = {
            enabled = true
        }
    },
    opts_extend = { "sources.default" }
}
