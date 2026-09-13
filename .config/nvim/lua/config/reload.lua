vim.keymap.set("n", "<Leader><Leader>r", function()
  for name in pairs(package.loaded) do
    if name ~= "config.lazy" and (name:match("^config") or name:match("^plugins")) then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
end, { desc = "Reload config" })
