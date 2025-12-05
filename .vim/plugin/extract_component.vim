function! ExtractToViewComponent() range
  " Get the selected text, stripping off any initial indentation
  let l:indent = matchstr(getline(a:firstline), '^\s*')
  let l:indent_width = indent(a:firstline)
  let l:lines = getline(a:firstline, a:lastline)
  call map(l:lines, {_, line -> substitute(line, '^\s\{0,' . l:indent_width . '}', '', '')})

  " Prompt for component name and namespace
  let l:component_name = input('Component name (e.g., SpotDimensions): ')
  if empty(l:component_name)
    echo "\nCancelled"
    return
  endif

  let l:namespace = input('Namespace (e.g., Admin::Bookings, or leave empty): ')

  " Build paths
  let l:namespace_path = empty(l:namespace) ? '' : substitute(tolower(l:namespace), '::', '/', 'g') . '/'
  let l:component_snake = substitute(l:component_name, '\(\u\)', '_\l\1', 'g')
  let l:component_snake = substitute(l:component_snake, '^_', '', '')
  let l:component_snake = tolower(l:component_snake)

  let l:base_dir = 'app/components/' . l:namespace_path
  let l:rb_file = l:base_dir . l:component_snake . '_component.rb'
  let l:erb_file = l:base_dir . l:component_snake . '_component.html.erb'

  " Create directory if needed
  call mkdir(fnamemodify(l:rb_file, ':h'), 'p')

  " Generate Ruby class
  let l:class_name = l:component_name . 'Component'
  if !empty(l:namespace)
    let l:full_class = l:namespace . '::' . l:class_name
  else
    let l:full_class = l:class_name
  endif

  let l:rb_content = [
        \ '# frozen_string_literal: true',
        \ '',
        \ 'class ' . l:full_class . ' < ViewComponent::Base',
        \ '  def initialize(**options)',
        \ '    @options = options',
        \ '  end',
        \ 'end'
        \ ]

  " Write files
  call writefile(l:rb_content, l:rb_file)
  call writefile(l:lines, l:erb_file)

  " Replace selection with render call, at the same indentation level
  let l:render_call = l:indent . '<%= render(' . l:full_class . '.new) %>'
  execute a:firstline . ',' . a:lastline . 'delete'
  call append(a:firstline - 1, l:render_call)

  " Open the new component files
  execute 'vsplit' l:erb_file
  execute 'vsplit' l:rb_file

  echo "\nCreated component: " . l:full_class
endfunction

command! -range ExtractComponent <line1>,<line2>call ExtractToViewComponent()
