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
            offsets = { {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left",
            } },
            separator_styple = "slant",
        },
    },
}
