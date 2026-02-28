require("core")

function Echo(str)
	vim.cmd("redraw")
	vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local function lazy_install(path)
	Echo("Installing lazy.nvim & plugins ...")
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, path })
	vim.opt.rtp:prepend(path)

	require("plugins")

	-- The hook for setup
end

Echo("Load lazy from " .. lazypath)
if not vim.loop.fs_stat(lazypath) then
	lazy_install(lazypath)
end

vim.opt.rtp:prepend(lazypath)

if vim.g.vscode then
	Echo("Loading nvim from vscode.")
else
	require("lazy").setup({
		spec = {
			{ import = "plugins" },
		},
	}, {
		rocks = {
			enabled = true,
			hererocks = false,
		},
	})
	require("core/lspconfig")
end
