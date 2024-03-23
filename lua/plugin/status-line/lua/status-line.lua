local M = {}

local status_line = require("status-line.main")

function M.setup()
    status_line.init()
    vim.opt.statusline = "%!v:lua.require('status-line.main').status_line()"
end

return M
