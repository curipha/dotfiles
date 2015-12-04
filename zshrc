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

export TERM=xterm-256color
[[ -z "${HOSTNAME}" ]] && export HOSTNAME=`hostname`
[[ -z "${SHELL}" ]]    && export SHELL=`whence -p zsh`
[[ -z "${USER}" ]]     && export USER=`id -un`
[[ -z "${EUID}" ]]     && export EUID=`id -u`
[[ -z "${UID}" ]]      && export UID=`id -ru`

export CYGWIN='nodosfilewarning winsymlinks:native'

export GEM_HOME=~/app/gem
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
  /usr/local/sbin(N-/)
  /usr/sbin(N-/)
  /sbin(N-/)
  /usr/local/bin(N-/)
  /usr/bin(N-/)
  /bin(N-/)
  $path
)
typeset -U path
export PATH

cdpath=(
  $HOME
  ..
  ../..
)
typeset -U cdpath

umask 022
ulimit -c 0

stty -ixon -ixoff
#}}}
# Autoloads {{{
autoload -Uz add-zsh-hook
autoload -Uz colors
autoload -Uz compinit
autoload -Uz history-search-end
autoload -Uz modify-current-argument
autoload -Uz run-help
autoload -Uz smart-insert-last-word
autoload -Uz url-quote-magic
autoload -Uz vcs_info
autoload -Uz zmv
#}}}
# Functions {{{
function exists() { whence -p "${1}" &> /dev/null }
function isinsiderepo() { exists git && [[ `git rev-parse --is-inside-work-tree 2> /dev/null` == 'true' ]] }
#}}}
# Macros {{{
case ${OSTYPE} in
  linux*)
    limit coredumpsize 0

    alias ls='ls --color=auto'
  ;;

  darwin*)
    limit coredumpsize 0

    alias ls='ls -G'
  ;;

  freebsd*)
    limit coredumpsize 0

    alias ls='ls -G'

    exists gmake && alias make=gmake
    exists gmake && export MAKE=`whence -p gmake`

    exists jot   && alias seq=jot
  ;;

  cygwin)
    alias ls='ls --color=auto'
    alias open=cygstart
    alias start=cygstart
  ;;
esac

[[ -n "${DISPLAY}" ]] && xset -b

if exists vim; then
  export EDITOR=vim
  export VISUAL=vim

  alias vi=vim
  alias view='vim -R'
fi

if exists less; then
  export PAGER=less

  alias taill='LESSOPEN= LESSCLOSE= less +F'
else
  export PAGER=cat
fi

exists dircolors && eval `dircolors --bourne-shell`

DIFF_PARAM='--unified --report-identical-files --minimal'
if exists colordiff; then
  alias diff="colordiff ${DIFF_PARAM}"
else
  alias diff="diff ${DIFF_PARAM}"
fi
unset DIFF_PARAM

GREP_PARAM='--color=auto --binary-files=text'
if [[ `grep --help 2>&1` =~ '--exclude-dir' ]]; then
  for EXCLUDE_DIR in .git .deps .libs; do
    GREP_PARAM+=" --exclude-dir=${EXCLUDE_DIR}"
  done
fi
alias grep="grep ${GREP_PARAM}"
unset GREP_PARAM EXCLUDE_DIR

if exists gcc; then
  GCC_HELP=`gcc -v --help 2> /dev/null`

  CFLAGS='-march=native -mtune=native -O2 -pipe'
  if   [[ "${GCC_HELP}" =~ '-fstack-protector-strong' ]]; then
    CFLAGS+=' -fstack-protector-strong --param=ssp-buffer-size=4'
  elif [[ "${GCC_HELP}" =~ '-fstack-protector' ]]; then
    CFLAGS+=' -fstack-protector --param=ssp-buffer-size=4'
  fi

  export CFLAGS
  export CXXFLAGS="${CFLAGS}"
  unset GCC_HELP
fi

