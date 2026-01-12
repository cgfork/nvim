return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = function()
		local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
		ts_update()
	end,
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c",
				"cpp",
				"lua",
				"vim",
				"go",
				"rust",
				"bash",
				"c_sharp",
				"css",
				"html",
				"json",
				"python",
				"proto",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		})

		require("nvim-treesitter").setup({})

		vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
			group = vim.api.nvim_create_augroup("TsFoldWorkaround", {}),
			callback = function()
				vim.opt.foldmethod = "expr"
				vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
				vim.opt.foldenable = false
			end,
		})
	end,
}
