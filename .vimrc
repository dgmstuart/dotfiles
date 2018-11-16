" Vundle config start
set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'mileszs/ack.vim'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'vim-ruby/vim-ruby'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'godlygeek/tabular'
Plugin 'garbas/vim-snipmate'
  Plugin 'MarcWeber/vim-addon-mw-utils' " snipmate dependency
  Plugin 'tomtom/tlib_vim'              " snipmate dependency
Plugin 'tpope/vim-liquid'
Plugin 'kchmck/vim-coffee-script'
Plugin 'ConradIrwin/vim-bracketed-paste'
Plugin 'suan/vim-instant-markdown'
Plugin 'stefanoverna/vim-i18n'
Plugin 'elixir-editors/vim-elixir'
Plugin 'elmcast/elm-vim'
Plugin 'ap/vim-css-color'

call vundle#end()            " required
filetype plugin indent on    " required
" Vundle config end

colorscheme solarized
set background=dark

" Set font for macvim
if has("gui_running")
  set guifont=Bitstream\ vera\ sans\ mono:h14
endif

" when the terminal has colors...
if &t_Co > 2 || has("gui_running")
  syntax on         " set syntax highlighting on
  set hlsearch      " highlight search matches

  " Highlight the status line
  highlight StatusLine ctermfg=00 ctermbg=06

  " highlight the status bar when in insert mode
  if version >= 700
    au InsertEnter * hi StatusLine ctermfg=136 ctermbg=00
    au InsertLeave * hi StatusLine ctermfg=00 ctermbg=06
  endif
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=1000    " lines of command line history to keep
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set incsearch       " do incremental searching
set gcr=a:blinkon0  " disable the blinking cursor
set cursorline      " show the cursor line
set colorcolumn=+1  " highlight the column limit
set number          " show line numbers
set relativenumber  " show relative line numbers
set scrolloff=2     " always show 2 lines of context at the top/bottom
set showcmd         " display incomplete commands
set showmatch       " show matching brackets
set matchtime=2     " speed up matching brackets
set laststatus=2    " always show status line.
set autoindent      " maintain the indenting from the previous line
set undofile        " enable persistent undo
set undodir=~/.vim/undo
set previewheight=30 " height of the preview window
set nomodeline      " modelines are a potential security hole
set ignorecase      " ignore case in searches
set smartcase       " do case-sensitive searches if the search term includes uppercase letters
set grepprg=ag      " use the silver searcher for grep commands
set splitright      " open new split panes on the right (left is default)
set mouse=a         " enable the mouse

" Soft tabs
set expandtab
set softtabstop=2
set shiftwidth=2

let g:netrw_dirhistmax = 0 "disable generation of .netrwhist

" Don't use Ex mode, use Q for formatting
map Q gq

" prevent accidental commands:
command! Q q " Bind :Q to :q
command! W w " Bind :W to :w
command! Wq wq " Bind :Wq to :wq
command! Bd bd " Bind :Bd to :bd

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

map <silent>\ :nohlsearch<CR> " clear search highlighting by pressing \

function! RegReset()
  echo 'Resetting named registers a-z...'
  let regs=split('abcdefghijklmnopqrstuvwxyz', '\zs')
  for r in regs
    call setreg(r, [])
  endfor
endfunction

let mapleader = ","

map <Leader>gs :Gstatus<CR>

" Run rspec using thoughtbot/vim-rspec and tpope/dispatch.
" rspec_cmd is defined in ~/.zsh/functions
let g:rspec_command = "Dispatch `rspec_cmd` {spec} --format=progress --no-color"
function! RunSpecsWithFlag(flag)
  let s:rspec_command = substitute(g:rspec_command, "{spec}", a:flag, "g")

  execute s:rspec_command
endfunction

map <Leader>r :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
map <Leader>f :call RunSpecsWithFlag("--only-failures")<CR>
map <Leader>n :call RunSpecsWithFlag("--next-failure")<CR>
map <Leader>rr :!bundle exec rspec %<CR>
map <Leader>ss :exe '!bundle exec rspec ' . expand('%'). ':' . line(".")<CR>
map <Leader>aa :!bundle exec rspec spec<CR>
map <Leader>ff :!bundle exec rspec spec --only-failures<CR>
map <Leader>nn :!bundle exec rspec spec --next-failure<CR>

" Run php tests
" ptest is defined in ~/.zsh/functions
map <Leader>w  :Dispatch ptest<CR>
map <Leader>wr :Dispatch ptest %<CR>

" Project search
map <Leader>m :Ack <cword> -w<CR>
map <Leader>/ :Ack  -w<left><left><left>
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" File search
map <Leader>t :CtrlP<CR>
map <Leader>p :CtrlP<CR>
map <Leader>b :CtrlPBuffer<CR>
let g:ctrlp_by_filename = 0
let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
let g:ctrlp_use_caching = 0
let g:ctrlp_show_hidden = 1

" Quickfix lists
map <Leader>q :cclose<CR>   " close the quickfix window
map <Leader>o :cope<CR> " open the quickfix window fullscreen
map <Leader>oo :cope<CR> :only<CR> " open the quickfix window fullscreen

" Rails i18n helpers
vmap <Leader>z :call I18nTranslateString()<CR>
vmap <Leader>dt :call I18nDisplayTranslation()<CR>