if exists manpath; then
  MANPATH=`MANPATH= manpath`

  manpath=(
    ~/app/*/man(N-/)
    ~/app/*/share/man(N-/)
    ${(s.:.)MANPATH}
  )
  typeset -U manpath
  export MANPATH
fi
#}}}

# Core {{{
bindkey -e

bindkey '^?'    backward-delete-char
bindkey '^H'    backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line

bindkey '^[[Z' reverse-menu-complete

setopt correct
setopt combining_chars
setopt no_flow_control
setopt ignore_eof
setopt print_exit_value
setopt print_eightbit

setopt multios
#setopt xtrace

setopt no_beep
setopt no_clobber

setopt c_bases
setopt octal_zeroes

REPORTTIME=2
TIMEFMT='%J | user: %U, system: %S, cpu: %P, total: %*E'

MAILCHECK=0
KEYTIMEOUT=10

colors
zle -N self-insert url-quote-magic

[[ `whence -w run-help` == 'run-help: alias' ]] && unalias run-help
#}}}
# Prompt {{{
[[ -n "${SSH_CLIENT}${SSH_CONNECTION}" || `ps -o comm= -p "${PPID}" 2> /dev/null` == 'sshd' ]] \
  && SSH_INDICATOR='@ssh'

PROMPT="[%m${SSH_INDICATOR}:%~] %n%1(j.(%j%).)%# "
PROMPT2='%_ %# '
RPROMPT='  %1v  %D{%b.%f (%a) %K:%M}'
SPROMPT='zsh: Did you mean %B%r%b ?  [%UN%uo, %Uy%ues, %Ua%ubort, %Ue%udit]: '
unset SSH_INDICATOR

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


zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' stagedstr '(+)'
zstyle ':vcs_info:*' unstagedstr '(!)'
zstyle ':vcs_info:git:*' check-for-changes true

zstyle ':vcs_info:*' formats '[%s:%b%c%u]'
zstyle ':vcs_info:*' actionformats '[%s:%b%c%u]'

zstyle ':vcs_info:*' max-exports 1

function precmd_vcs_info() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "${vcs_info_msg_0_}" ]] && psvar[1]="${vcs_info_msg_0_}"
}
add-zsh-hook precmd precmd_vcs_info
#}}}

# Jobs {{{
setopt auto_resume
setopt bg_nice
setopt long_list_jobs
#}}}
# History {{{
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt append_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history

