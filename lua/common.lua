local M = {}

function M.try_require(name)
    local ok, _ = pcall(require, name)
    if not ok then
        local msg = string.format(
            'The package(`%s`) is not loaded successfully.', name
        )
        vim.notify(msg, vim.log.levels.ERROR)
    end
end

function M.echo(str)
    vim.cmd "redraw"
    vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

function M.check()
    -- check version
    local version = string.format('%s.%s.%s', vim.version().major, vim.version().minor, vim.version().patch)
    if not vim.version.cmp then
        vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", version))
    end

    if vim.version.cmp(vim.version(), { 0, 9, 4 }) >= 0 then
        vim.health.ok(string.format("Neovim version is: '%s'", version))
    else
        vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", version))
    end

    for _, exe in ipairs { 'git', 'make', 'unzip', 'rg' } do
        local is_executable = vim.fn.executable(exe) == 1
        if is_executable then
            vim.health.ok(string.format("Found executable: '%s'", exe))
        else
            vim.health.warn(string.format("Could not find executable: '%s'", exe))
        end
    end
end

return M
