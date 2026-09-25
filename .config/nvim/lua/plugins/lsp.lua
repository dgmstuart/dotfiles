-- ruby-lsp only loads add-ons it can find in the project's bundle - or on
-- Ruby's load path. ruby-lsp-rspec is editor tooling, so it can't go in a
-- project's Gemfile; instead the copy installed alongside ruby-lsp (via
-- .default-gems) is put on the load path by passing `-I` in RUBYOPT.
--
-- One ruby invocation, run from the project root so that the version manager
-- picks the same Ruby that ruby-lsp itself will run on. Both gems are looked
-- up together because the answer is only meaningful for that one Ruby.
-- Returns nil for a gem that Ruby doesn't have.
local function gem_paths(root_dir)
  local script = [[
    def gem_path(name)
      Gem::Specification.find_by_name(name).full_gem_path
    rescue Gem::MissingSpecError
      ""
    end

    puts [gem_path("ruby-lsp"), gem_path("ruby-lsp-rspec")]
  ]]

  local result = vim.system(
    { "ruby", "-e", script },
    { cwd = root_dir, text = true }
  ):wait()

  if result.code ~= 0 then
    return nil, nil
  end

  local lines = vim.split(result.stdout, "\n")

  local function found(path)
    if path == nil or path == "" then
      return nil
    end
    return path
  end

  return found(lines[1]), found(lines[2])
end

-- Whether the project's bundle includes RSpec.
local function uses_rspec(root_dir)
  local lockfile = io.open(root_dir .. "/Gemfile.lock", "r")
  if not lockfile then
    return false
  end

  local contents = lockfile:read("*a")
  lockfile:close()

  return contents:find("\n    rspec%-core ") ~= nil
end

-- Same as nvim-lspconfig's default `cmd`, plus RUBYOPT (which its default
-- has no way to pass: it ignores `cmd_env`).
--
-- The missing-gem case is caught here rather than left to the server: since
-- ruby-lsp is installed per Ruby version, a project on a Ruby that hasn't got
-- it would otherwise just exit non-zero, and the only symptom would be that
-- nothing completes. Raising here means Neovim reports this message instead
-- of its own generic "quit with exit code" one - the server never starts, so
-- only one error is shown.
local function start_ruby_lsp(dispatchers, config)
  local root_dir = config.cmd_cwd or config.root_dir
  local spawn_params = { cwd = root_dir }

  local ruby_lsp, rspec_addon = gem_paths(root_dir)

  if not ruby_lsp then
    error(
      "ruby-lsp is not installed for this project's Ruby.\n"
        .. "Fix: `gem install ruby-lsp` with that Ruby active, then `asdf reshim ruby`.\n"
        .. "(Rubies installed from now on get it from ~/.default-gems.)",
      0
    )
  end

  -- A missing add-on doesn't stop the server, but ruby-lsp misbehaves without
  -- it in an RSpec project (e.g. no RuboCop diagnostics), so say so rather
  -- than failing quietly. Projects that don't use RSpec don't need it.
  if rspec_addon then
    local rubyopt = vim.env.RUBYOPT or ""
    spawn_params.env = { RUBYOPT = vim.trim(rubyopt .. " -I" .. rspec_addon .. "/lib") }
  elseif uses_rspec(root_dir) then
    vim.notify(
      "ruby-lsp-rspec is not installed for this project's Ruby.\n"
        .. "Fix: `gem install ruby-lsp-rspec` with that Ruby active, then `:lsp restart ruby_lsp`.\n"
        .. "(Rubies installed from now on get it from ~/.default-gems.)",
      vim.log.levels.WARN
    )
  end

  return vim.lsp.rpc.start({ "ruby-lsp" }, dispatchers, spawn_params)
