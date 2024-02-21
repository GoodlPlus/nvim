--------------------------------------------------------------------------------
-- Personal tab keymaps
--------------------------------------------------------------------------------
vim.keymap.set("n", "<Tab>", "<Nop>", { noremap = true })
vim.keymap.set("n", "<Tab>h", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<Tab>j", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<Tab>k", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<Tab>l", "<C-w>l", { noremap = true })
vim.keymap.set("n", "<Tab>w", "<C-w>w", { noremap = true })
vim.keymap.set("n", "<Tab>c", "<C-w>c", { noremap = true })
vim.keymap.set("n", "<Tab>+", "<C-w>+", { noremap = true })
vim.keymap.set("n", "<Tab>-", "<C-w>-", { noremap = true })
vim.keymap.set("n", "<Tab>,", "<C-w>,", { noremap = true })
vim.keymap.set("n", "<Tab>.", "<C-w>.", { noremap = true })
vim.keymap.set("n", "<Tab>=", "<C-w>=", { noremap = true })
vim.keymap.set("n", "<Tab>s", "<C-w>s", { noremap = true })
vim.keymap.set("n", "<Tab>v", "<C-w>v", { noremap = true })
vim.keymap.set("n", "<Tab>o", "<C-w>o", { noremap = true })
vim.keymap.set("n", "<Tab>n", "<C-w>n", { noremap = true })
vim.keymap.set("n", "<Tab>p", "<C-w>p", { noremap = true })
vim.keymap.set("n", "<Tab>H", "<C-w>H", { noremap = true })
vim.keymap.set("n", "<Tab>J", "<C-w>J", { noremap = true })
vim.keymap.set("n", "<Tab>K", "<C-w>K", { noremap = true })
vim.keymap.set("n", "<Tab>L", "<C-w>L", { noremap = true })

-- Window resize (respecting `v:count`)
vim.keymap.set('n', '<C-Left>',  '"<Cmd>vertical resize -" . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Down>',  '"<Cmd>resize -"          . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Up>',    '"<Cmd>resize +"          . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Increase window height' })
vim.keymap.set('n', '<C-Right>', '"<Cmd>vertical resize +" . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Increase window width' })

--------------------------------------------------------------------------------
-- modify the key value of <C-i>
--------------------------------------------------------------------------------
-- vim.keymap.set("", "<Esc>^i", "<C-i>", { noremap = true })
vim.keymap.set("", "<C-^>", "<C-i>", { noremap = true })

--------------------------------------------------------------------------------
-- make j,k,h,l better
--------------------------------------------------------------------------------
vim.keymap.set({"n", "x"}, "j", [[v:count == 0 ? "gj" : "j"]], { noremap = true, expr = true, silent = true })
vim.keymap.set({"n", "x"}, "k", [[v:count == 0 ? "gk" : "k"]], { noremap = true, expr = true, silent = true })
vim.keymap.set({"n", "x"}, "<Down>", [[v:count == 0 ? "gj" : "j"]], { noremap = true, expr = true, silent = true })
vim.keymap.set({"n", "x"}, "<Up>", [[v:count == 0 ? "gk" : "k"]], { noremap = true, expr = true, silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })
-- vim.keymap.set("n", "H", "<Cmd>bprevious<CR>", { noremap = true })
-- vim.keymap.set("n", "L", "<Cmd>bnext<CR>", { noremap = true })
vim.keymap.set("n", "[b", "<Cmd>bprevious<CR>", { noremap = true })
vim.keymap.set("n", "]b", "<Cmd>bnext<CR>", { noremap = true })

--------------------------------------------------------------------------------
-- Indent in visual mode
--------------------------------------------------------------------------------
vim.keymap.set("x", "<", "<gv", { noremap = true })
vim.keymap.set("x", ">", ">gv", { noremap = true })

--------------------------------------------------------------------------------
-- Modify but don't save to register
--------------------------------------------------------------------------------
vim.keymap.set("", "s", '"_s', { noremap = true })
vim.keymap.set("", "S", '"_S', { noremap = true })
vim.keymap.set("", "x", '"_x', { noremap = true })
vim.keymap.set("", "X", '"_X', { noremap = true })

vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { noremap = true })
-- vim.keymap.set("n", "<Esc><Esc>", "<Cmd>nohlsearch<CR>", { noremap = true })

-- This generic behaviour for rename will be overwritten by treesitter.lua where
-- supported. Don't use 'cxr' in visual mode as it will block 'c'.
-- vim.keymap.set("n", "cxr", ":%s/<C-R><C-W>/<C-R><C-W>/gc<Left><Left><Left>", { noremap = true })

--------------------------------------------------------------------------------
-- search in very magic mode
--------------------------------------------------------------------------------
vim.keymap.set({"n", "x"}, "/", "/\\v", { noremap = true })
vim.keymap.set({"n", "x"}, "?", "?\\v", { noremap = true })

--------------------------------------------------------------------------------
-- Search in selected region
--------------------------------------------------------------------------------
vim.keymap.set("x", "g/", "<Esc>/\\%V\\v", { noremap = true })
vim.keymap.set("x", "g?", "<Esc>?\\%V\\v", { noremap = true })

-- vim.keymap.set({ "n", "x" }, "*", "*N", { noremap = true })
-- vim.keymap.set({ "n", "x" }, "#", "#N", { noremap = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
-- vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
-- vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Copy/paste with system clipboard
vim.keymap.set({"n", "x"}, "gy", '"+y', { noremap = true, desc = "Copy to system clipboard" })
vim.keymap.set("n", "gp", '"+p', { noremap = true, desc = "Paste from system clipboard" })
-- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
vim.keymap.set("x", "gp", '"+P', { noremap = true, desc = "Paste from system clipboard" })

-- Reselect latest changed, put, or yanked text
vim.keymap.set('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, replace_keycodes = false, desc = 'Visually select changed text' })

vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
