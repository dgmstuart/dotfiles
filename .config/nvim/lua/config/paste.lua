-- Neovim handles bracketed paste itself, and in normal mode it puts the text
-- *after* the cursor. With a block cursor that's ambiguous, and it bypasses the
-- reindenting `p`/`P` maps in config.keymaps. Refuse it instead:
-- `clipboard=unnamedplus` means `p` already pastes the system clipboard, with
-- reindenting.
local default_paste = vim.paste

vim.paste = function(lines, phase)
  local is_normal_mode = vim.fn.getcmdtype() == "" and vim.api.nvim_get_mode().mode:find("^n")

  if is_normal_mode then
    if phase <= 1 then -- only warn once per paste, not once per streamed chunk
      vim.notify("Paste ignored in normal mode — use i/a, or p", vim.log.levels.WARN)
    end
    return true -- true = "consumed", so the client doesn't cancel/retry
  end

  return default_paste(lines, phase)
end