end

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
        "eslint",
        "ts_ls",
        "tailwindcss",
        "yamlls",
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Send every edit to ruby_lsp immediately (Neovim debounces by 150ms
      -- by default). ruby_lsp parses a file when a request arrives but
      -- applies edits later on another thread, so an edit sent right before
      -- a completion request - which is what any debounce causes - gets
      -- answered from the text before the last keystroke: missing or wrong
      -- suggestions.
      vim.lsp.config("ruby_lsp", {
        flags = { debounce_text_changes = 0 },
        cmd = start_ruby_lsp,
      })
      -- ruby-lsp comes from .default-gems rather than Mason, so that it runs
      -- on the project's own Ruby, which means mason-lspconfig won't enable it
      vim.lsp.enable("ruby_lsp")

      -- prevent nagging about type annotations
      vim.lsp.config("basedpyright", { settings = { basedpyright = {
        analysis = { typeCheckingMode = "standard" }
      } } })

      -- Tailwind class completion inside plain Ruby (Phlex / ViewComponent
      -- `div(class: "...")`). Out of the box the server never sees .rb files
      -- at all: "ruby" isn't in its filetype list, it has to be told to treat
      -- ruby as HTML, and classRegex is what makes it look for classes in
      -- `class: "..."` instead of HTML class attributes. Without the regex
      -- there are no completions in a .rb file at all; with it, they appear
      -- only inside that string and nowhere else in the file.
      -- (ERB needs none of this - it's already covered by the defaults.)
      local tailwind_filetypes = vim.deepcopy(vim.lsp.config.tailwindcss.filetypes)
      if not vim.tbl_contains(tailwind_filetypes, "ruby") then
        table.insert(tailwind_filetypes, "ruby")
      end

      vim.lsp.config("tailwindcss", {
        filetypes = tailwind_filetypes,
        -- settings are merged, not replaced, so the defaults for eruby and
        -- classAttributes survive this.
        settings = {
          tailwindCSS = {
            includeLanguages = { ruby = "html" },
            experimental = { classRegex = { [[class:\s*"([^"]*)"]] } },
          },
        },
      })

      -- Run eslint --fix on save.
      -- Only attaches in a project that has an eslint config
      local eslint_on_attach = vim.lsp.config.eslint.on_attach
      vim.lsp.config("eslint", {
        on_attach = function(client, bufnr)
          eslint_on_attach(client, bufnr)

          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "LspEslintFixAll",
          })
        end,
      })

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
    -- Go to definition from a CSS class in a template to where it's
    -- defined in a stylesheet (including nested SCSS like `&__title`)
    "Dani-rev-96/css-classes",
    -- `npm ci` rather than `npm install`: install never touches the
    -- committed lockfile, so the plugin's checkout stays clean for Lazy updates
    build = "npm ci && npm run build",
    config = function()
      -- The server picks a parser by file extension, not filetype, so ERB
      -- templates need mapping onto its HTML parser explicitly.
      vim.lsp.config("css_classes", {
        filetypes = { "eruby", "html", "css", "scss" },
        -- Only used for jumping around: its one diagnostic ("class not
        -- defined in any indexed stylesheet") flags every Tailwind utility,
        -- and it has no setting to turn that off.
        handlers = {
          ["textDocument/publishDiagnostics"] = function() end,
        },
        settings = {
          cssClasses = {
            extensions = { html = { ".html", ".htm", ".erb" } },
            -- jump to the full class wherever the cursor is in `card__title`
            bemDefinitionParts = false,
          },
        },
      })
      vim.lsp.enable("css_classes")
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

      completion = {
        menu = { border = 'single', max_height = 25 },
        -- Show the documentation popup automatically alongside the completion
        -- menu. <C-space> still toggles it manually.
        documentation = {
          auto_show = true,
          window = { border = 'single' },
          -- ruby-lsp's docs contain leftover RDoc HTML and blank-looking
          -- code fence lines
          draw = function(draw_opts)
            if draw_opts.item.client_name == 'ruby_lsp' then
              require('config.ruby_lsp_docs').draw(draw_opts)
              return
            end
            draw_opts.default_implementation()
          end,
        },
      },

      -- Use LuaSnip to expand and navigate snippets (instead of Neovim's
      -- native vim.snippet), for its more faithful re-indenting of
      -- multi-line snippet bodies and support for dynamic snippet content.
      --
      -- blink.cmp penalises snippets by -4 out of the box (two separate
      -- score offsets which stack), which is enough for an exact trigger
      -- match like "def" to lose a ranking tie against an equally-exact LSP
      -- keyword or method. score_offset puts snippets a decisive tier above
      -- LSP results instead - deliberately a large gap rather than a
      -- marginal nudge, so the outcome doesn't depend on tie-breaking.
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
