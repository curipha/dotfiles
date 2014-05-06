"
" .vimrc (2014-4-13)
"

" Mode {{{
set nocompatible
scriptencoding utf-8

let s:iswin  = has('win32') || has('win64')

if s:iswin
  language message en

  set shellslash
  set termencoding=cp932
else
  language message C
endif

augroup MyAutoCmd
  autocmd!
augroup END

syntax enable
filetype plugin indent on

set t_Co=256
set background=dark

let mapleader = ','
let maplocalleader = ','

if has('vim_starting')
  if s:iswin
    let s:path_dotvim = $VIM . '/plugins/*'
  else
    let s:path_dotvim = $HOME . '/.vim/*'
  endif

  for s:path_plugin in split(glob(s:path_dotvim), '\n')
    if s:path_plugin !~# '\~$' && isdirectory(s:path_plugin)
      let &runtimepath = &runtimepath . ',' . s:path_plugin
    end
  endfor
endif
" }}}
" Encoding {{{
set encoding=utf-8

let s:enc_jis = 'iso-2022-jp'
let s:enc_euc = 'euc-jp'
let s:guess   = has('guess_encode') ? ',guess,' :  ','

if has('iconv')
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_jis = 'iso-2022-jp-3'
    let s:enc_euc = 'euc-jisx0213,euc-jp'
  endif
endif

let &fileencodings = 'ucs-bom,' . s:enc_jis . s:guess . s:enc_euc . ',cp932,utf-8'

autocmd MyAutoCmd BufReadPost *
\   if &fileencoding =~# 'iso-2022-jp' && search('[^\x00-\x7f]', 'cnw') == 0
\ |   let &fileencoding = 'utf-8'
\ | endif

set fileformat=unix
set fileformats=unix,dos,mac
" }}}

" Edit {{{
set wildmenu
set wildchar=<tab>
set wildmode=list:full
set wildignorecase
set infercase
set browsedir=buffer

