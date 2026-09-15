-- Splitting a one-line construct across several lines, and joining it back:
-- `gS` splits, `gJ` joins. (`gJ` shadows the built-in join-without-spaces,
-- which `J` and `:join!` both still cover.)
--
-- Three tools, tried in order, most informed first, because none of them
-- covers everything:
--
-- 1. treesj reads the syntax tree, so it knows what it is looking at. That
--    buys what a bracket matcher cannot: `{ |x| ... }` becomes `do |x| ... end`,
--    hash braces keep their inner padding when rejoined, and a `def` with
--    keyword arguments splits as a parameter list rather than as a hash.
-- 2. config.parenless_splitjoin covers the Ruby calls written without
--    parentheses, which treesj mishandles and is told to leave alone.
-- 3. mini.splitjoin only matches brackets, which is exactly what is wanted
--    where there is no parser or no preset for the language - ERB being the
--    one that comes up daily, since `.html.erb` parses as embedded_template.
--
-- Each leaves the buffer alone when it has nothing to say, so "did anything
-- change?" is what decides whether to try the next one.

local function first_of(actions)
  local before = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for _, action in ipairs(actions) do
    pcall(action)
    if not vim.deep_equal(before, vim.api.nvim_buf_get_lines(0, 0, -1, false)) then
      return
    end
  end
end

local function split()
  first_of({
    function() require("treesj").split() end,
    function() require("config.parenless_splitjoin").split() end,
    function() require("mini.splitjoin").split() end,
  })
end

local function join()
  first_of({
    function() require("treesj").join() end,
    function() require("config.parenless_splitjoin").join() end,
    function() require("mini.splitjoin").join() end,
  })
end

return {
  {
    "Wansmer/treesj",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "echasnovski/mini.splitjoin",
        -- Its own `gS` toggle would shadow the chain above, which is the only
        -- thing that reaches the other two.
        opts = { mappings = { toggle = "" } },
      },
    },
    keys = {
      { "gS", split, desc = "Split the construct under the cursor" },
      { "gJ", join, desc = "Join the construct under the cursor" },
    },
    config = function()
      local presets = require("treesj.langs.utils")
      local parenless = require("config.parenless_splitjoin")

      require("treesj").setup({
        -- `gS`/`gJ` are bound above, to the chain.
        use_default_keymaps = false,
        -- Handing over to the next tool is the normal path here, not an error
        -- worth reporting: every ERB split starts with treesj finding no
        -- parser it recognises.
        notify = false,
        -- The default 120 refuses to join anything that would come out longer
        -- than that, which is a surprise when the whole point of the keystroke
        -- is to see the joined form.
        max_join_length = 1000,
        langs = {
          ruby = {
            array = presets.set_preset_for_list({
              -- RuboCop's defaults: no trailing comma, and no padding inside
              -- `[ ]` (unlike `{ }`, which keeps it).
              split = { last_separator = false },
              join = { space_in_brackets = false },
            }),
            hash = presets.set_preset_for_list({
              split = { last_separator = false },
            }),
            argument_list = presets.set_preset_for_args({
              -- Without a closing bracket treesj treats the last argument as
              -- one, dropping the separator before it and leaving it
              -- unindented. Parenthesis-less calls go to step 2 instead.
              both = { enable = parenless.has_parens },
            }),
          },
        },
      })
    end,
  },
}
