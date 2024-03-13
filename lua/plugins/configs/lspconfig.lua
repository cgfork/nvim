local lspconfig = require('lspconfig')
local lspconfigutil = require('lspconfig/util')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

lspconfig.lua_ls.setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/extensions/nvchad_types"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
}

lspconfig.gopls.setup {
    cmd = { "gopls", "serve" },
    filetypes = { "go", "gomod" },
    capabilities = capabilities,
    root_dir = lspconfigutil.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            usePlaceholders = true,
            completeUnimported = true,
        },
    },
}

lspconfig.golangci_lint_ls.setup {
    cmd = { "golangci-lint-langserver" },
    filetypes = { "go", "gomod" },
    root_dir = lspconfigutil.root_pattern("go.work", "go.mod", ".git"),
    init_options = {
        command = { "golangci-lint", "run", "--out-format", "json",
            "--issues-exit-code=1" },
    },
}

lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
        }
    },
})

lspconfig.tsserver.setup {
    capabilities = capabilities,
    root_dir = lspconfigutil.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
}

lspconfig.pyright.setup {
    capabilities = capabilities,
}

lspconfig.marksman.setup({
    filetypes = { "md", "markdown" },
    root_dir = lspconfigutil.root_pattern(".git", ".marksman.toml"),
})

local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({ name = 'DiagnosticSignError', text = '' })
sign({ name = 'DiagnosticSignWarn', text = '' })
sign({ name = 'DiagnosticSignHint', text = '' })
sign({ name = 'DiagnosticSignInfo', text = '' })

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    serverity_sort = true,
    underline = true,
    float = {
        border = "rounded",
        source = "always",
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = "rounded",
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = "rounded",
    }
)

vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist)

local function is_available(plugin)
    local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
    return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'LSP: ' .. desc })
        end

        if is_available 'telescope.nvim' then
            local ts = require("telescope.builtin")
            map('gd', ts.lsp_definitions, '[G]oto [D]efinition')
            map('gD', ts.lsp_type_definitions, 'Type [D]efinition')
            map('gi', ts.lsp_implementations, '[G]oto [I]mplementation')
            map('gr', ts.lsp_references, '[G]oto [R]eferences')
            map('<leader>ws', ts.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
            map('<leader>ds', ts.lsp_document_symbols, '[D]ocument [S]ymbols')
        else
            map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
            map('gD', vim.lsp.buf.type_definition, 'Type [D]efinition')
            map('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
            map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
        end


        map('K', vim.lsp.buf.hover, 'Hover Document')
        map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('<leader>sf', vim.lsp.buf.format, '[S]ave [F]ormat')
    end,
})

-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { "*.go", "*.rs", "*.lua" },
    callback = function()
        vim.lsp.buf.format { async = false }
    end
})
