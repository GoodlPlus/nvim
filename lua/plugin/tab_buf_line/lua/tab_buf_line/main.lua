local M = {}

local devicons = require("nvim-web-devicons")

local LEFT = ""
local RIGHT = ""

local HIGHLIGHT_GROUP_PREFIX = "GoodlPlus_tab_buf_line"

local SELECTED_FG = vim.api.nvim_get_hl(0, { name = "Normal" }).fg
local SELECTED_BG = "#32302f"
local SELECTED_HIGHLIGHT_GROUP
local SELECTED_PAD_HIGHLIGHT_GROUP

local UNSELECTED_FG = vim.api.nvim_get_hl(0, { name = "Comment" }).fg
local UNSELECTED_BG = "#282828"
local UNSELECTED_HIGHLIGHT_GROUP
local UNSELECTED_PAD_HIGHLIGHT_GROUP

local BASE_COLUMNS = 20

local icon_highlight_groups = {}

local function is_buffer_valid(bufnr)
    return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

local function get_highlight_group(highlight_group, fg, bg)
    highlight_group = HIGHLIGHT_GROUP_PREFIX .. highlight_group
    local highlight_group_info = vim.api.nvim_get_hl(0, { name = highlight_group, create = false })
    if next(highlight_group_info) == nil then
        vim.api.nvim_set_hl(0, highlight_group, { fg = fg, bg = bg })
    end
    return highlight_group
end

local function get_highlighted_text(text, highlight_group)
    return "%#" .. highlight_group .. "#" .. text .. "%*"
end

local function add_pad(text, highlight_group)
    if text == nil or text == "" then
        return ""
    end
    local left_pad = get_highlighted_text(LEFT, highlight_group)
    local right_pad = get_highlighted_text(RIGHT, highlight_group) .. "%*"
    return left_pad .. text .. right_pad
end

local function concat(parts, sep)
    local existing_parts = {}
    for _, part in ipairs(parts) do
        if #part ~= 0 then
            table.insert(existing_parts, part)
        end
    end
    if #existing_parts == 0 then
        return nil
    else
        table.insert(existing_parts, 1, "")
        table.insert(existing_parts, "")
        return table.concat(existing_parts, sep)
    end
end

local function get_highlighted_buffer_text(file_name, bufnr)
    local icon, highlight_group = devicons.get_icon(file_name)
    local current_buffer = vim.api.nvim_get_current_buf()
    local path_highlight_group, pad_highlight_group
    if current_buffer == bufnr then
        highlight_group = "selected_" .. highlight_group
        path_highlight_group = SELECTED_HIGHLIGHT_GROUP
        pad_highlight_group = SELECTED_PAD_HIGHLIGHT_GROUP
    else
        highlight_group = "unselected_" .. highlight_group
        path_highlight_group = UNSELECTED_HIGHLIGHT_GROUP
        pad_highlight_group = UNSELECTED_PAD_HIGHLIGHT_GROUP
    end
    local icon_highlight_group = icon_highlight_groups[highlight_group]
    if icon_highlight_group == nil then
        local _, color, bg
        if current_buffer == bufnr then
            _, color = devicons.get_icon_color(file_name)
            bg = SELECTED_BG
        else
            _, color = " ", UNSELECTED_FG
            bg = UNSELECTED_BG
        end
        icon_highlight_group = get_highlight_group(highlight_group, color, bg)
        icon_highlight_groups[highlight_group] = icon_highlight_group
    end
    local highlighted_icon = get_highlighted_text(icon, icon_highlight_group)
    local highlighted_path = get_highlighted_text(file_name, path_highlight_group)
    local modified = (vim.bo[bufnr].modified == true and { get_highlighted_text("", path_highlight_group) } or { "" })[1]
    local parts = { highlighted_icon, highlighted_path, modified }
    return add_pad(concat(parts, get_highlighted_text(" ", path_highlight_group)), pad_highlight_group)
end

