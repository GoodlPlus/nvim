return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "VeryLazy",
    opts = {
        lua_ls = {
            cmd = { VIM_DATA_PATH .. "/mason/bin/lua-language-server" },
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using
                        -- (most likely LuaJIT in the case of Neovim)
                        version = "LuaJIT"
                    },
                    diagnostics = {
                        globals = { "vim" },
                        disable = { "different-requires" },
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                        },
                        maxPreload = 100000,
                        preloadFileSize = 10000,
                    },
                    format = { enable = false },
                    telemetry = { enable = false },
                    -- Do not override treesitter lua highlighting with lua_ls's highlighting
                    semantic = { enable = false },
                },
            },
        }
    }
}
