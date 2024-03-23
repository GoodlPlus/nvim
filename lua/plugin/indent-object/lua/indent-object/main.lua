local M = {}

function M.init()
    local path = VIM_CONFIG_PATH .. "/lua/plugin/indent-object/lua/indent-object/main.vim"
    vim.cmd("source " .. path)
end

return M
