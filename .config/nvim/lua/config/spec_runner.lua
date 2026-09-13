-- RUN SPECS IN A GHOSTTY TAB
-- ==========================
-- Neovim's :! is documented as non-interactive ("Use :terminal instead"), so
-- the old .vimrc's RunSpecsInTerminal -- a plain :!bin/rspec -- can't be
-- reproduced directly. This is the old RunSpecsInWindow instead: build the
-- command here, hand it to the terminal to actually run. That used iTerm via
-- AppleScript; this uses Ghostty the same way.
--
-- Running outside Neovim also keeps long paths (eg. Capybara screenshots) on
-- a single line, so they stay cmd-clickable. Any terminal hosted inside
-- Neovim rewraps them at the window width, which breaks the path in two.

local function rspec_executable()
  if vim.uv.fs_stat("bin/rspec") then
    return "bin/rspec"
  else
    return "bundle exec rspec"
  end
end

-- Escape a value for embedding in an AppleScript string literal
local function escape(text)
  local escaped = text:gsub("\\", "\\\\")
  escaped = escaped:gsub('"', '\\"')
  return escaped
end

local function run_in_ghostty_tab(args)
  local command = rspec_executable() .. " " .. args
  -- AppleScript has no \n escape, so the trailing newline that submits the
  -- command is the `return` constant, concatenated on.
  local configuration = '{initial working directory:"'
    .. escape(vim.uv.cwd())
    .. '", initial input:"'
    .. escape(command)
    .. '" & return}'

  local script = table.concat({
    'tell application "Ghostty"',
    "  activate",
    "  new tab with configuration " .. configuration,
    "end tell",
  }, "\n")

  vim.system({ "osascript", "-e", script }, {}, function(result)
    if result.code == 0 then
      return
    end

    -- Ghostty opens the tab and runs the command correctly, then reports the
    -- event as unhandled (AppleScript error -1708). The work has already
    -- happened by then, so treat only this error as benign; anything else is
    -- worth seeing.
    if result.stderr:find("-1708", 1, true) then
      return
    end

    vim.schedule(function()
      vim.notify("Could not run specs in Ghostty: " .. result.stderr, vim.log.levels.ERROR)
    end)
  end)
end

vim.keymap.set("n", "<Leader>rr", function()
  run_in_ghostty_tab(vim.fn.expand("%"))
end, { desc = "Run spec file in a Ghostty tab" })

vim.keymap.set("n", "<Leader>ss", function()
  run_in_ghostty_tab(vim.fn.expand("%") .. ":" .. vim.fn.line("."))
end, { desc = "Run spec under the cursor in a Ghostty tab" })

vim.keymap.set("n", "<Leader>aa", function()
  run_in_ghostty_tab("spec")
end, { desc = "Run all specs in a Ghostty tab" })
