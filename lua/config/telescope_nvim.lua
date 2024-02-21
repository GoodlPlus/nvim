return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true, event = "VeryLazy" },
        { "nvim-tree/nvim-web-devicons", lazy = true, event = "VeryLazy" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true, event = "VeryLazy" },
    },
    opts = {
        defaults = {
            initial_mode = "insert",
            mappings = {
                i = {
                    ["<C-u>"] = false,
                },
            },
            layout_strategy = "vertical",
            layout_config = {
                horizontal = {
                    width = 0.618,
                    height = 0.618,
                    preview_height = 0.5,
                    prompt_position = "top",
                    preview_position = "bottom",
                    mirror = true,
                },
                vertical = {
                    width = 0.618,
                    height = 0.618,
                    preview_height = 0.5,
                    prompt_position = "top",
                    preview_position = "bottom",
                    mirror = true,
                },
            },
            sorting_strategy = "ascending",
            prompt_prefix = " ",
            selection_caret = "󰅂 ",
            border = true,
            dynamic_preview_title = false,
            results_title = false,
            prompt_title = false,
        },
    },
    config = function(_, opts)
        local plugin = require("telescope")
        plugin.setup(opts)
        pcall(plugin.load_extension, "fzf")
    end,
    keys = {
        { "<leader>f", "<Cmd>Telescope find_files<CR>", noremap = true },
        { "<leader>/", "<Cmd>Telescope live_grep<CR>", noremap = true },
        { "<leader>h", "<Cmd>Telescope help_tags<CR>", noremap = true },
        { "<leader>b", "<Cmd>Telescope buffers<CR>", noremap = true },
    },
}
