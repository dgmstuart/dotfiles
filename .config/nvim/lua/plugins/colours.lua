return {
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      on_highlights = function(colors, _color)
        -- override the default palette to match my preferences
        return {
          ['@function.macro'] = { fg = colors.orange },
          ['@keyword.directive'] = { fg = colors.violet },
          ['@string.delimiter'] = { fg = colors.red },

          -- Ruby-specific:
          ['@variable.ruby'] = { fg = colors.base0 },
          ['@variable.parameter.ruby'] = { fg = colors.base0 },
          ['@function.call.ruby'] = { fg = colors.base0 },
          ['@type.ruby'] = { fg = colors.yellow },
          ['@variable.builtin.ruby'] = { fg = colors.cyan },
          ['@punctuation.special.ruby'] = { fg = colors.red },
          ['@string.special.symbol.ruby'] = { fg = colors.cyan },

          MatchParen = { fg = colors.red, bg = colors.base01, bold = true },

          -- Diagnostics (eg. lint errors)
          DiagnosticVirtualTextError = { fg = colors.base01, italic = true },
          DiagnosticVirtualTextWarn = { fg = colors.base01, italic = true },
          DiagnosticVirtualTextInfo = { fg = colors.base01, italic = true },
          DiagnosticVirtualTextHint = { fg = colors.base01, italic = true },
        }
      end,
    },
    config = function(_, opts)
      vim.o.termguicolors = true
      require('solarized').setup(opts)
      vim.cmd.colorscheme 'solarized'
    end,
  },
  { -- Highlight colors in CSS
    "brenoprata10/nvim-highlight-colors",
    opts = {},
  },
}
