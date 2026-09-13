vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Register Neovim's own Syntax autocommands before lazy.nvim sources plugins.
-- vim-bundler hooks the Syntax event directly (no syntax/ file) to highlight
-- Gemfile.lock; if Neovim's `Syntax *` handler is registered after it, its
-- `syn clear` runs second and wipes the plugin's rules. Old .vimrc had
-- `syntax on` before plugins loaded for the same reason.
vim.cmd("syntax on")

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.diagnostics")
require("config.reload")
require("config.editing_commands")
require("config.restore_cursor")
require("config.rails")
require("config.spec_runner")
