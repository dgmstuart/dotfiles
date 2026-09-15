return {
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      on_highlights = function(colors, _color)
        -- Solarized's greys swap roles between backgrounds, but the plugin's
        -- palette keeps the same names for both, so pick the "secondary
        -- content" grey (what Comment uses) based on the active background.
        local dim
        if vim.o.background == 'light' then
          dim = colors.base1
        else
          dim = colors.base01
        end

        -- override the default palette to match my preferences
        return {
          -- No bold in code. solarized.nvim bolds its keyword-ish groups,
          -- which reads as heavier rather than clearer. on_highlights merges
          -- over the plugin's own definition rather than replacing it, so
          -- each group only needs the attribute being dropped - the colours
          -- below are left as the plugin set them.
          --
          -- These are the code groups only. UI chrome (Search, CursorLineNr,
          -- lualine) and the deliberate bolds further down this file
          -- (MatchParen, the neotest markers) are left alone.
          Keyword = { bold = false },
          Define = { bold = false },
          Include = { bold = false },
          Macro = { bold = false },
          PreProc = { bold = false },
          ['@keyword'] = { bold = false },
          ['@keyword.function'] = { bold = false },
          ['@keyword.import'] = { bold = false },
          ['@keyword.type'] = { bold = false },
          ['@keyword.debug'] = { bold = false },
          ['@attribute'] = { bold = false },
          ['@punctuation.special'] = { bold = false },
          ['@type.builtin'] = { bold = false },
          ['@property.json'] = { bold = false },
          ['@property.yaml'] = { bold = false },
          ['@character.printf'] = { bold = false },
          ['@lsp.type.keyword'] = { bold = false },
          ['@lsp.typemod.keyword.documentation'] = { bold = false },

          ['@function.macro'] = { fg = colors.orange },
          ['@string.delimiter'] = { fg = colors.red },

          -- Ruby-specific:
          ['@variable.ruby'] = { fg = colors.base0 },
          ['@variable.parameter.ruby'] = { fg = colors.base0 },
          ['@function.call.ruby'] = { fg = colors.base0 },
          ['@type.ruby'] = { fg = colors.yellow },
          ['@constant.ruby'] = { fg = colors.yellow },
          ['@variable.builtin.ruby'] = { fg = colors.cyan },
          ['@string.special.symbol.ruby'] = { fg = colors.cyan },
          ['@boolean.ruby'] = { fg = colors.cyan },
          ['@keyword.import.ruby'] = { fg = colors.orange },
          ['@punctuation.special.ruby'] = { fg = colors.red },
          ['@keyword.directive.ruby'] = { fg = colors.red },

          -- Search matches: yellow, as in Vim, where solarized sets Search to
          -- a yellow foreground plus 'reverse' and IncSearch to orange.
          -- solarized.nvim instead uses a muted teal wash for Search and
          -- magenta for the current match.
          --
          -- Kept as fg + reverse rather than a literal background, so the text
          -- colour follows whatever Normal is and `,d` keeps working in both
          -- backgrounds. on_highlights merges, so the wash this replaces has
          -- to be cleared by name.
          Search = { fg = colors.yellow, bg = "NONE", reverse = true, bold = false },
          IncSearch = { fg = colors.orange, bg = "NONE", reverse = true },
          CurSearch = { fg = colors.orange, bg = "NONE", reverse = true },

          MatchParen = { fg = colors.red, bg = colors.base01, bold = true },

          BlinkCmpLabelMatch = { fg = colors.blue },

          -- Spellcheck. solarized.nvim renders a misspelling as struck-through
          -- underlined text in no colour at all, which reads as deleted text
          -- rather than as a spelling error. A coloured undercurl, leaving the
          -- word's own colour alone, is what every other Solarized port does.
          -- on_highlights merges over the plugin's own definition rather than
          -- replacing it, so the attributes to drop have to be named explicitly.
          SpellBad = {
            fg = "NONE",
            sp = colors.red,
            undercurl = true,
            underline = false,
            strikethrough = false,
          },
          SpellCap = { fg = "NONE", sp = colors.violet, undercurl = true },
          SpellRare = { fg = "NONE", sp = colors.cyan, undercurl = true },
          SpellLocal = { fg = "NONE", sp = colors.yellow, undercurl = true },

          -- Diagnostics (eg. lint errors)
          DiagnosticVirtualTextError = { fg = dim, italic = true },
          DiagnosticVirtualTextWarn = { fg = dim, italic = true },
          DiagnosticVirtualTextInfo = { fg = dim, italic = true },
          DiagnosticVirtualTextHint = { fg = dim, italic = true },

          QuickFixLine = { bg = colors.base02, fg = 'NONE' }, -- prevents removal of syntax highlighting

          -- neotest (summary window, sign column icons and virtual text).
          -- solarized.nvim has no neotest support, so without these neotest
          -- falls back to its own hardcoded neon palette.
          NeotestPassed = { fg = colors.green },
          NeotestFailed = { fg = colors.red },
          NeotestRunning = { fg = colors.yellow },
          NeotestSkipped = { fg = colors.cyan },
          NeotestNamespace = { fg = colors.violet },
          NeotestFile = { fg = colors.blue },
          NeotestDir = { fg = colors.blue },
          NeotestIndent = { fg = dim },
          NeotestExpandMarker = { fg = dim },
          NeotestAdapterName = { fg = colors.orange },
          NeotestWinSelect = { fg = colors.cyan, bold = true },
          NeotestMarked = { fg = colors.orange, bold = true },
          NeotestTarget = { fg = colors.red },
          NeotestWatching = { fg = colors.yellow },
        }
      end,
    },
    config = function(_, opts)
      vim.o.termguicolors = true

      -- Neovim asks the terminal for its background colour itself (OSC 11),
      -- but inside tmux that answer comes from a cache tmux only refreshes
      -- when a client attaches, so a Neovim started after a light/dark switch
      -- comes up in the old mode. Ask macOS directly instead. Setting
      -- 'background' during startup also switches off Neovim's own detection
      -- (it drops its OSC 11 handler at VimEnter if 'background' was set), so
      -- tmux's stale answer can't override this. <Leader>d still toggles by
      -- hand for instances that are already open.
      if vim.fn.has('mac') == 1 and vim.env.TMUX ~= nil then
        local appearance = vim.system({ 'defaults', 'read', '-g', 'AppleInterfaceStyle' }):wait()
        if appearance.code == 0 then
          vim.o.background = 'dark'
        else
          vim.o.background = 'light'
        end
      end

      require('solarized').setup(opts)

      -- solarized.nvim sets terminal_color_0..15 from a table that doesn't
      -- match the standard Solarized ANSI mapping (e.g. index 4 is magenta,
      -- not blue), so programs like tig look wrong in :terminal. Unset them so
      -- Neovim forwards colour indices to the outer terminal, which already
      -- has the correct Solarized palette. The plugin re-sets them whenever
      -- the colorscheme reloads (e.g. toggling 'background'), hence the autocmd.
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = 'solarized',
        callback = function()
          for i = 0, 15 do
            vim.g['terminal_color_' .. i] = nil
          end
        end,
      })

      vim.cmd.colorscheme 'solarized'
    end,
  },
  { -- Highlight colors in CSS
    "brenoprata10/nvim-highlight-colors",
    opts = {},
  },
}
