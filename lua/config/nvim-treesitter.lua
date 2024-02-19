return {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    event = "VeryLazy",
    build = ":TSUpdate",
    init = function(plugin)
        -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
        -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
        -- no longer trigger the **nvim-treeitter** module to be loaded in time.
        -- Luckily, the only thins that those plugins need are the custom queries, which we make available
        -- during startup.
        require("lazy.core.loader").add_to_rtp(plugin)
        require("nvim-treesitter.query_predicates")
    end,
    opts = {
        ensure_installed = { "python", "c", "cpp", "lua", "vim", "vimdoc", "json", "bash" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
    },
    configs = function(_, opts)
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        local plugin = require("nvim-treesitter")
        plugin.setup(opts)
    end,
    main = "nvim-treesitter.configs"
}
