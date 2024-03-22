local M = {}

local utils = require("utils")

local DEFAULT_IM = "com.apple.keylayout.ABC"
local SELECTOR = "macism"
local previous_IM = DEFAULT_IM

function M.load(IM)
    vim.system({
        SELECTOR,
        IM
    },
    { timeout = 10000 })
end

function M.load_IM()
    if previous_IM ~= DEFAULT_IM then
        M.load(previous_IM)
    end
end

function M.callback(output)
    local current_IM = utils.strip(output.stdout)
    if current_IM ~= DEFAULT_IM then
        M.load(DEFAULT_IM)
    end
    previous_IM = current_IM
end

function M.save_IM()
    vim.system({
        SELECTOR,
    },
    { timeout = 10000 },
    M.callback)
end

function M.init()
    if vim.fn.executable(SELECTOR) ~= 1 then
        return
    end
    local IM_group_id = utils.augroup("IM")
    vim.api.nvim_create_autocmd(
        { "InsertLeave" },
        {
            group = IM_group_id,
            callback = function()
                M.save_IM()
            end,
        }
    )
    vim.api.nvim_create_autocmd(
        { "InsertEnter" },
        {
            group = IM_group_id,
            callback = function()
                M.load_IM()
            end,
        }
    )
end

return M
