return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        conf = { "trim_whitespace" },
        css = { "trim_whitespace" },
        eruby = { "trim_whitespace" },
        gitcommit = { "trim_whitespace" },
        html = { "trim_whitespace" },
        javascript = { "prettier", "trim_whitespace" },
        javascriptreact = { "prettier", "trim_whitespace" },
        typescript = { "prettier", "trim_whitespace" },
        typescriptreact = { "prettier", "trim_whitespace" },
        json = { "prettier", "trim_whitespace" },
        lua = { "trim_whitespace" },
        php = { "trim_whitespace" },
        python = { "trim_whitespace" },
        ruby = { "trim_whitespace" },
        scss = { "trim_whitespace" },
        sh = { "trim_whitespace" },
        sql = { "trim_whitespace" },
        text = { "trim_whitespace" },
        toml = { "trim_whitespace" },
        vim = { "trim_whitespace" },
        yaml = { "trim_whitespace" },
      },
      formatters = {
        -- Only run prettier where the project actually configures it. conform's
        -- bundled prettier already searches upward for .prettierrc and friends
        -- (or a "prettier" key in package.json) to pick its cwd; require_cwd
        -- turns "no config found" into "skip this formatter" rather than
        -- running prettier with its own defaults.
        prettier = { require_cwd = true },
      },
      -- Only the filetypes listed above have formatters configured, so this
      -- doesn't trigger fix-on-save for anything else.
      format_on_save = {},
    },
  },
}