" Disable backspace in normal mode - it's a bad habit
noremap <BS> <Nop>

" Swedish keyboard mappings:
map <Leader>- :Ack  -w<left><left><left>
map - /<left><left><left>


" Open tig showing the history of the current file
command! Tighist !tig %

" replace ruby hashrockets with key: value syntax
command! Notation %s/:\(\w\+\)\s*=>\s*/\1: /g

" replace `try` (Rails) with the lonely operator (`&. Ruby)
command! Thereisnotry %s/.try(:\(\w\+\))/\&.\1/gc

" statusline highlighting groups:
hi warningmsg ctermbg=red ctermfg=black
hi time ctermbg=black ctermfg=136
set statusline=
set statusline+=(%n)\                      " buffer number
set statusline+=%f\                        " file name
set statusline+=[
set statusline+=%{strlen(&ft)?&ft:'none'}  " filetype
set statusline+=]
set statusline+=%#warningmsg#              " <start warning>
set statusline+=%m                         " flag: modified
set statusline+=%*                         " <end warning>
set statusline+=%1*%h%r%w%0*\              " flags: help window, readonly, preview window
set statusline+=%{fugitive#statusline()}\  " git info
set statusline+=%#warningmsg#              " <start warning>
set statusline+=%{SyntasticStatuslineFlag()} " syntax error
set statusline+=%*                         " <end warning>

set statusline+=%=                         " right align

set statusline+=%-14.(%c%V%)\              " column
set statusline+=%<                         " truncation point (???)
set statusline+=(%l/%L)                    " line number
set statusline+=\                          " space
if exists('$TMUX') == 0
  set statusline+=%#time#                    " <start time>
  set statusline+=\                          " space
  set statusline+=%{strftime('%e\ %b\ %k:%M')} " Date and Time e.g. 6 Feb 17:44
  set statusline+=%*                         " <end time>
endif

" Syntax checking
let g:syntastic_always_populate_loc_list = 1  " populate the location list on each save
let g:syntastic_auto_loc_list = 1             " automatically open and close the location list
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_open = 1             " run checks on open, not just on save
let g:syntastic_check_on_wq = 0               " don't run checks on exit
let g:syntastic_auto_jump = 1                 " always jump the cursor to the first issue

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

augroup vimrcEx
  autocmd!
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

augroup ruby
  autocmd!
  " For all ruby files, encourage 80 columns:
  autocmd FileType ruby setlocal colorcolumn=81

  let g:syntastic_ruby_checkers = ['mri']
  if filereadable(".rubocop.yml")
    call add(g:syntastic_ruby_checkers, "rubocop")
  endif

  " Prevent autocomplete looking in all gems!
  set complete-=i
augroup END

augroup haml
  autocmd!
  let g:syntastic_haml_checkers = ['haml']
  if filereadable(".haml-lint.yml")
    call add(g:syntastic_haml_checkers, "haml_lint")
  endif
augroup END

augroup scss
  autocmd!
  let g:syntastic_scss_checkers = ['sass']
  if filereadable(".stylelintrc.json")
    let g:syntastic_scss_stylelint_exec = './node_modules/.bin/stylelint'
    call add(g:syntastic_scss_checkers, "stylelint")
  endif
augroup END

augroup css
  autocmd!
  if filereadable(".stylelintrc.json")
    let g:syntastic_css_stylelint_exec = './node_modules/.bin/stylelint'
    let g:syntastic_css_checkers = ['stylelint']
  endif
augroup END

augroup elm
  autocmd!
  " For all elm files, encourage 80 columns:
  autocmd FileType elm setlocal colorcolumn=81

  autocmd Filetype elm setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

  let g:elm_syntastic_show_warnings = 1
  let g:elm_setup_keybindings = 0
  autocmd FileType elm map <Leader>e :ElmMake<CR>
  autocmd FileType elm map <Leader>d :ElmErrorDetail<CR>
augroup END

augroup php
  autocmd!
  " For all php files, encourage 85 columns:
  autocmd FileType php setlocal colorcolumn=86

  autocmd Filetype php setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

  let g:syntastic_php_checkers=['php', 'phpcs']
  let g:syntastic_php_phpcs_args='--standard=PSR2 -n --ignore=*/templates/*,*/vendor/*'
augroup END

augroup text
  autocmd!
  " For all text and markdown files:
  " - enable spellchecking
  " - set 'textwidth' to 78 characters.
  autocmd FileType text,markdown,help,yaml setlocal spell textwidth=78
augroup END

augroup gitcommit
  autocmd!
  " Start typing straight away in commit messages
  autocmd BufReadPost COMMIT_EDITMSG exe 'normal gg' | startinsert!

  " add spellchecking and automatic wrapping at the recommended 72 columns to commit messages.
  autocmd Filetype gitcommit setlocal spell textwidth=72
augroup END

" Automatically delete trailing whitespace for certain filetypes
augroup whitespace
  autocmd!
  autocmd FileType ruby,eruby,haml,javascript,json,scss,css,php,markdown,vim,help,sh,conf,yaml,gitcommit,text autocmd BufWritePre <buffer> :%s/\s\+$//e
augroup END

" Whitespace highlighting
set list
set listchars=trail:·,tab:¬·

" Delete trailing whitespace by pressing f5
:nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
