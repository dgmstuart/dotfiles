vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Register Neovim's own Syntax autocommands before lazy.nvim sources plugins.
-- vim-bundler hooks the Syntax event directly (no syntax/ file) to highlight
-- Gemfile.lock; if Neovim's `Syntax *` handler is registered after it, its
-- `syn clear` runs second and wipes the plugin's rules.
vim.cmd("syntax on")

-- Before lazy.nvim, because after/queries/ruby/highlights.scm names the
-- predicates it registers, and a query with an unknown predicate is discarded.
require("config.treesitter_predicates")

require("config.lazy")
require("config.options")
require("config.filetypes")
require("config.odd_whitespace")
require("config.spellfile")
require("config.keymaps")
require("config.paste")
require("config.diagnostics")
require("config.reload")
require("config.editing_commands")
require("config.restore_cursor")
require("config.rails")
require("config.yaml_keys")
require("config.spec_runner")
