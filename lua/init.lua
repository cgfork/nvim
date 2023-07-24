require("core")

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

local function echo(str)
    vim.cmd "redraw"
    vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

local function lazy_install(path)
    echo "Installing lazy.nvim & plugins ..."
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", repo, path }
    vim.opt.rtp:prepend(path)

    require("plugins")

    -- The hook for setup
end

echo("Load lazy from " .. lazypath)
if not vim.loop.fs_stat(lazypath) then
    lazy_install(lazypath)
end

if vim.g.neovide then
    vim.o.guifont = "Menlo:h12"
    vim.o.linespace = 0
    vim.g.neo_scale_factor = 1.0
end

vim.opt.rtp:prepend(lazypath)
require("plugins")
