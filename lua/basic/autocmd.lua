local utils = require("utils")

--------------------------------------------------------------------------------
-- Dynamically smartcase
-- Do not use smart case in command line mode,
-- extracted from https://vi.stackexchange.com/q/16509/15292
--------------------------------------------------------------------------------
local auto_smartcase_id = utils.augroup("auto_smartcase")
vim.api.nvim_create_autocmd({ "CmdLineEnter" },
    {
        group = auto_smartcase_id,
        callback = function()
            vim.opt.smartcase = false
        end,
    }
)
vim.api.nvim_create_autocmd({ "CmdLineLeave" },
    {
        group = auto_smartcase_id,
        callback = function()
            vim.opt.smartcase = true
        end,
    }
)

--------------------------------------------------------------------------------
-- Highlight yank region
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "TextYankPost" },
    {
        group = utils.augroup("highlight_yank_region"),
        callback = function()
            vim.highlight.on_yank()
        end,
    }
)

--------------------------------------------------------------------------------
-- Remove trailing spaces and lines
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufWritePre" },
    {
        group = utils.augroup("auto_remove_trailing_spaces_lines"),
        callback = function()
            local saved_cursor = vim.api.nvim_win_get_cursor(0)
            vim.cmd([[silent %s/\s\+$//e]])
            local first_line_num = vim.fn.line("^")
            local first_non_blank_line_num = vim.fn.nextnonblank(first_line_num)
            if first_non_blank_line_num - 1 >= first_line_num + 1 then
                vim.fn.deletebufline("%", first_line_num + 1, first_non_blank_line_num - 1)
            end
            local last_line_num = vim.fn.line("$")
            local last_non_blank_line_num = vim.fn.prevnonblank(last_line_num)
            if last_non_blank_line_num + 1 <= last_line_num then
                vim.fn.deletebufline("%", last_non_blank_line_num + 1, last_line_num)
            end
            vim.api.nvim_win_set_cursor(0, saved_cursor)
        end,
    }
)

--------------------------------------------------------------------------------
-- Resize splits if window got resized
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = utils.augroup("resize_splits"),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})


--------------------------------------------------------------------------------
-- check for spell in text filetypes
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = utils.augroup("spell_check"),
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us,cjk"
    end,
})

--------------------------------------------------------------------------------
-- Fix conceallevel for json files
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = utils.augroup("json_conceal"),
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

--------------------------------------------------------------------------------
-- Auto create dir when saving a file, in case some intermediate directory does not exist
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = utils.augroup("auto_create_dir"),
    callback = function(args)
        if args.match:match("^%w%w+://") then
            return
        end
        local file = vim.loop.fs_realpath(args.match) or args.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

--------------------------------------------------------------------------------
-- gd in vim help
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = utils.augroup("go_to_def_help"),
    pattern = { "help" },
    callback = function()
        vim.keymap.set("n", "gd", "<c-]>", { buffer = 0 })
    end,
})

--------------------------------------------------------------------------------
-- restore cursor position
--------------------------------------------------------------------------------
-- vim.api.nvim_create_autocmd('BufRead', {
--     callback = function(args)
--         vim.api.nvim_create_autocmd('BufWinEnter', {
--             once = true,
--             buffer = args.buf,
--             callback = function()
--                 local ft = vim.bo[args.buf].filetype
--                 local last_known_line = vim.api.nvim_buf_get_mark(args.buf, '"')[1]
--                 if
--                     not (ft:match('commit') and ft:match('rebase'))
--                     and last_known_line > 1
--                     and last_known_line <= vim.api.nvim_buf_line_count(args.buf)
--                     then
--                         vim.api.nvim_feedkeys([[g`"]], 'nx', false)
--                     end
--                 end,
--             })
--         end,
--     })

--------------------------------------------------------------------------------
-- go to last loc when opening a buffer
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = utils.augroup("restore_cursor"),
    callback = function(args)
        local exclude = { "gitcommit" }
        local buf = args.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].is_cursor_restored then
            return
        end
        vim.b[buf].is_cursor_restored = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local line_count = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

--------------------------------------------------------------------------------
-- close some filetypes with <Esc>
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = utils.augroup("close_with_esc"),
    pattern = {
        "lazy",
        "mason",
        "lspinfo",
    },
    callback = function(args)
        vim.bo[args.buf].buflisted = false
        vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", { buffer = args.buf, silent = true })
    end,
})

--------------------------------------------------------------------------------
-- remove auto comment in next line
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    group = utils.augroup("remove_auto_comment"),
    callback = function()
        vim.opt_local.formatoptions:remove({ "r", "o" })
    end,
})

--------------------------------------------------------------------------------
-- modify indent and shiftwidth when filetype is yaml
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    group = utils.augroup("modify_yaml_indent"),
    pattern = {
        "yaml",
    },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.listchars = { leadmultispace = "╏ " }
    end,
})
