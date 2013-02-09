" Vim plugin for opening resources through the shell (paths, URLS, and emails)
" Maintainer: Evan Shelhamer
" Version: 0.1
" Url: http://github.com/shelhamer/vim-open/

" Match known resource type at cursor and open
function! open#open_at_cursor()
  let cword = expand('<cWORD>')
  " check for path (for further expansion)
  if matchstr(getline('.'), '\[[^\]]\+]') != ''
    " capture text in delimiters around cursor
    let l = line('.')
    let c = col('.')
    norm vi[y
    let resource = expand(getreg('0'))
    " undo side effects
    call setreg('0','')
    call cursor(l,c)
  " urls/emails work as is
  else
    let resource = cword
  end
  call open#open_resource(resource)
endfunction

" open resource w/ default handler for the shell (paths, URLs, and emails)
function! open#open_resource(resource)
  " URL
  if matchstr(a:resource, '\<\(\w\+://\)\(\S*\w\)\+/\?') != ''
    call open#shell_open(a:resource)
  " email
  elseif matchstr(a:resource, '\%(\p\|\.\|_\|-\|+\)\+@\%(\p\+\.\)\p\+') != ''
    call open#shell_open('mailto:' . a:resource)
  " path
  else
    " check exists/readable
    if !(isdirectory(a:resource) || filereadable(a:resource))
      echo "shell: " . a:resource . " couldn't be opened."
    else
      call open#shell_open(a:resource)
    endif
  endif
endfunction

" open on the osx shell
function! open#shell_open(resource)
  silent exec '!open ' . shellescape(a:resource)
endfunction

" syntax highlighting for files, urls, and emails
function! open#highlight_resources()
  syntax match noteFilePath /\[[^\]]\+\]/
  hi def link noteFilePath Label

  syntax match noteURL @\<\(\w\+://\)\(\S*\w\)\+/\?@
  hi def link noteUrl Label

  syntax match noteMail /\%(\p\|\.\|_\|-\|+\)\+@\%(\p\+\.\)\p\+/
  hi def link noteMail Label
endfunction