set wildignore=*.o,*.so,*.obj,*.exe,*.dll,*.pyc,*.jar,*.class
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.bz2,*.gz,*.tar,*.xz,*.zip
set wildignore+=*.sw?,*.?~,*.??~,*.???~,*.~
set wildignore+=.git/*,.svn/*
set suffixes=.bak,.tmp,.out,.aux,.dvi,.toc

set history=100
set undolevels=4000

set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~

set formatoptions& formatoptions+=mMj
autocmd MyAutoCmd FileType * setlocal formatoptions-=ro

set nobackup
set nowritebackup
set noswapfile
set noundofile
set viminfo=

set hidden
set switchbuf& switchbuf+=useopen

set autoindent
set smartindent

autocmd MyAutoCmd FileType html,xhtml,xml,xslt setlocal indentexpr=
autocmd MyAutoCmd FileType html,xhtml setlocal path& path+=;/

set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set shiftround
set softtabstop=0

set complete=.,w,b,u,t,i,d,]
set pumheight=18

set clipboard=unnamed,autoselect
set nrformats=alpha,hex
set virtualedit=block
set cryptmethod=blowfish

nnoremap <F1> <Nop>
nnoremap ZZ   <Nop>
nnoremap ZQ   <Nop>
nnoremap Q    <Nop>

nnoremap q: :q

nnoremap ; :
vnoremap ; :

inoremap jj <Esc>
onoremap jj <Esc>

vnoremap . :normal .<CR>

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
vnoremap <Down> gj
vnoremap <Up>   gk

nnoremap <Tab> %
vnoremap <Tab> %

xnoremap >       >gv
xnoremap <       <gv
xnoremap <Tab>   >gv
xnoremap <S-Tab> <gv

xnoremap <Leader>m :sort<CR>
xnoremap <Leader>u :sort u<CR>

inoremap <C-t> <C-v><Tab>

inoremap <C-v>        <C-r><C-o>*
inoremap <RightMouse> <C-r><C-o>*
cnoremap <RightMouse> <C-r><C-o>*
nnoremap <RightMouse> "*p

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

nnoremap <CR> O<Esc>
nnoremap Y    y$
nnoremap R    gR

nnoremap <Leader>o :<C-u>only<CR>
nnoremap <Leader>r :<C-u>e ++enc=
nnoremap <Leader>w :<C-u>update<CR>

inoremap , ,<Space>

for s:p in ['""', '''''', '``', '()', '<>', '[]', '{}']
  execute 'inoremap ' . s:p . ' ' . s:p . '<Left>'
  execute 'cnoremap ' . s:p . ' ' . s:p . '<Left>'
endfor

autocmd MyAutoCmd FileType ruby inoremap <buffer> {\|\| {\|\|<Left>
autocmd MyAutoCmd FileType ruby inoremap <buffer> // //<Left>
autocmd MyAutoCmd FileType ruby inoremap <buffer> :// ://
autocmd MyAutoCmd FileType autohotkey,dosbatch inoremap <buffer> %% %%<Left>

autocmd MyAutoCmd FileType html,xhtml,xml,xslt,php inoremap <buffer> </ </<C-x><C-o>

autocmd MyAutoCmd FileType c          setlocal omnifunc=ccomplete#Complete
autocmd MyAutoCmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
autocmd MyAutoCmd FileType html,xhtml,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd MyAutoCmd FileType java       setlocal omnifunc=javacomplete#Complete
autocmd MyAutoCmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd MyAutoCmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
autocmd MyAutoCmd FileType python     setlocal omnifunc=pythoncomplete#Complete
autocmd MyAutoCmd FileType ruby       setlocal omnifunc=rubycomplete#Complete
autocmd MyAutoCmd FileType sql        setlocal omnifunc=sqlcomplete#Complete
autocmd MyAutoCmd FileType xml,xslt   setlocal omnifunc=xmlcomplete#CompleteTags

autocmd MyAutoCmd FileType *
\   if &omnifunc == ''
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif

if has('multi_byte_ime') || has('xim')
  set noimcmdline
  set iminsert=0
  set imsearch=0

  if has('xim') && has('GUI_GTK')
    set imactivatekey=Zenkaku_Hankaku
  endif

  augroup MyAutoCmd
    "autocmd InsertEnter,CmdwinEnter * set noimdisable
    "autocmd InsertLeave,CmdwinLeave * set imdisable
    autocmd InsertLeave,CmdwinLeave * set iminsert=0
  augroup END
endif

"set paste
"autocmd MyAutoCmd FileType * set nopaste
set pastetoggle=<F12>
autocmd MyAutoCmd InsertLeave * set nopaste

autocmd MyAutoCmd BufEnter * execute ':lcd ' . fnameescape(expand('%:p:h'))

autocmd MyAutoCmd BufWriteCmd *[,*]
\   if input('Write to "' . expand('<afile>') . '". OK? [y/N]: ') =~? '^y\%[es]$'
\ |   execute 'write'.(v:cmdbang ? '!' : '') expand('<afile>')
\ | else
\ |   redraw
\ |   echo 'File not saved.'
\ | endif

if !has('gui_running') && !s:iswin
  autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
else
  autocmd MyAutoCmd BufWritePost $MYVIMRC
  \   source $MYVIMRC
  \ | if has('gui_running')
  \ |   source $MYGVIMRC
  \ | endif
  autocmd MyAutoCmd BufWritePost $MYGVIMRC
  \   if has('gui_running')
  \ |   source $MYGVIMRC
  \ | endif
endif
" }}}
" Search {{{
set hlsearch
set incsearch
set wrapscan

set ignorecase
set smartcase

set grepprg=internal

autocmd MyAutoCmd QuickFixCmdPost make,grep,grepadd,vimgrep
\   if len(getqflist()) != 0
\ |   cwindow
\ | endif

autocmd MyAutoCmd WinLeave *
\   let b:vimrc_pattern  = @/
\ | let b:vimrc_hlsearch = &hlsearch
autocmd MyAutoCmd WinEnter *
\   let @/ = get(b:, 'vimrc_pattern', @/)
\ | let &l:hlsearch = get(b:, 'vimrc_hlsearch', &l:hlsearch)

nmap <silent> <Esc><Esc> :<C-u>nohlsearch<CR><Esc>

nnoremap / /\v
nnoremap ? ?\v

nnoremap * g*zz
nnoremap # g#zz

cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

nnoremap <Leader>s :<C-u>%s!\v!!g<Left><Left><Left>
vnoremap <Leader>s :s!\v!!g<Left><Left><Left>
" }}}
" Display {{{
set notitle
set number
set noruler

set laststatus=2
set showcmd
set showmode

set showtabline=2
set tabpagemax=32

set statusline=%<%F\ %m%r%y
set statusline+=[%{&fenc!=''?&fenc:&enc}%{&bomb?':BOM':''}][%{&ff}]
set statusline+=\ %=
set statusline+=[%{&fenc=='utf-8'?'U+':'0x'}%04B]
set statusline+=\ %3v\ \ %3l/%3L\ %P

set nowrap

set scrolloff=5
set sidescroll=1
set sidescrolloff=20
nnoremap <Space>   <C-d>
nnoremap <S-Space> <C-u>

set splitbelow
set splitright
set noequalalways
autocmd MyAutoCmd VimResized * wincmd =

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :<C-u>bfirst<CR>
nnoremap <silent> ]B :<C-u>blast<CR>

nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>
nnoremap <silent> [T :<C-u>tabfirst<CR>
nnoremap <silent> ]T :<C-u>tablast<CR>

set display=uhex
set list listchars=tab:>.,trail:_,extends:>,precedes:<
set showmatch
set matchpairs& matchpairs+=<:>
autocmd MyAutoCmd FileType c,cpp,java setlocal matchpairs+==:;

if exists('&ambiwidth')
  set ambiwidth=double
endif

set foldenable
set foldcolumn=0
set foldmethod=marker
"set foldmethod=syntax

autocmd MyAutoCmd FileType css setlocal foldmethod=marker foldmarker={,}
autocmd MyAutoCmd FileType html,xhtml,xml,xslt nnoremap <buffer> <Leader>f Vatzf

set lazyredraw
set ttyfast
set visualbell t_vb=

set shortmess& shortmess+=I
set report=0
set synmaxcol=270

autocmd MyAutoCmd FileType help nnoremap <buffer> q :<C-u>quit<CR>

highlight IdeographicSpace cterm=underline ctermfg=lightblue
autocmd MyAutoCmd VimEnter,WinEnter * match IdeographicSpace /　/

highlight Pmenu     ctermbg=white ctermfg=darkgray
highlight PmenuSel  ctermbg=blue  ctermfg=white
highlight PmenuSbar ctermbg=black ctermfg=lightblue

highlight StatusLine ctermfg=red ctermbg=white

augroup MyAutoCmd
  autocmd InsertEnter * highlight StatusLine ctermfg=gray ctermbg=black
  autocmd InsertLeave * highlight StatusLine ctermfg=red ctermbg=white
augroup END
" }}}

" Command {{{
command! -bar SSF syntax sync fromstart

for s:e in ['utf-8', 'cp932', 'euc-jp', 'euc-jisx0213', 'iso-2022-jp', 'utf-16le', 'utf-16be']
  execute 'command! -bang -nargs=0'
        \ substitute(toupper(s:e[0]).tolower(s:e[1:]), '\W', '', 'g')
        \ 'edit<bang> ++enc='.s:e '<args>'
endfor
for s:f in ['dos', 'unix', 'mac']
  execute 'command! -bang -nargs=0'
        \ substitute(toupper(s:f[0]).tolower(s:f[1:]), '\W', '', 'g')
        \ 'edit<bang> ++ff='.s:f '<args>'
endfor
" }}}
" Syntax {{{
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

let php_sql_query = 1
let php_htmlInStrings = 1
let php_noShortTags = 1
" }}}
" Plugin {{{
" neocomplete {{{
"  - https://github.com/Shougo/neocomplete.vim
let g:neocomplete#enable_at_startup = 1

if !has('lua')
 let g:neocomplete#enable_at_startup = 0
endif
if exists('g:neocomplete#enable_at_startup') && g:neocomplete#enable_at_startup
  let g:neocomplete#enable_auto_select = 1

  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#enable_fuzzy_completion = 1

  let g:neocomplete#max_list = 80
  let g:neocomplete#max_keyword_width = 50

  let g:neocomplete#auto_completion_start_length = 2
  let g:neocomplete#manual_completion_start_length = 0
  let g:neocomplete#min_keyword_length = 4

  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns._ = '\h\w*'

  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  let g:neocomplete#sources#omni#input_patterns.c    = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#sources#omni#input_patterns.cpp  = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
  let g:neocomplete#sources#omni#input_patterns.php  = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

  inoremap <expr> <C-g> neocomplete#undo_completion()
  inoremap <expr> <C-l> neocomplete#complete_common_string()
  inoremap <expr> <CR>  pumvisible() ? neocomplete#close_popup() : "\<CR>"

  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

  inoremap <expr> <C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr> <BS>  neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr> <C-y> neocomplete#close_popup()
  inoremap <expr> <C-e> neocomplete#cancel_popup()

  inoremap <expr> <Up>   pumvisible() ? neocomplete#cancel_popup()."\<Up>" : "\<Up>"
  inoremap <expr> <Down> pumvisible() ? neocomplete#cancel_popup()."\<Down>" : "\<Down>"
endif
" }}}
" unite.vim {{{
"  - https://github.com/Shougo/unite.vim
"  - http://www.vim.org/scripts/script.php?script_id=3396
let g:unite_enable_start_insert = 0

let g:unite_enable_split_vertically = 1
let g:unite_split_rule = 'rightbelow'
let g:unite_winwidth = 50
let g:unite_winheight = 10

let g:unite_source_file_mru_time_format = '(%m/%d %H:%M) '
let g:unite_source_file_mru_filename_format = ''

let g:unite_source_file_mru_limit = 120
let g:unite_source_directory_mru_limit = 40

let g:unite_source_grep_command = 'grep'
let g:unite_source_grep_default_opts = '-iHn'

nnoremap <Leader>U  :<C-u>Unite<Space>
nnoremap <Leader>ub :<C-u>Unite bookmark<CR>
nnoremap <Leader>uc :<C-u>Unite -no-quit -keep-focus change<CR>
nnoremap <Leader>uf :<C-u>UniteWithBufferDir -auto-preview file<CR>
nnoremap <Leader>uh :<C-u>Unite mapping<CR>
nnoremap <Leader>ui :<C-u>Unite file_include<CR>
nnoremap <Leader>um :<C-u>Unite -auto-preview file_mru<CR>
nnoremap <Leader>ur :<C-u>Unite register<CR>
nnoremap <Leader>uu :<C-u>Unite -auto-preview buffer<CR>

autocmd MyAutoCmd FileType unite setlocal statusline=%<%m%y\ %=\ \ %3l/%3L\ %P

autocmd MyAutoCmd FileType unite imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
autocmd MyAutoCmd FileType unite imap <buffer> jj    <Plug>(unite_insert_leave)

autocmd MyAutoCmd FileType unite inoremap <buffer> <C-l> <C-x><C-u><C-p><Down>
" }}}
" }}}

set secure
