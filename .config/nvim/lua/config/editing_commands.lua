-- Clear named registers a-z
local function reg_reset()
  print("Resetting named registers a-z...")
  for i = string.byte("a"), string.byte("z") do
    vim.fn.setreg(string.char(i), {})
  end
end
vim.api.nvim_create_user_command("RegReset", reg_reset, {})

-- Open tig showing the history of the current file
vim.api.nvim_create_user_command("Tighist", function()
  local file = vim.fn.expand("%")
  vim.cmd("tabnew")
  vim.cmd.terminal("tig " .. file)
  vim.cmd("startinsert")
  -- Close the tab automatically when tig exits
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = 0,
    once = true,
    callback = function()
      vim.cmd("bdelete!")
    end,
  })
end, {})

-- Ruby-only commands
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function(args)
    -- Auto-correct hashrocket syntax to key: value syntax via rubocop
    vim.api.nvim_buf_create_user_command(args.buf, "Norocket", function()
      vim.cmd("update")
      vim.cmd("!bin/rubocop -a --only Style/HashSyntax " .. vim.fn.expand("%"))
      vim.cmd("edit!")
    end, {})

    -- Replace `.try(:foo)` (Rails) with the safe navigation operator `&.foo` (Ruby)
    vim.api.nvim_buf_create_user_command(args.buf, "Thereisnotry", function()
      vim.cmd([[%s/.try(:\(\w\+\))/\&.\1/gc]])
    end, {})

    -- Take initialize arguments and create variable assignments, e.g.
    -- def initialize(foo:, bar:)
    -- creates lines:
    --     @foo = foo
    --     @bar = bar
    vim.api.nvim_buf_create_user_command(args.buf, "FillInitialize", function()
      local line = vim.fn.getline(".")
      local match = vim.fn.matchstr(line, [[(\zs.*\ze)]])
      local fn_args = vim.split((match:gsub("[: ]", "")), ",")

      local assignments = {}
      for _, arg in ipairs(fn_args) do
        if arg ~= "" then
          table.insert(assignments, "    @" .. arg .. " = " .. arg)
        end
      end

      vim.fn.append(vim.fn.line("."), assignments)
      vim.cmd("normal! =ip")
    end, {})
  end,
})
