;; extends

; vim-ruby's "Special Methods" block (syntax/ruby.vim:413-429) that
; tree-sitter-ruby's own highlights.scm doesn't classify — it only
; handles private/protected/public and require. Explicit priority so
; these win regardless of the base query's own pattern order.

; Access control, attr_*, and metaprogramming macros
; (vim-ruby groups these together under one "Macro" highlight)
((identifier) @function.macro
  (#any-of? @function.macro
    "attr" "attr_accessor" "attr_reader" "attr_writer"
    "module_function"
    "private_class_method" "public_class_method"
    "private_constant" "public_constant"
    "private" "protected" "public"
    "include" "extend" "prepend" "refine" "using"
    "alias_method" "define_method" "define_singleton_method"
    "remove_method" "undef_method")
  (#set! priority 105))

; Exception-raising methods (vim-ruby: rubyException)
((identifier) @keyword.exception
  (#any-of? @keyword.exception "raise" "fail" "catch" "throw")
  (#set! priority 105))

; require family — extends upstream's own "require"-only rule
((identifier) @function.method.builtin
  (#any-of? @function.method.builtin "require_relative" "load" "gem")
  (#set! priority 105))

; eval family + other keyword-flavoured builtins (vim-ruby: rubyEval/rubyKeyword/rubyControl)
((identifier) @function.method.builtin
  (#any-of? @function.method.builtin
    "eval" "class_eval" "instance_eval" "module_eval"
    "callcc" "caller" "lambda" "proc"
    "abort" "at_exit" "exit" "exit!" "fork" "loop" "trap")
  (#set! priority 105))

; Magic comments (vim-ruby: rubyMagicComment -> SpecialComment)
((comment) @keyword.directive
  (#match? @keyword.directive "^#\\s*(frozen[-_]string[-_]literal|warn[-_]indent|warn[-_]past[-_]scope|shareable[-_]constant[-_]value|(en)?coding)\\s*:")
  (#set! priority 105))

; String delimiters (vim-ruby: rubyStringDelimiter, distinct from content)
(string
  "\"" @string.delimiter
  (#set! priority 105))
