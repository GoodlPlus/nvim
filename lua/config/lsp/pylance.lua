return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "VeryLazy",
    ft = "python",
    opts = function(_, opts)
        local util = require("lspconfig.util")
        local configs = require("lspconfig.configs")
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
        configs.pylance = {
            default_config = {
                cmd = { VIM_DATA_PATH .. "/mason/bin/pylance", "--stdio" },
                filetypes = { "python" },
                root_dir = util.root_pattern(unpack({
                    'pyproject.toml',
                    'setup.py',
                    'setup.cfg',
                    'requirements.txt',
                    'Pipfile',
                    'pyrightconfig.json',
                    '.git',
                })),
                single_file_support = true,
                capabilities = capabilities,
                on_init = function(client)
                    if vim.env.VIRTUAL_ENV then
                        client.config.settings.python.pythonPath =
                        vim.fn.resolve(vim.env.VIRTUAL_ENV .. "/bin/python")
                    else
                        client.config.settings.python.pythonPath = vim.fn.exepath("python3")
                        or vim.fn.exepath("python")
                        or "python"
                    end
                end,
                before_init = function() end,
                on_new_config = function(new_config, new_root_dir)
                    new_config.settings.python.pythonPath = vim.fn.exepath("python")
                    or vim.fn.exepath("python3")
                    or "python"
                end,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            diagnosticMode = "openFilesOnly",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            indexing = true,
                            autoImportCompletions = false,
                            completeFunctionParens = false,
                            inlayHints = {
                                variableTypes = false,
                                functionReturnTypes = false,
                                callArgumentNames = false,
                                pytestParameters = false,
                            },
                        },
                    },
                },
            },
        }
        opts.pylance = {}
    end,
}
