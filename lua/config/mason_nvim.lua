return {
    "williamboman/mason.nvim",
    lazy = true,
    event = "VeryLazy",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
        ui = {
            border = "rounded",
            width = 0.618,
            height = 0.618,
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        },
        ensure_installed = { "pylance", "clangd", "lua-language-server" },
        registries = { "github:fecet/mason-registry" },
    },
}
