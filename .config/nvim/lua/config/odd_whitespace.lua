-- Flag whitespace and typographic characters that render as an ordinary space
-- or as nothing at all, so they can't be spotted by eye. They arrive by
-- pasting from a browser, a word processor or a PDF, and then quietly break
-- string comparisons, greps and diffs.
--
-- Neovim already marks the zero-width characters (U+200B, U+200E, U+2060,
-- U+FEFF) as <200b> and friends via its own unprintable table, so those are
-- left out here.

local odd_chars = {
  "\\u00a0",         -- no-break space
  "\\u00ad",         -- soft hyphen
  "\\u1680",         -- ogham space mark
  "\\u180e",         -- mongolian vowel separator
  "\\u2000-\\u200a", -- fixed-width typesetting spaces (en quad … hair space)
  "\\u2028",         -- line separator
  "\\u2029",         -- paragraph separator
  "\\u202f",         -- narrow no-break space
  "\\u205f",         -- medium mathematical space
  "\\u3000",         -- ideographic space
}

local pattern = "[" .. table.concat(odd_chars) .. "]"

-- The group has to set a *background*. These characters draw nothing, so a
-- foreground colour alone would leave the cell just as blank as before.
-- Taking the red from DiagnosticError and the text colour from Normal's
-- background keeps it in step with the colorscheme.
local function set_highlight()
  local red = vim.api.nvim_get_hl(0, { name = "DiagnosticError", link = false }).fg
  local page = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg

  if red == nil then
    red = "#dc322f"
  end

  vim.api.nvim_set_hl(0, "OddWhitespace", { bg = red, fg = page })
end

set_highlight()

-- Loading a colorscheme clears every highlight group, including this one.
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_highlight,
})

-- A match belongs to a single window, so every new window needs its own. The
-- guard stops duplicates stacking up each time a buffer is displayed.
local function add_match()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "OddWhitespace" then
      return
    end
  end

  vim.fn.matchadd("OddWhitespace", pattern, 20)
end

vim.api.nvim_create_autocmd({ "VimEnter", "WinNew", "BufWinEnter" }, {
  callback = add_match,
})
