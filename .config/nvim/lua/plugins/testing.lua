return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-rspec",
    },
    ft = "ruby",
    keys = {
      { "<Leader>s", function() require("neotest").run.run() end, desc = "Run nearest spec" },
      { "<Leader>r", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run spec file" },
      { "<Leader>a", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run all specs" },
      { "<Leader>l", function() require("neotest").run.run_last() end, desc = "Run last spec" },
      { "<Leader>;", function() require("neotest").output.open({ enter = true }) end, desc = "Open spec output" },
      { "<Leader>O", function() require("neotest").output.open(
        { enter = true, open_win = function() vim.cmd("tabnew") end, }
      ) end, desc = "Open spec output in a new tab" },
      { "<Leader>v", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
    },
    config = function()
      require("neotest").setup({
        floating = {
          -- configure the floating window which shows test output inline:
          border = "rounded",
          max_width = 0.9,
        },
        consumers = {
          -- Remembers whether the most recent run passed, for the statusline.
          -- Failures need no help: they already show as diagnostics.
          last_run = function(client)
            local passed = false

            client.listeners.run = function()
              passed = false
            end

            client.listeners.results = function(_, results, partial)
              if partial then return end

              for _, result in pairs(results) do
                if result.status == "failed" then
                  passed = false
                  return
                end
              end
              passed = true
            end

            return {
              passed = function() return passed end,
            }
          end,
        },
        adapters = {
          require("neotest-rspec")({
            rspec_cmd = function()
              if vim.uv.fs_stat("bin/rspec") then
                return { "bin/rspec" }
              else
                return { "bundle", "exec", "rspec" }
              end
            end,
          }),
        },
      })
    end,
  },
}
