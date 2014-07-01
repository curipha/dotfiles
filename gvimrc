"
" .gvimrc (2014-6-14)
"

scriptencoding utf-8

" Variables {{{
let s:iswin  = has('win32') || has('win64')
let s:ismac  = has('mac')
let s:isunix = has('unix') || has('win32unix')
"}}}
" Font {{{
if s:iswin
  set guifont=MigMix_2M:h10:cSHIFTJIS
  set renderoptions=type:directx,renmode:5
  set linespace=1
elseif s:ismac
  set guifont=MigMix_2M:h10
elseif s:isunix
  set guifont=MigMix\ 2M\ 10
endif
"}}}
" GUI {{{
colorscheme desert

set guioptions=aegi
set visualbell t_vb=

highlight IdeographicSpace gui=underline guifg=lightblue
autocmd MyAutoCmd VimEnter,WinEnter * match IdeographicSpace /　/


set title
set titlelen=80
set titlestring=%t\ %m%r\ \(%<%{expand('%:p:h')}\)\ -\ GVim

if has('vim_starting')
  set columns=128
  set lines=32
endif

set cmdheight=1

set mouse=a
set mousehide
set nomousefocus

set winaltkeys=no
"}}}

