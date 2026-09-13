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
