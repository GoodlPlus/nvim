local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazy_path,
    })
end
vim.opt.rtp:prepend(lazy_path)
require("lazy").setup({
    defaults = {
        -- lazy = true, -- every plugin is lazy-loaded by default
        version = false, -- always use the latest git commit
        -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    spec = {
        { import = "config" },
        { import = "config.lsp" },
    },
    lockfile = VIM_CONFIG_PATH .. "/cache/lazy-lock.json",
    dev = {
        path = VIM_CONFIG_PATH .. "/lua/plugin",
    },
    checker = { enabled = false, frequency = 3600 * 24 }, -- automatically check for plugin updates
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
-- neogit
-- Undotree
