-- When editing a file, always jump to the last known cursor position.
-- Nested FileType/once (rather than hooking BufReadPost directly) and the
-- diff-mode check both come from Neovim's own documented version of this
-- pattern (:help restore-cursor) - more robust than the classic BufReadPost
-- snippet, which can misbehave around not-yet-computed folds.
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function(args)
    vim.api.nvim_create_autocmd("FileType", {
      buffer = args.buf,
      once = true,
      callback = function()
        local line = vim.fn.line([['"]])
        if line >= 1 and line <= vim.fn.line("$")
          and not vim.bo.filetype:match("commit")
          and not vim.tbl_contains({ "xxd", "gitrebase" }, vim.bo.filetype)
          and not vim.wo.diff then
          vim.cmd([[normal! g`"]])
        end
      end,
    })
  end,
})
