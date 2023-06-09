if bufname('%') == "idris-response"
  finish
endif

if exists("b:did_ftplugin")
  finish
endif

setlocal shiftwidth=2
setlocal tabstop=2
if !exists("g:idris_allow_tabchar") || g:idris_allow_tabchar == 0
	setlocal expandtab
endif
setlocal comments=s1:{-,mb:-,ex:-},:\|\|\|,:--
setlocal commentstring=--%s
setlocal iskeyword+=?
setlocal wildignore+=*.ibc

let idris_response = 0
let b:did_ftplugin = 1

function! IdrisDocFold(lineNum)
  let line = getline(a:lineNum)

  if line =~ "^\s*|||"
    return "1"
  endif

  return "0"
endfunction

function! IdrisFold(lineNum)
  return IdrisDocFold(a:lineNum)
endfunction

setlocal foldmethod=expr
setlocal foldexpr=IdrisFold(v:lnum)

function! IdrisResponseWin()
  if (!bufexists("idris-response"))
    botright 10split
    badd idris-response
    b idris-response
    let g:idris_respwin = "active"
    set buftype=nofile
    wincmd k
  elseif (bufexists("idris-response") && g:idris_respwin == "hidden")
    botright 10split
    b idris-response
    let g:idris_respwin = "active"
    wincmd k
  endif
endfunction

function! IdrisHideResponseWin()
  let g:idris_respwin = "hidden"
endfunction

function! IdrisShowResponseWin()
  let g:idris_respwin = "active"
endfunction

au BufHidden idris-response call IdrisHideResponseWin()
au BufEnter idris-response call IdrisShowResponseWin()
