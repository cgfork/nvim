vim.lsp.enable({ "lua_ls", "golangci_lint_ls", "gopls", "pyright" })

vim.api.nvim_create_augroup('lsp#', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
    group = "lsp#",
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gD', vim.lsp.buf.type_definition, 'Type [D]efinition')
        --gri map('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        --grr map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')

        map('K', vim.lsp.buf.hover, 'Hover Document')
        --CTRL-S map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
        --grn map('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')
        --gra map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('<leader>sf', vim.lsp.buf.format, '[S]ave [F]ormat')

        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- Inlay Hints
        if client and client:supports_method('textDocument/inlayHint') then
            vim.keymap.set("n", "yoh", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
            end, { buffer = ev.buf, desc = "Toggle inlay hints" })
        end

        -- CodeLens
        if client and client:supports_method("textDocument/codeLens") then
            vim.api.nvim_create_autocmd("LspProgress", {
                group = "lsp#",
                callback = function(lsp_args)
                    if lsp_args.buf == ev.buf then
                        vim.lsp.codelens.refresh({ bufnr = ev.buf })
                    end
                end
            })
            vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
                group = "lsp#",
                buffer = ev.buf,
                callback = function() vim.lsp.codelens.refresh({ bufnr = ev.buf }) end
            })
            vim.lsp.codelens.refresh({ bufnr = ev.buf })
        end

        -- Folding
        if client and client:supports_method("textDocument/foldingRange") then
            vim.wo[0].foldmethod = "expr"
            vim.wo[0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end

        -- Formatting
        if client and not client:supports_method("textDocument/willSaveWaitUntil") and
            client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "lsp#",
                buffer = ev.buf,
                callback = function()
                    local autoformat = client.settings and client.settings.autoformat or
                        vim.b.lsp and vim.b.lsp.autoformat or
                        vim.g.lsp and vim.g.lsp.autoformat or
                        false
                    if autoformat then
                        vim.lsp.buf.format({ bufnr = ev.buf, id = ev.data.client_id })
                    end
                end
            })
        end

        -- Completion
        if client and client:supports_method("textDocument/completion") then
            if client.name == "lua-language-server" then
                client.server_capabilities.completionProvider.triggerCharacters = { ".", ":" }
            end
            vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
        end
    end,
})

vim.api.nvim_create_autocmd('LspDetach', {
    callback = function(ev)
        vim.b[ev.buf].lsp = nil
        vim.api.nvim_clear_autocmds({ group = "lsp#", buffer = ev.buf })
    end
})

vim.api.nvim_create_autocmd("LspProgress", {
    group = "lsp#",
    pattern = "*",
    callback = function() vim.cmd("redrawstatus") end
})
