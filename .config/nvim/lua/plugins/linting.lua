return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      -- nvim-lint ships no linthtml definition, and linthtml has no
      -- machine-readable output to parse - it has no --format flag at all -
      -- so this reads its human-readable report:
      --
      --   4:16  warning  The attribute "class" is not double quoted  attr-quote-style
      --
      -- Lines without a line:column pair (the File:/Config file: headers, the
      -- summary, and config-level warnings reported as "-:-") don't match, and
      -- are ignored.
      local linthtml_pattern = "^%s*(%d+):(%d+)%s+(%w+)%s+(.-)%s%s+([%w%-]+)%s*$"

      require('lint').linters.linthtml = {
        -- linthtml is a project-local dev dependency, never installed
        -- globally, so use the binary the project itself provides. In a
        -- project that doesn't use linthtml there is no binary, and the
        -- executable check in try_lint's filter skips it - which is also what
        -- keeps linthtml out of projects that never asked for it.
        cmd = function()
          local root = vim.fs.root(0, "node_modules")
          if root then
            return root .. "/node_modules/.bin/linthtml"
          end

          return "linthtml"
        end,
        -- linthtml's --no-color flag is silently ignored (as are --no--color
        -- and --color=false); FORCE_COLOR is the only thing that stops it
        -- writing ANSI escapes into the report we have to parse.
        env = { FORCE_COLOR = "0" },
        -- It reads a file path rather than stdin, and exits non-zero whenever
        -- it reports a problem.
        stdin = false,
        ignore_exitcode = true,
        parser = require('lint.parser').from_pattern(
          linthtml_pattern,
          { "lnum", "col", "severity", "message", "code" },
          {
            error = vim.diagnostic.severity.ERROR,
            warning = vim.diagnostic.severity.WARN,
          }
        ),
      }

      -- Linting is mostly done by LSPs - these are the exceptions which aren't covered by LSPs:
      require('lint').linters_by_ft = {
        eruby = { "erb_lint" },
        html = { "linthtml" },
        python = { "pylint" },
      }

      -- Trigger linting on open and write:
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        callback = function()
          require("lint").try_lint(nil, {
            filter = function(linter)
              local cmd = linter.cmd
              if type(cmd) == "function" then
                cmd = cmd()
              end

              return vim.fn.executable(cmd) == 1 -- If the linter isn't installed, silence the warning
            end,
          })
        end,
      })
    end,
  },
}
