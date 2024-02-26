local M = {}

local utils = require("utils")
local popup = require("plenary.popup")

local function filter_text(text)
    local comment_string = vim.api.nvim_get_option_value("commentstring", { scope = "local" })
    local comment_prefix = utils.split(comment_string, " ")[1]
    local escape_comment_prefix = utils.escape(comment_prefix)

    local lines = utils.split(text, "\n")
    local filtered_lines = {}
    for _, line in ipairs(lines) do
        if comment_prefix ~= nil and comment_prefix ~= "" then
            line = string.gsub(line, "^%s*" .. escape_comment_prefix, "")
        end
        line = utils.strip(line)
        table.insert(filtered_lines, line)
    end
    local filtered_text = table.concat(filtered_lines, "\n")

    -- start with "-\s" or "*\s" or "•\s" or "1.\s"
    -- end with ":\s\n"
    filtered_text = string.gsub(filtered_text, "(:)(\n)", "%1\r%2")
    filtered_text = string.gsub(filtered_text, "([^\r])(\n[%-%*•]%s+)", "%1\r%2")
    filtered_text = string.gsub(filtered_text, "([^\r])(\n%d+%.%s+)", "%1\r%2")
    filtered_text = string.gsub(filtered_text, "([^\r\n])\n([^\r\n])", "%1 %2")
    filtered_text = string.gsub(filtered_text, "\r", "")
    filtered_text = string.gsub(filtered_text, "\n\n+", "\n\n")
    filtered_text = string.gsub(filtered_text, "^%s+", "")
    filtered_text = string.gsub(filtered_text, "%s+$", "")
    filtered_text = string.gsub(filtered_text, "([a-z])([A-Z])", "%1 %2") -- firstSecond
    filtered_text = string.gsub(filtered_text, "([A-Z])([A-Z][a-z])", "%1 %2") -- firstOKSecond
    filtered_text = string.gsub(filtered_text, "([a-zA-Z])_([a-zA-Z])", "%1 %2") -- first_second
    return filtered_text
end

local function get_max_line_width(lines)
    local max_width = 0
    for _, line in ipairs(lines) do
        local width = vim.api.nvim_strwidth(line)
        max_width = math.max(max_width, width)
    end
    return max_width
end

local function compute_height(lines, max_width)
    local height = 0
    for _, line in ipairs(lines) do
        local width = math.max(vim.api.nvim_strwidth(line), 1)
        height = height + math.ceil(width / max_width)
    end
    return height
end

local function compute_window_width_height(lines, window_width, window_height)
    local max_line_width = get_max_line_width(lines)
    local ratio = 0.618
    local new_ratio = 0.618
    local multiple = 0.2
    local width, height
    repeat
        ratio = new_ratio
        width = math.floor(math.min(max_line_width, window_width * ratio))
        height = compute_height(lines, width)
        new_ratio = math.min(ratio * (1 + multiple), 1)
    until (height <= window_height * ratio or ratio >= 1)
    return width, height
end

local function process_ouput(output)
    local function show(response)
        response = vim.json.decode(response)
        local text = response.data
        local lines = utils.split(text, "\n")

        -- close window when cursor moved
        local finalize_callback = function(win_id, bufnr)
            vim.api.nvim_set_option_value("linebreak", false, { win = win_id })
            vim.api.nvim_set_option_value("breakindent", false, { win = win_id })
            vim.api.nvim_create_autocmd(
                { "CursorMoved", "CursorMovedI", "InsertEnter", "BufLeave" },
                {
                    group = utils.augroup("translator_popup"),
                    buffer = 0,
                    callback = function()
                        if vim.api.nvim_win_is_valid(win_id) then
                            vim.api.nvim_win_close(win_id, true)
                        end
                        if vim.api.nvim_buf_is_valid(bufnr) then
                            vim.api.nvim_buf_delete(bufnr, {})
                        end
                    end,
                    once = true, -- process only once
                    nested = true,
                }
            )
        end

        -- create popup to show translate result
        local current_window_width = vim.api.nvim_win_get_width(0)
        local current_window_height = vim.api.nvim_win_get_height(0)
        local width, height = compute_window_width_height(lines, current_window_width, current_window_height)
        popup.create(lines,
            {
                line = "cursor+2",
                col = "cursor",
                width = width,
                height = height,
                minwidth = width,
                minheight = height,
                maxwidth = width,
                maxheight = height,
                border = true,
                borderchars = {  "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                enter = false,
                finalize_callback = finalize_callback,
            }
        )
    end

    if output.code == 0 then
        vim.schedule_wrap(show)(output.stdout)
    else
        vim.notify("translator: " .. output.stderr, vim.log.levels.ERROR)
    end
end

local function translate(text)
    local data = { text = text, target_lang = "zh" }
    data = vim.json.encode(data)
    vim.system({
        "curl",
        "--location",
        "https://service-cux6rntx-1304954655.bj.tencentapigw.com.cn/release/translate",
        "--header",
        "Content-Type: application/json",
        "--data",
        data,
    },
        { timeout = 5000 },
        process_ouput)
end

function M.main(mode, opts)
    local text = utils.get_selected_text(mode)
    local filtered_text = filter_text(text)
    translate(filtered_text)
end

return M
