return {
    dir = VIM_CONFIG_PATH .. "/lua/plugin/translator",
    lazy = true,
    event = "VeryLazy",
    config = true,
    keys = {
        { "<leader>t", ":Translate<CR>", mode = { "n", "x" }, silent = true, noremap = true },
    },
}
