-- Shows the full key path of the YAML key under the cursor as virtual text,
-- replacing the yaml-revealer plugin. Paths are written the way Rails refers
-- to translations - dot-separated, and without the locale - so the path shown
-- for `name:` under `en:` > `users:` > `headings:` is `users.headings.name`.

local yaml_keys = {}

local namespace = vim.api.nvim_create_namespace("yaml_key_path")

-- A key glyph, to mark the text as an annotation at a glance the way the
-- diagnostics' box does. Swap it for anything your font has.
local icon = ""

-- Match the diagnostics' virtual text - Comment's grey, italicised - so this
-- reads as annotation rather than as part of the file.
local function set_highlight()
  local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
  vim.api.nvim_set_hl(0, "YamlKeyPath", { fg = comment.fg, italic = true })
end

set_highlight()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_highlight,
})

function yaml_keys.key_path()
  -- Ask for the yaml parser by name. Left to itself `get_parser` derives the
  -- language from the filetype, and vim-rails sets `eruby.yaml` on YAML files
  -- in a Rails app, which maps to `embedded_template` - the ERB tree, not this
  -- one. Naming the language also means this keeps working in a `.yml.erb`.
  local ok, parser = pcall(vim.treesitter.get_parser, 0, "yaml")
  if not ok or not parser then
    return ""
  end

  -- Resolve the node from the first non-blank column of the line rather than
  -- the cursor's own column: the cursor sits at column 0 after any vertical
  -- move, where the innermost node is the enclosing mapping rather than this
  -- line's key, which would silently report the parent's path instead.
  local row = vim.fn.line(".") - 1
  local col = vim.fn.match(vim.fn.getline("."), "\\S")
  if col < 0 then
    col = 0
  end

  -- Walk that parser's own tree rather than calling `get_node`, which derives
  -- the language from the filetype in the same way. Parsing here also matters
  -- because CursorMoved fires before the redraw that refreshes the
  -- highlighter's tree, which would otherwise be an edit behind.
  local tree = parser:parse()[1]
  if not tree then
    return ""
  end

  local node = tree:root():named_descendant_for_range(row, col, row, col)
  if not node then
    return ""
  end

  -- Every mapping the cursor sits inside contributes one key, outermost last
  local keys = {}
  while node do
    if node:type() == "block_mapping_pair" then
      local key = node:field("key")[1]
      if key then
        table.insert(keys, 1, vim.treesitter.get_node_text(key, 0))
      end
    end
    node = node:parent()
  end

  -- In a locale file the outermost key is the locale itself, which isn't
  -- part of the key you'd pass to `t`.
  if vim.fn.expand("%:p"):match("config/locales/") then
    table.remove(keys, 1)
  end

  return table.concat(keys, ".")
end

-- Rails' own YAML - database.yml, cable.yml, the fixtures - is left alone:
-- vim-rails marks it `eruby.yaml`, and the ERB in it isn't valid YAML anyway.
-- Locale files are exempt because filetypes.lua flips those back to `yaml`.
--
-- This has to be asked at call time, not at attach time: those files are still
-- plain `yaml` when FileType first fires, and only become `eruby.yaml` when
-- vim-rails' BufReadPost runs afterwards.
local function plain_yaml(buffer)
  return vim.bo[buffer].filetype == "yaml"
end

local function show_key_path(buffer)
  vim.api.nvim_buf_clear_namespace(buffer, namespace, 0, -1)

  if not plain_yaml(buffer) then
    return
  end

  local path = yaml_keys.key_path()
  if path == "" then
    return
  end

  -- hl_mode "combine" rather than the default "replace": YamlKeyPath sets only
  -- a foreground, and replacing would drop the line's own background, leaving
  -- the annotation on the plain Normal background while the rest of the
  -- cursor line keeps CursorLine's.
  vim.api.nvim_buf_set_extmark(buffer, namespace, vim.fn.line(".") - 1, -1, {
    virt_text = { { "  " .. icon .. " " .. path, "YamlKeyPath" } },
    virt_text_pos = "eol",
    hl_mode = "combine",
  })
end

local function yank_key_path()
  if not plain_yaml(0) then
    vim.notify("Key paths are off in Rails' own YAML", vim.log.levels.WARN)
    return
  end

  local path = yaml_keys.key_path()
  if path == "" then
    vim.notify("No YAML key under the cursor", vim.log.levels.WARN)
    return
  end

  -- setreg doesn't honour 'clipboard', so the plus register (what `p` reads
  -- back under unnamedplus) has to be set explicitly; the unnamed one is a
  -- fallback for when there's no clipboard provider.
  vim.fn.setreg("+", path)
  vim.fn.setreg('"', path)
  vim.notify("Yanked " .. path)
end

-- `yaml` only. vim-rails sets `eruby.yaml` on the YAML it claims
-- (*/config/*.yml and the fixtures), and locale files are exempt because
-- filetypes.lua flips those back - so this ends up on translations and on
-- ordinary YAML like .github/workflows, but not on database.yml and friends,
-- where the ERB breaks the parse anyway.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function(args)
    -- FileType fires more than once for a buffer, so without this the
    -- autocmd and the mapping stack up on every repeat
    if vim.b[args.buf].yaml_key_path_attached then
      return
    end
    vim.b[args.buf].yaml_key_path_attached = true

    -- BufWinEnter as well as CursorMoved: opening a file doesn't move the
    -- cursor, so on its own CursorMoved shows nothing until you press a key -
    -- and restore_cursor has usually dropped you into the middle of the file.
    vim.api.nvim_create_autocmd({ "CursorMoved", "BufWinEnter" }, {
      buffer = args.buf,
      callback = function()
        show_key_path(args.buf)
      end,
    })

    vim.keymap.set("n", "<leader>y", yank_key_path, {
      buffer = args.buf,
      desc = "Yank the key path under the cursor",
    })
  end,
})

return yaml_keys
