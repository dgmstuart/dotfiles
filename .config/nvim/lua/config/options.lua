vim.opt.cursorline = true          -- show the cursor line
vim.opt.colorcolumn = "+1"         -- highlight the column limit
vim.opt.number = true              -- show line numbers
vim.opt.relativenumber = true      -- show relative line numbers
vim.opt.scrolloff = 2              -- always show 2 lines of context at the top/bottom
vim.opt.showmatch = true           -- show matching brackets
vim.opt.matchtime = 2              -- matching brackets duration in tenths of a second (default: 5)
vim.opt.ignorecase = true          -- default to case-insensitive search
vim.opt.smartcase = true           -- ...but use case-sensitive search if the search term includes uppercase letters
vim.opt.splitright = true          -- open new split panes to the right
vim.opt.updatetime = 300           -- minimise latency (default is 4000)
vim.opt.modeline = false           -- modelines are a potential security hole
vim.opt.undofile = true            -- persistent undo: keep the undo history after closing a file
vim.opt.clipboard = "unnamedplus"  -- yank/delete/paste use the system clipboard by default (M19)

-- Soft tabs:
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Whitespace highlighting:
vim.opt.list = true
vim.opt.listchars = { trail = "·", tab = "¬·" }

-- Instead of backing up files, just reload the buffer when it changes.
-- The buffer is an in-memory representation of a file, it's what you edit
vim.opt.writebackup = false -- Don't backup the file while editing
vim.opt.swapfile = false -- Don't create swapfiles for new buffers
