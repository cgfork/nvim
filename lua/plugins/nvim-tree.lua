return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },

	init = function()
		-- Disable netrw
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		vim.keymap.set("n", "<leader>tt", ":NvimTreeToggle<CR>", { silent = true, desc = "Nvim[T]ree [T]oggle" })
		vim.keymap.set("n", "<leader>tf", ":NvimTreeFindFile<CR>", { silent = true, desc = "Nvim[T]ree [F]ind File" })
	end,

	config = function()
		require("nvim-tree").setup({
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 38,
			},
		})

		local function auto_open_selected_file()
			local buf = vim.api.nvim_get_current_buf()
			local bufname = vim.api.nvim_buf_get_name(buf)
			if vim.fn.isdirectory(bufname) or vim.fn.isfile(bufname) then
				require("nvim-tree.api").tree.find_file(vim.fn.expand("%:p"))
			end
		end

		vim.api.nvim_create_autocmd("BufEnter", { callback = auto_open_selected_file })
	end,
}
