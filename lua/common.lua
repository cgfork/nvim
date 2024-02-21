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

return M
