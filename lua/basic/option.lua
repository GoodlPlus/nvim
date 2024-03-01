if vim.fn.has('nvim-0.10') == 0 then
    vim.opt.termguicolors = true -- Enable gui colors
end

vim.env.LANG = "en_US.UTF-8"

vim.g.mapleader = " "

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "ucs-bom", "gbk", "gb18030", "big5", "euc-jp", "latin1" }
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "dos", "mac" }

vim.opt.ruler = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.fillchars = { eob = " ", fold = " " }
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldtext = "v:lua.custom_fold_text()"

function _G.custom_fold_text()
    local line = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]
    local line_num = vim.v.foldend - vim.v.foldstart + 1
    return line .. "  " .. line_num .. "L"
end
-- function M.foldtext()
-- function _G.custom_fold_text()
--     local ok = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
--     local ret = ok and vim.treesitter.foldtext and vim.treesitter.foldtext()
--     if not ret or type(ret) == "string" then
--         ret = { { vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1], {} } }
--     end
--     table.insert(ret, { " " .. "󰇘" })
--
--     vim.print(ret)
--     if not vim.treesitter.foldtext then
--         return table.concat(
--             vim.tbl_map(function(line)
--                 return line[1]
--             end, ret),
--             " "
--         )
--     end
--     return ret
-- end

-- vim.opt.linebreak = true
-- vim.opt.breakindent = true
vim.opt.copyindent = true

vim.opt.splitbelow = true -- Horizontal splits will be below
vim.opt.splitright = true -- Vertical splits will be to the right

vim.opt.splitkeep = 'screen' -- Reduce scroll during window split

vim.opt.scrolloff = 5
vim.opt.smoothscroll = true

vim.opt.synmaxcol = 512
-- vim.opt.regexpengine = 1

vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true

-- Use left / right arrow to move to the previous / next line when at the start
-- or end of a line.
-- See doc (:help 'whichwrap')
vim.opt.whichwrap = "<,>,[,]"

vim.opt.list = true
vim.opt.listchars = { leadmultispace = "╏   " }

vim.opt.matchpairs:append({ "<:>" })

-- vim.opt.showmatch = true

vim.opt.mouse = { n = true }

vim.opt.showmode = false

-- Set tabline
vim.opt.showtabline = 2
-- vim.opt.laststatus = 3

vim.opt.pumheight = 10

vim.opt.complete:append({ kspell = true })
vim.opt.completeopt = { menu = true, menuone = true, popup = true }

vim.opt.shortmess = { a = true, s = true, t = true, c = true, C = true, F = true }

vim.opt.updatetime = 500

-- Always report number of lines changed
vim.opt.report = 0

-- viminfo

-- Set timeout (default on)
vim.opt.timeoutlen = 500

vim.opt.directory = ".,~/tmp,/var/tmp,/tmp"
vim.opt.undofile = true

vim.cmd([[
set diffopt+=algorithm:patience,indent-heuristic,vertical " see https://vimways.org/2018/the-power-of-diff
]])

vim.cmd([[
" ------------------------------------------------------------------------------
" DiffOrig
" ------------------------------------------------------------------------------
command DiffOrig vert new | set buftype=nofile | r ++edit # | 0d_
\ | diffthis | wincmd p | diffthis
]])

--------------------------------------------------------------------------------
-- Set timeout
-- https://unix.stackexchange.com/questions/9605/how-can-i-detect-if-the-shell-is-controlled-from-ssh
--------------------------------------------------------------------------------
if vim.fn.empty(vim.env.TMUX) == 0 then -- In TMUX
    vim.opt.ttimeoutlen = 5
elseif vim.fn.empty(vim.env.SSH_CLIENT) == 0 or vim.fn.empty(vim.env.SSH_TTY) == 0 then -- Not in TMUX but in SSH
    vim.opt.ttimeoutlen = 30
else
    vim.opt.ttimeoutlen = 5
end
