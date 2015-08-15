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

set guioptions& guioptions+=M

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
\   if empty(&l:filetype) && empty(&l:buftype) && empty(expand('<afile>'))
\ |   setfiletype markdown
\ | endif
autocmd MyAutoCmd BufWritePost *
\   if &l:filetype ==# 'markdown' && expand('%:e') !=# 'md'
\ |   filetype detect
\ | endif
" }}}

" Edit {{{
set fileencodings=ucs-bom,utf-8
if has('guess_encode')
  set fileencodings^=guess
endif

set fileformat=unix
set fileformats=unix,dos

set wildmenu
set wildchar=<tab>
set wildmode=list:full
set wildignorecase
set infercase
set browsedir=buffer
set isfname& isfname-==

set wildignore=*.o,*.so,*.obj,*.exe,*.dll,*.lib,*.luac,*.pyc,*.zwc,*.jar,*.class,*.dvi
set wildignore+=*.bmp,*.gif,*.jpg,*.png
set wildignore+=*.tar,*.bz2,*.gz,*.xz,*.7z,*.zip
set wildignore+=*.sw?,*.?~,*.??~,*.???~,*.~
set wildignore+=*/.git/*
set wildignore+=*/$RECYCLE.BIN/*,*/System\ Volume\ Information/*
set suffixes=.bak,.tmp,.out,.aux,.toc

set history=100
set undolevels=4000

set modeline modelines=3

set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~

set nojoinspaces
set formatoptions& formatoptions+=mMj
autocmd MyAutoCmd FileType * setlocal formatoptions-=ro

set textwidth=0
set wrapmargin=0

set nobackup
set nowritebackup
set noswapfile
set noundofile
set viminfo=

set hidden
set switchbuf& switchbuf+=useopen

set autoindent smartindent
autocmd MyAutoCmd FileType html,xhtml,xml,xslt setlocal indentexpr=

set smarttab
set expandtab shiftround
set tabstop=2
set shiftwidth=2
set softtabstop=0

set complete& complete+=d
set pumheight=18

autocmd MyAutoCmd FileType *commit*,markdown setlocal spell spelllang=en_us,cjk
autocmd MyAutoCmd FileType diff,qf,xxd       setlocal nospell
nnoremap <silent> <Leader>c :<C-u>setlocal spell! spell? spelllang=en_us,cjk<CR>
nnoremap <silent> <Leader>z 1z=

set clipboard=unnamed,autoselect
set nrformats=alpha,hex
set virtualedit=block

nnoremap <F1>  <Esc>
inoremap <C-c> <Esc>

nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q  <Nop>
nnoremap qq <Nop>

nnoremap q: :q

nnoremap ; :
vnoremap ; :

inoremap jj <Esc>
onoremap jj <Esc>
inoremap kk <Esc>
onoremap kk <Esc>

xnoremap <silent> . :<C-u>normal .<CR>

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
vnoremap <Down> gj
vnoremap <Up>   gk

nnoremap <CR>  O<Esc>
nnoremap <Tab> %
nnoremap R     gR
nnoremap Y     y$

nnoremap J  mzJ`z
nnoremap gJ mzgJ`z

nnoremap p p`]
vnoremap p p`]
vnoremap y y`]

xnoremap >       >gv
xnoremap <       <gv
xnoremap <Tab>   >gv
xnoremap <S-Tab> <gv

vnoremap <silent> <Leader>m :sort<CR>
vnoremap <silent> <Leader>u :sort u<CR>

inoremap <C-z> <Esc>ui
cnoremap <C-z> :<C-u>suspend<CR>

inoremap <C-t> <C-v><Tab>

inoremap <C-v>        <C-r><C-o>*
inoremap <RightMouse> <C-r><C-o>*
cnoremap <RightMouse> <C-r><C-o>*
nnoremap <RightMouse> "*p

nnoremap <Space>   <C-d>
nnoremap <S-Space> <C-u>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

nnoremap <expr> 0 col('.') ==# 1 ? '^' : '0'

nnoremap gf :<C-u>vertical wincmd f<CR>
autocmd MyAutoCmd FileType html,xhtml setlocal path& path+=;/

nnoremap gI `.a
nnoremap gc `[v`]
vnoremap gc :<C-u>normal `[v`]<CR>

nnoremap vv ggVG
vnoremap v  V

nnoremap <silent> <Leader>o :<C-u>only<CR>
nnoremap <silent> <Leader>w :<C-u>update<CR>

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

autocmd MyAutoCmd BufNewFile,BufReadPost *.md setfiletype=markdown

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
\   if empty(&l:omnifunc)
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif

if has('xim') && has('GUI_GTK')
  set imactivatekey=Zenkaku_Hankaku
endif
if has('multi_byte_ime') || has('xim')
  set noimcmdline
  set iminsert=0 imsearch=0

  augroup MyAutoCmd
    "autocmd InsertEnter,CmdwinEnter * set noimdisable
    "autocmd InsertLeave,CmdwinLeave * set imdisable
    autocmd InsertLeave,CmdwinLeave * set iminsert=0
  augroup END
endif

set pastetoggle=<F12>
nnoremap <silent> <F12> :<C-u>set paste<CR>i
autocmd MyAutoCmd InsertLeave * set nopaste

autocmd MyAutoCmd BufEnter,BufFilePost *
\   if empty(&l:buftype) && isdirectory(expand('%:p:h'))
\ |   execute ':lcd ' . fnameescape(expand('%:p:h'))
\ | endif

autocmd MyAutoCmd FileType ruby compiler ruby
autocmd MyAutoCmd BufWritePost,FileWritePost *.rb silent make -cw % | redraw!

autocmd MyAutoCmd BufReadPost *
\   if &l:binary && executable('xxd')
\ |   setlocal filetype=xxd
\ |   setlocal noendofline
\ | endif
autocmd MyAutoCmd BufReadPost *
\   if &l:binary && &l:filetype ==# 'xxd'
\ |   execute 'silent %!xxd -g 1'
\ | endif
autocmd MyAutoCmd BufWritePre *
\   if &l:binary && &l:filetype ==# 'xxd'
\ |   execute '%!xxd -r'
\ | endif
autocmd MyAutoCmd BufWritePost *
\   if &l:binary && &l:filetype ==# 'xxd'
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
set hlsearch incsearch
set ignorecase smartcase
set wrapscan

set grepprg=internal

autocmd MyAutoCmd QuickFixCmdPost make,*grep*
\   if len(getqflist()) ==# 0
\ |   cclose
\ | else
\ |   cwindow
\ | endif

autocmd MyAutoCmd WinLeave *
\   let b:vimrc_pattern  = @/
\ | let b:vimrc_hlsearch = &hlsearch
autocmd MyAutoCmd WinEnter *
\   let @/ = get(b:, 'vimrc_pattern', @/)
\ | let &hlsearch = get(b:, 'vimrc_hlsearch', &hlsearch)

nmap <silent> <Esc><Esc> :<C-u>nohlsearch<CR><Esc>

nnoremap / /\v
nnoremap ? ?\v

vnoremap <silent> * y/<C-r>=escape(@", '\\/.*$^~[]')<CR><CR>

nnoremap *  g*N
nnoremap #  g#N
nnoremap g* *N
nnoremap g# #N

nnoremap <expr> n (exists('v:searchforward') ? v:searchforward : 1) ? 'nzv' : 'Nzv'
nnoremap <expr> N (exists('v:searchforward') ? v:searchforward : 1) ? 'Nzv' : 'nzv'
vnoremap <expr> n (exists('v:searchforward') ? v:searchforward : 1) ? 'nzv' : 'Nzv'
vnoremap <expr> N (exists('v:searchforward') ? v:searchforward : 1) ? 'Nzv' : 'nzv'

cnoremap <expr> / getcmdtype() ==# '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() ==# '?' ? '\?' : '?'

nnoremap <Leader>s :<C-u>%s!\v!!g<Left><Left><Left>
vnoremap <Leader>s :s!\v!!g<Left><Left><Left>
" }}}
" Display {{{
set notitle noruler
set number norelativenumber
nnoremap <silent> <Leader>n :<C-u>setlocal relativenumber! relativenumber?<CR>

set showcmd showmode
set laststatus=2

set showtabline=2
set tabpagemax=32

set statusline=%t\ %m%r%y%<
set statusline+=[%{empty(&fileencoding)?&encoding:&fileencoding}%{&bomb?':bom':''}]
set statusline+=[%{&fileformat}]%{empty(&binary)?'':'[binary]'}
set statusline+=\ \(%{expand('%:p:h')}\)\ %=[U+%04B]\ %3v\ \ %3l/%3L\ \(%P\)

if has('gui_running')
  set cursorline
endif
autocmd MyAutoCmd WinLeave *
\   let b:vimrc_cursorline = &l:cursorline
\ | setlocal nocursorline
autocmd MyAutoCmd WinEnter *
\   let &l:cursorline = get(b:, 'vimrc_cursorline', &l:cursorline)

set nowrap
autocmd MyAutoCmd FileType markdown setlocal wrap
nnoremap <silent> <Leader>l :<C-u>setlocal wrap! wrap?<CR>

if has('linebreak')
  set linebreak

  set breakindent breakindentopt=min:42,shift:0,sbr
  set showbreak=..
endif

set scrolloff=4 sidescrolloff=12
set sidescroll=1

set splitbelow splitright
set noequalalways
autocmd MyAutoCmd VimResized * wincmd =

set diffopt=filler,context:3,vertical
autocmd MyAutoCmd InsertLeave *
\   if &l:diff
\ |   diffupdate
\ | endif
autocmd MyAutoCmd WinEnter *
\   if winnr('$') ==# 1 && getbufvar(winbufnr(0), '&l:diff') ==# 1
\ |   diffoff
\ | endif

nnoremap <silent> [w :<C-u>wincmd W<CR>
nnoremap <silent> ]w :<C-u>wincmd w<CR>
nnoremap <silent> [W :<C-u>wincmd t<CR>
nnoremap <silent> ]W :<C-u>wincmd b<CR>

nnoremap <silent> <S-Left>  :<C-u>wincmd ><CR>
nnoremap <silent> <S-Right> :<C-u>wincmd <<CR>
nnoremap <silent> <S-Up>    :<C-u>wincmd +<CR>
nnoremap <silent> <S-Down>  :<C-u>wincmd -<CR>

for [s:k, s:p] in [['b', 'b'], ['t', 'tab'], ['q', 'c']]
  execute 'nnoremap <silent> [' . s:k . ' :' . s:p . 'previous<CR>'
  execute 'nnoremap <silent> ]' . s:k . ' :' . s:p . 'next<CR>'
  execute 'nnoremap <silent> [' . toupper(s:k) . ' :<C-u>' . s:p . 'first<CR>'
  execute 'nnoremap <silent> ]' . toupper(s:k) . ' :<C-u>' . s:p . 'last<CR>'
endfor

nnoremap <silent> <C-p> :tabprevious<CR>
nnoremap <silent> <C-n> :tabnext<CR>

nnoremap <silent> tt :<C-u>tabnew<CR>

set display=uhex
set list listchars=tab:>.,trail:_,extends:>,precedes:<
set fillchars=fold:\ 

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

nnoremap zl mzzMzvzz`z

autocmd MyAutoCmd FileType css                 setlocal foldmethod=marker foldmarker={,}
autocmd MyAutoCmd FileType *commit*,diff,xxd   setlocal nofoldenable
autocmd MyAutoCmd FileType html,xhtml,xml,xslt nnoremap <buffer> <Leader>f Vatzf

set lazyredraw
set ttyfast
set visualbell t_vb=

set notimeout
set ttimeout
set timeoutlen=100

set shortmess=aoOTI
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
        \ 'edit<bang> ++encoding='.s:e '<args>'
endfor
for s:f in ['dos', 'unix', 'mac']
  execute 'command! -bang -nargs=0'
        \ substitute(toupper(s:f[0]).tolower(s:f[1:]), '\W', '', 'g')
        \ 'edit<bang> ++fileformat='.s:f '<args>'
endfor

command! -bar PluginUpdate call s:plugin_update()
function! s:plugin_update()
  if executable('git')
    let l:pwd = getcwd()

    for l:path in split(&runtimepath, ',')
      if isdirectory(l:path . '/.git')
        echohl WarningMsg
        echomsg '* Updating:' l:path
        echohl None

        execute 'lcd' fnameescape(l:path)
        silent let l:result = system('git stash save && git fetch && git reset --hard FETCH_HEAD && git gc --quiet')
        echo l:result
      endif
    endfor

    if exists('l:result')
      silent! runtime! ftdetect/**/*.vim
      silent! runtime! after/ftdetect/**/*.vim
      silent! runtime! plugin/**/*.vim
      silent! runtime! after/plugin/**/*.vim

      execute 'lcd' fnameescape(l:pwd)
    else
      echomsg 'Nothing to update.'
    endif
  else
    echohl ErrorMsg
    echomsg 'Install Git before running this command.'
    echohl None
  endif
endfunction
" }}}
" Abbreviation {{{
inoreabbrev <expr> #! '#!/usr/bin/env' . (empty(&l:filetype) ? '' : ' ' . &l:filetype) . "<CR>"

cnoreabbrev bd1  bd!
cnoreabbrev q1   q!
cnoreabbrev qa1  qa!
cnoreabbrev wq1  wq!
cnoreabbrev wqa1 wqa!
" }}}
" Syntax {{{
" autoload/rubycomplete.vim
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1

" syntax/c.vim
let g:c_comment_strings = 1

" syntax/markdown.vim
let g:markdown_fenced_languages = [ 'bash=sh', 'css', 'html', 'javascript', 'ruby', 'sass', 'xml' ]

" syntax/php.vim
let g:php_sql_query = 1
let g:php_htmlInStrings = 1
let g:php_noShortTags = 1

" syntax/sh.vim
let g:is_bash = 1
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
" }}}

set secure