local function get_buffer_text(bufnr)
    local path = vim.api.nvim_buf_get_name(bufnr)
    local file_name = ((#path ~= 0) and { vim.fn.fnamemodify(path, ":t") } or { "No Name" })[1]
    return get_highlighted_buffer_text(file_name, bufnr)
end

local function buffer_part()
    local buffers = {} -- buffersults
    local available_columns = vim.o.columns
    local current_buffer = vim.api.nvim_get_current_buf()
    local has_current = false -- have we seen current buffer yet?

    local used_columns = 0
    for _, bufnr in ipairs(vim.t.buffers) do
        if is_buffer_valid(bufnr) then
            if ((#buffers + 1) * BASE_COLUMNS + 1) > available_columns then
                if has_current then
                    break
                end
                table.remove(buffers, 1)
            end
            if bufnr == current_buffer then
                has_current = true
            end
            table.insert(buffers, get_buffer_text(bufnr))
        end
    end

    return table.concat(buffers, " ")
end

local function init_buffer()
    local buffers = vim.api.nvim_list_bufs()
    local listed_buffers = {}
    for _, bufnr in ipairs(buffers) do
        if vim.bo[bufnr].buflisted then
            table.insert(listed_buffers, bufnr)
        end
    end
    vim.t.buffers = listed_buffers
end

local function init_autocmd()
    -- autocmds for tabufline -> store bufnrs on bufadd, bufenter events
    -- thx to https://github.com/ii14 & stores buffer per tab -> table
    vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter", "tabnew" }, {
        callback = function(args)
            local buffers = vim.t.buffers

            if buffers == nil then
                vim.t.buffers = (vim.api.nvim_get_current_buf() == args.buf and { {} } or { { args.buf } })[1]
            else
                -- check for duplicates
                if
                    not vim.tbl_contains(buffers, args.buf)
                    and (args.event == "BufEnter" or vim.bo[args.buf].buflisted or args.buf ~= vim.api.nvim_get_current_buf())
                    and vim.api.nvim_buf_is_valid(args.buf)
                    and vim.bo[args.buf].buflisted
                then
                    table.insert(buffers, args.buf)
                    vim.t.buffers = buffers
                end
            end

            -- remove unnamed buffer which isnt current buf & modified
            if args.event == "BufAdd" then
                local first_buffer = vim.t.buffers[1]

                if #vim.api.nvim_buf_get_name(first_buffer) == 0 and not vim.api.nvim_get_option_value("modified", { buf = first_buffer }) then
                    table.remove(buffers, 1)
                    vim.t.buffers = buffers
                end
            end
        end,
    })

    vim.api.nvim_create_autocmd("BufDelete", {
        callback = function(args)
            for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
                local buffers = vim.t[tab].buffers
                if buffers then
                    for i, bufnr in ipairs(buffers) do
                        if bufnr == args.buf then
                            table.remove(buffers, i)
                            vim.t[tab].buffers = buffers
                            break
                        end
                    end
                end
            end
        end,
    })
end

local function init_highlight_group()
    SELECTED_HIGHLIGHT_GROUP = get_highlight_group("selected", SELECTED_FG, SELECTED_BG)
    SELECTED_PAD_HIGHLIGHT_GROUP = get_highlight_group("selected_pad", SELECTED_BG, "NONE")
    -- UNSELECTED_HIGHLIGHT_GROUP = get_highlight_group("unselected", UNSELECTED_FG, "#282828")
    -- UNSELECTED_HIGHLIGHT_GROUP = get_highlight_group("unselected", UNSELECTED_FG, SELECTED_BG)
    UNSELECTED_HIGHLIGHT_GROUP = get_highlight_group("unselected", UNSELECTED_FG, UNSELECTED_BG)
    UNSELECTED_PAD_HIGHLIGHT_GROUP = get_highlight_group("unselected_pad", UNSELECTED_BG, "NONE")
end

function M.init()
    init_buffer()
    init_autocmd()
    init_highlight_group()
end

function M.tab_buf_line()
    local modules = {
        "",
        buffer_part(),
        "",
    }
    local exist_modules = {}
    for _, module in pairs(modules) do
        if module ~= nil then
            table.insert(exist_modules, module)
        end
    end
    return table.concat(exist_modules, " ")
end

return M
