vim.lsp.enable({ "lua_ls", "golangci_lint_ls", "gopls", "pyright" })

vim.lsp.config("*", {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    on_attach = function(client, buf)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = buf, desc = 'LSP: ' .. desc })
        end
        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gD', vim.lsp.buf.type_definition, 'Type [D]efinition')
        map('K', vim.lsp.buf.hover, 'Hover Document')
        map('gsf', vim.lsp.buf.format, '[S]ave [F]ormat')
        -- Inlay Hints
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, buf) then
            vim.keymap.set("n", "yoh", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
            end, { buffer = buf, desc = "Toggle inlay hints" })
        end

        if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, buf) then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = buf,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
                buffer = buf,
                callback = vim.lsp.buf.clear_references,
            })
        end

        if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, buf) then
            vim.api.nvim_create_autocmd("LspProgress", {
                callback = function(args)
                    if args.buf == buf then
                        vim.lsp.codelens.refresh({ bufnr = buf })
                    end
                end
            })
            vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
                buffer = buf,
                callback = function()
                    vim.lsp.codelens.refresh({ bufnr = buf })
                end
            })
            vim.lsp.codelens.refresh({ bufnr = buf })
        end

        if client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange, buf) then
            vim.wo[0].foldmethod = "expr"
            vim.wo[0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end

        if client:supports_method(vim.lsp.protocol.Methods.textDocument_willSaveWaitUntil, buf) and
            client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting, buf) then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = buf,
                callback = function()
                    local autoformat = client.settings and client.settings.autoformat or
                        vim.b.lsp and vim.b.lsp.autoformat or vim.g.lsp and vim.g.lsp.autoformat or false
                    if autoformat then
                        vim.lsp.buf.format({ bufnr = buf, id = client.id })
                    end
                end
            })
        end

        -- use blink.cmp
        -- if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, buf) then
        --     if client.name == "lua-language-server" and client.name == "pyright" then
        --         client.server_capabilities.completionProvider.triggerCharacters = { ".", ":" }
        --     end
        --     vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
        -- end
    end
})