setopt hist_ignore_space
setopt hist_no_store

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
#}}}
# Complement {{{
compinit

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
    reply=(_expand _complete _history _correct _match _prefix _list)
  fi'

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[.,_-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=long-list

zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' ignore-line other
zstyle ':completion:*' ignore-parents parent pwd ..

zstyle ':completion:*:default' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*:default' select-prompt '%SScrolling active: current selection at %p%s'

zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:processes' command "ps -U ${USER} -o pid,user,command -w -w"
zstyle ':completion:*:(processes|jobs)' menu yes=2 select=2

zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:hosts' ignored-patterns localhost 'localhost.*' '*.localdomain'

if [[ -r /etc/passwd ]]; then
  [[ -r /etc/login.defs ]] && \
    eval `awk '$1 ~ /^UID_(MAX|MIN)$/ && $2 ~ /^[0-9]+$/ { print $1 "=" $2 }' /etc/login.defs`

  zstyle ':completion:*:users' users \
    $(awk -F: "\$3 >= ${UID_MIN:-1000} && \$3 <= ${UID_MAX:-60000} { print \$1 }" /etc/passwd)
  unset UID_MIN UID_MAX
fi

zstyle ':completion:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:-subscript-:*' list-separator ':'

zstyle ':completion:*:sudo:*' command-path
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:scp:*:files' command command -

setopt auto_cd
setopt auto_pushd
setopt cdable_vars
setopt pushd_ignore_dups
setopt pushd_to_home

setopt always_last_prompt
setopt auto_list
setopt auto_menu
setopt auto_name_dirs
setopt auto_param_keys
setopt auto_param_slash
setopt auto_remove_slash
#setopt complete_aliases
setopt complete_in_word
setopt extended_glob
setopt glob_complete
setopt glob_dots
setopt list_packed
setopt list_types
setopt numeric_glob_sort

setopt brace_ccl
setopt equals
setopt magic_equal_subst
setopt mark_dirs
setopt path_dirs

zle -N insert-last-word smart-insert-last-word
zstyle ':insert-last-word' match '*([[:alpha:]/\\]?|?[[:alpha:]/\\])*'
bindkey '^]' insert-last-word

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
function magic-abbrev-expand-and-accept() {
  magic-abbrev-expand
  zle accept-line
}
function magic-abbrev-expand-and-complete() {
  magic-abbrev-expand
  zle expand-or-complete
}

zle -N magic-abbrev-expand-and-insert
zle -N magic-abbrev-expand-and-complete
zle -N magic-abbrev-expand-and-accept
bindkey ' '  magic-abbrev-expand-and-insert
bindkey '^I' magic-abbrev-expand-and-complete
#bindkey '^M' magic-abbrev-expand-and-accept   # ^M will be handled by 'magic_enter'
#}}}
# Utility{{{
alias rename='noglob zmv -ivW'
alias wipe='shred --verbose --iterations=3 --zero --remove'

alias cls='echo -en "\033c" && tput clear'
alias rst='
  if [[ -n `jobs` ]]; then
    echo "zsh: processing job still exists." 1>&2
  elif [[ "${0:0:1}" == "-" ]]; then
    exec -l zsh
  else
    exec zsh
  fi'

function chpwd_ls() { ls -AF }
add-zsh-hook chpwd chpwd_ls

function command_not_found_handler() {
  if isinsiderepo; then
    git_alias=( `git config --list | sed -En 's/^alias\.([^=]+).+$/\1/p'` )

    if [[ "${git_alias[(I)${0}]}" != '0' ]]; then
      echo "git ${@}"
      git "${@}"
      return "${?}"
    fi
  fi

  return 127
}

function +x() { chmod +x "${@}" }

function bak() { [[ "${#}" == '1' ]] && cp -fv "${1}"{,.bak} }
function rvt() { [[ "${#}" == '1' ]] && mv -iv "${1}"{,.new} && mv -iv "${1}"{.bak,} }

function enc() { [[ "${#}" == '1' ]] && openssl enc -e -aes-256-cbc -in "${1}" -out "${1}".enc }
function dec() { [[ "${#}" == '1' ]] && openssl enc -d -aes-256-cbc -in "${1}" -out "${1}".dec }

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
        echo 'Warning: Directory already exists. Just change direcotry.' 1>&2
        builtin cd "${1}"
      else
        mkdir -vp "${1}" && builtin cd "${1}"
      fi
    ;;

    * )
      local DIR="${@: -1}"
      if [[ -d "${DIR}" ]]; then
        echo 'Warning: Directory already exists. Just move file(s).' 1>&2
        mv -iv "${@}"
      else
        mkdir -vp "${DIR}" && mv -iv "${@}"
      fi
    ;;
  esac
}
alias mkcd=mkmv

function whois() {
  local WHOIS
  exists jwhois && WHOIS=`whence -p jwhois`
  exists whois  && WHOIS=`whence -p whois`

  if [[ -z "${WHOIS}" ]]; then
    echo 'Error: Please install "whois" command first.' 1>&2
    return 1
  fi

  local DOMAIN=`echo "${1}" | sed -E 's!^([^:]+://)?([^/]+).*$!\2!' | sed -E 's!^www\.([^\.]+\.[^\.]+)$!\1!'`
  if [[ -z "${DOMAIN}" ]]; then
    ${WHOIS}
  else
    ( echo "${WHOIS} ${DOMAIN}" && ${WHOIS} ${DOMAIN} ) |& ${PAGER}
  fi
}

