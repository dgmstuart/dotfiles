-- Custom predicates available to treesitter queries (see after/queries/).
--
-- Loaded before lazy.nvim sources plugins: a query naming an unknown
-- predicate is discarded in full, so this has to be registered before the
-- first Ruby buffer is highlighted.

-- `(#file-path-match? "<lua pattern>")`
--
-- True when the buffer's full path matches the pattern.
--
-- A treesitter query applies to every buffer of its language, but some of
-- vim-ruby's world is deliberately file-scoped: vim-rails only defines its
-- RSpec syntax inside `*_spec.rb`. Without a gate, `let`, `before`, `given`
-- and `subject` would be coloured as macros in ordinary Ruby, where they are
-- just method names.
vim.treesitter.query.add_predicate("file-path-match?", function(_match, _pattern, source, predicate)
  if type(source) ~= "number" then
    return false
  end

  local path = vim.api.nvim_buf_get_name(source)
  return path:match(predicate[2]) ~= nil
end, { force = true })
