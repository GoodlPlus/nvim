VIM_CONFIG_PATH = vim.fn.stdpath("config")
VIM_DATA_PATH = vim.fn.stdpath("data")

require("basic.option")
require("basic.keymap")
require("basic.autocmd")
require("basic.plugin")

vim.cmd.colorscheme("gruvbox-material")
