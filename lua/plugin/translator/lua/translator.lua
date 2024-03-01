local M = {}

local utils = require("utils")
local translator = require("translator.main")

function M.create_command(command_function)
    vim.api.nvim_create_user_command(
        "Translate",
        function(opts)
            local mode = (opts.range == 0 and { vim.fn.mode() } or { vim.fn.visualmode() })[1]
            command_function(mode, opts)
        end,
        {
            range = 0,
        }
    )
end

function M.setup()
    M.create_command(translator.main)
end

return M
