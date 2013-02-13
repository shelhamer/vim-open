" Vim plugin for opening resources through the shell (paths, URLS, and emails)
" Maintainer: Evan Shelhamer
" Version: 0.1
" Url: http://github.com/shelhamer/vim-open/

" Match known resource type at cursor and open
function! open#open_at_cursor()
  let cword = expand('<cWORD>')
  let line = getline('.')
  " check for path (for further expansion)
  if matchstr(line, '\[\[.\{-}\]\]') != ''
    " capture text in delimiters around cursor
    let idx = col('.') - 1
    let idx_start = strridx(line[0:idx], '[[') + 2
    let idx_end  = stridx(line[idx+1:-1], ']]') + idx
    let resource = line[idx_start : idx_end]
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
    let shell_resource = expand(a:resource)
    " check exists/readable
    if !(isdirectory(shell_resource) || filereadable(shell_resource))
      echo "shell: " . shell_resource . " couldn't be opened."
    else
      call open#shell_open(shell_resource)
    endif
  endif
endfunction

" open on the osx shell
function! open#shell_open(resource)
  silent exec '!open ' . shellescape(a:resource)
endfunction

" syntax highlighting for files, urls, and emails
function! open#highlight_resources()
  syntax match noteFilePath @\%(^\|\s\+\)\zs\%(\~\|\.\{1,2}\)\?/\%(\S\+\)@
  syntax match noteFilePath /\%(\[\[\)\@<=.\{-}\%(\]\]\)\@=/
  hi def link noteFilePath Label

  syntax match noteURL @\<\(\w\+://\)\(\S*\w\)\+/\?@
  hi def link noteUrl Label

  syntax match noteMail /\<\w[^@ \t\r]*\w@\w[^@ \t\r]\+\w\>/
  hi def link noteMail Label
endfunction
