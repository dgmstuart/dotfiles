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
Plugin 'dense-analysis/ale'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'SirVer/ultisnips'
Plugin 'ConradIrwin/vim-bracketed-paste'
Plugin 'suan/vim-instant-markdown'
Plugin 'ap/vim-css-color'
Plugin 'yuezk/vim-js'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'elzr/vim-json'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'jbgutierrez/vim-partial'
Plugin 'mattn/emmet-vim'
Plugin 'AndrewRadev/splitjoin.vim'


call vundle#end()            " required
filetype plugin indent on    " required
" Vundle config end

colorscheme solarized
set background=light

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

" ===== Instead of backing up files, just reload the buffer when it changes. =====
" The buffer is an in-memory representation of a file, it's what you edit
set autoread        " Auto-reload buffers when file changed on disk
set nobackup        " Don't use backup files
set nowritebackup   " Don't backup the file while editing
set noswapfile      " Don't create swapfiles for new buffers
set updatecount=0   " Don't try to write swapfiles after some number of updates

let g:netrw_dirhistmax = 0 "disable generation of .netrwhist

" Don't use Ex mode, use Q for formatting
map Q gq

" prevent accidental commands:
command! Q q " Bind :Q to :q
command! W w " Bind :W to :w
command! Wq wq " Bind :Wq to :wq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

map <silent>\ :nohlsearch<CR> " clear search highlighting by pressing \

" Close the current buffer without closing the split
command! Bd bp\|bd \#

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
if filereadable("bin/rspec")
  let b:rspec_executable = "bin/rspec"
else
  let b:rspec_executable = "bundle exec rspec"
endif
let g:rspec_command = "Dispatch " . b:rspec_executable . " {spec} --format=progress --no-color"
let g:rspec_terminal_command = '!' . b:rspec_executable
function! RunSpecsWithFlag(flag)
  let s:rspec_command = substitute(g:rspec_command, "{spec}", a:flag, "g")

  execute s:rspec_command
endfunction
function! RunSpecsInTerminal(args)
  let l:rspec_terminal_command = g:rspec_terminal_command . ' ' . a:args

  execute l:rspec_terminal_command
endfunction

map <Leader>r :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
map <Leader>f :call RunSpecsWithFlag("--only-failures")<CR>
map <Leader>n :call RunSpecsWithFlag("--next-failure")<CR>
map <Leader>rr :call RunSpecsInTerminal('%')<CR>
map <Leader>ss :call RunSpecsInTerminal(expand('%') . ':' . line("."))<CR>
map <Leader>aa :call RunSpecsInTerminal('spec')<CR>
map <Leader>ff :call RunSpecsInTerminal('spec --only-failures')<CR>
map <Leader>nn :call RunSpecsInTerminal('spec --next-failure')<CR>

" Run tests which don't use RSpec
map <Leader>ea :Dispatch bundle exec rake<CR>
map <Leader>eaa :!bundle exec rake<CR>
map <Leader>er :Dispatch bundle exec rake test TEST=%<CR>
map <Leader>err :!bundle exec rake test TEST=%<CR>

" Run php tests
" ptest is defined in ~/.zsh/functions
map <Leader>w  :Dispatch ptest<CR>
map <Leader>wr :Dispatch ptest %<CR>

" Project search
map <Leader>m :Ack <cword> -w<CR>
map <Leader>/ :Ack '' -w<left><left><left><left>
let g:ack_use_dispatch = 1
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Refactoring - vim/partial config
let g:partial_templates = {
      \ 'erb' : '<%%= render "%s" %%>',
      \ }
let g:partial_use_splits = 1
let g:partial_vertical_split = 1

" File search
map <Leader>t :FZF<CR>
map <Leader>b :Buffers<CR>
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" Quickfix lists
map <Leader>q :cclose<CR>   " close the quickfix window
map <Leader>o :cope<CR> " open the quickfix window fullscreen
map <Leader>oo :cope<CR> :only<CR> " open the quickfix window fullscreen

nnoremap <Leader>1 :call ToggleRelativeNumber()<cr>
function! ToggleRelativeNumber()
    if &relativenumber
        set norelativenumber
    else
        set relativenumber
    endif
endfunction

" Rails i18n helpers
vmap <Leader>z :call I18nTranslateString()<CR>
vmap <Leader>dt :call I18nDisplayTranslation()<CR>

" Disable backspace in normal mode - it's a bad habit
noremap <BS> <Nop>

" move in quickfix list, useful with Ack.vim
nnoremap <C-S-n> :cprevious<CR>
nnoremap <C-n> :cnext<CR>

" convenient shortcut to save file
nnoremap <C-s> :w<CR>

" Swedish keyboard mappings:
map <Leader>- :Ack  -w<left><left><left>
map - /<left><left><left>


" Open tig showing the history of the current file
command! Tighist !tig %

" replace ruby hashrockets with key: value syntax
command! Notation %s/:\(\w\+\)\s*=>\s*/\1: /g

