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
