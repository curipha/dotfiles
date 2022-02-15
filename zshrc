# ===============
#  .zshrc
# ===============

# Environments {{{
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

export SHELL=$(whence -p zsh)
[[ -z "${HOSTNAME}" ]] && export HOSTNAME="${HOST}"
[[ -z "${USER}" ]]     && export USER="${USERNAME}"

export GEM_HOME=~/app/gem
export GOPATH=~/app/go

export GIT_MERGE_AUTOEDIT=no
export MAKEFLAGS='--jobs=2 --silent'
export QUOTING_STYLE=literal
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
  ~/app/*/sbin(N-/)
  ~/app/*/bin(N-/)
  ~/.local/bin(N-/)
  /usr/local/sbin(N-/)
  /usr/local/bin(N-/)
  /usr/sbin(N-/)
  /usr/bin(N-/)
  /sbin(N-/)
  /bin(N-/)
  /opt/*/bin(N-/)
  $path
)
typeset -gU path
export PATH

typeset -T LD_LIBRARY_PATH ld_library_path
ld_library_path=(
  ~/app/*/lib(N-/)
  /usr/local/lib(N-/)
  $ld_library_path
)
typeset -gU ld_library_path
export LD_LIBRARY_PATH

typeset -T PKG_CONFIG_PATH pkg_config_path
pkg_config_path=(
  ~/app/*/lib/pkgconfig(N-/)
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
autoload -Uz compinit && compinit
autoload -Uz down-line-or-beginning-search
autoload -Uz modify-current-argument
autoload -Uz run-help
autoload -Uz smart-insert-last-word
autoload -Uz up-line-or-beginning-search
autoload -Uz url-quote-magic
autoload -Uz vcs_info
autoload -Uz zmv
#}}}
# Functions {{{
function exists()  { whence -p -- "${1}" &> /dev/null }
function warning() { echo "${funcstack[2]:-zsh}:" "${@}" 1>&2 }

function is_ssh()  { [[ -n "${SSH_CONNECTION}" || $(ps -o comm= -p "${PPID}" 2> /dev/null) == 'sshd' ]] }
function is_x()    { [[ -n "${DISPLAY}" ]] }
function is_tmux() { [[ -n "${STY}${TMUX}" ]] }

function isinrepo() { exists git && [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] }

function set_cc() {
  if (( ${#} < 1 )); then
    unset CC CXX CFLAGS CXXFLAGS
    warning '$CC, $CXX, $CFLANGS and $CXXFLAGS are removed'
    return
  fi

  if ! exists "${1}"; then
    warning "no such command: ${1}"
    return 1
  fi

  case "${1}" in
    'clang' ) export CC=clang CXX=clang++;;
    'gcc'   ) export CC=gcc   CXX=g++;;

    * )
      warning "nothing to do for: ${1}"
      return 1
    ;;
  esac

  CFLAGS='-march=native -mtune=native -O2 -pipe -w'
  if [[ $(${CC} -v --help 2> /dev/null) =~ '-fstack-protector-strong' ]]; then
    CFLAGS+=' -fstack-protector-strong'
  else
    CFLAGS+=' -fstack-protector-all'
  fi

  export CFLAGS
  export CXXFLAGS="${CFLAGS}"
}
#}}}
# Macros {{{
case "${OSTYPE}" in
  linux* | freebsd* )
    limit coredumpsize 0
  ;|

  linux* )
    alias ls='ls --color=auto'
    alias open=xdg-open
    alias start=xdg-open
  ;|

  freebsd* )
    export CLICOLOR=1
    export LSCOLORS=Gxdxcxdxbxegedabagacad

    exists gmake && alias make=gmake
    exists gmake && export MAKE=$(whence -p gmake)
  ;|
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

if exists git; then
  alias diff='git diff --no-index'
else
  alias diff='diff --unified --report-identical-files --minimal'
fi

GREP_PARAM='--color=auto --binary-files=text'
[[ $(grep --help 2>&1) =~ '--exclude-dir' ]] && GREP_PARAM+=' --exclude-dir=".*"'
alias grep="grep ${GREP_PARAM}"
unset GREP_PARAM

if exists clang; then
  set_cc clang
elif exists gcc; then
  set_cc gcc
fi

if exists nproc; then
  export CPUS=$(nproc)
elif exists getconf; then
  export CPUS=$( ( getconf NPROCESSORS_ONLN || getconf _NPROCESSORS_ONLN ) 2> /dev/null )
fi
[[ -z "${CPUS}" ]] && export CPUS=1

if exists manpath; then
  MANPATH=$(MANPATH= manpath)

  manpath=(
    ~/app/*/man(N-/)
    ~/app/*/share/man(N-/)
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

bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
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

setopt append_create
setopt no_clobber
setopt no_flow_control
setopt interactive_comments
setopt no_mail_warning
setopt multios
setopt print_eight_bit
setopt print_exit_value
setopt warn_create_global
#setopt warn_nested_var  # for testing

setopt no_beep
setopt combining_chars

setopt c_bases

REPORTTIME=2
TIMEFMT='%J | user: %U, system: %S, cpu: %P, total: %*E'

MAILCHECK=0
KEYTIMEOUT=10

zle -N bracketed-paste bracketed-paste-magic
zle -N self-insert url-quote-magic

[[ $(whence -w run-help) == 'run-help: alias' ]] && unalias run-help
#}}}
# Prompt {{{
is_ssh && SSH_INDICATOR='@ssh'

PROMPT="[%m${SSH_INDICATOR}:%~] %n%1(j.(%j%).)%# "
PROMPT2='%_ %# '
RPROMPT='  ${vcs_info_msg_0_}'
SPROMPT='zsh: Did you mean %B%r%b ?  [%UN%uo, %Uy%ues, %Ua%ubort, %Ue%udit]: '
unset SSH_INDICATOR

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
zstyle ':vcs_info:*' actionformats '%B%a/%m%%b [%s:%b%c%u]'
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
  LANG=en_US.UTF-8 vcs_info
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
setopt hist_fcntl_lock
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt share_history

function add_history() {
  (( ${#1} < 5 )) && return 1  # $1 = BUFFER + 0x0A

  local -a match mbegin mend
  [[ "${1}" =~ '^(sudo )?(reboot|poweroff|halt|shutdown)\b' ]] && return 1
  return 0
}
add-zsh-hook -Uz zshaddhistory add_history

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

zstyle ':completion:*' auto-description '%d (provided by auto-description)'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-line other
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-separator ':'
zstyle ':completion:*' single-ignored show
zstyle ':completion:*' squeeze-slashes true

zstyle ':completion:*:default' list-prompt '%SHit TAB for more, or the character to insert%s'
zstyle ':completion:*:default' select-prompt '%SCandidate: %l (%p)%s'

zstyle ':completion:*:descriptions' format '%B%F{yellow}%d%f%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format '%B%F{red}No matches for:%f%b %d'
zstyle ':completion:*:corrections' format '%B%F{yellow}%d%f %F{red}(errors: %e)%f%b'

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
    $(awk -F: "\$3 >= ${UID_MIN:-1000} && \$3 <= ${UID_MAX:-60000} { print \$1 }" <<< "${ETC_PASSWD}")
  unset ETC_PASSWD UID_MIN UID_MAX
fi

zstyle ':completion:*:-subscript-:*' tag-order indexes parameters
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

  '?'  "--help |& ${PAGER}"
  'C'  "| sort | uniq -c | sort -nrs |& ${PAGER}"
  'E'  '> /dev/null'
  'G'  '| grep -iE'
  'GV' '| grep -ivE'
  'H'  '| head -20'
  'L'  "|& ${PAGER}"
  'S'  '| sort'
  'T'  '| tail -20'
  'U'  '| sort | uniq'
  'X'  '| xargs -r -n1'
)

function magic-abbrev-expand() {
  local MATCH BASE EXPAND MBEGIN MEND
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
  printf '\e[32m....\e[0m'
  magic-abbrev-expand
  zle expand-or-complete
  printf '\e[4D    '
  zle redisplay
}

zle -N magic-abbrev-expand-and-insert
zle -N magic-abbrev-expand-and-space
zle -N magic-abbrev-expand-and-complete
zle -N magic-abbrev-expand-and-accept
bindkey ' '  magic-abbrev-expand-and-space
#bindkey '^I' magic-abbrev-expand-and-complete
#bindkey '^M' magic-abbrev-expand-and-accept   # ^M will be handled by 'magic_enter'

function magic_enter() {
  if [[ -z "${BUFFER}" && "${CONTEXT}" == 'start' ]]; then
    if isinrepo; then
      BUFFER=' git status --branch --short --untracked-files=all && git diff --patch-with-stat --ignore-all-space'
    else
      BUFFER=' ls -AF'
    fi
  else
    magic-abbrev-expand
  fi

  zle accept-line
}
zle -N magic_enter
bindkey '^M' magic_enter

function magic_tab() {
  printf '\e[32m....\e[0m'
  zle expand-or-complete
  printf '\e[4D    '
  zle redisplay
}
zle -N magic_tab
bindkey '^I' magic_tab

function change_command() {
  [[ -z "${BUFFER}" && "${CONTEXT}" == 'start' ]] && zle up-history

  zle beginning-of-line

  [[ "${BUFFER}" =~ '^sudo .*' ]] && zle forward-word
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
    if (( ${#jobtexts} < 1 )); then
      if is_tmux; then
        BUFFER=' tmux detach-client'
      elif tmux has-session 2> /dev/null; then
        BUFFER=' tmux attach-session'
      else
        zle -M 'zsh: Nothing to do for CTRL-Z'
      fi
    else
      BUFFER='fg'
    fi
    [[ -n "${BUFFER}" ]] && zle accept-line
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
  printf '\ec'
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
#}}}
# Utility {{{
alias myip='dig @za.akamaitech.net. whoami.akamai.net. a +short'
#alias myip='dig @ns1.google.com. o-o.myaddr.l.google.com. txt +short'
#alias myip='dig @1.1.1.1 whoami.cloudflare. chaos txt +short'

alias rst='
  if [[ -n $(jobs) ]]; then
    warning "processing job still exists"
  elif [[ "${0:0:1}" == "-" ]]; then
    exec -l zsh
  else
    exec zsh
  fi'

function zman() {
  if (( ${#} > 0 )); then
    PAGER="less --squeeze-blank-lines -p '${1}'" man zshall
  else
    man zshall
  fi
}

function +x() { chmod a+x -- "${@}" }

function bak() { [[ "${#}" == '1' ]] && cp -fv -- "${1}"{,.bak} }
function rvt() { [[ "${#}" == '1' ]] && mv -iv -- "${1}"{,.new} && mv -iv -- "${1}"{.bak,} }

function mkmv() {
  case "${#}" in
    '0' )
      cat <<HELP 1>&2
Usage: ${0} directory
Usage: ${0} files... directory
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
        mv -iv -- "${@}" && builtin cd -- "${DIR}"
      else
        mkdir -vp -- "${DIR}" && mv -iv -- "${@}" && builtin cd -- "${DIR}"
      fi
    ;;
  esac
}
alias mkcd=mkmv

function whois() {
  local WHOIS
  exists jwhois && WHOIS=$(whence -p jwhois)
  exists whois  && WHOIS=$(whence -p whois)

  if [[ -z "${WHOIS}" ]]; then
    warning 'install "whois" command'
    return 1
  fi

  local REPORTTIME=-1

  local ARG DOMAIN
  local -aU OPTION
  for ARG in "${@}"; do
    case "${ARG}" in
      -* ) OPTION+=( "${ARG}" );;
      *  ) DOMAIN=$(perl -pe 's!^(?:[^:]+://)?(?:www.)?([^/.]+\.[^/]+)(?:/.*)?$!\1!' <<< "${ARG}");;
    esac
  done

  if [[ -z "${DOMAIN}" ]]; then
    "${WHOIS}" "${OPTION[@]}"
  else
    ( echo "${WHOIS}" "${OPTION[@]}" "${DOMAIN}" && "${WHOIS}" "${OPTION[@]}" "${DOMAIN}" ) |& ${PAGER}
  fi
}

function xpanes() {
  if ! exists tmux; then
    warning 'install "tmux" command'
    return 1
  fi
  if ! is_tmux; then
    warning 'run inside a tmux session'
    return 1
  fi

  local COMMAND NOSYNC NOCMD
  while (( ${#} > 0 )); do
    case "${1}" in
      -z | --nosync )
        NOSYNC=1
        shift
      ;;
      --ssh )
        NOCMD=1
        COMMAND='ssh'
        shift
      ;;
      -* )
        cat <<HELP 1>&2
Usage: ${0} [-z] [ command [ initial arguments ... ] ]

Options:
  -z, --nosync        Run without setting 'synchronize-panes on'
      --ssh           SSH mode
  -h, --help          Show this help message and exit


Examples:
  dig jp. ns +short | ${0} ping
    Run ping to all authoritative name server of .jp

  ${0} --ssh user@host1 user@host2
  echo user@host1 user@host2 | ${0} --ssh
    Run ssh to user@host1 and user@host2
HELP
        return 1
      ;;

      * )
        if [[ -z "${NOCMD}" ]]; then
          COMMAND="${1}"
          shift
        fi
        break
      ;;
    esac
  done

  [[ -z "${COMMAND}" ]] && COMMAND='echo'
  if ! exists "${COMMAND}"; then
    warning "no such command: ${COMMAND}"
    return 1
  fi

  local ARG
  local -a ARGUMENTS
  if [[ -n "${NOCMD}" && "${#}" != '0' ]]; then
    ARGUMENTS+=( "${@}" )
    shift "${#}"
  else
    for ARG in $(< /dev/stdin); do
      ARGUMENTS+=( "${ARG}" )
    done
  fi

  if (( ${#ARGUMENTS} < 1 )); then
    warning 'no arguments found'
    return 1
  fi
  (( ${#ARGUMENTS} == 1 )) && NOSYNC=1


  tmux new-window -a

  local -i i=1
  for ARG in "${ARGUMENTS[@]}"; do
    tmux split-window -d \; select-layout tiled
  done
  for ARG in "${ARGUMENTS[@]}"; do
    tmux send-keys -t ".$(( i++ ))" "${COMMAND} ${*} ${ARG}" C-m
  done

  tmux kill-pane -t .0
  tmux select-layout tiled

  [[ -z "${NOSYNC}" ]] && tmux set-option -w synchronize-panes on
  tmux refresh-client
}

function 256color() {
  printf '\e[48;5;%1$dm %1$x \e[0m' {0..7}
  printf '  '
  printf '\e[%1$dm %1$d \e[0m' {30..37}
  echo
  printf '\e[48;5;%1$dm %1$x \e[0m' {8..15}
  printf '  '
  printf '\e[1;%1$dm %1$d \e[0m' {30..37}
  printf '\n\n'

  local -i BASE ITERATION COUNT
  for BASE in {0..11}; do
    for ITERATION in {0..2}; do
      for COUNT in {0..5}; do
        printf '\e[48;5;%1$dm %1$x \e[0m' $(( 16 + ${BASE} * 6 + ${ITERATION} * 72 + ${COUNT} ))
      done
      printf '  '
    done
    echo
    (( ${BASE} == 5 )) && echo
  done
  echo

  printf '\e[48;5;%1$dm %1$x \e[0m' {232..255}
  printf '\n\n'

  local -i WIDTH COL R G B
  WIDTH=95
  for COL in {0..${WIDTH}}; do
    R=$(( 255 - ( ${COL} * 255 / ${WIDTH} ) ))
    G=$(( ${COL} * 510 / ${WIDTH} ))
    B=$(( ${COL} * 255 / ${WIDTH} ))
    (( ${G} > 255 )) && G=$(( 510 - ${G} ))
    printf '\e[48;2;%d;%d;%dm \e[0m' "${R}" "${G}" "${B}"
  done
  echo
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

Options:
  -y, --yes           Answer "yes" to any question
  -h, --help          Show this help message and exit


Examples:
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
  if [[ "${MODE}" == 'install' && "${#PACKAGES}" == '0' ]]; then
    warning 'no packages are specified in install mode'
    return 1
  fi

  local REPORTTIME=-1

  local OPTIONS
  if exists apt; then
    [[ -n "${YES}" ]] && OPTIONS=--assume-yes

    case "${MODE}" in
      install )
        sudo apt ${OPTIONS} clean        && \
        sudo apt ${OPTIONS} update       && \
        sudo apt ${OPTIONS} full-upgrade && \
        sudo apt ${OPTIONS} install --no-install-recommends "${PACKAGES[@]}" && \
        sudo apt ${OPTIONS} autoremove
      ;;

      update )
        sudo apt ${OPTIONS} clean        && \
        sudo apt ${OPTIONS} update       && \
        sudo apt ${OPTIONS} full-upgrade && \
        sudo apt ${OPTIONS} autoremove
      ;;
    esac

    [[ -s /var/run/reboot-required      ]] && cat /var/run/reboot-required
    [[ -s /var/run/reboot-required.pkgs ]] && cat /var/run/reboot-required.pkgs

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
}

function createpasswd() {
  # Default
  local -r LENGTH=18
  local -r NUMBER=1

  # Arguments
  local CHARACTER PARANOID
  local -i P_LENGTH="${LENGTH}"
  local -i P_NUMBER="${NUMBER}"

  local ARG
  while getopts hpc:l:n: ARG; do
    case "${ARG}" in
      'c' ) CHARACTER="${OPTARG}";;
      'l' ) P_LENGTH="${OPTARG}";;
      'n' ) P_NUMBER="${OPTARG}";;
      'p' ) PARANOID=1;;

      * )
        cat <<HELP 1>&2
Usage: ${0} [-p | -c <chars>] [-l <length>] [-n <number>]

Options:
  -c <chars>          Specify candidate characters for passwords
  -l <length>         Specify the length of password(s) (Default = ${LENGTH})
  -n <number>         Specify the number of password(s) (Default = ${NUMBER})
  -p                  Paranoid mode (Generated password contains all letter type)


Examples:
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

  if [[ -n "${PARANOID}" ]]; then
    [[ -n "${CHARACTER}" ]] && warning '-c option is ignored in paranoid mode'
    CHARACTER='[:graph:]'

    if (( ${P_LENGTH} < 4 )); then
      warning 'minimum length is 4 in paranoid mode'
      return 1
    fi
  fi

  LC_CTYPE=C tr -cd "${CHARACTER:-[:alnum:]}" < /dev/urandom \
    | fold -w "${P_LENGTH}" \
    | if [[ -n "${PARANOID}" ]]; then \
        grep '[[:digit:]]' | grep '[[:punct:]]' | grep '[[:upper:]]' | grep '[[:lower:]]' ; \
      else \
        cat ; \
      fi \
    | head -n "${P_NUMBER}"
}

function aws-ec2-instances() {
  if ! exists aws; then
    warning 'install "awscli" command'
    return 1
  fi

  local ARG LOCAL NOHEADER
  for ARG in "${@}"; do
    case "${ARG}" in
      -l | --local     ) LOCAL=1;;
      -H | --no-header ) NOHEADER=1;;

      -* )
        cat <<HELP 1>&2
Usage: ${0} [--local] [--no-header]

Options:
  -l, --local         Get instance lists only from the current region ($(aws configure get region))
  -H, --no-header     Print no header line at all
  -h, --help          Show this help message and exit
HELP
        return 1;;
    esac
  done

  local REPORTTIME=-1
  (
    [[ -z "${NOHEADER}" ]] && echo 'az stat type name id public-ip private-ip' ; \
    if [[ -n "${LOCAL}" ]]; then \
      aws configure get region ; \
    else \
      aws ec2 describe-regions --query 'Regions[].{Name:RegionName}' --output text ; \
    fi \
      | xargs -r -n1 -P4 stdbuf -oL aws ec2 describe-instances \
          --query 'Reservations[].Instances[].[
                     Placement.AvailabilityZone,
                     State.Name,
                     InstanceType,
                     Tags[?Key==`Name`].Value|[0],
                     InstanceId,
                     PublicIpAddress,
                     PrivateIpAddress
                   ]' \
          --output text \
          --region \
      | sort
  ) \
    | column -t \
    | sed \
        -e "s/\b\(stopped\)\b/$(printf '\e[31m')\1$(printf '\e[0m')/" \
        -e "s/\b\(running\)\b/$(printf '\e[32m')\1$(printf '\e[0m')/" \
        -e "s/\b\(pending\|shutting-down\|stopping\)\b/$(printf '\e[33m')\1$(printf '\e[0m')/" \
        -e "s/\b\(terminated\)\b/$(printf '\e[31;7m')\1$(printf '\e[0m')/"
}

function aws-ec2-spot() {
  if ! exists aws; then
    warning 'install "awscli" command'
    return 1
  fi
  if ! exists ruby; then
    warning 'install "ruby" command'
    return 1
  fi

  # Default
  local -r DAY=3
  local INSTANCE=c4.8xlarge

  # Arguments
  local -aU P_INSTANCE
  local -i P_DAY P_HOUR

  while (( ${#} > 0 )); do
    case "${1}" in
      --day )
        if [[ -z "${2}" || "${2}" != <-> ]]; then
          warning '--day option requires an integer argument'
          return 1
        fi
        P_DAY="${2}"
        shift
      ;;
      --hour )
        if [[ -z "${2}" || "${2}" != <-> ]]; then
          warning '--hour option requires an integer argument'
          return 1
        fi
        P_HOUR="${2}"
        shift
      ;;

      -* )
        cat <<HELP
Usage: ${0} [--day <days>] [--hour <hours>] [ instance_types ... ]

Options:
      --day <days>    Specify the duration in day to retrieve the price (Default = ${DAY})
      --hour <hours>  Specify the duration in hour to retrieve the price (Default = 0)
  -h, --help          Show this help message and exit


Examples:
  ${0} --hour 12
    Display price statistics of ${INSTANCE} for the last half a day

  ${0} --day 1 c4.8xlarge c3.8xlarge
    Display price statistics of c4.8xlarge and c3.8xlarge for the last one day
HELP
        return 1;;

      * )
        P_INSTANCE+=( "${1}" );;
    esac
    shift
  done

  (( ${#P_INSTANCE} < 1 )) && P_INSTANCE=( "${INSTANCE}" )
  (( ${P_DAY} == 0 && ${P_HOUR} == 0 )) && P_DAY="${DAY}"

  local FROM=$(date --utc --date="-${P_DAY} day -${P_HOUR} hour" +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null)
  local TO=$(date --utc +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null)

  if [[ -z "${FROM}" ]]; then
    warning '--day and/or --hour option contains illegal character'
    return 1
  fi

  printf '%30s%10s%10s%10s%10s%10s%10s\n' '' 'ave.r' 'stdev.s' 'max' 'min' 'latest' '(count)'

  aws ec2 describe-regions --query 'sort(Regions[].RegionName)' --output text \
    | xargs -r -n1 -P4 stdbuf -oL aws ec2 describe-spot-price-history \
        --output text \
        --instance-types "${P_INSTANCE[@]}" \
        --product-description 'Linux/UNIX (Amazon VPC)' \
        --start-time "${FROM}" \
        --end-time "${TO}" \
        --query 'SpotPriceHistory[].[AvailabilityZone,InstanceType,SpotPrice,Timestamp]' \
        --region \
    | ruby -rtime -e '
db = Hash.new{|h1,k1| h1[k1] = Hash.new{|h2,k2| h2[k2] = [] }}
while STDIN.gets
  az, type, price, time = $_.split(" ")
  db[az][type] << { price: price.to_f, timestamp: Time.parse(time) }
end

result = []
db.each_key{|az|
  db[az].each{|type, record|
    next if record.length < 1

    ave_s = record.inject(0.0){|sum, v| sum + v[:price] } / record.length

    sum_r = 0.0
    (record + [{timestamp: Time.parse(ARGV.first)}]).sort_by{|v| v[:timestamp] }.each_cons(2){|base, subseq|
      sum_r += base[:price] * (subseq[:timestamp] - base[:timestamp])
    }

    result << {
      type:    type,
      az:      az,
      ave_r:   sum_r / (Time.parse(ARGV.first) - record.min_by{|v| v[:timestamp]}[:timestamp]),
      ave_s:   ave_s,
      stdev_s: record.length < 2 ? 0.0 : Math.sqrt(record.inject(0.0){|sum, v| sum + (v[:price] - ave_s) ** 2 } / (record.length - 1)),
      max:     record.max_by{|v| v[:price] }[:price],
      min:     record.min_by{|v| v[:price] }[:price],
      latest:  record.max_by{|v| v[:timestamp]}[:price],
      count:   record.length
    }
  }
}

if result.length < 1
  puts "... no record ...".center(80)
else
  result.sort_by{|v| v.values }.each{|v|
    rank = result.select{|r| r[:type] == v[:type] }
    color = lambda {|k|
      case true
      when v[k] <= rank.map{|r| r[k] }.min(3).last then "\e[32;7m"
      when v[k] >= rank.map{|r| r[k] }.max(3).last then "\e[31;7m"
      else ""
      end
    }

    printf("%-14s%-16s%s%10.3f\e[0m%s%10.3f\e[0m%s%10.3f\e[0m%s%10.3f\e[0m%s%10.3f\e[0m   (%5d)\n",
           v[:type], v[:az],
           color.call(:ave_r),   v[:ave_r],
           color.call(:stdev_s), v[:stdev_s],
           color.call(:max),     v[:max],
           color.call(:min),     v[:min],
           color.call(:latest),  v[:latest],
                                 v[:count]
          )
  }
end
' "${TO}"
}
#}}}

# Alias {{{
alias sudo='sudo '
alias sort='LC_ALL=C sort'

alias zmv='noglob zmv -v'
alias zcp='noglob zmv -vC'
alias zln='noglob zmv -vL'

alias l.='ls -d .*'
alias la='ls -AF'
alias ll='ls -l'

alias rm='rm -I'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -v'
alias mkdir='mkdir -vp'
alias rmdir='rmdir -vp'

alias chmod='chmod -v'
alias chown='chown -v'

alias .='pwd'

alias a='./a.out'
#alias b=''
#alias c=''
alias d='dirs -pv'
#alias e=''
#alias f=''
#alias g=''
alias h='fc -l -t "%b.%e %k:%M"'
#alias i=''
alias j='jobs -l'
#alias k=''
#alias l=''
#alias m=''
#alias n=''
#alias o=''
#alias p=''
#alias q=''
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

if [[ -n "${TTY}" && "${SHLVL}" == '1' ]] && exists tmux && is_ssh; then
  tmux new-session -AD -s "${TTY:-/dev/null}"
fi
