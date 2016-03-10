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
set pastetoggle=<C-p> " key for toggling paste mode
set nomodeline      " modelines are a potential security hole
set ignorecase      " ignore case in searches
set smartcase       " do case-sensitive searches if the search term includes uppercase letters
set grepprg=ag      " use the silver searcher for grep commands
set iskeyword+=-    " treat dashes as part of words, not as separators

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

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

map <silent>\ :nohlsearch<CR> " clear search highlighting by pressing \

let mapleader = ","

map <Leader>gs :Gstatus<CR>

" Run rspec using thoughtbot/vim-rspec and tpope/dispatch.
" Use binstub if available
if executable("bin/rspec")
  let b:rspec_executable = "bin/rspec"
else
  let b:rspec_executable = "bundle exec rspec"
end
let g:rspec_command = "Dispatch " . b:rspec_executable . " {spec} --format=progress"

map <Leader>r :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Project search
map <Leader>m :Ack<CR>
map <Leader>/ :Ack<Space>

" File search
map <Leader>t :CtrlP<CR>
map <Leader>p :CtrlP<CR>
map <Leader>b :CtrlPBuffer<CR>
let g:ctrlp_by_filename = 1

" Quickfix lists
map <Leader>q :cclose<CR>   " close the quickfix window

" Disable the arrow keys:
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" Disable backspace in normal mode - it's a bad habit
noremap <BS> <Nop>

" statusline highlighting groups:
hi warningmsg ctermbg=red ctermfg=black
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

" Syntax checking
let g:syntastic_always_populate_loc_list = 1  " populate the location list on each save
let g:syntastic_auto_loc_list = 1             " automatically open and close the location list
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_open = 1             " run checks on open, not just on save
let g:syntastic_check_on_wq = 0               " don't run checks on exit
let g:syntastic_auto_jump = 1                 " always jump the cursor to the first issue

" Plugins with unbundle:
filetype off
runtime bundle/vim-unbundle/plugin/unbundle.vim

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

augroup vimrcEx
  autocmd!

  " For all text and markdown files set 'textwidth' to 78 characters.
  autocmd FileType text,markdown,help setlocal textwidth=78

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

augroup gitcommit
  " Start typing straight away in commit messages
  autocmd!
  autocmd BufReadPost COMMIT_EDITMSG exe 'normal gg' | startinsert!

  " add spellchecking and automatic wrapping at the recommended 72 columns to commit messages.
  autocmd Filetype gitcommit setlocal spell textwidth=72
augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    \ | wincmd p | diffthis
endif

autocmd Filetype php setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Whitespace highlighting
set list
set listchars=trail:·,tab:¬·

" Automatically delete trailing whitespace for certain filetypes
augroup whitespace
  autocmd!
  autocmd FileType ruby,haml,javascript,php,markdown,vim,help,sh,conf autocmd BufWritePre <buffer> :%s/\s\+$//e
augroup END

" Delete trailing whitespace by pressing f5
:nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
