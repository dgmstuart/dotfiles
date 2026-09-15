vim.g.rails_projections = {
  [".env"] = { alternate = ".env.example" },
  [".env.example"] = { alternate = ".env" },
}

-- Open an alternate file and create it if it doesn't exist
local alternate_file_create_command = function(name, action)
  vim.api.nvim_create_user_command(name, function()
    vim.cmd(("execute '%s ' . rails#buffer().alternate()"):format(action))
  end, {})
end

alternate_file_create_command("AC", "e")
alternate_file_create_command("ACV", "vsp")
alternate_file_create_command("ACS", "sp")

-- CamelCase -> camel_case
local function snake_case(name)
  local snaked = name:gsub("(%u)", "_%1")
  snaked = snaked:gsub("^_", "")

  return snaked:lower()
end

-- Extract the given lines into a Rails ViewComponent: a ViewComponent::Base
-- subclass plus an .html.erb template holding the lines, with a render call
-- left behind in their place. Paths are relative to the working directory,
-- i.e. the Rails root.
local function extract_to_view_component(line1, line2)
  local indent = vim.fn.getline(line1):match("^%s*")
  local indent_width = vim.fn.indent(line1)

  -- Strip the selection's own indentation, but never more than it has
  local lines = vim.fn.getline(line1, line2)
  for i, line in ipairs(lines) do
    local leading = #line:match("^%s*")
    lines[i] = line:sub(math.min(leading, indent_width) + 1)
  end

  local component_name = vim.fn.input("Component name (e.g., SpotDimensions): ")
  if component_name == "" then
    vim.notify("Cancelled", vim.log.levels.WARN)
    return
  end

  local namespace = vim.fn.input("Namespace (e.g., Admin::Bookings, or leave empty): ")

  local namespace_path = ""
  local full_class = component_name .. "Component"
  if namespace ~= "" then
    namespace_path = namespace:lower():gsub("::", "/") .. "/"
    full_class = namespace .. "::" .. full_class
  end

  local base_dir = "app/components/" .. namespace_path
  local rb_file = base_dir .. snake_case(component_name) .. "_component.rb"
  local erb_file = base_dir .. snake_case(component_name) .. "_component.html.erb"

  vim.fn.mkdir(base_dir, "p")
  vim.fn.writefile({
    "# frozen_string_literal: true",
    "",
    "class " .. full_class .. " < ViewComponent::Base",
    "  def initialize(**options)",
    "    @options = options",
    "  end",
    "end",
  }, rb_file)
  vim.fn.writefile(lines, erb_file)

  local render_call = indent .. "<%= render(" .. full_class .. ".new) %>"
  vim.api.nvim_buf_set_lines(0, line1 - 1, line2, false, { render_call })

  vim.cmd("vsplit " .. vim.fn.fnameescape(erb_file))
  vim.cmd("vsplit " .. vim.fn.fnameescape(rb_file))

  vim.notify("Created component: " .. full_class)
end

vim.api.nvim_create_user_command("ExtractComponent", function(opts)
  extract_to_view_component(opts.line1, opts.line2)
end, { range = true })
