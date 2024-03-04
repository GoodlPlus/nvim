local M = {}

local utils = require("utils")
local devicons = require("nvim-web-devicons")

local LEFT = ""
local RIGHT = ""

local HIGHLIGHT_GROUP_PREFIX = "GoodlPlus_status_line"

local SELECTED_FG = vim.api.nvim_get_hl(0, { name = "Normal" }).fg
local SELECTED_BG = "#32302f"
local SELECTED_HIGHLIGHT_GROUP
local SELECTED_PAD_HIGHLIGHT_GROUP

local UNSELECTED_FG = vim.api.nvim_get_hl(0, { name = "Comment" }).fg
-- local UNSELECTED_BG = "#32302f"
local UNSELECTED_BG = "#282828"
local UNSELECTED_HIGHLIGHT_GROUP
local UNSELECTED_PAD_HIGHLIGHT_GROUP

local icon_highlight_groups = {}

local diagnostics_config = {
    error_highlight_group = nil,
    warn_highlight_group = nil,
    info_highlight_group = nil,
    hint_highlight_group = nil,
    error_icon = nil,
    warn_icon = nil,
    info_icon = nil,
    hint_icon = nil,
}

local function get_status_line_bufnr()
    return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

local function is_active_window()
    return vim.api.nvim_get_current_win() == vim.g.statusline_winid
end

local function get_highlight_group(highlight_group, fg, bg)
    highlight_group = HIGHLIGHT_GROUP_PREFIX .. highlight_group
    local highlight_group_info = vim.api.nvim_get_hl(0, { name = highlight_group, create = false })
    if next(highlight_group_info) == nil then
        vim.api.nvim_set_hl(0, highlight_group, { fg = fg, bg = bg })
    end
    return highlight_group
end

local function get_highlight_group_info(highlight_group)
    local highlight_group_info = { link = highlight_group }
    repeat
        highlight_group_info = vim.api.nvim_get_hl(0, { name = highlight_group_info.link, create = false })
    until (highlight_group_info.link == nil)
    return highlight_group_info
end

local function get_highlighted_text(text, highlight_group)
    return "%#" .. highlight_group .. "#" .. text .. "%*"
end

local function get_default_highlighted_text(text)
    local highlight_group = (is_active_window() and { SELECTED_HIGHLIGHT_GROUP } or { UNSELECTED_HIGHLIGHT_GROUP })[1]
    return "%#" .. highlight_group .. "#" .. text .. "%*"
end

local function add_pad(text)
    if text == nil or text == "" then
        return ""
    end
    local pad_highlight_group = (is_active_window() and { SELECTED_PAD_HIGHLIGHT_GROUP } or { UNSELECTED_PAD_HIGHLIGHT_GROUP })[1]
    local left_pad = get_highlighted_text(LEFT, pad_highlight_group)
    local right_pad = get_highlighted_text(RIGHT, pad_highlight_group) .. "%*"
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

local function file()
    local bufnr = get_status_line_bufnr()
    local path = vim.api.nvim_buf_get_name(bufnr)
    path = vim.fn.fnamemodify(path, ":~")
    local name = vim.fn.fnamemodify(path, ":t")
    local icon, highlight_group = devicons.get_icon(name)
    if is_active_window() then
        highlight_group = "selected_" .. highlight_group
    else
        highlight_group = "unselected_" .. highlight_group
    end
    local icon_highlight_group = icon_highlight_groups[highlight_group]
    if icon_highlight_group == nil then
        local _, color, bg
        if is_active_window() then
            _, color = devicons.get_icon_color(name)
            bg = SELECTED_BG
        else
            _, color = " ", UNSELECTED_FG
            bg = UNSELECTED_BG
        end
        icon_highlight_group = get_highlight_group(highlight_group, color, bg)
        icon_highlight_groups[highlight_group] = icon_highlight_group
    end
    local highlighted_icon = get_highlighted_text(icon, icon_highlight_group)
    local highlighted_path = get_default_highlighted_text(path)
    local modified = (vim.bo[bufnr].modified == true and { get_default_highlighted_text("") } or { "" })[1]
    local parts = { highlighted_icon, highlighted_path, modified }
    return add_pad(concat(parts, get_default_highlighted_text(" ")))
end

local function git()
    local branch_name, added, changed, removed = "", "", "", ""
    local bufnr = get_status_line_bufnr()
    if not vim.b[bufnr].gitsigns_head or vim.b[bufnr].gitsigns_git_status then
        local path = vim.api.nvim_buf_get_name(bufnr)
        local root = vim.fn.fnamemodify(path, ":h")
        local branch_info = vim.system({ "git", "symbolic-ref", "--short", "HEAD" }, { cwd = root, stderr = false }):wait()
        local code = branch_info.code
        if code == 0 then
            branch_name = branch_info.stdout
            branch_name = utils.strip(branch_name)
        end
    else
        local git_status = vim.b[bufnr].gitsigns_status_dict
        added = ((git_status.added and git_status.added ~= 0) and { get_default_highlighted_text(" " .. git_status.added) } or { "" })[1]
        changed = ((git_status.changed and git_status.changed ~= 0) and { get_default_highlighted_text(" " .. git_status.changed) } or { "" })[1]
        removed = ((git_status.removed and git_status.removed ~= 0) and { get_default_highlighted_text(" " .. git_status.removed) } or { "" })[1]
        branch_name = git_status.head
    end
    if branch_name == "" or branch_name == nil then
        return nil
    end
    local branch_icon = get_default_highlighted_text("")
    branch_name = get_default_highlighted_text(branch_name)
    local parts = { branch_icon, branch_name, added, changed, removed }
    return add_pad(concat(parts, get_default_highlighted_text(" ")))
