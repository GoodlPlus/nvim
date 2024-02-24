return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true, event = "VeryLazy" },
        { "nvim-tree/nvim-web-devicons", lazy = true, event = "VeryLazy" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true, event = "VeryLazy" },
        { "debugloop/telescope-undo.nvim", lazy = true, event = "VeryLazy" },
    },
    opts = {
        defaults = {
            initial_mode = "insert",
            mappings = {
                i = {
                    ["<C-u>"] = false,
                },
            },
            layout_strategy = "vertical_merged",
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
            path_display = { "truncate" },
            sorting_strategy = "ascending",
            prompt_prefix = " ",
            selection_caret = "󰁕 ",
            border = true,
            dynamic_preview_title = false,
            results_title = false,
            prompt_title = false,
        },
        extensions = {
            undo = {
                side_by_side = true,
            },
        },
    },
    config = function(_, opts)
        require('telescope.pickers.layout_strategies').vertical_merged = function(...)
            local layout = require('telescope.pickers.layout_strategies').vertical(...)
            layout.prompt.title = false
            layout.results.title = false
            layout.results.line = layout.results.line - 1
            layout.results.height = layout.results.height + 1
            if layout.preview == false then
                layout.results.borderchars = { '─', '│', '─', '│', '├', '┤', '┘', '└' }
            else
                layout.results.borderchars = { '─', '│', '─', '│', '├', '┤', '┤', '├' }
                layout.preview.title = false
                layout.preview.line = layout.preview.line - 1
                layout.preview.height = layout.preview.height + 1
            end
            return layout
        end
        local plugin = require("telescope")
        plugin.setup(opts)
        pcall(plugin.load_extension, "fzf")
        pcall(plugin.load_extension, "undo")
    end,
    keys = {
        { "<leader>f", "<Cmd>Telescope find_files<CR>", noremap = true },
        { "<leader>/", "<Cmd>Telescope live_grep<CR>", noremap = true },
        { "<leader>h", "<Cmd>Telescope help_tags<CR>", noremap = true },
        { "<leader>b", "<Cmd>Telescope buffers initial_mode=normal<CR>", noremap = true },
        { "<leader><leader>", "<Cmd>Telescope resume initial_mode=normal<CR>", noremap = true },
        { "?", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", noremap = true },
        { "<leader>d", "<Cmd>Telescope diagnostics bufnr=0 initial_mode=normal<CR>", noremap = true },
        { "<leader>u", "<cmd>Telescope undo initial_mode=normal<CR>" }
    },
}
