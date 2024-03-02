return {
    "sainnhe/everforest",
    lazy = true,
    event = "VeryLazy",
    -- lazy = false,
    -- priority = 1000,
    config = function()
        vim.cmd([[
            let g:everforest_background = "hard"
            let g:everforest_enable_italic = 1
            let g:everforest_disable_italic_comment = 0
            let g:everforest_cursor = "auto"
            let g:everforest_transparent_background = 2
            let g:everforest_dim_inactive_windows = 0
            let g:everforest_sign_column_background = "none"
            let g:everforest_spell_foreground = "none"
            let g:everforest_ui_contrast = "high"
            let g:everforest_show_eob = 1
            let g:everforest_float_style = "bright"
            let g:everforest_diagnostic_text_highlight = 1
            let g:everforest_diagnostic_line_highlight = 0
            let g:everforest_diagnostic_virtual_text = "colored"
            let g:everforest_current_word = "grey background"
            let g:everforest_disable_terminal_colors = 1
            let g:everforest_better_performance = 1
            highlight FloatBorder ctermbg=NONE guibg=NONE
            highlight NormalFloat ctermbg=NONE guibg=NONE
            ]])
    end
}
