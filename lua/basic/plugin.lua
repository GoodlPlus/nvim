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
        lazy = true, -- every plugin is lazy-loaded by default
        version = false, -- always use the latest git commit
        -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    spec = {
        { import = "config" },
        { import = "config.lsp" },
        { import = "config.theme" },
    },
    lockfile = VIM_CONFIG_PATH .. "/cache/lazy-lock.json",
    dev = {
        path = VIM_CONFIG_PATH .. "/lua/plugin",
    },
    checker = { enabled = false, frequency = 3600 * 24 }, -- automatically check for plugin updates
    ui = {
        size = { width = 0.618, height = 0.618 },
        icons = {
        ft = "",
        lazy = "󰂠 ",
        loaded = "",
        not_loaded = "",
        },
        border = "rounded",
        backdrop = 100,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "tohtml",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "netrw",
                "netrwPlugin",
                "netrwSettings",
                "netrwFileHandlers",
                "matchit",
                "tar",
                "tarPlugin",
                "rrhelper",
                "spellfile_plugin",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
                "tutor",
                "rplugin",
                "syntax",
                "synmenu",
                "optwin",
                "compiler",
                "bugreport",
                "ftplugin",
            },
        },
    },
})
