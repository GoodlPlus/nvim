local M = {}

local utils = require("utils")
local job = require("plenary.job")
local popup = require("plenary.popup")

local function filter_text(text)
    local comment_string = vim.api.nvim_get_option_value("commentstring", { scope = "local" })
    local comment_prefix = utils.split(comment_string, " ")[1]
    local escape_comment_prefix = utils.escape(comment_prefix)

    local filtered_text = {}
    for i, part in ipairs(text) do
        if comment_prefix ~= nil and comment_prefix ~= "" then
            part = string.gsub(part, "^%s*" .. escape_comment_prefix, "")
        end
        part = string.gsub(part, "^%s+", "")
        part = string.gsub(part, "%s+$", "")
        table.insert(filtered_text, part)
    end
    filtered_text = table.concat(filtered_text, "\n")

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
    for i, line in ipairs(lines) do
        local width = vim.api.nvim_strwidth(line)
        max_width = math.max(max_width, width)
    end
    return max_width
end

local function compute_height(lines, max_width)
    local height = 0
    for i, line in ipairs(lines) do
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

local function process_ouput(self, code, signal)
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
        current_window_width = vim.api.nvim_win_get_width(0)
        current_window_height = vim.api.nvim_win_get_height(0)
        width, height = compute_window_width_height(lines, current_window_width, current_window_height)
        popup.create(lines,
            {
                line = "cursor+1",
                col = "cursor",
                width = width,
                height = height,
                minwidth = width,
                minheight = height,
                maxwidth = width,
                maxheight = height,
                enter = false,
                finalize_callback = finalize_callback,
            }
        )
    end

    if code == 0 then
        local stdout = table.concat(self:result(), "\n")
        vim.schedule_wrap(show)(stdout)
    else
        local stderr = table.concat(self:stderr_result(), "\n")
        vim.notify("translator: " .. stderr, vim.log.levels.ERROR)
    end
end

local function translate(text)
    local data = { text = text, target_lang = "zh" }
    data = vim.json.encode(data)
    local results = {}
    job:new(
        {
            command = "curl",
            args = {
                "--location",
                "https://service-cux6rntx-1304954655.bj.tencentapigw.com.cn/release/translate",
                "--header",
                "Content-Type: application/json",
                "--data",
                data,
            },
            cwd = "/usr/bin",
            on_exit = process_ouput,
        }
    ):start()
end

function M.main(mode, opts)
    local text = utils.get_selected_text(mode)
    local filtered_text = filter_text(text)
    translate(filtered_text)
end

return M
