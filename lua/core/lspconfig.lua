vim.lsp.enable({ "lua_ls", "golangci_lint_ls", "gopls", "pyright", "zls", "rust_analyzer", "vue_ls", "ts_ls" })

local function on_attach(client, buf)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = buf, desc = "LSP: " .. desc })
	end

	map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	map("gD", vim.lsp.buf.type_definition, "Type [D]efinition")
	map("K", vim.lsp.buf.hover, "Hover Document")
	map("gsf", vim.lsp.buf.format, "[S]ave [F]ormat")

	-- Inlay Hints
	if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, buf) then
		map("grl", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
		end, "Toggle inlay hints")
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, buf) then
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = buf,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved" }, {
			buffer = buf,
			callback = vim.lsp.buf.clear_references,
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, buf) then
		vim.api.nvim_create_autocmd("LspProgress", {
			callback = function(args)
				if args.buf == buf then
					vim.lsp.codelens.enable(true, { bufnr = buf })
				end
			end,
		})
		vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
			buffer = buf,
			callback = function()
				vim.lsp.codelens.enable(true, { bufnr = buf })
			end,
		})
		vim.lsp.codelens.enable(true, { bufnr = buf })
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange, buf) then
		vim.wo[0].foldmethod = "expr"
		vim.wo[0].foldexpr = "v:lua.vim.lsp.foldexpr()"
	end

	if
		client:supports_method(vim.lsp.protocol.Methods.textDocument_willSaveWaitUntil, buf)
		and client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting, buf)
	then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = buf,
			callback = function()
				local autoformat = client.settings and client.settings.autoformat
					or vim.b.lsp and vim.b.lsp.autoformat
					or vim.g.lsp and vim.g.lsp.autoformat
					or false
				if autoformat then
					vim.lsp.buf.format({ bufnr = buf, id = client.id })
				end
			end,
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

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	-- on_attach = on_attach, -- maybe override by single lsp config
	root_markers = {
		".git",
	},
})

local mod_cache = nil
local function get_root(fname)
	if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
		local clients = vim.lsp.get_clients({ name = "gopls" })
		if #clients > 0 then
			return clients[#clients].config.root_dir
		end
	end
	-- 0.11+ 中推荐使用 vim.fs.root 代替旧方法，这里保持一致
	return vim.fs.root(fname, { "go.work", "go.mod", ".git" })
end

vim.lsp.config("gopls", {
	-- 融入核心需求 A：解决跳转到第三方库 \$GOPATH/pkg/mod 导致工作区破损的问题
	-- 0.11+ 中 root_markers 除了可以是字符串列表，也可以是一个接收 (path, bufnr) 并返回根目录路径的函数
	root_markers = function(path, bufnr)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		if mod_cache then
			return get_root(fname)
		end

		-- 同步或异步提取 GOMODCACHE 路径
		local cmd = { "go", "env", "GOMODCACHE" }
		local obj = vim.system(cmd, { text = true }):wait()
		if obj.code == 0 and obj.stdout then
			mod_cache = vim.trim(obj.stdout)
		end
		return get_root(fname)
	end,

	-- 融入核心需求 B：在 LSP 服务端开启 gopls 的所有内联提示能力
	settings = {
		gopls = {
			hints = {
				assignVariableTypes = true, -- 变量类型推导提示
				compositeLiteralFields = true, -- 结构体字面量缺失字段名提示
				compositeLiteralTypes = true, -- 嵌套字面量省略类型提示
				constantValues = true, -- iota 和常量实际计算值提示
				functionTypeParameters = true, -- 泛型隐式类型参数提示
				parameterNames = true, -- 函数形参名称提示
				rangeVariableTypes = true, -- range 循环迭代变量类型提示
			},
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local buf = event.buf
		on_attach(client, buf)
	end,
})
