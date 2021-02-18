" ===============
"  .vimrc
" ===============

" Mode {{{
set encoding=utf-8
scriptencoding utf-8

let s:iswin = has('win32')

if s:iswin
  language message en

  set termencoding=cp932
else
  language message C
endif

augroup MyAutoCmd
  autocmd!
augroup END

if &term =~# '\<256color\>'
  set t_Co=256

" if has('termguicolors')
"   set termguicolors
" endif
endif
set background=dark

if has('vim_starting')
  set guioptions& guioptions+=M
endif

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
" }}}

" Edit {{{
set fileencodings=ucs-bom,utf-8
if has('guess_encode')
  set fileencodings^=guess
endif

set fileformat=unix
set fileformats=unix,dos
set fixendofline

set wildmenu
set wildchar=<tab>
set wildmode=list:longest,full
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
set suffixes=.bak,.tmp,.log,.out,.aux,.toc,.pdf

set history=100
set undolevels=4000

set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~

set nojoinspaces
set formatoptions=qnlmMj
autocmd MyAutoCmd FileType * setlocal formatoptions-=c formatoptions-=o formatoptions-=r formatoptions-=t

set textwidth=0
set wrapmargin=0
autocmd MyAutoCmd FileType * setlocal textwidth=0

set nobackup
set nowritebackup
set noswapfile
set noundofile
set viminfo=

set autoread
set hidden
set switchbuf& switchbuf+=useopen

set autoindent
set smartindent
autocmd MyAutoCmd FileType html,xhtml,xml,xslt setlocal indentexpr=

set smarttab
set expandtab
set shiftround
set tabstop=2
set shiftwidth=2
set softtabstop=0
autocmd MyAutoCmd FileType * setlocal tabstop=2
autocmd MyAutoCmd FileType * setlocal shiftwidth=2
autocmd MyAutoCmd FileType * setlocal softtabstop=0

set complete& complete+=d
set completeopt& completeopt+=menuone
set pumheight=12
set showfulltag

set spelllang=en_us,cjk
set spellsuggest=best,12
autocmd MyAutoCmd FileType *commit*,markdown setlocal spell
autocmd MyAutoCmd FileType diff,qf,xxd       setlocal nospell
nnoremap <silent> <Leader>c :<C-u>setlocal spell! spell?<CR>
nnoremap <silent> <Leader>z 1z=

set clipboard=unnamed
if has('unnamedplus')
  set clipboard+=unnamedplus
endif

set nrformats=alpha,bin,hex
set virtualedit=block

nnoremap <F1>  <Esc>
inoremap <C-c> <Esc>
inoremap <C-@> <Esc>

nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q  <Nop>

nnoremap ! :!

nnoremap ; :
vnoremap ; :
nnoremap <Leader>; ;
vnoremap <Leader>; ;

xnoremap <silent> . :<C-u>normal! .<CR>

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
vnoremap <Down> gj
vnoremap <Up>   gk

nnoremap <CR>  O<Esc>
nnoremap R     gR
nnoremap Y     y$
nnoremap X     "_X
nnoremap x     "_x

nnoremap J  mzJ`z
nnoremap gJ mzgJ`z

nnoremap p p`]
vnoremap p p`]
vnoremap y y`]

inoremap <C-a> <C-g>u<C-a>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

xnoremap >       >gv
xnoremap <       <gv
xnoremap <Tab>   >gv
xnoremap <S-Tab> <gv

vnoremap <silent> <Leader>m :sort<CR>
vnoremap <silent> <Leader>u :sort u<CR>

nnoremap <silent> <Leader>r V:!sh<CR>
vnoremap <silent> <Leader>r :!sh<CR>

vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv

inoremap <expr> <Tab>   pumvisible() ? '<C-n>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<C-h>'
inoremap <expr> <Down>  pumvisible() ? '<C-e><Down>' : '<Down>'
inoremap <expr> <Up>    pumvisible() ? '<C-e><Up>'   : '<Up>'

cnoremap <C-z> :<C-u>suspend<CR>
inoremap <C-l> <C-o><C-l>

inoremap <C-t> <C-v><Tab>

inoremap <C-v>        <C-r><C-o>*
inoremap <RightMouse> <C-r><C-o>*
cnoremap <RightMouse> <C-r><C-o>*
nnoremap <RightMouse> "*p

nnoremap <Space>   <C-d>
nnoremap <S-Space> <C-u>

cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <expr> <C-u> empty(getcmdline()) ? '<C-c>' : '<C-u>'
cnoremap <expr> <C-w> empty(getcmdline()) ? '<C-c>' : '<C-w>'

nnoremap <expr> 0 col('.') ==# 1 ? '^' : '0'

nnoremap gf <C-w>f<C-w>L
vnoremap gf <C-w>f<C-w>L
nnoremap gF <C-w>gf
vnoremap gF <C-w>gf

nnoremap gI `.a
nnoremap gc `[v`]
vnoremap gc :<C-u>normal! `[v`]<CR>

