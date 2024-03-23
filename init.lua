VIM_CONFIG_PATH = vim.fn.stdpath("config")
VIM_DATA_PATH = vim.fn.stdpath("data")

if vim.g.neovide then
    require("basic.neovide")
end
require("basic.option")
require("basic.keymap")
require("basic.autocmd")
require("basic.plugin")

vim.cmd.colorscheme("gruvbox-material")
