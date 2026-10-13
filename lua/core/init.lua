-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Encoding
vim.g.encoding = "UTF-8"

vim.o.autoread = true
vim.bo.autoread = true
vim.o.backup = false
vim.o.swapfile = false

-- Trigger checktime to refresh buffers when focus changes or entering a buffer
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = "*",
})

-- Clipboard
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
	local function dummy_paste()
		-- 返回空，拒绝让远程通过 OSC 52 读取 Mac 的剪贴板，彻底消除卡顿超时
		return { {}, "" }
	end
	vim.g.clipboard = {
		name = "SSH Network Clipboard (OSC52 + NC)",
		copy = {
			-- 复制时：使用高效的内置 OSC 52 将内容传回 Mac 本地
			["+"] = function(lines, regtype)
				require("vim.ui.clipboard.osc52").copy("+")(lines, regtype)
			end,
			["*"] = function(lines, regtype)
				require("vim.ui.clipboard.osc52").copy("*")(lines, regtype)
			end,
		},
		paste = {
			-- 粘贴时：通过 nc 从 Mac 转发的端口瞬间读取，支持远程无卡顿使用 p 键
			-- -w 1 设置 1 秒超时，万一没开转发也不会导致 Nvim 死锁
			-- ["+"] = "nc -w 1 127.0.0.1 2222",
			-- ["*"] = "nc -w 1 127.0.0.1 2222",
			["+"] = dummy_paste,
			["*"] = dummy_paste,
		},
		cache_enabled = 1,
	}
end
vim.opt.clipboard = "unnamedplus" -- use system clipboard
-- vim.opt.completeopt = { 'menu', 'menuon', 'noselect' }
vim.opt.mouse = "a" -- allow the mouse to be used in nvim

-- Tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.api.nvim_create_autocmd("FileType", {
	pattern = "typescript",
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "javascript",
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
	end,
})

-- UI
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true

-- Searching
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- undofile
vim.opt.undofile = true

-- NVIM Tree
-- disable netrw at the very start of your init.lua
-- see nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.diagnostic.config({
	virtual_lines = false,
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "󰟃",
			[vim.diagnostic.severity.INFO] = "",
		},
	},
	update_in_insert = true,
	serverity_sort = true,
	underline = true,
	float = {
		border = "single",
		source = true,
		format = function(diagnostic)
			return string.format(
				"%s (%s) [%s]",
				diagnostic.message,
				diagnostic.source,
				diagnostic.code or diagnostic.user_data.lsp.code
			)
		end,
	},
})

vim.opt.winborder = "single"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
