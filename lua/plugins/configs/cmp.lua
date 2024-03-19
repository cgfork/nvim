local luasnip = require('luasnip')
local cmp = require("cmp")

require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"
local opts = {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    }),
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),

}

local status, lspkind = pcall(require, 'lspkind')
if status then
    Echo 'lspkind loaded'
    opts.formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 80,
            ellipsis_char = '...',
            show_labelDetails = true,

            before = function(entry, vim_item)
                -- if vim_item.kind == 'Color' and entry.completion_item.documentation then
                --     local _, _, r, g, b = string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')
                --     if r then
                --         local color = string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
                --         local group = 'Tw_' .. color
                --         if vim.fn.hlID(group) < 1 then
                --             vim.api.nvim_set_hl(0, group, { fg = '#' .. color })
                --         end
                --         vim_item.kind = "●"
                --         vim_item.kind_hl_group = group
                --         return vim_item
                --     end
                -- end
                -- vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
                return vim_item
            end
        })
    }
end
cmp.setup(opts)
cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
