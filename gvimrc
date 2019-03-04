" ===============
"  .gvimrc
" ===============

scriptencoding utf-8

" Variables {{{
let s:iswin  = has('win32')
let s:ismac  = has('mac')
let s:isunix = has('unix') || has('win32unix')
"}}}
" Environment specific {{{
if s:iswin
  set guifont=Consolas:h10:cANSI
  set guifontwide=MigMix_2M:h10:cSHIFTJIS
  set renderoptions=type:directx,renmode:5,taamode:1
  set linespace=2

  let $PATH .= ';C:\cygwin\bin'
elseif s:ismac
  set guifont=MigMix_2M:h10
elseif s:isunix
  set guifont=Fira\ Mono\ 9
  set guifontwide=MigMix\ 2M\ 10
endif
"}}}
" GUI {{{
try
  colorscheme gruvbox
catch
  colorscheme desert
endtry

set guioptions=!ciM
set guicursor=a:blinkon0

set title titlelen=80
set titlestring=%t%(\ %m%r%)\ \(%<%{expand('%:p:h')}\)\ -\ GVim

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

