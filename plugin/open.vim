" Vim plugin for opening resources through the shell (paths, URLS, and emails)
" Maintainer: Evan Shelhamer
" Version: 0.1
" Url: http://github.com/shelhamer/vim-open/

" don't reload
if exists('g:loaded_open')
  finish
end
let g:loaded_open = 1

" open resource at cursor
map <silent> <leader>g :call open#open_at_cursor()<CR>

augroup PluginOpen
  " syntax highlight files, urls, and emails automatically
  autocmd! BufNew,BufRead,Syntax * call open#highlight_resources()
augroup END

" syntax: filepaths, URLs, emails
syntax match OpenFilePath /\[[^\]]\+\]/
hi def link OpenFilePath Label

syntax match OpenURL @\<\(\w\+://\)\(\S*\w\)\+/\?@
hi def link OpenUrl Label

syntax match OpenMail /\%(\p\|\.\|_\|-\|+\)\+@\%(\p\+\.\)\p\+/
hi def link OpenMail Label
