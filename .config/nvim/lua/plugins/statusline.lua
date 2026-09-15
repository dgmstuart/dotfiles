return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Everything below resolves its colours when it is called, not when this
      -- file is read. lualine re-runs setup() on ColorScheme and on
      -- OptionSet background, so a toggle only restyles the statusline if the
      -- theme and the section colours are rebuilt from the palette in force at
      -- that moment.
      local function palette()
        return require("solarized.utils").get_colors()
      end

      local function theme()
        -- lualine's "auto" theme is worked out when its module first loads and
        -- then kept in package.loaded, so a second require hands back the
        -- startup background's colours. Dropping the cached copy forces the
        -- module body to run again against the current background.
        package.loaded["lualine.themes.auto"] = nil
        local colours = palette()
        -- The loaded theme is a shared table, so copy before overriding it.
        local auto = vim.deepcopy(require("lualine.themes.auto"))
        auto.insert.a.bg = colours.yellow
        auto.visual.a.bg = colours.green
        auto.inactive = { c = { bg = colours.base00, fg = colours.base03 } }
        return auto
      end

      local function readonly_colour()
        if vim.bo.readonly then
          local colours = palette()
          return { bg = colours.red, fg = colours.base3 }
        end
      end

      require("lualine").setup({
        options = {
          theme = theme,
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                if vim.bo.readonly then return "READONLY" end
                return str
              end,
              color = readonly_colour,
            },
          },
          lualine_b = { { "branch", cond = function() return vim.bo.buftype ~= "help" end } },
          lualine_c = {
            {
              "filename",
              path = 1,
              file_status = false,
              fmt = function(str)
                if vim.bo.buftype == "help" then return vim.fn.expand("%:t") end
                return str
              end,
            },
            {
              function() return vim.bo.modified and "[+]" or "" end,
              color = function() return { fg = palette().red } end,
            },
            "diagnostics",
          },
          lualine_x = { "location" },
          lualine_y = { "filetype" },
          lualine_z = {
            {
              function()
                if vim.env.TMUX then return " " end
                return os.date("%e %b %H:%M")
              end,
              color = readonly_colour,
            }
          },
        },
      })
    end,
  },
}
