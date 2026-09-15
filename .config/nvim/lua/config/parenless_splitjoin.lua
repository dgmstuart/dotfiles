-- Breaking up, and rejoining, a Ruby call written without parentheses:
--
--   validates :email, presence: true, uniqueness: { case_sensitive: false }
--
-- Splitting tools find what to work on by looking for a bracket pair - break
-- after the `(`, put the `)` on its own line. These calls have no brackets to
-- anchor to, so the argument list has to be found in the syntax tree instead.
-- Rails is largely written this way (`validates`, `has_many`, `render`,
-- `link_to`), so it is worth the parser lookup.
--
-- Nothing here fires unless the cursor is in an argument list with no
-- parentheses, so the caller can try this alongside the general-purpose tools
-- and take whichever one moves.

local parenless_splitjoin = {}

---Whether an `argument_list` node is bracketed. Also the gate that keeps the
---general-purpose tools off the calls this module handles.
---@param node TSNode
---@return boolean
function parenless_splitjoin.has_parens(node)
  local first = node:child(0)
  if first == nil then
    return false
  end

  return first:type() == "("
end

---The parenthesis-less `argument_list` around the cursor, if there is one.
---@return TSNode|nil
local function arguments_at_cursor()
  if vim.bo.filetype ~= "ruby" then
    return nil
  end

  local node = vim.treesitter.get_node()
  while node ~= nil and node:type() ~= "argument_list" do
    node = node:parent()
  end

  if node == nil or parenless_splitjoin.has_parens(node) then
    return nil
  end

  return node
end

---Puts each argument on a line of its own, indented one level past the call.
function parenless_splitjoin.split()
  local node = arguments_at_cursor()
  if node == nil then
    return
  end

  local row, start_col, end_row, _ = node:range()
  if end_row ~= row then
    return -- already split
  end

  local arguments = node:named_children()
  if #arguments < 2 then
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
  local indent = line:match("^%s*") .. (" "):rep(vim.fn.shiftwidth())

  -- Everything before the first argument - the receiver, the method name and
  -- the space after it - stays put, and the first argument stays with it.
  local split = { line:sub(1, start_col) .. vim.treesitter.get_node_text(arguments[1], 0) .. "," }
  for i = 2, #arguments do
    local separator = ","
    if i == #arguments then
      separator = ""
    end
    table.insert(split, indent .. vim.treesitter.get_node_text(arguments[i], 0) .. separator)
  end

  vim.api.nvim_buf_set_lines(0, row, row + 1, false, split)
end

---Puts the arguments back on one line. They already carry their commas, so
---`J` - which strips the indent and joins with a single space - gives exactly
---the right line.
function parenless_splitjoin.join()
  local node = arguments_at_cursor()
  if node == nil then
    return
  end

  local row, _, end_row, _ = node:range()
  if end_row == row then
    return -- already joined
  end

  -- `[count]J` counts the lines it joins, not the joins it makes.
  vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
  vim.cmd("normal! " .. (end_row - row + 1) .. "J")
end

return parenless_splitjoin
