return  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp", lazy = true, event = "VeryLazy" },
        { "hrsh7th/cmp-buffer", lazy = true, event = "VeryLazy" },
        { "hrsh7th/cmp-path", lazy = true, event = "VeryLazy" },
        { "hrsh7th/cmp-cmdline", lazy = true, event = "VeryLazy" },
        -- { "saadparwaiz1/cmp_luasnip", lazy = true, event = "VeryLazy" },
        -- { "L3MON4D3/LuaSnip", lazy = true, event = "VeryLazy" },
        { "onsails/lspkind-nvim", lazy = true, event = "VeryLazy" },
    },
    config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.setup {
            completion = {
                autocomplete = false,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-u>'] = cmp.mapping.scroll_docs(-5), -- Up
                ['<C-d>'] = cmp.mapping.scroll_docs(5), -- Down
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                        --[[ Replace with your snippet engine (see above sections on this page)
                    elseif snippy.can_expand_or_advance() then
                        snippy.expand_or_advance() ]]
                    elseif has_words_before() then
                        cmp.complete()
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                        --[[ Replace with your snippet engine (see above sections on this page)
                    elseif snippy.can_expand_or_advance() then
                        snippy.expand_or_advance() ]]
                    elseif has_words_before() then
                        cmp.complete()
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            -- snippet = {
            --     expand = function(args)
            --         require("luasnip").lsp_expand(args.body)
            --     end,
            -- },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                -- { name = "luasnip" },
            }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            -- formatting = {
            --     format = lspkind.cmp_format {
            --         mode = "symbol_text",
            --         maxwidth = 50,
            --     },
            -- },
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    local kind = require("lspkind").cmp_format({ mode = "symbol", maxwidth = 50 })(entry, vim_item)
                    local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    local menu = {
                        luasnip = "[SNP]",
                        nvim_lsp = "[LSP]",
                        nvim_lua = "[VIM]",
                        buffer = "[BUF]",
                        path = "[PTH]",
                        calc = "[CLC]",
                        latex_symbols = "[TEX]",
                        orgmode = "[ORG]",
                    }
                    kind.kind = (strings[1] or "")
                    kind.menu = menu[entry.source.name]
                    return kind
                end,
            },
        }

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                    { name = "cmdline" },
                }),
        })
    end,
}
