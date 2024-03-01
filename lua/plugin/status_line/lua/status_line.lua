local M = {}

local status_line = require("status_line.main")

function M.setup()
    status_line.init()
    vim.opt.statusline = "%!v:lua.require('status_line.main').status_line()"
end

return M
