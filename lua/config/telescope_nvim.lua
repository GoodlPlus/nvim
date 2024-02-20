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
                prompt_position = "top",
                width = 0.618,
                height = 0.618,
            },
            sorting_strategy = "ascending",
            -- prompt_prefix = " ",
            -- selection_caret = ">",
        },
        pickers = {
        },
        extensions = {
        },
    },
    config = function(_, opts)
        local plugin = require("telescope")
        plugin.setup(opts)
        pcall(plugin.load_extension, "fzf")
    end,
    keys = {
        { "<leader>f", "<Cmd>Telescope find_files<CR>", silent = true, noremap = true },
        { "<leader>g", "<Cmd>Telescope live_grep<CR>", silent = true, noremap = true },
        { "<leader>h", "<Cmd>Telescope help_tags<CR>", silent = true, noremap = true },
        { "<leader>b", "<Cmd>Telescope buffers<CR>", silent = true, noremap = true },
    },
}