nnoremap vv ggVG
vnoremap v  V

nnoremap <silent> <Leader><Leader> :<C-u>update<CR>

inoremap <Left>  <C-g>U<Left>
inoremap <Right> <C-g>U<Right>

for s:p in ['""', '''''', '``', '()', '<>', '[]', '{}']
  execute 'inoremap ' . s:p . ' ' . s:p . '<C-g>U<Left>'
  execute 'cnoremap ' . s:p . ' ' . s:p . '<Left>'
endfor
inoremap [[]] [[  ]]<C-g>U<Left><C-g>U<Left><C-g>U<Left>
inoremap (()) ((  ))<C-g>U<Left><C-g>U<Left><C-g>U<Left>
inoremap {{}} {{  }}<C-g>U<Left><C-g>U<Left><C-g>U<Left>

inoremap #! #!/usr/bin/env <C-r>=&l:filetype<CR>

autocmd MyAutoCmd FileType ruby inoremap <buffer> {\|\| {\|\|<C-g>U<Left>
autocmd MyAutoCmd FileType ruby inoremap <buffer> %q %q!!<C-g>U<Left>
autocmd MyAutoCmd FileType ruby inoremap <buffer> %r %r!!<C-g>U<Left>
autocmd MyAutoCmd FileType ruby inoremap <buffer> %w %w()<C-g>U<Left>
autocmd MyAutoCmd FileType ruby inoremap <buffer> // //<C-g>U<Left>
autocmd MyAutoCmd FileType autohotkey,dosbatch inoremap <buffer> %% %%<C-g>U<Left>

autocmd MyAutoCmd FileType ruby     inoremap <buffer> :// ://
autocmd MyAutoCmd FileType markdown inoremap <buffer> ``` ```

autocmd MyAutoCmd FileType html,xhtml,xml,xslt,eruby,htmldjango,php,markdown inoremap <buffer> </ </<C-x><C-o><C-y>

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

autocmd MyAutoCmd FileType *
\   if empty(&l:omnifunc)
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif

if has('xim') && has('GUI_GTK')
  set imactivatekey=Zenkaku_Hankaku
endif
if has('multi_byte_ime') || has('xim')
  set noimcmdline
  set iminsert=0
  set imsearch=0

  "autocmd MyAutoCmd InsertEnter,CmdwinEnter * set noimdisable
  "autocmd MyAutoCmd InsertLeave,CmdwinLeave * set imdisable
  autocmd MyAutoCmd InsertLeave,CmdwinLeave * set iminsert=0
endif

autocmd MyAutoCmd InsertLeave * set nopaste

if &term =~# '^xterm' || &term =~# '^screen'
  set t_ti&
  set t_te&

  let &t_ti .= "\e[?2004h"
  let &t_te .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  nnoremap <silent> <Esc>[200~ :<C-u>set paste<CR>i
  vnoremap <silent> <Esc>[200~ c<C-o>:set paste<CR>
  inoremap <silent> <Esc>[200~ <C-o>:set paste<CR>
  cnoremap <silent> <Esc>[200~ <Nop>
  cnoremap <silent> <Esc>[201~ <Nop>
endif

autocmd MyAutoCmd BufEnter,BufFilePost,BufWritePost *
\   if empty(&l:buftype) && isdirectory(expand('%:p:h'))
\ |   execute 'lcd ' fnameescape(expand('%:p:h'))
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

autocmd MyAutoCmd BufWritePost $MYVIMRC,$MYGVIMRC nested
\   source $MYVIMRC
\ | if has('gui_running')
\ |   source $MYGVIMRC
\ | endif
" }}}
" Search {{{
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan

set grepprg=internal
nnoremap <silent> g/ :<C-u>vimgrep /<C-r>//j %<CR>
nnoremap <silent> K  *N:<C-u>vimgrep /<C-r>//j %<CR>
nnoremap <silent> gK g*N:<C-u>vimgrep /<C-r>//j %<CR>

vnoremap <silent> * y/\V<C-r>=escape(@", '/\')<CR><CR>N
vnoremap <silent> K y/\V<C-r>=escape(@", '/\')<CR><CR>N:<C-u>vimgrep /<C-r>//j %<CR>

nnoremap <silent> <C-Up>   :cprevious<CR>zv
nnoremap <silent> <C-Down> :cnext<CR>zv

autocmd MyAutoCmd QuickFixCmdPost make,*grep*
\   if len(getqflist()) ==# 0
\ |   cclose
\ | else
\ |   cwindow
\ | endif
autocmd MyAutoCmd WinEnter *
\   if winnr('$') ==# 1 && getbufvar(winbufnr(0), '&l:buftype') ==# 'quickfix'
\ |   quit
\ | endif

autocmd MyAutoCmd TabLeave *
\   let t:vimrc_pattern  = @/
\ | let t:vimrc_hlsearch = &hlsearch
autocmd MyAutoCmd TabEnter *
\   let @/ = get(t:, 'vimrc_pattern', @/)
\ | let &hlsearch = get(t:, 'vimrc_hlsearch', &hlsearch)

nnoremap <silent> <Leader><Space> :<C-u>nohlsearch<CR>:<C-u>diffupdate<CR>:<C-u>syntax sync fromstart<CR><C-l>

nnoremap / /\v
nnoremap ? ?\v

nnoremap *  *N
nnoremap #  #N
nnoremap g* g*N
nnoremap g# g#N

nnoremap <expr> n (exists('v:searchforward') ? v:searchforward : 1) ? 'nzv' : 'Nzv'
nnoremap <expr> N (exists('v:searchforward') ? v:searchforward : 1) ? 'Nzv' : 'nzv'
vnoremap <expr> n (exists('v:searchforward') ? v:searchforward : 1) ? 'nzv' : 'Nzv'
vnoremap <expr> N (exists('v:searchforward') ? v:searchforward : 1) ? 'Nzv' : 'nzv'

cnoremap <expr> / getcmdtype() ==# '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() ==# '?' ? '\?' : '?'

nnoremap <Leader>s :<C-u>%s!\v!!g<Left><Left><Left>
vnoremap <Leader>s :s!\v!!g<Left><Left><Left>

autocmd MyAutoCmd FileType css  setlocal iskeyword+=-
autocmd MyAutoCmd FileType ruby setlocal iskeyword+=?,!,@-@
" }}}
" Display {{{
set notitle
set noruler
set nonumber

set showcmd
set showmode
set laststatus=2

set showtabline=2
set tabpagemax=32

set tabline=%!g:MyTabline()

function! g:MyTabline() abort
  let labels = map(range(1, tabpagenr('$')), 's:tablabel(v:val)')
  return join(labels, '') . '%T%#TabLineFill#%='
endfunction

function! s:tablabel(nr) abort
  let buflist = tabpagebuflist(a:nr)
  let winnr = tabpagewinnr(a:nr)
  let bufnr = buflist[winnr - 1]

  let flag = ''

  let wincnt = len(buflist)
  if wincnt > 1
    let flag .= wincnt
  endif

  if len(filter(buflist, 'getbufvar(v:val, "&l:modified")')) > 0
    let flag .= '+'
  endif

  let label  = '%' . a:nr . 'T'
  let label .= a:nr == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
  let label .= ' '

  if strlen(flag) > 0
    let label .= flag . ' '
  endif

  let buftype = getbufvar(bufnr, '&l:buftype')
  if empty(buftype)
    let bufname = bufname(bufnr)
    if empty(bufname)
      let label .= '[No Name]'
    else
      let label .= fnamemodify(bufname, ':t')
    endif
  else
    let label .= '[' . buftype . ']'
  endif

  return label . ' '
endfunction

set statusline=%t\ %m%r%y
set statusline+=[%{empty(&fileencoding)?&encoding:&fileencoding}%{&bomb?':bom':''}]
set statusline+=[%{&fileformat}]%{empty(&binary)?'':'[binary]'}
set statusline+=\ %<\(%{expand('%:p:h')}\)\ %=[U+%04B]\ %3c\ \ %3l/%3L\ \(%P\)

autocmd MyAutoCmd FileType help let &l:statusline = '[Help] %t %= %3l/%3L (%P)'
autocmd MyAutoCmd FileType qf   let &l:statusline = '%q (%3l/%3L) %{exists("w:quickfix_title") ? w:quickfix_title : ""}'

set cursorline
autocmd MyAutoCmd WinLeave *
\   let b:vimrc_cursorline = &l:cursorline
\ | setlocal nocursorline
autocmd MyAutoCmd WinEnter *
\   let &l:cursorline = get(b:, 'vimrc_cursorline', &l:cursorline)

set nowrap
nnoremap <silent> <Leader>l :<C-u>setlocal wrap! wrap?<CR>

if has('linebreak') && exists('+breakindent')
  set linebreak

  set breakindent
  set breakindentopt=min:42,shift:0,sbr
  set showbreak=..
endif

set scrolloff=4
set sidescrolloff=12
set sidescroll=1

set previewheight=8
autocmd MyAutoCmd FileType help
\   wincmd L
\ | vertical resize 80
\ | setlocal winfixwidth

set splitbelow
set splitright
set noequalalways
autocmd MyAutoCmd VimResized * wincmd =

nnoremap <silent> <Leader>o :<C-u>only<CR>

set diffopt=filler,context:3,vertical,hiddenoff
if has('patch-8.1.0360')
  set diffopt^=internal,indent-heuristic,algorithm:histogram
endif

autocmd MyAutoCmd BufLeave,InsertLeave,TextChanged *
\   if &l:diff
\ |   diffupdate
\ | endif
autocmd MyAutoCmd WinEnter *
\   if winnr('$') ==# 1 && getbufvar(winbufnr(0), '&l:diff') ==# 1
\ |   diffoff
\ | endif

nnoremap <silent> [w <C-w>W
nnoremap <silent> ]w <C-w>w
nnoremap <silent> [W <C-w>t
nnoremap <silent> ]W <C-w>b

nnoremap <silent> <S-Left>  <C-w>>
nnoremap <silent> <S-Right> <C-w><
nnoremap <silent> <S-Up>    <C-w>+
nnoremap <silent> <S-Down>  <C-w>-

for [s:k, s:p, s:a] in [['b', 'b', ''], ['t', 'tab', ''], ['q', 'c', 'zv']]
  execute 'nnoremap <silent> [' . s:k . ' :' . s:p . 'previous<CR>' . s:a
  execute 'nnoremap <silent> ]' . s:k . ' :' . s:p . 'next<CR>' . s:a
  execute 'nnoremap <silent> [' . toupper(s:k) . ' :<C-u>' . s:p . 'first<CR>' . s:a
  execute 'nnoremap <silent> ]' . toupper(s:k) . ' :<C-u>' . s:p . 'last<CR>' . s:a
endfor

nnoremap <silent> <C-p>     :tabprevious<CR>
nnoremap <silent> <C-n>     :tabnext<CR>
nnoremap <silent> <C-Left>  :tabprevious<CR>
nnoremap <silent> <C-Right> :tabnext<CR>

nnoremap <silent> tt :<C-u>$tabnew<CR>

set display=uhex
set list
set listchars=tab:>.,trail:_,extends:>,precedes:<
set fillchars=fold:\ 

set showmatch
set matchpairs=(:),<:>,[:],{:},«:»,‹:›,≪:≫,〈:〉,《:》,「:」,『:』,【:】,〔:〕,（:）,＜:＞,［:］,｛:｝,｢:｣,‘:’,“:”
autocmd MyAutoCmd FileType c,cpp,java setlocal matchpairs+==:;

if has('kaoriya')
  set ambiwidth=auto
else
  set ambiwidth=double
endif

set foldenable
set foldcolumn=0
set foldmethod=marker
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

autocmd MyAutoCmd FileType css                 setlocal foldmethod=marker foldmarker={,}
autocmd MyAutoCmd FileType *commit*,diff,xxd   setlocal nofoldenable

set lazyredraw
set ttyfast
set belloff=all

set timeout
set timeoutlen=800
set ttimeoutlen=100

set shortmess=acTI
set report=0
set synmaxcol=420

autocmd MyAutoCmd FileType help nnoremap <buffer><silent><nowait> q :<C-u>helpclose<CR>
autocmd MyAutoCmd FileType help nnoremap <buffer> <CR> <C-]>
autocmd MyAutoCmd FileType help nnoremap <buffer> <BS> <C-t>

autocmd MyAutoCmd FileType qf nnoremap <buffer><silent><nowait> q :<C-u>cclose<CR>
autocmd MyAutoCmd FileType qf nnoremap <buffer><silent> <CR> :<C-u>.cc<CR>zv

autocmd MyAutoCmd VimEnter,Colorscheme * highlight IdeographicSpace cterm=underline ctermfg=lightblue gui=underline guifg=lightblue
autocmd MyAutoCmd VimEnter,WinEnter    * match IdeographicSpace /　/

autocmd MyAutoCmd                   InsertEnter *
\ highlight StatusLine cterm=bold,reverse ctermfg=gray ctermbg=black gui=bold,reverse guifg=gray  guibg=black
autocmd MyAutoCmd VimEnter,WinEnter,InsertLeave *
\ highlight StatusLine cterm=bold,reverse ctermfg=red  ctermbg=white gui=bold,reverse guifg=brown guibg=white

highlight Pmenu     ctermfg=darkgray ctermbg=white
highlight PmenuSel  ctermfg=white    ctermbg=blue
highlight PmenuSbar ctermfg=darkgray
" }}}

" Command {{{
for s:e in ['utf-8', 'cp932', 'euc-jp', 'iso-2022-jp', 'utf-16le', 'utf-16be']
  execute 'command! -bang -bar -nargs=? -complete=file'
        \ substitute(toupper(s:e[0]).tolower(s:e[1:]), '\W', '', 'g')
        \ 'edit<bang> ++encoding='.s:e '<args>'
endfor
for s:f in ['dos', 'unix', 'mac']
  execute 'command! -bang -bar -nargs=? -complete=file'
        \ substitute(toupper(s:f[0]).tolower(s:f[1:]), '\W', '', 'g')
        \ 'edit<bang> ++fileformat='.s:f '<args>'
endfor

command! -bar PluginUpdate call s:plugin_update()
function! s:plugin_update() abort
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
cnoreabbrev bd1  bd!
cnoreabbrev q1   q!
cnoreabbrev qa1  qa!
cnoreabbrev wq1  wq!
cnoreabbrev wqa1 wqa!
" }}}
" Syntax {{{
" filetype.vim
let g:c_syntax_for_h = 1
let g:tex_flavor = 'latex'

" autoload/rubycomplete.vim
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1

" indent/vim.vim
let g:vim_indent_cont = 0

" syntax/c.vim
let g:c_gnu = 1
let g:c_comment_strings = 1
let g:c_curly_error = 1
let g:c_space_errors = 1

" syntax/markdown.vim
let g:markdown_fenced_languages = [ 'bash=sh', 'css', 'html', 'javascript', 'ruby', 'sass', 'xml' ]

" syntax/php.vim
let g:php_sql_query = 1
let g:php_htmlInStrings = 1
let g:php_noShortTags = 1

" syntax/sh.vim
let g:is_bash = 1

" syntax/vim.vim
let g:vimsyn_embed = 0
let g:vimsyn_folding = 0
" }}}
" Plugin {{{
" Standard plugin {{{
let g:loaded_2html_plugin    = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip            = 1
let g:loaded_logiPat         = 1
let g:loaded_rrhelper        = 1
let g:loaded_tarPlugin       = 1
let g:loaded_vimballPlugin   = 1
let g:loaded_zipPlugin       = 1
" }}}
" Colorscheme {{{
if &t_Co >= 256
  try
    colorscheme gruvbox

    highlight SpellBad   cterm=underline
    highlight SpellCap   cterm=underline
    highlight SpellRare  cterm=underline
    highlight SpellLocal cterm=underline
  catch
  endtry
endif
" }}}
" matchit.vim {{{
packadd! matchit

nmap <Tab> %
" }}}
" }}}

set secure
