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
        javascript = { "trim_whitespace" },
        typescript = { "trim_whitespace" },
        json = { "trim_whitespace" },
        lua = { "trim_whitespace" },
        php = { "trim_whitespace" },
        python = { "trim_whitespace" },
        ruby = { "trim_whitespace" },
        ruby = { "trim_whitespace" },
        scss = { "trim_whitespace" },
        sh = { "trim_whitespace" },
        sql = { "trim_whitespace" },
        text = { "trim_whitespace" },
        toml = { "trim_whitespace" },
        vim = { "trim_whitespace" },
        yaml = { "trim_whitespace" },
      },
      -- Only the filetypes listed above have formatters configured, so this
      -- doesn't (yet) trigger fix-on-save for anything else. Your old config
      -- only enabled fix-on-save conditionally per project (filereadable
      -- checks) for other fixers like rubocop — revisit that conditional
      -- logic at M16 when those get added here.
      format_on_save = {},
    },
  },
}
