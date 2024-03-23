local M = {}

local tab_buf_line = require("tab-buf-line.main")

function M.setup()
    tab_buf_line.init()
    vim.opt.tabline = "%!v:lua.require('tab-buf-line.main').tab_buf_line()"
end

return M
