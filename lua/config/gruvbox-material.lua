return {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd([[
            let g:gruvbox_material_background = "hard"
            let g:gruvbox_material_foreground = "material"
            let g:gruvbox_material_disable_italic_comment = 0
            let g:gruvbox_material_enable_bold = 1
            let g:gruvbox_material_enable_italic = 1
            let g:gruvbox_material_cursor = "auto"
            let g:gruvbox_material_transparent_background = 2
            let g:gruvbox_material_dim_inactive_windows = 0
            let g:gruvbox_material_visual = "reverse"
            let g:gruvbox_material_menu_selection_background = "grey"
            let g:gruvbox_material_sign_column_background = "none"
            let g:gruvbox_material_spell_foreground = "none"
            let g:gruvbox_material_ui_contrast = "high"
            let g:gruvbox_material_show_eob = 1
            let g:gruvbox_material_float_style = "bright"
            let g:gruvbox_material_diagnostic_text_highlight = 1
            let g:gruvbox_material_diagnostic_line_highlight = 0
            let g:gruvbox_material_diagnostic_virtual_text = "colored"
            let g:gruvbox_material_current_word = "grey background"
            let g:gruvbox_material_disable_terminal_colors = 1
            let g:gruvbox_material_statusline_style = "default"
            let g:gruvbox_material_lightline_disable_bold = 0
            let g:gruvbox_material_better_performance = 1
            colorscheme gruvbox-material
            ]])
    end
}
