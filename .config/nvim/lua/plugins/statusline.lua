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

      local function specs_running()
        -- neotest loads lazily; don't load it just to draw the statusline:
        local neotest = package.loaded["neotest"]
        if not neotest then return false end

        for _, adapter_id in ipairs(neotest.state.adapter_ids()) do
          local counts = neotest.state.status_counts(adapter_id)
          if counts and counts.running > 0 then
            return true
          end
        end
        return false
      end

      local function last_spec_run_passed()
        local neotest = package.loaded["neotest"]
        if not neotest then return false end

        return neotest.last_run.passed()
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
            {
              function() return "󰗠" end, -- md-check_circle
              cond = last_spec_run_passed,
              color = function() return { fg = palette().green } end,
            },
            {
              function() return "running specs" end,
              cond = specs_running,
              color = function() return { fg = palette().yellow } end,
            },
          },
          lualine_x = {
            { -- pending plugin updates (lazy.nvim's checker doesn't notify)
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
            },
            "location",
          },
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
