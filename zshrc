# ===============
#  .zshrc
# ===============

# Environments {{{
#export LANG=ja_JP.UTF-8
#export LANG=C.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export LC_COLLATE=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=ja_JP.UTF-8
export LC_NUMERIC=ja_JP.UTF-8
export LC_TIME=en_US.UTF-8

export TZ=Asia/Tokyo

[[ -z "${SHELL}" ]]    && export SHELL=$(whence -p zsh)
[[ -z "${HOSTNAME}" ]] && export HOSTNAME="${HOST}"
[[ -z "${USER}" ]]     && export USER="${USERNAME}"

export CYGWIN='nodosfilewarning winsymlinks:native'

export GEM_HOME=~/app/gem
export GOPATH=~/app/go

export GIT_MERGE_AUTOEDIT=no
export MAKEFLAGS='--jobs=4 --silent'
export RUBYOPT=-EUTF-8
export XZ_DEFAULTS='--check=sha256 --keep --verbose'

export WINEARCH=win32
export WINEDEBUG=-all

export LESS='--LONG-PROMPT --QUIET --RAW-CONTROL-CHARS --chop-long-lines --ignore-case --jump-target=5 --no-init --quit-if-one-screen --tabs=2'
export LESSCHARSET=utf-8
export LESSHISTFILE=/dev/null
export LESSSECURE=1
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;37m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[30;47m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;36m'

path=(
  ~/sbin(N-/)
  ~/bin(N-/)
  ~/app/*/sbin(N-/)
  ~/app/*/bin(N-/)
  /opt/*/bin(N-/)
  /opt/bin(N-/)
  /usr/local/sbin(N-/)
  /usr/sbin(N-/)
  /sbin(N-/)
  /usr/local/bin(N-/)
  /usr/bin(N-/)
  /bin(N-/)
  $path
)
typeset -gU path
export PATH

typeset -T LD_LIBRARY_PATH ld_library_path
ld_library_path=(
  ~/lib(N-/)
  ~/app/*/lib(N-/)
  /opt/*/lib(N-/)
  /opt/lib(N-/)
  /usr/local/lib(N-/)
  $ld_library_path
)
typeset -gU ld_library_path
export LD_LIBRARY_PATH

typeset -T PKG_CONFIG_PATH pkg_config_path
pkg_config_path=(
  ~/lib/pkgconfig(N-/)
  ~/app/*/lib/pkgconfig(N-/)
  /opt/*/lib/pkgconfig(N-/)
  /opt/lib/pkgconfig(N-/)
  /usr/local/lib/pkgconfig(N-/)
  $pkg_config_path
)
typeset -gU pkg_config_path
export PKG_CONFIG_PATH

cdpath=(
  $HOME
  ..
  ../..
)
typeset -gU cdpath

umask 022
ulimit -c 0

stty -ixon -ixoff
#}}}
# Autoloads {{{
autoload -Uz add-zsh-hook
autoload -Uz bracketed-paste-magic
autoload -Uz colors   && colors
autoload -Uz compinit && compinit
autoload -Uz down-line-or-beginning-search
autoload -Uz is-at-least
autoload -Uz modify-current-argument
autoload -Uz run-help
autoload -Uz smart-insert-last-word
autoload -Uz up-line-or-beginning-search
autoload -Uz url-quote-magic
autoload -Uz vcs_info
autoload -Uz zmv
#}}}
# Functions {{{
function exists() { whence -p -- "${1}" &> /dev/null }

function warning() {
  (( ${#} > 0 )) && echo "${funcstack[2]:-zsh}:" "${@}" 1>&2
  return 1
}

function is_ssh()  { [[ -n "${SSH_CONNECTION}" || $(ps -o comm= -p "${PPID}" 2> /dev/null) == 'sshd' ]] }
function is_x()    { [[ -n "${DISPLAY}" ]] }
function is_tmux() { [[ -n "${STY}${TMUX}" ]] }

function isinrepo() { exists git && [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] }

function set_cc() {
  case "${1}" in
    'clang' )
      export CC=clang
      export CXX=clang++
    ;;

    'gcc' )
      export CC=gcc
      export CXX=g++
    ;;

    * )
      unset CC CXX CFLAGS CXXFLAGS
      warning '$CC, $CXX, $CFLANGS and $CXXFLAGS are removed'
    ;;
  esac

  if [[ -n "${CC}" ]]; then
    CFLAGS='-march=native -mtune=native -O2 -pipe -w'
    if [[ $(${CC} -v --help 2> /dev/null) =~ '-fstack-protector-strong' ]]; then
      CFLAGS+=' -fstack-protector-strong'
    else
      CFLAGS+=' -fstack-protector-all'
    fi

    export CFLAGS
    export CXXFLAGS="${CFLAGS}"
  fi
}
#}}}
# Macros {{{
case "${OSTYPE}" in
  linux*)
    limit coredumpsize 0

    alias ls='ls --color=auto'
    alias open=xdg-open
    alias start=xdg-open

    setopt hist_fcntl_lock
  ;;

  darwin*)
    limit coredumpsize 0

    alias ls='ls -G'

    setopt hist_fcntl_lock
  ;;

  freebsd*)
    limit coredumpsize 0

    alias ls='ls -G'

    exists gmake && alias make=gmake
    exists gmake && export MAKE=$(whence -p gmake)

    exists jot   && alias seq=jot

    setopt hist_fcntl_lock
  ;;

  cygwin)
    alias ls='ls --color=auto'
    alias open=cygstart
    alias start=cygstart
  ;;
esac

is_x && xset -b

if exists vim; then
  export EDITOR=vim
  export VISUAL=vim

  alias vi=vim
  alias view='vim -R'
fi

if exists less; then
  export PAGER=less
else
  export PAGER=cat
fi

exists dircolors && eval "$(dircolors --bourne-shell)"

DIFF_PARAM='--unified --report-identical-files --minimal'
if exists colordiff; then
  alias diff="colordiff ${DIFF_PARAM}"
else
  alias diff="diff ${DIFF_PARAM}"
fi
unset DIFF_PARAM

GREP_PARAM='--color=auto --binary-files=text'
if [[ $(grep --help 2>&1) =~ '--exclude-dir' ]]; then
  for EXCLUDE_DIR in .git .deps .libs; do
    GREP_PARAM+=" --exclude-dir=${EXCLUDE_DIR}"
  done
fi
alias grep="grep ${GREP_PARAM}"
unset GREP_PARAM EXCLUDE_DIR

if exists clang; then
  set_cc clang
elif exists gcc; then
  set_cc gcc
fi

if exists manpath; then
  MANPATH=$(MANPATH= manpath)

  manpath=(
    ~/app/*/man(N-/)
    ~/app/*/share/man(N-/)
    /opt/*/man(N-/)
    /opt/*/share/man(N-/)
    /opt/man(N-/)
    /usr/local/man(N-/)
    /usr/local/share/man(N-/)
    /usr/share/man(N-/)
    $manpath
  )
  typeset -gU manpath
  export MANPATH
fi
#}}}

# Core {{{
bindkey -e

bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char

bindkey '^[OC'    forward-word
bindkey '^[OD'    backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n "${terminfo[kend]}"  ]] && bindkey "${terminfo[kend]}"  end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[H'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[OH'  beginning-of-line
bindkey '^[OF'  end-of-line

[[ -n "${terminfo[kdch1]}" ]] && bindkey "${terminfo[kdch1]}" delete-char
bindkey '^[[3~' delete-char

[[ -n "${terminfo[kcbt]}" ]] && bindkey "${terminfo[kcbt]}" reverse-menu-complete
bindkey '^[[Z' reverse-menu-complete

setopt correct
setopt hash_list_all

is-at-least '5.1' && setopt append_create
setopt no_clobber
setopt no_flow_control
setopt ignore_eof
setopt interactive_comments
setopt no_mail_warning
setopt multios
setopt path_dirs
setopt print_eight_bit
setopt print_exit_value
setopt warn_create_global

setopt no_beep
setopt combining_chars

setopt c_bases
setopt octal_zeroes

REPORTTIME=2
TIMEFMT='%J | user: %U, system: %S, cpu: %P, total: %*E'

MAILCHECK=0
KEYTIMEOUT=10

zle -N bracketed-paste bracketed-paste-magic
zle -N self-insert url-quote-magic

[[ $(whence -w run-help) == 'run-help: alias' ]] && unalias run-help
#}}}
# Prompt {{{
is_ssh  && SSH_INDICATOR='@ssh'
is_tmux || DATE_INDICATOR='  %D{%b.%f (%a) %K:%M}'

PROMPT="[%m${SSH_INDICATOR}:%~] %n%1(j.(%j%).)%# "
PROMPT2='%_ %# '
RPROMPT="  %1v${DATE_INDICATOR}"
SPROMPT='zsh: Did you mean %B%r%b ?  [%UN%uo, %Uy%ues, %Ua%ubort, %Ue%udit]: '
unset SSH_INDICATOR DATE_INDICATOR

function precmd_title() { print -Pn "\e]0;%n@%m: %~\a" }
add-zsh-hook -Uz precmd precmd_title


setopt prompt_cr
setopt prompt_sp
PROMPT_EOL_MARK='%B%S<NOEOL>%s%b'

setopt prompt_subst
setopt transient_rprompt

function accept-line() {
  region_highlight=("0 ${#BUFFER} bold")
  zle .accept-line
}
zle -N accept-line

function kill-whole-line() {
  zle end-of-history
  zle .kill-whole-line
}
zle -N kill-whole-line


zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' stagedstr '(+)'
zstyle ':vcs_info:*' unstagedstr '(!)'
zstyle ':vcs_info:git:*' check-for-changes true

zstyle ':vcs_info:*' formats '[%s:%b%c%u%m]'
zstyle ':vcs_info:*' actionformats '*%a* [%s:%b%c%u%m]'
zstyle ':vcs_info:*' max-exports 1

zstyle ':vcs_info:git+set-message:*' hooks git-hook
function +vi-git-hook() {
  isinrepo || return

  git status --porcelain --untracked-files=all | grep -Esq '^\?\? ' && hook_com[unstaged]+='(?)'

  local COUNT
  COUNT=$(git rev-list --count '@{upstream}..HEAD' 2> /dev/null)
  (( ${COUNT:-0} > 0 )) && hook_com[misc]+=":@{upstream}+${COUNT}"
  COUNT=$(git rev-list --count 'master..HEAD' 2> /dev/null)
  (( ${COUNT:-0} > 0 )) && hook_com[misc]+=":master+${COUNT}"
  COUNT=$(git stash list 2> /dev/null | wc -l)
  (( ${COUNT:-0} > 0 )) && hook_com[misc]+=":stash@${COUNT//[^0-9]/}"
}

function precmd_vcs_info() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "${vcs_info_msg_0_}" ]] && psvar[1]="${vcs_info_msg_0_}"
}
add-zsh-hook -Uz precmd precmd_vcs_info
#}}}

# Job {{{
setopt auto_continue
setopt auto_resume
setopt bg_nice
setopt long_list_jobs
setopt monitor

setopt check_jobs
setopt no_hup
#}}}
# History {{{
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history
setopt share_history

[[ -n "${terminfo[kpp]}" ]] && bindkey "${terminfo[kpp]}" up-history
[[ -n "${terminfo[knp]}" ]] && bindkey "${terminfo[knp]}" down-history
bindkey '^[[5~' up-history
bindkey '^[[6~' down-history

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${terminfo[cuu1]}"  ]] && bindkey "${terminfo[cuu1]}"  up-line-or-beginning-search
[[ -n "${terminfo[cud1]}"  ]] && bindkey "${terminfo[cud1]}"  down-line-or-beginning-search
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
bindkey '^P'   up-line-or-beginning-search
bindkey '^N'   down-line-or-beginning-search

bindkey '^[p' history-incremental-pattern-search-backward
bindkey '^[n' history-incremental-pattern-search-forward

bindkey '^R' end-of-history

bindkey -r '^S'
#}}}
# Complement {{{
LISTMAX=0
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

zstyle ':completion:*' verbose true
zstyle ':completion:*' use-cache true

#zstyle ':completion:*' completer _expand _complete _history _correct _approximate _match _prefix _list
zstyle -e ':completion:*' completer '
  COMPLETER_TRY_CURRENT="${HISTNO}${BUFFER}${CURSOR}"
  if [[ "${COMPLETER_TRY_PREVIOUS}" == "${COMPLETER_TRY_CURRENT}" ]]; then
    reply=(_expand _complete _history _correct _approximate _match _prefix _list)
  else
    COMPLETER_TRY_PREVIOUS="${COMPLETER_TRY_CURRENT}"
    reply=(_expand _complete _correct _match _prefix _list)
  fi'

zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[.,_-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=long-list

zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' ignore-line other
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*' single-ignored show
zstyle ':completion:*' squeeze-slashes true

zstyle ':completion:*:default' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*:default' select-prompt '%SScrolling active: current selection at %p%s'

zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:processes' command 'ps x -o pid,user,stat,tty,command -w -w'
zstyle ':completion:*:(processes|jobs)' menu yes select
zstyle ':completion:*:(processes|jobs)' force-list always

zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:hosts' ignored-patterns localhost 'localhost.*' '*.localdomain'

exists getent && ETC_PASSWD=$(getent passwd 2> /dev/null)
[[ ( "${?}" != '0' || -z "${ETC_PASSWD}" ) && -r /etc/passwd ]] && ETC_PASSWD=$(cat /etc/passwd)
if [[ -n "${ETC_PASSWD}" ]]; then
  [[ -r /etc/login.defs ]] && \
    eval "$(awk '$1 ~ /^UID_(MAX|MIN)$/ && $2 ~ /^[0-9]+$/ { print $1 "=" $2 }' /etc/login.defs)"

  zstyle ':completion:*:users' users \
    $(echo "${ETC_PASSWD}" | awk -F: "\$3 >= ${UID_MIN:-1000} && \$3 <= ${UID_MAX:-60000} { print \$1 }")
  unset ETC_PASSWD UID_MIN UID_MAX
fi

zstyle ':completion:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:-subscript-:*' list-separator ':'

zstyle ':completion:*:-tilde-:*' group-order named-directories path-directories users expand

zstyle ':completion:*:sudo:*' command-path
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:scp:*:files' command command -


DIRSTACKSIZE=20

setopt auto_cd
setopt auto_pushd
setopt cdable_vars
setopt pushd_ignore_dups
setopt pushd_to_home

function chpwd_ls() { ls -AF }
add-zsh-hook -Uz chpwd chpwd_ls

setopt always_last_prompt
setopt always_to_end
setopt auto_list
setopt auto_menu
setopt auto_name_dirs
setopt auto_param_keys
setopt auto_param_slash
setopt auto_remove_slash
setopt no_complete_aliases
setopt complete_in_word
setopt list_packed
setopt list_types

setopt brace_ccl
setopt case_glob
setopt equals
setopt extended_glob
setopt glob_dots
setopt magic_equal_subst
setopt mark_dirs
setopt no_nomatch
setopt numeric_glob_sort
setopt rc_expand_param


typeset -A abbrev_expand
abbrev_expand=(
  '..'    '../'
  '...'   '../../'
  '....'  '../../../'
  '.....' '../../../../'

  '?'   "--help |& ${PAGER}"
  'C'   '| sort | uniq -c | sort -nr'
  'D'   "| hexdump -C | ${PAGER}"
  'E'   '> /dev/null'
  'G'   '| grep -iE'
  'GV'  '| grep -ivE'
  'H'   '| head -20'
  'L'   "|& ${PAGER}"
  'N'   '| wc -l'
  'S'   '| sort'
  'T'   '| tail -20'
  'U'   '| sort | uniq'
  'V'   '| vim -'
  'X'   '| xargs -r'
  'XN'  '| xargs -r -n1'
  'Z'   '| openssl enc -e -aes-256-cbc'
  'ZD'  '| openssl enc -d -aes-256-cbc'
)

function magic-abbrev-expand() {
  local MATCH BASE EXPAND
  BASE="${LBUFFER%%(#m)[^[:IFS:]]#}"
  EXPAND="${abbrev_expand[${MATCH}]}"

  [[ -n "${EXPAND}" ]] && LBUFFER="${BASE}${EXPAND}"
}
function magic-abbrev-expand-and-insert() {
  magic-abbrev-expand
  zle self-insert
}
function magic-abbrev-expand-and-space() {
  magic-abbrev-expand
  zle magic-space
}
function magic-abbrev-expand-and-accept() {
  magic-abbrev-expand
  zle accept-line
}
function magic-abbrev-expand-and-complete() {
  echo -en "\e[32m....\e[0m"
  magic-abbrev-expand
  zle expand-or-complete
  zle redisplay
}

zle -N magic-abbrev-expand-and-insert
zle -N magic-abbrev-expand-and-space
zle -N magic-abbrev-expand-and-complete
zle -N magic-abbrev-expand-and-accept
bindkey ' '  magic-abbrev-expand-and-space
bindkey '^I' magic-abbrev-expand-and-complete
#bindkey '^M' magic-abbrev-expand-and-accept   # ^M will be handled by 'magic_enter'

function magic_enter() {
  if [[ -z "${BUFFER}" && "${CONTEXT}" == 'start' ]]; then
    if isinrepo; then
      BUFFER='git status --branch --short --untracked-files=all && git diff --patch-with-stat'
    else
      BUFFER='ls -AF'
    fi
  else
    magic-abbrev-expand
  fi

  zle accept-line
}
zle -N magic_enter
bindkey '^M' magic_enter


function change_command() {
  [[ -z "${BUFFER}" && "${CONTEXT}" == 'start' ]] && zle up-history

  zle beginning-of-line

  [[ "${BUFFER}" =~ '^sudo .*' ]] && zle kill-word
  zle kill-word
}
zle -N change_command
bindkey '^X^X' change_command

function prefix_with_sudo() {
  [[ -z "${BUFFER}" && "${CONTEXT}" == 'start' ]] && zle up-history
  [[ "${BUFFER}" =~ '^sudo .*' ]] || BUFFER="sudo ${BUFFER}"
  zle end-of-line
}
zle -N prefix_with_sudo
bindkey '^S^S' prefix_with_sudo

function magic_ctrlz() {
  if [[ -z "${BUFFER}" && "${CONTEXT}" == 'start' ]]; then
    BUFFER='fg'
    zle accept-line
  else
    zle -M "zsh: Buffer pushed to stack: ${BUFFER}"
    zle push-line-or-edit
  fi
}
zle -N magic_ctrlz
bindkey '^Z' magic_ctrlz

function magic_circumflex() {
  if [[ -z "${BUFFER}" && "${CONTEXT}" == 'start' ]]; then
    BUFFER='cd ..'
    zle accept-line
  else
    zle self-insert
  fi
}
zle -N magic_circumflex
bindkey '\^' magic_circumflex

function force_reset_screen() {
  echo -en "\033c"
  tput clear

  zle clear-screen
  zle reset-prompt
}
zle -N force_reset_screen
bindkey '^L' force_reset_screen

function surround_with_single_quote() {
  modify-current-argument '${(qq)${(Q)ARG}}'
  zle vi-forward-blank-word
}
zle -N surround_with_single_quote
bindkey '^[s' surround_with_single_quote

function surround_with_double_quote() {
  modify-current-argument '${(qqq)${(Q)ARG}}'
  zle vi-forward-blank-word
}
zle -N surround_with_double_quote
bindkey '^[d' surround_with_double_quote


zle -N insert-last-word smart-insert-last-word
zstyle ':insert-last-word' match '*([[:alpha:]/\\]?|?[[:alpha:]/\\])*'
bindkey '^]' insert-last-word

bindkey '^[m' copy-prev-shell-word
#}}}
# Utility {{{
alias wipe='shred --verbose --iterations=3 --zero --remove'

alias rst='
  if [[ -n `jobs` ]]; then
    warning "processing job still exists"
  elif [[ "${0:0:1}" == "-" ]]; then
    exec -l zsh
  else
    exec zsh
  fi'

function +x() { chmod +x -- "${@}" }

function bak() { [[ "${#}" == '1' ]] && cp -fv -- "${1}"{,.bak} }
function rvt() { [[ "${#}" == '1' ]] && mv -iv -- "${1}"{,.new} && mv -iv -- "${1}"{.bak,} }

function mkmv() {
  case "${#}" in
    '0' )
      cat <<HELP 1>&2
Usage: ${0} DIRECTORY
Usage: ${0} FILES... DIRECTORY
HELP
      return 1
    ;;

    '1' )
      if [[ -d "${1}" ]]; then
        warning 'directory already exists'
        builtin cd -- "${1}"
      else
        mkdir -vp -- "${1}" && builtin cd -- "${1}"
      fi
    ;;

    * )
      local DIR="${@: -1}"
      if [[ -d "${DIR}" ]]; then
        warning 'directory already exists'
        mv -iv -- "${@}"
      else
        mkdir -vp -- "${DIR}" && mv -iv -- "${@}"
      fi
    ;;
  esac
}
alias mkcd=mkmv

function wol() {
  MAC="${1//[^0-9A-Fa-f]/}"

  if (( ${#MAC} != 12 )); then
    warning 'MAC address must be 12 hexdigits'
    return 1
  fi

  echo -en "$( ( printf 'f%.0s' {1..12} && printf "${MAC}%.0s" {1..16} ) | sed -e 's/../\\x&/g' )" \
    | nc -w0 -u 255.255.255.255 4000
}

function whois() {
  {
    local REPORTTIME_ORIG="${REPORTTIME}"
    REPORTTIME=-1

    local WHOIS
    exists jwhois && WHOIS=$(whence -p jwhois)
    exists whois  && WHOIS=$(whence -p whois)

    if [[ -z "${WHOIS}" ]]; then
      warning 'install "whois" command'
      return 1
    fi

    local ARG DOMAIN OPTION
    local -a OPTION
    for ARG in "${@}"; do
      case "${ARG}" in
        -* )
          OPTION+=( "${ARG}" );;
        * )
          DOMAIN=$(perl -pe 's!^(?:[^:]+://)?(?:www.)?([^/.]+\.[^/]+)(?:/.*)?$!\1!' <<< "${ARG}");;
      esac
    done

    if [[ -z "${DOMAIN}" ]]; then
      "${WHOIS}" "${OPTION[@]}"
    else
      ( echo "${WHOIS}" "${OPTION[@]}" "${DOMAIN}" && "${WHOIS}" "${OPTION[@]}" "${DOMAIN}" ) |& ${PAGER}
    fi
  } always {
    local RETURN="${?}"
    REPORTTIME="${REPORTTIME_ORIG}"
    return "${RETURN}"
  }
}

function mailsend() {
  if ! exists openssl; then
    warning 'install "openssl" command'
    return 1
  fi

  local HOST PORT FROM TO SUBJECT
  HOST=${1:-localhost}
  PORT=${2:-25}

  read -r 'FROM?From: '
  read -r 'TO?To: '
  read -r 'SUBJECT?Subject: '

  echo 'Body (end with Ctrl-D):'

  nc -C "${HOST}" "${PORT}" <<EOC
HELO ${HOST}
MAIL FROM: <${FROM}>
RCPT TO: <${TO}>
DATA
From: <${FROM}>
To: <${TO}>
Subject: =?UTF-8?B?$(echo -n "${SUBJECT}" | openssl base64 | tr -d '\r\n')?=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

$(< /dev/stdin)

.
QUIT
EOC
}

function 256color() {
  local CODE
  for CODE in {0..15}; do
    echo -en "\e[48;5;${CODE}m $(( [##16] ${CODE} )) "
    (( ${CODE} % 8 == 7 )) && echo -e "\e[0m"
  done
  echo

  local BASE ITERATION COUNT
  for BASE in {0..11}; do
    for ITERATION in {0..2}; do
      for COUNT in {0..5}; do
        CODE=$(( 16 + ${BASE} * 6 + ${ITERATION} * 72 + ${COUNT} ))
        echo -en "\e[48;5;${CODE}m $(( [##16] ${CODE} )) "
      done
      echo -en "\e[0m  "
    done
    echo
    (( ${BASE} == 5 )) && echo
  done
  echo

  for CODE in {232..255}; do
    echo -en "\e[48;5;${CODE}m $(( [##16] ${CODE} )) "
  done
  echo -e "\e[0m"
}

function package() {
  local ARG MODE YES
  local -aU PACKAGES
  for ARG in "${@}"; do
    case "${ARG}" in
      install | update )
        if [[ -z "${MODE}" ]];then
          MODE="${ARG}"
        else
          warning 'a parameter is assumed as a package name'
          PACKAGES+=( "${ARG}" )
        fi
      ;;

      -y | --yes )
        YES=1;;
      -* )
        cat <<HELP 1>&2
Usage: ${0} [-y] install [ packages ... ]
Usage: ${0} [-y] update
Usage: ${0} -h

Options:
  -y, --yes           Answer "yes" to any question
  -h, --help          Show this help message and exit


Example:
  ${0} install vim gcc
  Install 'vim' and 'gcc' package

  ${0} -y update
  Update all packages in any case
HELP
        return 1;;

      * )
        PACKAGES+=( "${ARG}" );;
    esac
  done

  if [[ -z "${MODE}" ]]; then
    warning 'operation mode is required'
    return 1
  fi
  if [[ "${MODE}" == 'install' && "${#PACKAGES[@]}" == '0' ]]; then
    warning 'no packages are specified in install mode'
    return 1
  fi

  {
    local REPORTTIME_ORIG="${REPORTTIME}"
    REPORTTIME=-1

    local OPTIONS
    if exists apt-get; then
      [[ -n "${YES}" ]] && OPTIONS=--assume-yes

      case "${MODE}" in
        install )
          sudo apt-get ${OPTIONS} clean                    && \
          sudo apt-get ${OPTIONS} update                   && \
          sudo apt-get ${OPTIONS} dist-upgrade             && \
          sudo apt-get ${OPTIONS} install "${PACKAGES[@]}" && \
          sudo apt-get ${OPTIONS} autoremove
        ;;

        update )
          sudo apt-get ${OPTIONS} clean        && \
          sudo apt-get ${OPTIONS} update       && \
          sudo apt-get ${OPTIONS} dist-upgrade && \
          sudo apt-get ${OPTIONS} autoremove
        ;;
      esac

      sudo -K
    elif exists dnf; then
      [[ -n "${YES}" ]] && OPTIONS=--assumeyes

      case "${MODE}" in
        install )
          sudo dnf ${OPTIONS} clean all                && \
          sudo dnf ${OPTIONS} upgrade                  && \
          sudo dnf ${OPTIONS} install "${PACKAGES[@]}" && \
          sudo dnf ${OPTIONS} autoremove
        ;;

        update )
          sudo dnf ${OPTIONS} clean all  && \
          sudo dnf ${OPTIONS} upgrade    && \
          sudo dnf ${OPTIONS} autoremove
        ;;
      esac

      sudo -K
    elif exists yum; then
      [[ -n "${YES}" ]] && OPTIONS=--assumeyes

      case "${MODE}" in
        install )
          sudo yum ${OPTIONS} clean all                && \
          sudo yum ${OPTIONS} upgrade                  && \
          sudo yum ${OPTIONS} install "${PACKAGES[@]}" && \
          sudo yum ${OPTIONS} autoremove
        ;;

        update )
          sudo yum ${OPTIONS} clean all  && \
          sudo yum ${OPTIONS} upgrade    && \
          sudo yum ${OPTIONS} autoremove
        ;;
      esac

      sudo -K
    elif exists pacman; then
      [[ -n "${YES}" ]] && OPTIONS=--noconfirm

      case "${MODE}" in
        install )
          sudo pacman -Sc ${OPTIONS}                   && \
          sudo pacman -Syu ${OPTIONS} "${PACKAGES[@]}"
        ;;

        update )
          sudo pacman -Sc ${OPTIONS}  && \
          sudo pacman -Syu ${OPTIONS}
        ;;
      esac

      sudo -K
    else
      warning 'no package manager can be found'
      return 1
    fi
  } always {
    local RETURN="${?}"
    REPORTTIME="${REPORTTIME_ORIG}"
    return "${RETURN}"
  }
}

function createpasswd() {
  # Default
  local CHARACTER='[:alnum:]'
  local LENGTH=18
  local NUMBER=1

  # Arguments
  local F_CHARACTER F_PARANOID
  local P_CHARACTER="${CHARACTER}"
  local P_LENGTH="${LENGTH}"
  local P_NUMBER="${NUMBER}"

  while getopts hpc:l:n: ARG; do
    case "${ARG}" in
      'c' ) F_CHARACTER=1
            P_CHARACTER="${OPTARG}";;
      'l' ) P_LENGTH="${OPTARG}";;
      'n' ) P_NUMBER="${OPTARG}";;
      'p' ) F_PARANOID=1;;

      * )
        cat <<HELP 1>&2
Usage: ${0} [-p | -c <chars>] [-l <length>] [-n <number>]

  -c <chars>    Specify candidate characters for passwords
  -l <length>   Specify the length of password(s) (Default = ${LENGTH})
  -n <number>   Specify the number of password(s) (Default = ${NUMBER})
  -p            Paranoid mode (Generated password contains all letter type)

Example:
  ${0}
  ${0} -c "0-9A-Za-z"
  ${0} -c "[:alnum:]"
    Create a password (${LENGTH} chars) contains letters and digits.

  ${0} -p -l 24 -n 2
    Create two passwords (24 chars) contains printable chars, not including space.

  ${0} -c ACGT -n 20
    Get a piece of DNA sequence.
HELP
      return 1;;
    esac
  done

  if [[ -n "${F_PARANOID}" ]]; then
    P_CHARACTER='[:graph:]'
    [[ -n "${F_CHARACTER}" ]] && warning '-c option is ignored in paranoid mode'
  fi

  LC_CTYPE=C tr -cd "${P_CHARACTER}" < /dev/urandom \
    | fold -w "${P_LENGTH}" \
    | if [[ -n "${F_PARANOID}" ]]; then \
        grep '[[:digit:]]' | grep '[[:punct:]]' | grep '[[:upper:]]' | grep '[[:lower:]]' ; \
      else \
        cat ; \
      fi \
    | head -n "${P_NUMBER}"
}
#}}}

# Alias {{{
alias sudo='sudo '
alias sort='LC_ALL=C sort'

alias zmv='noglob zmv -vW'
alias zcp='noglob zmv -vWC'
alias zln='noglob zmv -vWL'

alias l.='ls -d .*'
alias la='ls -AF'
alias ll='ls -l'
alias lla='ls -AFl'
alias llh='ls -Flh'
alias llha='ls -AFlh'
alias lls='ls -AFl'

alias rm='rm -i'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -v'
alias mkdir='mkdir -vp'

alias chmod='chmod -v'
alias chown='chown -v'

alias .='pwd'

alias a='./a.out'
#alias b=''
#alias c=''
alias d='dirs -v'
#alias e=''
#alias f=''
#alias g=''
alias h='fc -l -t "%b.%e %k:%M:%S"'
#alias i=''
alias j='jobs -l'
#alias k=''
alias l="last -a | ${PAGER}"
#alias m=''
#alias n=''
#alias o=''
#alias p=''
alias q='exit'
#alias r='' # Shell built-in command already exists
#alias s=''
#alias t=''
#alias u=''
#alias v=''
#alias w='' # Command already exists
alias x='exit'
#alias y=''
#alias z=''
#}}}

[[ -s ~/.zshrc.include ]] && source ~/.zshrc.include

for ZFILE in ~/.zshrc ~/.zcompdump; do
  [[ -s "${ZFILE}" && ( ! -s "${ZFILE}.zwc" || "${ZFILE}" -nt "${ZFILE}.zwc" ) ]] && zcompile "${ZFILE}" &!
done
unset ZFILE

if [[ "${OSTYPE}" != 'cygwin' && "${SHLVL}" == '1' ]] && exists tmux; then
  tmux attach || tmux
fi

