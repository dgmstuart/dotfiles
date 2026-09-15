-- Snippets which derive their default text from the current filename,
-- e.g. `user_spec.rb` -> `describe User`. That can't be expressed as
-- static VS Code JSON, so these are written directly in LuaSnip's own
-- format. All other ruby snippets live in ../snippets/ruby.json.

local luasnip = require("luasnip")
local snippet = luasnip.snippet
local snippet_node = luasnip.snippet_node
local insert = luasnip.insert_node
local dynamic = luasnip.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

-- snake_case (or a plain word) -> PascalCase, e.g. "my_model" -> "MyModel"
local function camelize(name)
  local parts = {}
  for part in name:gmatch("[^_]+") do
    table.insert(parts, part:sub(1, 1):upper() .. part:sub(2))
  end
  return table.concat(parts)
end

local function classname()
  return camelize(vim.fn.expand("%:t:r"))
end

-- Strips a trailing "_spec" before camelizing, e.g. "user_spec" -> "User"
local function spec_classname()
  local name = vim.fn.expand("%:t:r"):gsub("_spec$", "")
  return camelize(name)
end

-- An editable tabstop pre-filled with a dynamically computed default.
local function dynamic_default(jump_index, compute)
  return dynamic(jump_index, function()
    return snippet_node(nil, { insert(1, compute()) })
  end)
end

return {
  snippet(
    { trig = "cla", name = "class .. end", dscr = "class .. end" },
    fmt("class {}{}\nend", { dynamic_default(1, classname), insert(0) })
  ),
  snippet(
    { trig = "clai", name = "class .. initialize .. end", dscr = "class .. initialize .. end" },
    fmt("class {}\n\tdef initialize({}){}\n\tend\nend", {
      dynamic_default(1, classname),
      insert(2, "args"),
      insert(0),
    })
  ),
  snippet(
    { trig = "clap", name = "class .. < ParentClass .. initialize .. end", dscr = "class .. < ParentClass .. initialize .. end" },
    fmt("class {} < {}\n\tdef initialize({}){}\n\tend\nend", {
      dynamic_default(1, classname),
      insert(2, "ParentClass"),
      insert(3, "args"),
      insert(0),
    })
  ),
  snippet(
    { trig = "mod", name = "module .. end", dscr = "module .. end" },
    fmt("module {}{}\nend", { dynamic_default(1, classname), insert(0) })
  ),
  snippet(
    { trig = "nam", name = "namespace .. do .. end" },
    fmt("namespace :{} do\n\t{}\nend", {
      dynamic_default(1, function() return vim.fn.expand("%:t:r") end),
      insert(0),
    })
  ),
  snippet(
    { trig = "desc", name = "describe .. do .. end" },
    fmt("describe {} do\n{}end", { dynamic_default(1, spec_classname), insert(0) })
  ),
}
