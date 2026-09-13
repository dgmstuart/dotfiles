return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local colors = require("solarized.utils").get_colors()

      require("lualine").setup({
        options = {
          theme = (function()
            local theme = require("lualine.themes.auto")
            theme.insert.a.bg = colors.yellow
            theme.visual.a.bg = colors.green
            theme.inactive = { c = { bg = colors.base00, fg = colors.base03 } }
            return theme
          end)(),
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                if vim.bo.readonly then return "READONLY" end
                return str
              end,
              color = function()
                if vim.bo.readonly then
                  return { bg = colors.red, fg = colors.base3 }
                end
              end,
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
              color = { fg = colors.red },
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
              color = function()
                if vim.bo.readonly then
                  return { bg = colors.red, fg = colors.base3 }
                end
              end,
            }
          },
        },
      })
    end,
  },
}
