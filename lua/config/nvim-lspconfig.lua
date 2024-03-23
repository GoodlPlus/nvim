local function replace_diagnostic_sign()
    local signs = { Error = "", Warn = "", Hint = "󰌶", Info = "" } -- 󰌵
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
end

local function init_float_window()
    local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
    }
    local vim_lsp_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return vim_lsp_util_open_floating_preview(contents, syntax, opts, ...)
    end
end

local function init_cursor_highlight(args)
    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = args.buf,
        callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = args.buf,
        callback = vim.lsp.buf.clear_references,
        })
    end
end

return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function(_, opts)
        local configs = require("lspconfig")
        for server, option in pairs(opts) do
            configs[server].setup(option)
        end
        replace_diagnostic_sign()
        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(args)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local keymap_opts = { buffer = args.buf }

                -- See `:help vim.diagnostic.*` for documentation on any of the below functions
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, keymap_opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, keymap_opts)


                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymap_opts)

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gd", "<Cmd>Telescope lsp_definitions initial_mode=normal<CR>", keymap_opts)

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "gi", "<Cmd>Telescope lsp_implementations initial_mode=normal<CR>", keymap_opts)

                -- Find references for the word under your cursor.
                -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "gr", "<Cmd>Telescope lsp_references initial_mode=normal<CR>", keymap_opts)

                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, keymap_opts)

                -- Rename the variable under your cursor.
                --  Most Language Servers support renaming across files, etc.
                vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, keymap_opts)

                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, keymap_opts)

                vim.diagnostic.config({ virtual_text = false })

                -- vim.diagnostic.disable()
                -- vim.lsp.inlay_hint.enable()
                init_cursor_highlight(args)
                init_float_window()
            end,
        })
    end,
}
