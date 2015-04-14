" ===============
"  .vimrc
" ===============

" Mode {{{
set encoding=utf-8
scriptencoding utf-8

let s:iswin = has('win32') || has('win64')

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

set t_Co=256
set background=dark

let g:mapleader = ','
let g:maplocalleader = ','

if has('vim_starting')
  let s:path_dotvim = s:iswin ? $VIM . '/plugins/*' : $HOME . '/.vim/*'

  for s:path_plugin in glob(s:path_dotvim, 1, 1)
    if s:path_plugin !~# '\~$' && isdirectory(s:path_plugin)
      let &runtimepath .= ',' . s:path_plugin
    endif
  endfor
endif

syntax enable
filetype plugin indent on

autocmd MyAutoCmd BufNewFile * setfiletype markdown
autocmd MyAutoCmd BufEnter *
\   if empty(expand('<afile>'))
\ |   setfiletype markdown
\ | endif
" }}}

" Edit {{{
set fileencodings=ucs-bom,utf-8
set fileformat=unix
set fileformats=unix,dos,mac

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
set wildignore+=*/.git/*,*/.svn/*
set wildignore+=*/$RECYCLE.BIN/*,*/System\ Volume\ Information/*
set suffixes=.bak,.tmp,.out,.aux,.dvi,.toc

set history=100
set undolevels=4000

set modeline
set modelines=3

set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~

set nojoinspaces
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

autocmd MyAutoCmd FileType *commit*,markdown setlocal spell spelllang=en_us,cjk
autocmd MyAutoCmd FileType diff,qf,xxd       setlocal nospell
nnoremap <silent> <Leader>c :<C-u>setlocal spell! spell?<CR>

set clipboard=unnamed,autoselect
set nrformats=alpha,hex
set virtualedit=block
set cryptmethod=blowfish

nnoremap <F1> <Esc>
nnoremap ZZ   <Nop>
nnoremap ZQ   <Nop>
nnoremap Q    <Nop>

nnoremap q: :q

nnoremap ; :
vnoremap ; :

inoremap jj <Esc>
onoremap jj <Esc>
inoremap kk <Esc>
onoremap kk <Esc>

vnoremap . :<C-u>normal .<CR>

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

nnoremap J  mzJ`z
nnoremap gJ mzgJ`z

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

nnoremap gf :vertical wincmd f<CR>

nnoremap gc `[v`]
vnoremap gc :<C-u>normal `[v`]<CR>

nnoremap vv ggVG
nnoremap vV ^v$h

nnoremap <Leader>e :<C-u>e ++enc=
nnoremap <Leader>o :<C-u>only<CR>
nnoremap <Leader>r :<C-u>registers<CR>
nnoremap <Leader>w :<C-u>update<CR>

inoremap , ,<Space>

for s:p in ['""', '''''', '``', '()', '<>', '[]', '{}']
  execute 'inoremap ' . s:p . ' ' . s:p . '<Left>'
  execute 'cnoremap ' . s:p . ' ' . s:p . '<Left>'
endfor

autocmd MyAutoCmd FileType ruby inoremap <buffer> {\|\| {\|\|<Left>
autocmd MyAutoCmd FileType ruby inoremap <buffer> %q %q!!<Left>
autocmd MyAutoCmd FileType ruby inoremap <buffer> %r %r!!<Left>
autocmd MyAutoCmd FileType ruby inoremap <buffer> %w %w()<Left>
autocmd MyAutoCmd FileType ruby inoremap <buffer> // //<Left>
autocmd MyAutoCmd FileType autohotkey,dosbatch inoremap <buffer> %% %%<Left>

autocmd MyAutoCmd FileType ruby     inoremap <buffer> :// ://
autocmd MyAutoCmd FileType markdown inoremap <buffer> ``` ```

autocmd MyAutoCmd FileType html,xhtml,xml,xslt,php inoremap <buffer> </ </<C-x><C-o>

for s:p in ['(', ')', '[', ']', '{', '}', ',']
  execute 'onoremap ' . s:p . ' t' . s:p
  execute 'vnoremap ' . s:p . ' t' . s:p
endfor
for [s:k, s:p] in [['a', '>'], ['r', ']'], ['q', ''''], ['d', '"']]
  execute 'onoremap a' . s:k . ' a' . s:p
  execute 'vnoremap a' . s:k . ' a' . s:p
  execute 'onoremap i' . s:k . ' i' . s:p
  execute 'vnoremap i' . s:k . ' i' . s:p
endfor

autocmd MyAutoCmd BufNewFile,BufReadPost *.md setlocal filetype=markdown

autocmd MyAutoCmd FileType vim setlocal keywordprg=:help

autocmd MyAutoCmd FileType c          setlocal omnifunc=ccomplete#Complete
autocmd MyAutoCmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
autocmd MyAutoCmd FileType html,xhtml,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd MyAutoCmd FileType java       setlocal omnifunc=javacomplete#Complete
autocmd MyAutoCmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd MyAutoCmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
autocmd MyAutoCmd FileType python     setlocal omnifunc=pythoncomplete#Complete
autocmd MyAutoCmd FileType ruby       setlocal omnifunc=rubycomplete#Complete
"autocmd MyAutoCmd FileType sql        setlocal omnifunc=sqlcomplete#Complete
autocmd MyAutoCmd FileType xml,xslt   setlocal omnifunc=xmlcomplete#CompleteTags

autocmd MyAutoCmd FileType *
\   if empty(&omnifunc)
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif

if has('xim') && has('GUI_GTK')
  set imactivatekey=Zenkaku_Hankaku
endif
if has('multi_byte_ime') || has('xim')
  set noimcmdline
  set iminsert=0
  set imsearch=0

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

autocmd MyAutoCmd BufEnter,BufFilePost *
\   if isdirectory(expand('%:p:h')) && &filetype !=# 'help'
\ |   execute ':lcd ' . fnameescape(expand('%:p:h'))
\ | endif

autocmd MyAutoCmd FileType ruby compiler ruby
autocmd MyAutoCmd BufWritePost,FileWritePost *.rb silent make -cw % | redraw!

autocmd MyAutoCmd BufReadPost *
\   if &binary && executable('xxd')
\ |   setlocal filetype=xxd
\ |   setlocal noendofline
\ | endif
autocmd MyAutoCmd BufReadPost *
\   if &binary && &filetype ==# 'xxd'
\ |   execute 'silent %!xxd -g 1'
\ | endif
autocmd MyAutoCmd BufWritePre *
\   if &binary && &filetype ==# 'xxd'
\ |   execute '%!xxd -r'
\ | endif
autocmd MyAutoCmd BufWritePost *
\   if &binary && &filetype ==# 'xxd'
\ |   execute 'silent %!xxd -g 1'
\ |   setlocal nomodified
\ | endif

autocmd MyAutoCmd BufWritePre *
\   let b:dir = expand('<afile>:p:h')
\ | if !isdirectory(b:dir)
\ |   if v:cmdbang || input(printf('"%s" does not exist. Create? [y/N]: ', b:dir)) =~? '^y\%[es]$'
\ |     call mkdir(iconv(b:dir, &encoding, &termencoding), 'p')
\ |   endif
\ | endif
autocmd MyAutoCmd BufWriteCmd *[,*]
\   let b:file = expand('<afile>')
\ | if input(printf('Write to "%s". OK? [y/N]: ', b:file)) =~? '^y\%[es]$'
\ |   execute 'write' . (v:cmdbang ? '!' : '') fnameescape(b:file)
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

autocmd MyAutoCmd QuickFixCmdPost make,*grep*
\   if len(getqflist()) == 0
\ |   cclose
\ | else
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

vnoremap <silent> * y/<C-r>=escape(@", '\\/.*$^~[]')<CR><CR>

nnoremap * g*zz
nnoremap # g#zz

nnoremap <expr> n (exists('v:searchforward') ? v:searchforward : 1) ? 'nzv' : 'Nzv'
nnoremap <expr> N (exists('v:searchforward') ? v:searchforward : 1) ? 'Nzv' : 'nzv'
vnoremap <expr> n (exists('v:searchforward') ? v:searchforward : 1) ? 'nzv' : 'Nzv'
vnoremap <expr> N (exists('v:searchforward') ? v:searchforward : 1) ? 'Nzv' : 'nzv'

cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

nnoremap <Leader>s :<C-u>%s!\v!!g<Left><Left><Left>
vnoremap <Leader>s :s!\v!!g<Left><Left><Left>
" }}}
" Display {{{
set notitle
set noruler
set number
nnoremap <silent> <Leader>n :<C-u>setlocal relativenumber! relativenumber?<CR>

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
nnoremap <silent> <Leader>l :<C-u>setlocal wrap! wrap?<CR>

if has('linebreak')
  set showbreak=...\ 
endif

set scrolloff=5
set sidescroll=1
set sidescrolloff=20
nnoremap <Space>   <C-d>
nnoremap <S-Space> <C-u>

set splitbelow
set splitright
set noequalalways
autocmd MyAutoCmd VimResized * wincmd =

set diffopt=filler,context:3,vertical
autocmd MyAutoCmd WinEnter *
\   if winnr('$') == 1 && getbufvar(winbufnr(0), '&diff') == 1
\ |   diffoff
\ | endif

nnoremap <silent> [w <C-w>W
nnoremap <silent> ]w <C-w>w
nnoremap <silent> [W <C-w>t
nnoremap <silent> ]W <C-w>b

for [s:k, s:p] in [['b', 'b'], ['t', 'tab'], ['q', 'c']]
  execute 'nnoremap <silent> [' . s:k . ' :' . s:p . 'previous<CR>'
  execute 'nnoremap <silent> ]' . s:k . ' :' . s:p . 'next<CR>'
  execute 'nnoremap <silent> [' . toupper(s:k) . ' :<C-u>' . s:p . 'first<CR>'
  execute 'nnoremap <silent> ]' . toupper(s:k) . ' :<C-u>' . s:p . 'last<CR>'
endfor

nnoremap <silent> <C-p> :tabprevious<CR>
nnoremap <silent> <C-n> :tabnext<CR>

nnoremap <silent> tt :<C-u>tabe<CR>

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
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

autocmd MyAutoCmd FileType css            setlocal foldmethod=marker foldmarker={,}
autocmd MyAutoCmd FileType diff,gitcommit setlocal nofoldenable
autocmd MyAutoCmd FileType html,xhtml,xml,xslt nnoremap <buffer> <Leader>f Vatzf

set lazyredraw
set ttyfast
set visualbell t_vb=

set notimeout
set ttimeout
set timeoutlen=100

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
" Abbreviation {{{
iabbrev <expr> #! '#!/usr/bin/env' . (empty(&filetype) ? '' : ' ' . &filetype) . "<CR>"
" }}}
" Syntax {{{
" autoload/rubycomplete.vim
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" syntax/php.vim
let g:php_sql_query = 1
let g:php_htmlInStrings = 1
let g:php_noShortTags = 1
" }}}
" Plugin {{{
" neocomplete {{{
"  - https://github.com/Shougo/neocomplete.vim
let g:neocomplete#enable_at_startup = has('lua')

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