function! Norocket()
  " change '"foo" => 1' into 'foo: 1'
  " ^x   go to beginning of line and delete initial quote
  " f"r: replace end quote with ':'
  " ldf> move into the following space and delete up to the end of the =>
  normal! ^xf"r:ldf>j
endfunction

command! Norocket call Norocket()

" replace `try` (Rails) with the lonely operator (`&. Ruby)
command! Thereisnotry %s/.try(:\(\w\+\))/\&.\1/gc

function! ErrorCountMessage()
  let current_buffer = bufnr("%")
  let total_errors = ale#statusline#Count(current_buffer)['total']
  if total_errors != 0
    return 'Syntax Errors: ' . total_errors
  else
    return ''
  endif
endfunction

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
set statusline+=%{ErrorCountMessage()}     " syntax error/lint count
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
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 1
let g:ale_virtualtext_cursor = 'disabled'
let g:ale_open_list = 1
let g:ale_list_window_size = 5
let g:ale_linters = {}
let g:ale_fixers = {}

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

let g:rails_projections = {
      \ ".env": {"alternate": ".env.example"},
      \ ".env.example": {"alternate": ".env"}
      \ }

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

  let g:ale_linters.eruby = ['erblint', 'erubi', 'erubis', 'ruumba']
augroup END

augroup ruby
  autocmd!
  " For all ruby files, encourage 80 columns:
  autocmd FileType ruby setlocal colorcolumn=81,101,125

  let g:ale_linters.ruby = ['ruby', 'sorbet']

  if filereadable(".rubocop.yml")
    call add(g:ale_linters['ruby'], "rubocop")
    let g:ale_ruby_rubocop_executable = "bundle"
  endif

  autocmd BufNewFile,BufRead Brewfile set filetype=ruby

  " Prevent autocomplete looking in all gems!
  set complete-=i
augroup END

augroup haml
  autocmd!
  let g:ale_linters.haml = []

  if filereadable(".haml-lint.yml")
    let g:ale_linters.haml = ['hamllint']
  endif
augroup END

augroup javascript
  autocmd!
  let g:ale_linters.javascript = ['eslint', 'standard', 'xo']
  let g:ale_linters.javascriptreact = ['eslint', 'standard', 'xo']
  let g:ale_linters.typescript = ['eslint', 'standard', 'tsserver', 'typecheck', 'xo']
  let g:ale_linters.typescriptreact = ['eslint', 'standard', 'tsserver', 'typecheck', 'xo']
  let g:ale_fixers.javascript = []
  let g:ale_fixers.javascriptreact = []
  let g:ale_fixers.typescript = []
  let g:ale_fixers.typescriptreact = []

  if filereadable(".prettierrc")
    call add(g:ale_fixers['javascript'], "prettier")
    call add(g:ale_fixers['javascriptreact'], "prettier")
    call add(g:ale_fixers['typescript'], "prettier")
    call add(g:ale_fixers['typescriptreact'], "prettier")
    let g:ale_fix_on_save = 1
  endif
augroup END

" augroup json
"   autocmd!
"   let g:ale_linters.json = ['eslint']
" augroup END

augroup elm
  autocmd!
  " For all elm files, encourage 80 columns:
  autocmd FileType elm setlocal colorcolumn=81

  autocmd FileType elm setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

  let g:elm_setup_keybindings = 0
  autocmd FileType elm map <Leader>e :ElmMake<CR>
  autocmd FileType elm map <Leader>d :ElmErrorDetail<CR>
augroup END

augroup php
  autocmd!
  " For all php files, encourage 85 columns:
  autocmd FileType php setlocal colorcolumn=86

  autocmd FileType php setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

  autocmd BufNewFile,BufRead .php_cs.dist set filetype=php
augroup END

augroup text
  autocmd!
  " For all text files:
  " - enable spellchecking
  " - set 'textwidth' to 78 characters.
  autocmd FileType text,help,yaml setlocal spell textwidth=78
augroup END

augroup markdown
  autocmd!
  autocmd FileType markdown,liquid setlocal spell textwidth=78
augroup END

augroup gitcommit
  autocmd!
  " Start typing straight away in commit messages
  autocmd BufReadPost COMMIT_EDITMSG exe 'normal gg' | startinsert!

  " add spellchecking and automatic wrapping at the recommended 72 columns to commit messages.
  autocmd FileType gitcommit setlocal spell textwidth=72 colorcolumn=73
augroup END

" Automatically delete trailing whitespace for certain filetypes
augroup whitespace
  autocmd!
  autocmd FileType conf,css,eruby,gitcommit,html,haml,help,javascript,typescript,react,typescriptreact,json,markdown,php,ruby,scss,sh,text,vim,yaml autocmd BufWritePre <buffer> :%s/\s\+$//e
augroup END

" Whitespace highlighting
set list
set listchars=trail:·,tab:¬·

" Delete trailing whitespace by pressing f5
:nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
