return {
  { -- Code Parsing
    'nvim-treesitter/nvim-treesitter',
    lazy = false, -- Treesitter doesn't support lazy loading
    build = ':TSUpdate', -- Update all parsers to latest versions when updating treesitter
    config = function()
      local languages = {
        'ruby',
        'javascript',
        'typescript',
        'tsx',
        'json',
        'yaml',
        'css',
        'embedded_template',
      }
      -- Parsers install asynchronously (below), so one can still be missing
      -- the first time a filetype is opened after being added to the list
      -- above. Letting `start` throw here aborts whatever triggered the
      -- FileType event: an fzf-lua buffer switch, for one, which fails with
      -- "Unable to add buffer" and simply doesn't open the file.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = languages,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- Installs run on every startup and skip what's already present, so a
      -- language added to the list above installs itself on each machine with
      -- no manual step. Starting treesitter on the buffers that were opened
      -- while the install was still running is the missing half of that -
      -- without it the first file you open after adding a language stays
      -- un-highlighted until you restart.
      -- `install` reports failure by *returning* false rather than erroring,
      -- so both have to be checked or a failed install is completely silent.
      require('nvim-treesitter').install(languages):await(vim.schedule_wrap(function(err, ok)
        if err or ok == false then
          vim.notify(
            "Treesitter parser install failed - see :TSLog: " .. tostring(err or ok),
            vim.log.levels.WARN
          )
          return
        end

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf)
            and vim.tbl_contains(languages, vim.bo[buf].filetype)
            and not vim.treesitter.highlighter.active[buf] then
            pcall(vim.treesitter.start, buf)
          end
        end
      end))

      -- Ruby's indent script (GetRubyIndent) uses synID() to detect
      -- context (e.g. inside a string/heredoc), which needs the legacy
      -- syntax engine running to return real data. Treesitter's own
      -- highlighter still takes priority visually, so this doesn't
      -- undo anything above - it just gives the indent script what it
      -- needs. https://github.com/nvim-treesitter/nvim-treesitter/issues/1501
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ruby",
        callback = function() vim.bo.syntax = "ruby" end,
      })
    end,
  },
  { -- Fuzzy Finder
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- `files` includes dotfiles out of the box, `grep` does not. Turn it on
      -- for grep, and exclude .git, which rg descends into once --hidden is set.
      -- `-e` must stay last: fzf-lua appends the search pattern directly after it.
      grep = {
        hidden = true,
        rg_opts = "--column --line-number --no-heading --color=always --smart-case "
          .. "--max-columns=4096 -g '!.git' -e",
      },
    },
  },
  { -- Open markdown files in the browser
    "suan/vim-instant-markdown", ft = "markdown"
  },
  { -- HTML completion
    "mattn/emmet-vim",
    ft = { "html", "css", "eruby", "javascript", "javascriptreact", "typescriptreact" }
  },
  "tpope/vim-surround",
}
