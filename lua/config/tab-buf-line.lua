return {
    dir = VIM_CONFIG_PATH .. "/lua/plugin/tab-buf-line",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "nvim-tree/nvim-web-devicons", lazy = true, event = "VeryLazy" },
    },
    config = true,
}
