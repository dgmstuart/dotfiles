-- RUN SPECS IN A TMUX WINDOW
-- ==========================
-- Specs run in a tmux window rather than inside Neovim: build the command
-- here, hand it to tmux to actually run it.
--
-- Running them outside Neovim keeps long paths (eg. Capybara screenshots) on
-- a single line, so they stay cmd-clickable. Any terminal hosted inside
-- Neovim rewraps them at the window width, which breaks the path in two.
-- :! isn't an option either -- it's documented as non-interactive ("Use
-- :terminal instead").
--
-- A tmux window (rather than a popup or split) is full width, so tmux lets
-- the outer terminal do the wrapping, which keeps wrapped paths clickable.

local function rspec_executable()
  if vim.uv.fs_stat("bin/rspec") then
    return "bin/rspec"
  else
    return "bundle exec rspec"
  end
end

-- The ID of this session's "rspec" window, if there is one. Returns the ID
-- rather than targeting the window by name, because a name that matches more
-- than one window is an error in tmux.
local function existing_rspec_window()
  local result = vim.system(
    { "tmux", "list-windows", "-F", "#{window_id} #{window_name}" }
  ):wait()

  for line in result.stdout:gmatch("[^\n]+") do
    local id, name = line:match("^(%S+) (.*)$")
    if name == "rspec" then
      return id
    end
  end
end

local function run_in_tmux_window(args)
  if not vim.env.TMUX then
    vim.notify("Can't run specs: Neovim isn't running inside tmux", vim.log.levels.ERROR)
    return
  end

  local command = rspec_executable() .. " " .. args
  -- Type the command into the new window's shell rather than running it
  -- directly, so the window stays open afterwards and the command is in the
  -- shell history to re-run.
  --
  -- Reuse the "rspec" window if there already is one. If specs are still
  -- running there, the typed command just waits until they finish.
  local window = existing_rspec_window()
  local tmux_command
  if window then
    tmux_command = {
      "tmux",
      "select-window", "-t", window,
      ";", "send-keys", "-t", window, "-l", command,
      ";", "send-keys", "-t", window, "Enter",
    }
  else
    tmux_command = {
      "tmux",
      "new-window", "-n", "rspec", "-c", vim.uv.cwd(),
      ";", "send-keys", "-l", command,
      ";", "send-keys", "Enter",
    }
  end

  vim.system(tmux_command, {}, function(result)
    if result.code == 0 then
      return
    end

    vim.schedule(function()
      vim.notify("Could not run specs in tmux: " .. result.stderr, vim.log.levels.ERROR)
    end)
  end)
end

vim.keymap.set("n", "<Leader>rr", function()
  run_in_tmux_window(vim.fn.expand("%"))
end, { desc = "Run spec file in a tmux window" })

vim.keymap.set("n", "<Leader>ss", function()
  run_in_tmux_window(vim.fn.expand("%") .. ":" .. vim.fn.line("."))
end, { desc = "Run spec under the cursor in a tmux window" })

vim.keymap.set("n", "<Leader>aa", function()
  run_in_tmux_window("spec")
end, { desc = "Run all specs in a tmux window" })
