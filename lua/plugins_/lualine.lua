return {
    "nvim-lualine/lualine.nvim",
    opts = {
        sections = {
            lualine_c = {
                {
                    'filename',
                    file_status = true,
                    path = 1,
                },
            },
        },
    },
}
