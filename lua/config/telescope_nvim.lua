return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    opts = {
        defaults = {
            initial_mode = "insert",
            mappings = {
                i = {
                    -- ["<C-j>"] = "move_selection_next",
                    -- ["<C-k>"] = "move_selection_previous",
                    -- ["<C-n>"] = "cycle_history_next",
                    -- ["<C-p>"] = "cycle_history_prev",
                    -- ["<C-c>"] = "close",
                    -- ["<C-u>"] = "preview_scrolling_up",
                    -- ["<C-d>"] = "preview_scrolling_down",
                },
            },
            layout_strategy = "flex",
            layout_config = {
                prompt_position = "top",
                width = 0.618,
                height = 0.618,
            },
            sorting_strategy = "ascending",
            prompt_prefix = " ",
            selection_caret = " ",
        },
        pickers = {
            -- find_files = {
            --     winblend = 20,
            -- },
        },
        extensions = {
            -- fzf = {
            --     fuzzy = true,
            --     override_generic_sorter = true,
            --     override_file_sorter = true,
            --     case_mode = "smart_case",
            -- },
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
