-- PREVENT ACCIDENTAL COMMANDS
-- ===========================
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})


-- EDITOR BEHAVIOUR
-- ================
-- Close the current buffer without closing the split
vim.api.nvim_create_user_command('Bd', 'bp|bd #', {})

-- CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
-- so that you can undo CTRL-U after inserting a line break.
vim.keymap.set('i', '<C-U>', '<C-G>u<C-U>')

vim.keymap.set('', '<BS>', '<Nop>', { desc = "Disable backspace in normal mode - it's a bad habit" })


-- SEARCH
-- ======
vim.keymap.set('n', '<Leader>f', function() require('fzf-lua').builtin() end,
  { desc = "General search" })

vim.keymap.set('n', '<Leader>t', function() require('fzf-lua').files() end,
  { desc = "Fuzzy find files" })

vim.keymap.set('n', '<Leader>b', function() require('fzf-lua').buffers() end,
  { desc = "Fuzzy find open buffers" })

local function live_grep() require('fzf-lua').live_grep() end
vim.keymap.set('n', '<Leader>/', live_grep,
  { desc = "grep (ANSI or GB keyboard)" })

vim.keymap.set('n', '<Leader>-', live_grep,
  { desc = "grep (Swedish keyboard)" })

vim.keymap.set('n', '<Leader>m', function() require('fzf-lua').grep_cword() end,
  { desc = "Search for word under cursor" })

vim.keymap.set('n', '<Leader>h', function() require('fzf-lua').helptags() end,
  { desc = "Search help text" })

vim.keymap.set('', '-', '/<left><left><left>',
  { desc = "Swedish keyboard mapping for search within a file" })

vim.keymap.set('', '\\', ':nohlsearch<CR>', { silent = true, desc = "clear search highlighting" })


-- MISC
-- ====
vim.keymap.set("n", "<Leader>1", function() vim.o.relativenumber = not vim.o.relativenumber end,
  { desc = "Toggle relativenumber" })

vim.keymap.set("n", "<Leader>d", function()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, { desc = "Toggle background" })

vim.keymap.set("n", "y<C-g>", function()
  local path = vim.fn.expand("%:.")
  -- setreg doesn't honour 'clipboard', so set the plus register explicitly,
  -- with the unnamed one as a fallback when there's no clipboard provider.
  vim.fn.setreg("+", path)
  vim.fn.setreg('"', path)
  vim.notify("Yanked " .. path)
end, { desc = "Yank relative file path" })


-- DIAGNOSTICS
-- ===========
vim.keymap.set('n', '<Leader>x', function()
  vim.diagnostic.setloclist({ open = false })
  vim.cmd('lopen 8')
  vim.wo.wrap = false
end, { desc = "Diagnostics: open location list" })

-- Neotest marks a failing spec with a diagnostic, so when we land on one of
-- those, also show the spec's output. Other diagnostics just move the cursor.
--
-- Neotest's output float closes itself when the cursor next moves, but Neovim
-- only acts on that once this function has finished running. Opening the new
-- float here would therefore find the previous one still on screen, and
-- neotest would jump back to that instead of showing the spec we landed on.
-- vim.schedule queues the open to happen after this function ends, by which
-- point the old float has gone.
local function jump_to_diagnostic(count)
  return function()
    local diagnostic = vim.diagnostic.jump({ count = count })
    if not diagnostic then
      return
    end

    if diagnostic.namespace == vim.api.nvim_create_namespace('neotest') then
      vim.schedule(function()
        require('neotest').output.open({ short = true, enter = false, quiet = true })
      end)
    end
  end
end

-- Cycle through diagnostics:
vim.keymap.set('n', '<C-j>', jump_to_diagnostic(1), { desc = "Next diagnostic" })
vim.keymap.set('n', '<C-k>', jump_to_diagnostic(-1), { desc = "Previous diagnostic" })


-- GIT
-- ===
vim.keymap.set('n', 'gs', ':Git<CR>', { desc = "Git status" })
vim.keymap.set('n', 'gb', ':Git blame<CR>', { desc = "Git blame" })


-- QUICKFIX
-- ========
vim.keymap.set('', '<Leader>q', ':cclose<CR>', { desc = "close the quickfix window" })
vim.keymap.set('', '<Leader>o', ':cope<CR>', { desc = "open the quickfix window fullscreen" })
vim.keymap.set('', '<Leader>oo', ':cope<CR>:only<CR>', { desc = "open the quickfix window fullscreen" })

-- Filled by fzf-lua (ctrl-q sends results to the quickfix list) and by neotest,
-- which adds every failing example across a full run.
vim.keymap.set('n', '<C-S-n>', ':cprevious<CR>', { desc = "Previous quickfix entry" })
vim.keymap.set('n', '<C-n>', ':cnext<CR>', { desc = "Next quickfix entry" })


-- EDITING
-- =======
local function paste_and_reindent(paste_cmd)
  return function()
    local view = vim.fn.winsaveview()
    vim.cmd("normal! " .. paste_cmd)
    vim.cmd("normal! =`]")
    vim.fn.winrestview(view) -- restore the cursor to where it was before the paste
  end
end

vim.keymap.set('n', 'p', paste_and_reindent("p"), { desc = "Paste and re-indent" })
vim.keymap.set('n', 'P', paste_and_reindent("P"), { desc = "Paste before and re-indent" })

vim.api.nvim_create_user_command('Savs', function(opts)
  vim.cmd('w ' .. opts.args)
  vim.cmd('leftabove vsplit ' .. opts.args)
end, { nargs = 1, desc = "'save as' and open in new split (in place of the current one, but keep the current one open)" })