end

local function get_diagnostics_icon_and_highlight_group(type)
    local sign = vim.fn.sign_getdefined("DiagnosticSign" .. type)[1]
    local icon = sign.text
    local sign_highlight_group = sign.texthl
    local sign_fg = get_highlight_group_info(sign_highlight_group).fg
    return icon, get_highlight_group(sign_highlight_group, sign_fg, SELECTED_BG)
end

local function init_diagnostics()
    if diagnostics_config.error_highlight_group == nil then
        diagnostics_config.selected_error_icon, diagnostics_config.selected_error_highlight_group = get_diagnostics_icon_and_highlight_group("Error")
    end
    if diagnostics_config.warn_highlight_group == nil then
        diagnostics_config.selected_warn_icon, diagnostics_config.selected_warn_highlight_group = get_diagnostics_icon_and_highlight_group("Warn")
    end
    if diagnostics_config.info_highlight_group == nil then
        diagnostics_config.selected_info_icon, diagnostics_config.selected_info_highlight_group = get_diagnostics_icon_and_highlight_group("Info")
    end
    if diagnostics_config.hint_highlight_group == nil then
        diagnostics_config.selected_hint_icon, diagnostics_config.selected_hint_highlight_group = get_diagnostics_icon_and_highlight_group("Hint")
    end
end

local function get_highlighted_diagnostics_text(num, icon_name, highlight_group_name)
    if is_active_window() then
        highlight_group = diagnostics_config[highlight_group_name]
    else
        highlight_group = UNSELECTED_HIGHLIGHT_GROUP
    end
    return ((num and num > 0) and { (get_highlighted_text(diagnostics_config[icon_name], highlight_group) .. get_default_highlighted_text(num)) } or { "" })[1]
end

local function diagnostics()
    if not rawget(vim, "lsp") then
        return nil
    end
    init_diagnostics()
    local bufnr = get_status_line_bufnr()
    local error_num = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
    local warn_num = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
    local info_num = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO })
    local hint_num = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT })
    local error_text = get_highlighted_diagnostics_text(error_num, "selected_error_icon", "selected_error_highlight_group")
    local warn_text = get_highlighted_diagnostics_text(warn_num, "selected_warn_icon", "selected_warn_highlight_group")
    local info_text = get_highlighted_diagnostics_text(info_num, "selected_info_icon", "selected_info_highlight_group")
    local hint_text = get_highlighted_diagnostics_text(hint_num, "selected_hint_icon", "selected_hint_highlight_group")
    -- local warn_text = ((warn_num and warn_num > 0) and { (get_highlighted_text(diagnostics_config.selected_warn_icon, diagnostics_config.selected_warn_highlight_group) .. get_default_highlighted_text(warn_num)) } or { "" })[1]
    -- local info_text = ((info_num and info_num > 0) and { (get_highlighted_text(diagnostics_config.selected_info_icon, diagnostics_config.selected_info_highlight_group) .. get_default_highlighted_text(info_num)) } or { "" })[1]
    -- local hint_text = ((hint_num and hint_num > 0) and { (get_highlighted_text(diagnostics_config.selected_hint_icon, diagnostics_config.selected_hint_highlight_group) .. get_default_highlighted_text(hint_num)) } or { "" })[1]
    local diagnostics_list= { error_text, warn_text, info_text, hint_text }
    return add_pad(concat(diagnostics_list, get_default_highlighted_text(" ")))
end

local function percent()
    local bufnr = get_status_line_bufnr()
    local current_pos = vim.fn.getcurpos(vim.g.statusline_winid)
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local percent = math.floor((current_pos[2] - 1) * 100 / line_count)
    local percent_text = string.format("%2d", percent)
    percent_text = get_default_highlighted_text("  " .. percent_text .. "%% ")
    return add_pad(percent_text)
end

local function init_highlight_group()
    SELECTED_HIGHLIGHT_GROUP = get_highlight_group("selected", SELECTED_FG, SELECTED_BG)
    SELECTED_PAD_HIGHLIGHT_GROUP = get_highlight_group("selected_pad", SELECTED_BG, "NONE")
    UNSELECTED_HIGHLIGHT_GROUP = get_highlight_group("unselected", UNSELECTED_FG, UNSELECTED_BG)
    UNSELECTED_PAD_HIGHLIGHT_GROUP = get_highlight_group("unselected_pad", UNSELECTED_BG, "NONE")
end

function M.init()
    init_highlight_group()
end

function M.status_line()
    local modules = {
        "",
        file(),
        git(),
        "%=",
        diagnostics(),
        percent(),
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
