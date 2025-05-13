return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },

  version = '1.*',

  opts = {
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = 'mono'
    },
    completion = {
      documentation = {
        auto_show = false,
        treesitter_highlighting = true,
      },
      keyword = {
        range = "prefix",
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
        auto_brackets = {
          enabled = false,
        },
      }
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
}
