-- Tidies ruby-lsp's completion documentation for the blink.cmp docs popup.
--
-- Docs for core methods (the RBS signatures ruby-lsp serves for methods like
-- attr_accessor) are generated from RDoc and still contain inline HTML:
-- <code>, <em>, <tt>, entities, and an <!-- rdoc-file ... --> comment
-- repeating the call signatures. Markdown rendering in Neovim shows all of
-- that as literal text, so it's rewritten as the markdown it stands for.
--
-- The popup hides code fence markers but not the lines they're on, so every
-- fence shows up as a blank line. The signature fence at the top is moved
-- into the popup's detail section instead (still highlighted as Ruby), and
-- code examples are fenced on lines that would be blank anyway.
local ruby_lsp_docs = {}

local inline_replacements = {
  -- Old RDoc quoting: ``main'' means "main". Wrapped around code, it also
  -- leaves three backticks in a row, which markdown can't parse.
  { "``(.-)''", '"%1"' },
  -- Links can't be followed from the popup, and the hidden file:// target
  -- still takes up wrapped rows, showing as blank lines
  { "%[(.-)%]%(file://[^)]*%)", "%1" },
  { "</?code>", "`" },
  { "</?tt>", "`" },
  { "</?em>", "*" },
  { "</?i>", "*" },
  { "</?b>", "**" },
  { "</?strong>", "**" },
  { "&lt;", "<" },
  { "&gt;", ">" },
  { "&quot;", '"' },
  -- last, so "&amp;lt;" becomes "&lt;" rather than "<"
  { "&amp;", "&" },
}

local function convert_html(line)
  for _, replacement in ipairs(inline_replacements) do
    line = line:gsub(replacement[1], replacement[2])
  end
  return line
end

local function is_blank(line)
  return line == nil or line:match("^%s*$") ~= nil
end

local function is_indented_code(line)
  return line ~= nil and line:match("^    ") ~= nil
end

-- Splits off a leading ```ruby block, e.g. "attr_accessor(*names)"
local function split_signature(text)
  local signature, rest = text:match("^```ruby\n(.-)\n```\n(.*)$")
  if signature == nil then
    return nil, text
  end
  return signature, rest
end

-- Converts HTML outside code, and turns indented code blocks (which
-- markdown can't tag with a language) into ```ruby fences so they get
-- syntax highlighting. A fence replaces the blank line before or after the
-- block where there is one, so it doesn't add to the gap.
local function convert_lines(lines)
  local converted = {}
  local in_fence = false
  local index = 1
  while index <= #lines do
    local line = lines[index]
    if line:match("^%s*```") then
      in_fence = not in_fence
      table.insert(converted, line)
      index = index + 1
    elseif in_fence then
      table.insert(converted, line)
      index = index + 1
    elseif is_indented_code(line) then
      if is_blank(converted[#converted]) and #converted > 0 then
        converted[#converted] = "```ruby"
      else
        table.insert(converted, "```ruby")
      end
      -- A blank line only ends the block if code doesn't resume after it
      while is_indented_code(lines[index]) or (is_blank(lines[index]) and is_indented_code(lines[index + 1])) do
        table.insert(converted, (lines[index]:gsub("^    ", "")))
        index = index + 1
      end
      table.insert(converted, "```")
      if is_blank(lines[index]) then
        index = index + 1
      end
    else
      table.insert(converted, convert_html(line))
      index = index + 1
    end
  end
  return converted
end

local function trim_blank_lines(lines)
  while #lines > 0 and is_blank(lines[1]) do
    table.remove(lines, 1)
  end
  while #lines > 0 and is_blank(lines[#lines]) do
    table.remove(lines)
  end
  return lines
end

local function is_prose(line)
  if is_blank(line) or line:match("^%s*```") then
    return false
  end
  -- list items and headings start a new line of their own
  if line:match("^%s*[-*+] ") or line:match("^%s*%d+%. ") or line:match("^#") then
    return false
  end
  return true
end

-- The docs are hard-wrapped at about 80 characters, so in a narrower popup
-- each line wraps again, leaving a ragged short line after every one.
-- Joining each paragraph into one line lets the popup wrap it evenly.
local function join_paragraphs(lines)
  local joined = {}
  local in_fence = false
  local previous_is_text = false
  for _, line in ipairs(lines) do
    if line:match("^%s*```") then
      in_fence = not in_fence
      table.insert(joined, line)
      previous_is_text = false
    elseif in_fence then
      table.insert(joined, line)
    elseif previous_is_text and is_prose(line) then
      joined[#joined] = joined[#joined] .. " " .. vim.trim(line)
    else
      table.insert(joined, line)
      previous_is_text = not is_blank(line)
    end
  end
  return joined
end

function ruby_lsp_docs.to_markdown(text)
  -- The comment only repeats the signature already shown at the top
  text = text:gsub("<!%-%-.-%-%->\n?", "")
  -- Removing the comment leaves a tall gap behind
  text = text:gsub("\n\n\n+", "\n\n")

  local lines = trim_blank_lines(join_paragraphs(convert_lines(vim.split(text, "\n"))))
  -- A fence left open runs to the end, so a closing one on the last line
  -- would only add a blank line to the bottom of the popup
  if lines[#lines] == "```" then
    table.remove(lines)
  end
  return table.concat(lines, "\n")
end

-- For blink.cmp's completion.documentation.draw
function ruby_lsp_docs.draw(draw_opts)
  local documentation = draw_opts.item.documentation
  if type(documentation) ~= "table" or documentation.kind ~= "markdown" then
    draw_opts.default_implementation()
    return
  end

  local signature, body = split_signature(documentation.value)
  draw_opts.default_implementation({
    detail = signature,
    documentation = { kind = "markdown", value = ruby_lsp_docs.to_markdown(body) },
  })
end

return ruby_lsp_docs
