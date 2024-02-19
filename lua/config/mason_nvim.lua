return {
    "williamboman/mason.nvim",
    lazy = true,
    event = "VeryLazy",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        },
        ensure_installed = { "pylance" },
        registries = { "github:fecet/mason-registry" },
    },
}
