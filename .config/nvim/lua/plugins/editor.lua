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
      }
      require('nvim-treesitter').install(languages)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = languages,
        callback = function() vim.treesitter.start() end,
      })

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
    opts = {}
  },
  { -- Open markdown files in the browser
    "suan/vim-instant-markdown", ft = "markdown"
  },
  { -- HTML completion
    "mattn/emmet-vim",
    ft = { "html", "css", "eruby", "javascript", "javascriptreact", "typescriptreact" }
  },
  { "echasnovski/mini.splitjoin", opts = {} },
  "tpope/vim-surround",
}
