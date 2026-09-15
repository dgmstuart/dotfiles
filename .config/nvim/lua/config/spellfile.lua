-- Recompile the personal spell wordlist after editing it by hand.
--
-- `zg` and friends append the word to spell/en.utf-8.add and then rebuild the
-- binary en.utf-8.add.spl themselves, but Neovim never regenerates that file
-- on its own: if the .spl is missing or older than the .add, every word in the
-- wordlist is silently ignored. So editing the .add directly - including
-- running `:runtime spell/cleanadd.vim` to strip the comment lines `zw` leaves
-- behind - needs an explicit :mkspell!, which this does on save.
--
-- The one-argument form of :mkspell writes {name}.{enc}.add.spl next to its
-- input and reloads it if a buffer is using it. It's kept quiet because it
-- reports its progress in four messages, which would mean a hit-enter prompt
-- on every save; :silent still lets real errors through.
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*/spell/*.add",
  callback = function(args)
    vim.cmd.mkspell({ args = { args.file }, bang = true, mods = { silent = true } })
  end,
})