function change_command() {
  [[ -z "${BUFFER}" && "${CONTEXT}" == 'start' ]] && zle up-history

  zle beginning-of-line

  [[ "${BUFFER}" == sudo\ * ]] && zle kill-word
  zle kill-word
}
zle -N change_command
bindkey '^X^X' change_command

function prefix_with_sudo() {
  [[ -z "${BUFFER}" && "${CONTEXT}" == 'start' ]] && zle up-history
  [[ "${BUFFER}" != sudo\ * ]] && BUFFER="sudo ${BUFFER}"
  zle end-of-line
}
zle -N prefix_with_sudo
bindkey '^S^S' prefix_with_sudo

function magic_enter() {
  if [[ -z "${BUFFER}" && "${CONTEXT}" == 'start' ]]; then
    if isinsiderepo; then
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
    zle self-insert '^'
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
  local -a PACKAGES
  for ARG in "${@}"; do
    case "${ARG}" in
      base )
        PACKAGES=( "${PACKAGES[@]}" zsh vim lua git gnupg2 screen tmux );;
      network | net )
        PACKAGES=( "${PACKAGES[@]}" nc jwhois traceroute bind-utils nmap openssl curl wget );;
      develop | dev )
        PACKAGES=( "${PACKAGES[@]}" gcc gcc-c++ make autoconf automake libtool binutils lsof patch strace kernel-devel libstdc++-devel );;
      archive )
        PACKAGES=( "${PACKAGES[@]}" bzip2 unzip xz );;
      utility | util )
        PACKAGES=( "${PACKAGES[@]}" binutils diffutils sharutils psmisc lsof patch strace );;
      ruby )
        PACKAGES=( "${PACKAGES[@]}" ruby irb );;
      multimedia | multi )
        PACKAGES=( "${PACKAGES[@]}" ImageMagick );;
      yum )
        PACKAGES=( "${PACKAGES[@]}" yum-plugin-remove-with-leaves );;
      misc )
        PACKAGES=( "${PACKAGES[@]}" figlet file jq nkf sqlite );;

      install | update )
        if [[ -z "${MODE}" ]];then
          MODE="${ARG}"
        else
          echo 'Warning: Execution mode is already set. Argument is assumed as a package name.' 1>&2
          PACKAGES=( "${PACKAGES[@]}" "${ARG}" )
        fi
      ;;

      -y | --yes )
        YES=1;;
      -* )
        cat <<HELP 1>&2
Usage: ${0} [-y] [-h] install [ packages ... ]
Usage: ${0} [-y] [-h] update

Options:
  -y, --yes           Answer "yes" to any question
  -h, --help          Show this help message and exit

List of pre-defined packages:
  base                Base packages for usual operation
  network (net)       Network related packages
  develop (dev)       Development suite
  archive             Archivers
  utility (util)      Utility tools
  multimedia (multi)  Images, videos and musics
  ruby                Ruby and its related packages
  yum                 Yum support packages
  misc                Miscellaneous


Example:
  ${0} -v install base
  Install base packages in verbose mode

  ${0} -v install base
  Install base packages in verbose mode

  ${0} -y update
  Update all packages in any case
