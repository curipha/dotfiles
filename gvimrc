" ===============
"  .gvimrc
" ===============

scriptencoding utf-8

" Variables
let s:iswin  = has('win32')
let s:isunix = has('unix')

" Environment specific
if s:iswin
  set guifont=Consolas:h10:cANSI
  set guifontwide=Cica:h10:cSHIFTJIS
  set renderoptions=type:directx,renmode:5,taamode:1
  set linespace=2
elseif s:isunix
  set guifont=Source\ Han\ Mono\ 10
  set guifontwide=Source\ Han\ Mono\ 10
endif

" GUI
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
