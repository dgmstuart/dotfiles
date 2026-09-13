return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      require('lint').linters_by_ft = {
        eruby = { "erb_lint" },
        python = { "pylint" },
      }

      -- Trigger linting on open and write:
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        callback = function()
          require("lint").try_lint(nil, {
            filter = function(linter)
              return vim.fn.executable(linter.cmd) == 1 -- If the linter isn't installed, silence the warning
            end,
          })
        end,
      })
    end,
  },
}
