return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "basedpyright",
        "ruby_lsp",
        "ts_ls",
        "tailwindcss",
        "yamlls",
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- ruby_lsp can't always abort a diagnostics run already in flight
      -- (e.g. mid-RuboCop) when a new edit cancels it, so it sometimes
      -- sends the stale result anyway -> "NO_RESULT_CALLBACK_FOUND".
      -- Coalescing rapid edits (e.g. snippet expansion) into fewer
      -- didChange notifications means fewer overlapping requests to race.
      vim.lsp.config("ruby_lsp", { flags = { debounce_text_changes = 300 } })

      -- prevent nagging about type annotations
      vim.lsp.config("basedpyright", { settings = { basedpyright = {
        analysis = { typeCheckingMode = "standard" }
      } } })

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

    dependencies = {
      {
        'L3MON4D3/LuaSnip', -- Snippet engine: expands/navigates snippets, and
        -- lets snippets compute dynamic content (e.g. a class name derived
        -- from the current filename) with plain Lua instead of Vimscript.
        version = 'v2.*',
        config = function()
          -- Loads snippets/package.json + snippets/*.json (VS Code format).
          -- LuaSnip doesn't auto-discover these under the config dir the
          -- way blink.cmp's own built-in snippets source does, so the path
          -- has to be given explicitly.
          require('luasnip.loaders.from_vscode').lazy_load({
            paths = { vim.fn.stdpath('config') .. '/snippets' },
          })
          -- Loads luasnippets/*.lua (native LuaSnip snippets)
          require('luasnip.loaders.from_lua').lazy_load()
        end,
      },
    },

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

      -- Use LuaSnip to expand and navigate snippets (instead of Neovim's
      -- native vim.snippet), for its more faithful re-indenting of
      -- multi-line snippet bodies and support for dynamic snippet content.
      --
      -- score_offset gives snippets a decisive priority over LSP results,
      -- mirroring the old coc-snippets setup's "snippets.priority": 100
      -- vs. "suggest.languageSourcePriority": 90 - a clear tier gap, not
      -- a marginal nudge, so an exact trigger match (e.g. "def") reliably
      -- outranks an equally-exact LSP keyword/method match.
      snippets = { preset = 'luasnip', score_offset = 20 },

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
