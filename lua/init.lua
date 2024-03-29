require("core")

local function try_require(name, notify)
    local ok, pkg = pcall(require, name)
    if (not ok) and notify then
        local msg = string.format(
            'The package(`%s`) is not loaded successfully.', name
        )
        vim.notify(msg, vim.log.levels.ERROR)
    end

    return pkg
end

function Echo(str)
    vim.cmd "redraw"
    vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

local function lazy_install(path)
    Echo "Installing lazy.nvim & plugins ..."
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", repo, path }
    vim.opt.rtp:prepend(path)

    require("plugins")

    -- The hook for setup
end

Echo("Load lazy from " .. lazypath)
if not vim.loop.fs_stat(lazypath) then
    lazy_install(lazypath)
end


-- Font for neovide
if vim.g.neovide then
    if vim.loop.os_uname().sysname == "Linux" then
        vim.o.guifont = "FiraMono Nerd Font:h11"
    elseif vim.loop.os_uname().sysname == "Windows_NT" then
        vim.o.guifont = "Hack Nerd Font:h10"
    else
        vim.o.guifont = "Hack Nerd Font:h12"
    end
    vim.o.linespace = 0
    vim.g.neo_scale_factor = 1.0
elseif vim.loop.os_uname().sysname == "Windows_NT" then
    vim.o.guifont = "Consolas NF:h10"
end

vim.opt.rtp:prepend(lazypath)

if vim.g.vscode then
    Echo "Loading nvim from vscode."
else
    try_require("plugins", true)
end

-- Colorscheme for neovide
if not vim.g.neovide then
    local status, _ = pcall(require, "catppuccin")
    if status then
        vim.cmd("set background=dark")
        vim.cmd("colorscheme catppuccin")
    end
else
    local status, _ = pcall(require, "catppuccin")
    if status then
        vim.cmd("set background=dark")
        vim.cmd("colorscheme catppuccin")
    end
end
