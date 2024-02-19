local M = {}

function M.exist(set, key)
    return set[key] ~= nil
end

function M.ternary(condition, first, second)
    return (condition and { first } or { second })[1]
end

function M.get_selected_text(mode)
    if mode == "n" then
        return { vim.fn.expand("<cword>") }
    elseif vim.list_contains({ "v", "V", "" }, mode) then
        return M.get_visual_selected_text()
    else
        vim.notify("translator: invalid mode", vim.log.levels.ERROR)
    end
end

function M.get_visual_selected_text()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local max_col = vim.v.maxcol
    local lines = vim.api.nvim_buf_get_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, M.ternary(end_pos[3] == max_col, -1, end_pos[3]), {})
    return lines
end

-- https://stackoverflow.com/questions/1426954/split-string-in-lua
function M.split(input_str, sep)
    sep = sep or "%s"
    local strs = {}
    for field, s in string.gmatch(input_str, "([^" .. sep .. "]*)(" .. sep .. "?)") do
        table.insert(strs, field)
        if s == "" then
            return strs
        end
    end
end

function M.escape(str)
    return string.gsub(str, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

function M.augroup(name)
  return vim.api.nvim_create_augroup("GoodlPlus_" .. name, { clear = true })
end

return M