HELP
        return 1;;

      * )
        PACKAGES=( "${PACKAGES[@]}" "${ARG}" );;
    esac
  done

  if [[ -z "${MODE}" ]]; then
    echo 'Error: Specify operation mode.' 1>&2
    return 1
  fi
  if [[ "${MODE}" == 'install' && "${#PACKAGES[@]}" == '0' ]]; then
    echo 'Error: Specify at least one package in install mode.' 1>&2
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
          sudo apt-get ${OPTIONS} update                   && \
          sudo apt-get ${OPTIONS} install "${PACKAGES[@]}" && \
          sudo apt-get ${OPTIONS} autoremove
        ;;

        update )
          sudo apt-get ${OPTIONS} update       && \
          sudo apt-get ${OPTIONS} dist-upgrade && \
          sudo apt-get ${OPTIONS} autoremove
        ;;
      esac

      sudo -K
    elif exists yum; then
      [[ -n "${YES}" ]] && OPTIONS=--assumeyes

      case "${MODE}" in
        install )
          sudo yum ${OPTIONS} install "${PACKAGES[@]}" && \
          sudo yum ${OPTIONS} autoremove
        ;;

        update )
          sudo yum ${OPTIONS} upgrade    && \
          sudo yum ${OPTIONS} autoremove
        ;;
      esac

      sudo -K
    elif exists pacman; then
      [[ -n "${YES}" ]] && OPTIONS=--noconfirm

      case "${MODE}" in
        install )
          sudo pacman -Sy ${OPTIONS} "${PACKAGES[@]}"
        ;;

        update )
          sudo pacman -Syu ${OPTIONS}
        ;;
      esac

      sudo -K
    else
      echo 'Cannot find a package manager which I know.' 1>&2
      return 1
    fi
  } always {
    local RETURN="${?}"
    REPORTTIME="${REPORTTIME_ORIG}"
    return "${RETURN}"
  }
}

function checkclock() {
  if ! exists ntpdate; then
    echo 'Error: Error: Please install "ntpdate" command first.' 1>&2
    return 1
  fi

  local -a NTP
  NTP=( ntp.nict.jp ntp.jst.mfeed.ad.jp jp.pool.ntp.org )

  local UPDATE RTC
  while getopts hru ARG; do
    case "${ARG}" in
      'r' ) RTC=1;;
      'u' ) UPDATE=1;;

      * )
        cat <<HELP 1>&2
Usage: ${0} [-ru]

  -r            Display RTC clock if possible
  -u            Update system clock
HELP
      return 1;;
    esac
  done

  if exists timedatectl; then
    local LINEOPT=-2
    [[ -n "${RTC}" ]] && LINEOPT=-3

    timedatectl | head ${LINEOPT}
  else
    echo -n '      Local time: ' && date
    echo -n '  Universal time: ' && date -u
    [[ -n "${RTC}" ]] && echo -n '        RTC time: ' && sudo hwclock --show
  fi

  echo
  echo Checking NTP servers...
  ntpdate -p1 -sq ${NTP} \
    | grep -v 'stratum 0' \
    | sed -e 's/, / /g' \
    | awk '{ offset += $6; delay += $8; print } END { if (NR > 0) { print "* * * * avg.", offset / NR, "avg.", delay / NR } }' \
    | column -t

  if [[ -n "${UPDATE}" ]]; then
    echo
    read -q 'REPLY?System clock will be updated by step mode. Are you sure? [y/N] '

    if [[ "${REPLY}" == 'y' ]]; then
      sudo ntpdate -b ${NTP}
      sudo hwclock --systohc
    else
      echo 'Cancel the update of system clock.'
      return 1
    fi
  fi
}

function createpasswd() {
  # Default
  local CHARACTER='[:alnum:]'
  local LENGTH=18
  local NUMBER=10

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
    Create ${NUMBER} of passwords (${LENGTH} chars) contains letters and digits.

  ${0} -l 24 -n 1
    Create a password (24 chars) contains printable chars, not including space.

  ${0} -c ACGT -n 20
    Get a piece of DNA sequence.
HELP
      return 1;;
    esac
  done

  if [[ -n "${F_PARANOID}" ]]; then
    P_CHARACTER='[:graph:]'
    [[ -n "${F_CHARACTER}" ]] && echo 'Warning: -c option is ignored in paranoid mode.' 1>&2
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
#alias d=''
#alias e=''
#alias f=''
#alias g=''
alias h='fc -l -t "%b.%d %T"'
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

[[ -r ~/.zshrc.include ]] && source ~/.zshrc.include

