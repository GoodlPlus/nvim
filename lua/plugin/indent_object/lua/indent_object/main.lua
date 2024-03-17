local M = {}

function M.init()
    local path = VIM_CONFIG_PATH .. "/lua/plugin/indent_object/lua/indent_object/main.vim"
    vim.cmd("source " .. path)
end

return M
