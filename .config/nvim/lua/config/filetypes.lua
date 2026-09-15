-- Filetype detection for files Neovim doesn't recognise by name
vim.filetype.add({
  filename = {
    ["Brewfile"] = "ruby",
    ["requirements-dev.txt"] = "requirements",
    [".php_cs.dist"] = "php",
  },
})

-- vim-rails sets `eruby.yaml` on everything matching */config/*.yml, which
-- sweeps up config/locales/ even though translations are plain YAML, not ERB.
-- That filetype costs real tooling: yamlls' filetypes are `yaml` and friends,
-- so it never attaches, and neither does treesitter (`eruby.yaml` maps to the
-- `embedded_template` parser). Claim the locale files back.
--
-- Deliberately not done for the rest of config/: database.yml and friends do
-- carry ERB control flow, which is a genuine YAML syntax error and would be
-- reported as one on every `<% ... %>` line.
--
-- This hooks FileType rather than BufReadPost so it reacts to whatever set
-- the filetype, instead of racing vim-rails' own autocmd registration.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "eruby.yaml",
  callback = function(args)
    if vim.api.nvim_buf_get_name(args.buf):match("/config/locales/") then
      vim.bo[args.buf].filetype = "yaml"
    end
  end,
})

-- Ruby
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    -- encourage 80 columns
    vim.opt_local.colorcolumn = "81,101,125"
  end,
})

-- PHP
vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    -- encourage 85 columns
    vim.opt_local.colorcolumn = "86"
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Prose: spellcheck, and wrap at 78 characters
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "help", "yaml", "markdown", "liquid" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 78
  end,
})

-- Commit messages. Neovim's bundled gitcommit ftplugin already sets
-- textwidth=72, which the global colorcolumn=+1 turns into a 73rd-column
-- marker, so only the spellchecking is left to add here.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function(args)
    vim.opt_local.spell = true
    -- No autocomplete popups while writing a commit message: blink.cmp
    -- checks this buffer variable
    vim.b[args.buf].completion = false
  end,
})

-- Start typing straight away in commit messages
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.cmd("normal! gg")
    vim.cmd("startinsert!")
  end,
})

-- Align a closing paren with the opening line, instead of with the last line
vim.g.python_indent = {
  closed_paren_align_last_line = false,
  open_paren = "shiftwidth()", -- defaults to shiftwidth() * 2
}
