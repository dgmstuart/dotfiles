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

; Rails DSL macros (vim-rails: rubyEntity/rubyEntities/rubyValidation/
; rubyCallback/rubyExceptionMacro/rubyMacro -> same "Macro" highlight as
; the attr_* block above). Word list taken from vim-rails'
; after/syntax/ruby/rails.vim, covering models, controllers, jobs,
; mailers, and concerns.
((identifier) @function.macro
  (#any-of? @function.macro
    ; Associations, attributes, scopes (models)
    "belongs_to" "has_one" "has_many" "has_and_belongs_to_many" "composed_of"
    "accepts_nested_attributes_for" "attr_readonly" "attribute" "encrypts"
    "enum" "normalizes" "serialize" "store" "store_accessor"
    "default_scope" "scope" "observe"
    "has_rich_text" "has_secure_password" "has_secure_token"
    "has_one_attached" "has_many_attached" "delegated_type"
    ; Validations (models)
    "validates" "validate" "validates_acceptance_of" "validates_associated"
    "validates_confirmation_of" "validates_each" "validates_exclusion_of"
    "validates_format_of" "validates_inclusion_of" "validates_length_of"
    "validates_numericality_of" "validates_presence_of" "validates_absence_of"
    "validates_size_of" "validates_with" "validates_uniqueness_of"
    ; Callbacks (models, jobs, controllers)
    "before_validation" "after_validation"
    "before_create" "before_destroy" "before_save" "before_update"
    "after_create" "after_destroy" "after_save" "after_update"
    "around_create" "around_destroy" "around_save" "around_update"
    "after_commit" "after_create_commit" "after_update_commit"
    "after_save_commit" "after_destroy_commit" "after_rollback"
    "after_find" "after_initialize" "after_touch"
    "before_enqueue" "around_enqueue" "after_enqueue"
    "before_perform" "around_perform" "after_perform"
    "before_action" "append_before_action" "prepend_before_action"
    "after_action" "append_after_action" "prepend_after_action"
    "around_action" "append_around_action" "prepend_around_action"
    "skip_before_action" "skip_after_action" "skip_around_action"
    ; Jobs
    "queue_as" "rescue_from" "retry_on" "discard_on"
    ; Controllers
    "protect_from_forgery" "skip_forgery_protection"
    "http_basic_authenticate_with"
    "helper" "helper_attr" "helper_method" "layout"
    ; Mailers
    "register_interceptor" "register_interceptors"
    "register_observer" "register_observers"
    ; Concerns
    "included" "class_methods"
    "alias_attribute" "concern" "concerning" "delegate"
    "delegate_missing_to" "with_options")
  (#set! priority 105))

; Exception-raising methods (vim-ruby: rubyException)
((identifier) @keyword.exception
  (#any-of? @keyword.exception "raise" "fail" "catch" "throw")
  (#set! priority 105))

; The file-loading family (vim-ruby: rubyInclude, one pattern covering
; autoload/gem/load/require/require_relative).
;
; Upstream has a rule for require/require_relative/load, but it is scoped to
; `(program (call ...))` - the top level of the file only - so the same call
; inside a module, class or method body falls through to plain body text.
; `autoload` is missing upstream entirely. Matching on the call rather than
; on a bare identifier, with no receiver, keeps `YAML.load` and
; `Marshal.load` out of it, which is also how vim-ruby behaves.
(call
  !receiver
  method: (identifier) @keyword.import
  (#any-of? @keyword.import "require" "require_relative" "load" "autoload")
  (#set! priority 105))

; `gem` is deliberately *not* in the list above, though vim-ruby groups it
; there: it declares a dependency rather than loading a file, and keeping it
; visually distinct from the require family is a preference, not parity.
(call
  !receiver
  method: (identifier) @function.method.builtin
  (#eq? @function.method.builtin "gem")
  (#set! priority 105))

; eval family + other keyword-flavoured builtins (vim-ruby: rubyEval/rubyKeyword/rubyControl)
((identifier) @function.method.builtin
  (#any-of? @function.method.builtin
    "eval" "class_eval" "instance_eval" "module_eval"
    "callcc" "caller" "lambda" "proc"
    "abort" "at_exit" "exit" "exit!" "fork" "loop" "trap")
  (#set! priority 105))

; Magic comments (vim-ruby: rubyMagicComment -> SpecialComment)
; "# frozen_string_literal: true" gets its own three-way split below, so
; it's excluded here to avoid this flat rule overriding that one.
((comment) @keyword.directive
  (#match? @keyword.directive "^#\\s*(frozen[-_]string[-_]literal|warn[-_]indent|warn[-_]past[-_]scope|shareable[-_]constant[-_]value|(en)?coding)\\s*:")
  (#not-match? @keyword.directive "^# frozen[-_]string[-_]literal: true$")
  (#set! priority 105))

; "# frozen_string_literal: true" specifically: split into the directive
; part (violet, like vim-ruby's SpecialComment) and the boolean value
; (whatever colour real `true`/`false` literals get elsewhere), leaving
; "#" as plain Comment colour underneath — mirrors vim-ruby's three-way
; rubyComment / rubyMagicComment / rubyBoolean split for this one comment.
;
; tree-sitter-ruby parses this as one flat comment leaf with no child
; nodes, so there's nothing to attach separate captures to directly. This
; carves out fixed byte ranges instead, via #offset!, computed from the
; known length of "frozen_string_literal" and "true" — it only matches
; this exact spelling/spacing ("# frozen_string_literal: true", hyphens or
; underscores); anything else (false, extra whitespace, etc.) falls
; through to the flat rule above instead.
((comment) @keyword.directive
  (#match? @keyword.directive "^# frozen[-_]string[-_]literal: true$")
  (#offset! @keyword.directive 0 2 0 -5)
  (#set! priority 110))

((comment) @boolean
  (#match? @boolean "^# frozen[-_]string[-_]literal: true$")
  (#offset! @boolean 0 25 0 0)
  (#set! priority 110))

; String delimiters (vim-ruby: rubyStringDelimiter, distinct from content)
(string
  "\"" @string.delimiter
  (#set! priority 105))

; Block and control-flow `do`/`begin`/`end` (vim-ruby: rubyControl ->
; Statement, ie. the same green as `if`, `while` and `rescue`).
;
; tree-sitter-ruby files every keyword it hasn't classified into one flat
; @keyword, which solarized renders as the bold grey that `def`, `class`,
; `module` and `alias` are supposed to be. That grey is right for those four
; and for the `end` that closes them, but it also swallows `do`, `begin` and
; every `end` closing something other than a method or an `if` - so a
; `do`/`end` pair reads as body text. These re-file exactly those tokens onto
; captures solarized already colours green, leaving the definition keywords
; alone.
;
; `do_block`'s pair goes on @keyword.repeat for want of a "block" capture in
; the standard set; vim-ruby likewise lumps it in with `while` under
; rubyControl.
(do_block
  "do" @keyword.repeat
  "end" @keyword.repeat
  (#set! priority 105))

; `while x do ... end` / `until x do ... end`. The trailing `end` hangs off an
; inner `do` node, and the `do` keyword itself is captured by nothing at all
; upstream - it comes out as plain body text rather than merely the wrong grey.
(do
  "do" @keyword.repeat
  (#set! priority 105))

(while
  (do
    "end" @keyword.repeat)
  (#set! priority 105))

(until
  (do
    "end" @keyword.repeat)
  (#set! priority 105))

(for
  (do
    "end" @keyword.repeat)
  (#set! priority 105))

; Upstream classifies the `end` of an `if` but not of an `unless`, `case` or
; `case/in`.
(unless
  "end" @keyword.conditional
  (#set! priority 105))

(case
  "end" @keyword.conditional
  (#set! priority 105))

(case_match
  "end" @keyword.conditional
  (#set! priority 105))

; `begin ... end` - grouped with rescue/ensure, which are already green.
(begin
  "begin" @keyword.exception
  "end" @keyword.exception
  (#set! priority 105))

; RSpec macros (vim-rails: rubyTestMacro -> rubyMacro -> Macro, the same
; orange as the attr_*/Rails macros above). Treesitter overrides the legacy
; syntax engine, so vim-rails' after/syntax/ruby/rails.vim never gets a say
; and these were coming out as plain method calls.
;
; Scoped to spec files, as vim-rails scopes them: `let`, `before`, `after`
; and `given` are ordinary method names in application code.
((identifier) @function.macro
  (#any-of? @function.macro
    ; Example groups
    "describe" "context" "feature"
    "shared_context" "shared_examples" "shared_examples_for"
    ; Examples
    "it" "example" "specify" "scenario"
    "include_examples" "include_context"
    "it_should_behave_like" "it_behaves_like"
    ; Hooks
    "before" "after" "around" "background" "setup" "teardown"
    ; Memoized helpers
    "let" "let!" "given" "given!")
  (#file-path-match? "_spec%.rb$")
  (#set! priority 105))

; `subject { ... }` and `subject(:name) { ... }` are macros, but a bare
; `subject` referring to the value is not - vim-rails draws the same
; distinction, so match it only in call position.
((call
  method: (identifier) @function.macro)
  (#eq? @function.macro "subject")
  (#file-path-match? "_spec%.rb$")
  (#set! priority 105))

; RSpec assertions (vim-rails: rubyAssertion -> rubyException, ie. the same
; green as `raise` and `rescue` - which the "Exception-raising methods" rule
; above already uses).
((identifier) @keyword.exception
  (#any-of? @keyword.exception
    "expect" "is_expected" "expect_any_instance_of"
    "allow" "allow_any_instance_of"
    "pending" "skip")
  (#file-path-match? "_spec%.rb$")
  (#set! priority 105))

; RSpec helpers that stand for a value rather than doing something
; (vim-rails: rubyTestHelper -> rubyHelper -> Function -> blue). Note this is
; `@function.builtin`, not `@function.call`: the latter is deliberately plain
; body text in this config.
((identifier) @function.builtin
  (#any-of? @function.builtin
    "described_class" "subject"
    "double" "instance_double" "class_double" "object_double"
    "spy" "instance_spy" "class_spy" "object_spy")
  (#file-path-match? "_spec%.rb$")
  (#set! priority 104))

; Regexp delimiters, in the same red as the string quotes above: they are
; quote marks, just for a regexp. (vim-ruby files them under Delimiter, which
; solarized leaves undefined - so this is a deliberate choice rather than
; something recovered from the old config.)
;
; Upstream captures these as both @operator and @punctuation.bracket, and the
; one that wins renders as plain body text. Note the node's *type* is "/" no
; matter what the delimiter actually is, so this one rule covers `/.../`,
; `%r{...}`, `%r!...!` and the rest - and it is also why searching an
; :InspectTree dump for "%r" finds nothing.
(regex
  "/" @string.delimiter
  (#set! priority 105))

; The remaining percent-literal delimiters, in the same red. `%q{}`, `%Q{}`
; and `%{}` need no rule: tree-sitter gives their delimiters the same node
; type as an ordinary quote, so the (string "\"") rule above already covers
; them. These four shapes get their own node types instead, and were being
; painted as brackets or as string body.
(string_array
  "%w(" @string.delimiter
  ")" @string.delimiter
  (#set! priority 105))

(symbol_array
  "%i(" @string.delimiter
  ")" @string.delimiter
  (#set! priority 105))

; Backticks and %x{}
(subshell
  "`" @string.delimiter
  (#set! priority 105))

(delimited_symbol
  ":\"" @string.delimiter
  "\"" @string.delimiter
  (#set! priority 105))
