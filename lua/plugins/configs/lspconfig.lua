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

vim.diagnostic.config({
    virtual_text = false,
    serverity_sort = true,
    underline = true,
    float = {
        border = "rounded",
        source = "always",
    },
})

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

local lsp_definition
local lsp_references
local lsp_implementation
if is_available "telescope.nvim" then
    local telescope_builtin = require("telescope.builtin")
    lsp_definition = function()
        telescope_builtin.lsp_definitions()
    end
    lsp_references = function()
        telescope_builtin.lsp_references()
    end
    lsp_implementation = function()
        telescope_builtin.lsp_implementations()
    end
else
    lsp_definition = vim.lsp.buf.definition
    lsp_references = vim.lsp.buf.references
    lsp_implementation = vim.lsp.buf.implementation
end

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', lsp_definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', lsp_implementation, opts)
        vim.keymap.set('n', 'gr', lsp_references, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>sf', vim.lsp.buf.format, opts)
    end,
})

-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = buffer,
    pattern = { "*.go", "*.rs", "*.lua" },
    callback = function()
        vim.lsp.buf.format { async = false }
    end
})
