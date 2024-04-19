let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'mileszs/ack.vim'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'vim-ruby/vim-ruby'
Plug 'dense-analysis/ale'
Plug 'terryma/vim-multiple-cursors'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'suan/vim-instant-markdown'
Plug 'ap/vim-css-color'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'elzr/vim-json'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'jbgutierrez/vim-partial'
Plug 'mattn/emmet-vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

let g:coc_global_extensions = [
\ 'coc-snippets',
\ 'coc-solargraph',
\ '@yaegassy/coc-tailwindcss3'
\ ]

colorscheme solarized

" when the terminal has colors...
if &t_Co > 2 || has("gui_running")
  syntax on         " set syntax highlighting on
  set hlsearch      " highlight search matches

  " local variables for solarized colors
  let s:solarizedBlack      = "8"
  let s:solarizedGrey5      = "0"
  let s:solarizedGrey4      = "10"
  let s:solarizedGrey3      = "11"
  let s:solarizedGrey2      = "12"
  let s:solarizedGrey1      = "14"
  let s:solarizedCreamDark  = "7"
  let s:solarizedCreamLight = "15"
  let s:solarizedYellow     = "3"
  let s:solarizedOrange     = "9"
  let s:solarizedRed        = "1"
  let s:solarizedMagenta    = "5"
  let s:solarizedViolet     = "13"
  let s:solarizedBlue       = "4"
  let s:solarizedCyan       = "6"
  let s:solarizedGreen      = "2"

  " Highlight the status line
  exe "hi StatusLine ctermfg=" .s:solarizedGrey5 "ctermbg=" .s:solarizedCyan

  " highlight the status bar when in insert mode
  autocmd InsertEnter * exe "hi StatusLine ctermfg=" .s:solarizedYellow "ctermbg=" .s:solarizedBlack
  autocmd InsertLeave * exe "hi StatusLine ctermfg=" .s:solarizedGrey5 "ctermbg=" .s:solarizedCyan

  function! SetCocColors()
    " partial match text in popup menu:
    exe "hi CocSearch ctermfg=" .s:solarizedBlue
    " basic colours of popup menu:
    exe "hi CocFloating ctermfg=" .s:solarizedGrey1 "ctermbg=" .s:solarizedGrey5
    " selected item in popup menu:
    exe "hi CocMenuSel ctermbg=" .s:solarizedCreamDark
  endfunction
  autocmd VimEnter,ColorScheme * call SetCocColors()
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
set updatetime=300  " minimise latency (default is 4000)

" Soft tabs
set expandtab
set softtabstop=2
set shiftwidth=2

" Whitespace highlighting
set list
set listchars=trail:·,tab:¬·

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

" Close the current buffer without closing the split
command! Bd bp\|bd \#

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Ack config
let g:ack_use_dispatch = 1
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" ALE config (Syntax checking)
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 1
let g:ale_virtualtext_cursor = 'disabled'
let g:ale_open_list = 1
let g:ale_list_window_size = 5
let g:ale_linters = {}
let g:ale_fixers = {}

" Fzf config (file search)
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit' }

" Rails.vim config
let g:rails_projections = {
      \ ".env": {"alternate": ".env.example"},
      \ ".env.example": {"alternate": ".env"}
      \ }

" Refactoring - vim/partial config
let g:partial_templates = {
      \ 'erb' : '<%%= render "%s" %%>',
      \ }
let g:partial_use_splits = 1
let g:partial_vertical_split = 1

" RSpec config
function! ChooseRSpecExecutable()
  if filereadable("bin/rspec")
    let b:rspec_executable = "bin/rspec"
  else
    let b:rspec_executable = "bundle exec rspec"
  endif
endfunction
augroup RSpecSettings
  autocmd!
  autocmd BufEnter * call ChooseRSpecExecutable()
augroup END
call ChooseRSpecExecutable()
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
function! RunSpecsInWindow(args)
  let l:rspec_command = b:rspec_executable . ' ' . a:args

  silent execute '!run_in_iterm_tab "' . l:rspec_command . '"'
endfunction


let mapleader = ","

" Git
map <Leader>gs :Git<CR>

" RSpec
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
map <Leader>rrr :call RunSpecsInWindow('%')<CR>
map <Leader>sss :call RunSpecsInWindow(expand('%') . ':' . line("."))<CR>
map <Leader>aaa :call RunSpecsInWindow('spec')<CR>
map <Leader>fff :call RunSpecsInWindow('spec --only-failures')<CR>
map <Leader>nnn :call RunSpecsInWindow('spec --next-failure')<CR>

