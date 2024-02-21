local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true, close_on_exit = true })

function _troggle_lazygit()
    lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _troggle_lazygit()<CR>", { noremap = true, silent = true })
