-- Function and class snippets which generate a docstring from the
-- argument list as you type it: each argument gets a `:name: TODO` line.
-- That derivation can't be expressed as static VS Code JSON, so these are
-- written directly in LuaSnip's own format.

local luasnip = require("luasnip")
local snippet = luasnip.snippet
local insert = luasnip.insert_node
local func = luasnip.function_node
local dynamic = luasnip.dynamic_node
local snippet_node = luasnip.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

-- Splits an argument list on commas which aren't inside brackets, so that
-- a default like `x=[1, 2]` counts as one argument.
local function split_arguments(arglist)
  local arguments = {}
  local depth = 0
  local current = ""
  for index = 1, #arglist do
    local char = arglist:sub(index, index)
    if char == "[" then
      depth = depth + 1
      current = current .. char
    elseif char == "]" and depth > 0 then
      depth = depth - 1
      current = current .. char
    elseif char == "," and depth == 0 then
      table.insert(arguments, current)
      current = ""
    else
      current = current .. char
    end
  end
  table.insert(arguments, current)
  return arguments
end

-- The documentable argument names: the bare name, with any type
-- annotation and default value stripped, and `self` left out.
local function argument_names(arglist)
  local names = {}
  for _, argument in ipairs(split_arguments(arglist)) do
    local name = argument:gsub("=.*$", ""):gsub(":.*$", ""):match("^%s*(.-)%s*$")
    if name ~= "" and name ~= "self" then
      table.insert(names, name)
    end
  end
  return names
end

-- The text currently in another node, as a single string.
local function node_text(argument_nodes, index)
  return table.concat(argument_nodes[index], "")
end

-- `self, ` (or `cls, `) only inside a class body, where the snippet was
-- expanded on an indented line.
local function receiver(name)
  return func(function(argument_nodes, parent)
    local line = parent.snippet.env.TM_CURRENT_LINE
    if not line:match("^%s") then
      return ""
    end
    if node_text(argument_nodes, 1) == "" then
      return name
    end
    return name .. ", "
  end, { 2 })
end

-- An editable docstring summary naming the function or class, which
-- follows that name as long as it hasn't been typed over yet.
local function summary(jump_index, name_index, template)
  return dynamic(jump_index, function(argument_nodes)
    local name = node_text(argument_nodes, 1)
    return snippet_node(nil, { insert(1, template:format(name)) })
  end, { name_index })
end

-- The `:name: TODO` lines for a function's docstring, preceded by a blank
-- line. Empty when the function takes no documentable arguments.
local function argument_docs(argument_index, indent)
  return func(function(argument_nodes)
    local names = argument_names(node_text(argument_nodes, 1))
    if #names == 0 then
      return ""
    end
    local lines = { "", "" }
    for _, name in ipairs(names) do
      table.insert(lines, indent .. ":" .. name .. ": TODO")
    end
    return lines
  end, { argument_index })
end

-- The body of a generated `__init__`: a `__init__` call per real parent
-- class, then an instance variable per argument.
local function init_body(parents_index, arguments_index)
  return func(function(argument_nodes)
    local lines = {}
    for _, parent_class in ipairs(split_arguments(node_text(argument_nodes, 1))) do
      local name = parent_class:match("^%s*(.-)%s*$")
      if name ~= "" and name ~= "object" then
        table.insert(lines, "\t\t" .. name .. ".__init__(self)")
      end
    end
    if #lines > 0 then
      table.insert(lines, "")
    end
    for _, name in ipairs(argument_names(node_text(argument_nodes, 2))) do
      if not name:match("%*") then
        table.insert(lines, "\t\tself._" .. name .. " = " .. name)
      end
    end
    if #lines == 0 then
      return ""
    end
    table.insert(lines, 1, "")
    return lines
  end, { parents_index, arguments_index })
end

-- The closing quotes of a class docstring, and the `:name: TODO` lines
-- above them. With no arguments the whole docstring stays on one line.
local function init_docs(arguments_index)
  return func(function(argument_nodes)
    local names = argument_names(node_text(argument_nodes, 1))
    if #names == 0 then
      return ' """'
    end
    local lines = { "", "" }
    for _, name in ipairs(names) do
      table.insert(lines, "\t\t:" .. name .. ": TODO")
    end
    table.insert(lines, '\t\t"""')
    return lines
  end, { arguments_index })
end

return {
  snippet(
    { trig = "def", name = "function with docstrings", dscr = "function with docstrings" },
    fmt('def {}({}{}):\n\t"""{}{}\n\t:returns: TODO\n\t"""\n{}', {
      insert(1, "function"),
      receiver("self"),
      insert(2, "arg1"),
      summary(3, 1, "TODO: Docstring for %s."),
      argument_docs(2, "\t"),
      insert(0),
    })
  ),
  snippet(
    { trig = "defc", name = "class method with docstrings", dscr = "class method with docstrings" },
    fmt('@classmethod\ndef {}({}{}):\n\t"""{}{}\n\t:returns: TODO\n\t"""\n\t{}', {
      insert(1, "function"),
      receiver("cls"),
      insert(2, "arg1"),
      summary(3, 1, "TODO: Docstring for %s."),
      argument_docs(2, "\t"),
      insert(4, "pass"),
    })
  ),
  snippet(
    { trig = "defs", name = "static method with docstrings", dscr = "static method with docstrings" },
    fmt('@staticmethod\ndef {}({}):\n\t"""{}{}\n\t:returns: TODO\n\t"""\n\t{}', {
      insert(1, "function"),
      insert(2, "arg1"),
      summary(3, 1, "TODO: Docstring for %s."),
      argument_docs(2, "\t"),
      insert(4, "pass"),
    })
  ),
  snippet(
    { trig = "class", name = "class with docstrings", dscr = "class with docstrings" },
    fmt('class {}({}):\n\n\t"""{}"""\n\n\tdef __init__(self{}):\n\t\t"""{}{}{}\n\t\t{}', {
      insert(1, "MyClass"),
      insert(2, "object"),
      summary(3, 1, "Docstring for %s. "),
      insert(4, ""),
      insert(5, "TODO: to be defined."),
      init_docs(4),
      init_body(2, 4),
      insert(0),
    })
  ),
}
