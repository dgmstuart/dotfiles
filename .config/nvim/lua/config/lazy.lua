local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Install lazy.nvim if it's not already installed:
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Add to path so that it can be required:
vim.opt.rtp:prepend(lazypath)

-- setup lazy.nvim:
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  -- periodically check for plugin updates. Shown in the statusline rather than
  -- notified: the notification comes back on every startup while an update
  -- is pending, as a prompt that has to be dismissed.
  checker = { enabled = true, notify = false },
})
