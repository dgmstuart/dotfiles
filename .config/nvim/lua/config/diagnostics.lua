vim.diagnostic.config({
  virtual_text = true,
})

-- Keep the location list's contents current if it's already open, without
-- popping it open or closed on its own (setloclist is per-window, but this
-- event is per-buffer, so only refresh when it's the buffer you're looking at).
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  callback = function(args)
    if args.buf == vim.api.nvim_get_current_buf() then
      vim.diagnostic.setloclist({ open = false })
    end
  end,
})
