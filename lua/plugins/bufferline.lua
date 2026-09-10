return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	enabled = true,
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					highlight = "Directory",
					text_align = "left",
				},
			},
			separator_styple = "slant",
			numbers = "ordinal",
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)

		-- 切换到左边的 buffer (Shift + h)
		vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Go to previous buffer" })

		-- 切换到右边的 buffer (Shift + l)
		vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Go to next buffer" })

		-- 闭着眼睛也能用的：左右移动当前 buffer 的顺序 (Alt + h / Alt + l)
		vim.keymap.set("n", "<A-h>", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
		vim.keymap.set("n", "<A-l>", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })

		-- 关闭当前 buffer（配合 mini.bufremove 或 bufdelete 插件效果更佳，防止弄乱窗口布局）
		vim.keymap.set("n", "<leader>bd", "<Cmd>bdelete!<CR>", { desc = "Delete current buffer" })

		-- 快速跳转到第 1 到第 9 个 buffer
		for i = 1, 9 do
			vim.keymap.set("n", "<A-" .. i .. ">", function()
				require("bufferline").go_to(i, true)
			end, { desc = "Go to buffer " .. i })
		end

		-- 开启 Pick 模式 (快捷键设为 leader + bp)
		vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLinePick<CR>", { desc = "Bufferline pick" })

		-- 用 Pick 模式快速关闭某个 buffer (快捷键设为 leader + bc)
		vim.keymap.set("n", "<leader>bc", "<Cmd>BufferLinePickClose<CR>", { desc = "Bufferline pick close" })
	end,
}
