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
            gofumpt = true,
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
}

lspconfig.golangci_lint_ls.setup {
    cmd = { "golangci-lint-langserver" },
    filetypes = { "go", "gomod" },
    init_options = {
        command = { "golangci-lint", "run", "--output.json.path=stdout", "--show-stats=false" },
    },
    root_markers = { ".golangci.yml", ".golangci.yaml", ".golangci.toml", ".golangci.json", "go.work", "go.mod", ".git" },
}

lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end,
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

local vue_typescript_plugin = vim.fn.system("npm list -g  -p @vue/typescript-plugin")

lspconfig.ts_ls.setup {
    capabilities = capabilities,
    root_dir = lspconfigutil.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vue_typescript_plugin,
                languages = { "javascript", "typescript", "vue" },
            },
        },
    },
    filetypes = { "typescript", "javascript", "vue" },
}


lspconfig.pyright.setup {
    capabilities = capabilities,
}

lspconfig.hls.setup {
    filetypes = { "haskell", "lhaskell", "cabal" },
}

lspconfig.marksman.setup({
    filetypes = { "md", "markdown" },
    root_dir = lspconfigutil.root_pattern(".git", ".marksman.toml"),
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

        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.server_capabilities.documentHighlightProvier then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = ev.buf,
                callback = vim.lsp.buf.document_hightlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = ev.buf,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { "*.go", "*.rs", "*.lua", "*.js", "*.ts" },
    callback = function()
        vim.lsp.buf.format { async = false }
    end
})
