return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "VeryLazy",
    opts = {
        -- Ensure mason installs the server
        clangd = {
            keys = {
                { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
            },
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
            },
            init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true,
            },
        },
    },
}
