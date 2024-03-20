return {
    "williamboman/mason.nvim",
    lazy = true,
    event = "VeryLazy",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
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
    config = function(_, opts)
        require("mason").setup(opts)

        -- custom nvchad cmd to install all mason binaries listed
        vim.api.nvim_create_user_command("MasonInstallAll", function()
            if opts.ensure_installed and #opts.ensure_installed > 0 then
                vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
            end
        end, {})
    end,
}
