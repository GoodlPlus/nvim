return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function(_, opts)
        local configs = require("lspconfig")
        configs.pylance.setup({})

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }

                -- See `:help vim.diagnostic.*` for documentation on any of the below functions
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
                vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
            end,
        })
    end,
    opts = {
        diagnostics = {
            virtual_text = {
                severity = {
                    vim.diagnostic.severity.INFO,
                    vim.diagnostic.severity.WARN,
                    vim.diagnostic.severity.ERROR,
                },
                prefix = "icons",
            },
            signs = {
                severity = {
                    vim.diagnostic.severity.HINT,
                },
                text = {
                    HINT = "💡",
                },
            },
        },
        inlay_hints = {
            enabled = true,
        },
        format_notify = true,
        servers = {
            -- pylance = require("config.lsp.server.pylance"),
        },
    },
}