" Ruby tests which don't use RSpec
map <Leader>ea :Dispatch bundle exec rake<CR>
map <Leader>eaa :!bundle exec rake<CR>
map <Leader>er :Dispatch bundle exec rake test TEST=%<CR>
map <Leader>err :!bundle exec rake test TEST=%<CR>

" PhP tests
" ptest is defined in ~/.zsh/functions
map <Leader>w  :Dispatch ptest<CR>
map <Leader>wr :Dispatch ptest %<CR>

" Project search
map <Leader>m :Ack <cword> -w<CR>
map <Leader>/ :Ack '' -w<left><left><left><left>

" File search
map <Leader>t :FZF<CR>
map <Leader>b :Buffers<CR>

" rename the symbol under the cursor - across the whole workspace
nmap <leader>rn <Plug>(coc-rename)

" Quickfix lists
map <Leader>q :cclose<CR>   " close the quickfix window
map <Leader>o :cope<CR> " open the quickfix window fullscreen
map <Leader>oo :cope<CR> :only<CR> " open the quickfix window fullscreen

" My functions (in .vim/plugin)
nnoremap <Leader>1 :call ToggleRelativeNumber()<cr>
map <Leader>d :call ToggleBackground()<CR>

" Disable backspace in normal mode - it's a bad habit
noremap <BS> <Nop>

" move in quickfix list, useful with Ack.vim
nnoremap <C-S-n> :cprevious<CR>
nnoremap <C-n> :cnext<CR>

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

" convenient shortcut to save file
nnoremap <C-s> :w<CR>

" Swedish keyboard mappings:
map <Leader>- :Ack  -w<left><left><left>
map - /<left><left><left>

map <silent>\ :nohlsearch<CR> " clear search highlighting by pressing \

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Autocomplete
" Use Tab to complete with coc, or expand a snippet if available
" (eg. by default non-word characters like % don't open up the popup menu)
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : "<Plug>(coc-snippets-expand)"
" ...or enter to complete with coc
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()  : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! RegReset()
  echo 'Resetting named registers a-z...'
  let regs=split('abcdefghijklmnopqrstuvwxyz', '\zs')
  for r in regs
    call setreg(r, [])
  endfor
endfunction

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

augroup vimStartup
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
        \ let line = line("'\"")
        \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
        \      && index(['xxd', 'gitrebase'], &filetype) == -1
        \ |   execute "normal! g`\""
        \ | endif
augroup END

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
exe "hi warningmsg ctermbg=" .s:solarizedRed "ctermfg=" .s:solarizedGrey5
exe "hi time ctermbg=" .s:solarizedGrey5 "ctermfg=" .s:solarizedYellow
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

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

augroup ruby
  autocmd!
  " For all ruby files, encourage 80 columns:
  autocmd FileType ruby setlocal colorcolumn=81,101,125

  autocmd BufNewFile,BufRead Brewfile set filetype=ruby

  " Prevent autocomplete looking in all gems!
  autocmd FileType ruby set complete-=i
augroup END

let g:ale_linters.ruby = ['ruby', 'sorbet']
let g:ale_linters.eruby = ['erblint', 'erubi', 'erubis', 'ruumba']

if filereadable(".rubocop.yml")
  call add(g:ale_linters['ruby'], "rubocop")
  let g:ale_ruby_rubocop_executable = "bundle"
endif

" Javascript
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

augroup elm
  autocmd!
  " For all elm files, encourage 80 columns:
  autocmd FileType elm setlocal colorcolumn=81

  autocmd FileType elm setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

  autocmd FileType elm map <Leader>e :ElmMake<CR>
  autocmd FileType elm map <Leader>d :ElmErrorDetail<CR>
augroup END

let g:elm_setup_keybindings = 0

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

  " disable CoC in commit messages
  autocmd FileType gitcommit let b:coc_enabled=0
augroup END

" Automatically delete trailing whitespace for certain filetypes
augroup whitespace
  autocmd!
  autocmd FileType conf,css,eruby,gitcommit,html,haml,help,javascript,typescript,react,typescriptreact,json,markdown,php,ruby,scss,sh,text,tmux,vim,yaml autocmd BufWritePre <buffer> :%s/\s\+$//e
augroup END

" auto-source .vimrc when saving
autocmd! bufwritepost .vimrc nested source %
