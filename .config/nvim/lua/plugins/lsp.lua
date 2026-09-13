return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "ruby_lsp",
        "ts_ls",
        "tailwindcss",
        "yamlls",
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Disable LSP from having an opinion on syntax highlighting
      -- otherwise it overrides treesitter
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          client.server_capabilities.semanticTokensProvider = nil

          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = args.buf, desc = "Go to references" })
        end,
      })
    end,
  },
  {
    'saghen/blink.cmp', -- Autocomplete
    version = '1.*',

    opts = {
      -- accept autocompletion with Tab:
      keymap = { preset = 'super-tab' },

      appearance = {
        -- Adjusts spacing to ensure icons are aligned.
        -- Needs to match terminal font variant
        nerd_font_variant = 'normal'
      },

      -- Only show the documentation popup when manually triggered:
      completion = { documentation = { auto_show = false } },

      -- List of sources for entries in the autocomplete list
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } }
    },

    -- Allow the sources list to be extended by other files:
    opts_extend = { "sources.default" },

    config = function(_, opts)
      require("blink.cmp").setup(opts)

      -- Advertise blink's completion capabilities to every LSP server:
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
    end,
  }
}
