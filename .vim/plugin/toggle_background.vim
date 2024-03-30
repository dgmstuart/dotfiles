" Function to Toggle the background because Tmux doesn't pass it through properly

let s:BACKGROUND_SETTING_FILE = '/tmp/vim_background_setting'

function! ToggleBackground()
  let &background = &background ==# 'dark' ? 'light' : 'dark'
  " save the new setting to a file
  call writefile([&background], s:BACKGROUND_SETTING_FILE)
endfunction

function! ReadBackgroundSetting()
  if filereadable(s:BACKGROUND_SETTING_FILE)
    execute 'set background=' . trim(readfile(s:BACKGROUND_SETTING_FILE)[0])
  endif
endfunction

" Call the function to read the background setting when Vim starts
augroup vimrcEx
  autocmd!
  autocmd VimEnter * call ReadBackgroundSetting()
augroup END

