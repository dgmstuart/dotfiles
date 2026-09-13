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
      { "[n", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Jump to previous failed test" },
      { "]n", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Jump to next failed test" },
    },
    config = function()
      require("neotest").setup({
        floating = {
          border = "rounded",
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
