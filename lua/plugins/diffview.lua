return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- 用于在文件树中显示漂亮的文件图标
	},
	-- 只有在执行这些命令或按下快捷键时才延迟加载，加快 Neovim 启动速度
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "打开 AI 代码审查 (Diffview)" },
		{ "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "关闭代码审查 (Diffview)" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "查看当前文件的 Git 历史" },
	},
	config = function()
		require("diffview").setup({
			enhanced_diff_hl = true, -- 【核心】开启字符级细粒度高亮，揪出 AI 改动的每一个字母
			use_icons = true, -- 开启图标支持
			icons = {
				folder_closed = "",
				folder_open = "",
			},
			view = {
				-- 配置默认视图，"diff2_horizontal" 为最经典的左右双栏对比
				default = { layout = "diff2_horizontal" },
				merge_tool = { layout = "diff3_horizontal" },
			},
			file_panel = {
				listing_style = "tree", -- 左侧侧边栏以树状结构展示改动的文件
				tree_options = {
					flatten_dirs = true, -- 展平没有文件的空目录
					folder_statuses = "only_folder",
				},
				win_config = {
					position = "left",
					width = 35, -- 左侧文件树的宽度
				},
			},
		})
	end,
}
