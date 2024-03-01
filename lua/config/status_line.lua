return {
    dir = VIM_CONFIG_PATH .. "/lua/plugin/status_line",
    lazy = true,
    event = { "BufReadPre" },
    dependencies = {
        { "nvim-tree/nvim-web-devicons", lazy = true, event = "VeryLazy" },
    },
    config = true,
}
