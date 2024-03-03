local kind_to_icon = {
    Namespace = "󰌗",
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰆧",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈚",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰊄",
    Table = "",
    Object = "󰅩",
    Tag = "",
    Array = "[]",
    Boolean = "",
    Number = "",
    Null = "󰟢",
    String = "󰉿",
    Calendar = "",
    Watch = "󰥔",
    Package = "",
    Copilot = "",
    Codeium = "",
    TabNine = "",
}

return  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp", lazy = true, event = "VeryLazy" },
        -- { "hrsh7th/cmp-buffer", lazy = true, event = "VeryLazy" },
        { "hrsh7th/cmp-path", lazy = true, event = "VeryLazy" },
        { "hrsh7th/cmp-cmdline", lazy = true, event = "VeryLazy" },
        -- { "saadparwaiz1/cmp_luasnip", lazy = true, event = "VeryLazy" },
        -- { "L3MON4D3/LuaSnip", lazy = true, event = "VeryLazy" },
    },
    config = function()
        local cmp = require("cmp")

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.setup({
            completion = {
                autocomplete = false,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-u>"] = cmp.mapping.scroll_docs(-5), -- Up
                ["<C-d>"] = cmp.mapping.scroll_docs(5), -- Down
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                        --[[ Replace with your snippet engine (see above sections on this page)
                    elseif snippy.can_expand_or_advance() then
                        snippy.expand_or_advance() ]]
                    elseif has_words_before() then
                        cmp.complete()
                        -- cmp.select_next_item()
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
                        -- cmp.select_prev_item()
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
                    -- { name = "buffer" },
                    { name = "path" },
                }),
            formatting = {
                fields = { "abbr", "kind", "menu" },
                format = function(_, item)
                    local icon = kind_to_icon[item.kind] or ""
                    item.kind = string.format("%s %s", icon, item.kind or "")
                    item.abbr = string.sub(item.abbr, 1, 50)
                    return item
                end,
            },
            window = {
                completion = {
                    border = "rounded",
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:NONE",
                    scrollbar = false,
                },
                documentation = {
                    border = "rounded",
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:NONE",
                    scrollbar = false,
                },
            },
        })

        -- cmp.setup.cmdline({ "/", "?" }, {
        --     mapping = cmp.mapping.preset.cmdline(),
        --     sources = {
        --         { name = "buffer" },
        --     },
        -- })

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
