#
# .zshrc (2014-8-23)
#

# Environments {{{
#export LANG=ja_JP.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#export LC_ALL=ja_JP.UTF-8
export LC_COLLATE=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export LC_IDENTIFICATION=ja_JP.UTF-8
export LC_MEASUREMENT=ja_JP.UTF-8
#export LC_MESSAGES=C
export LC_MONETARY=ja_JP.UTF-8
#export LC_NUMERIC=C
export LC_PAPER=ja_JP.UTF-8
export LC_TELEPHONE=ja_JP.UTF-8
#export LC_TIME=C

export EDITOR=vim
export PAGER=less
export VISUAL=vim

export TERM=xterm-256color

export GREP_OPTIONS='--color=auto --binary-files=without-match'
export GZIP=-v9N
export LESS='--LONG-PROMPT --QUIET --RAW-CONTROL-CHARS --chop-long-lines --ignore-case --jump-target=5 --no-init --quit-if-one-screen --tabs=2'
export LESSCHARSET=utf-8
export LESSHISTFILE=/dev/null

export RUBYOPT='-w -EUTF-8'
#export MAKEFLAGS=-j4
export WINEDEBUG=-all

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

manpath=(
  ~/app/*/man(N-/)
  $manpath
)
typeset -U manpath

umask 022
ulimit -c 0

stty -ixon -ixoff
# }}}
# Autoloads {{{
autoload -Uz add-zsh-hook
autoload -Uz colors
autoload -Uz compinit
autoload -Uz history-search-end
#autoload -Uz predict-on
autoload -Uz url-quote-magic
autoload -Uz vcs_info
autoload -Uz zmv
#}}}
# Functions {{{
function exists() { whence -p $1 &> /dev/null }
# }}}
# Macros {{{
case ${OSTYPE} in
  linux*)
    limit coredumpsize 0

    alias ls='ls --color=auto'

    eval "$(dircolors -b)"
  ;;

  darwin*)
    limit coredumpsize 0

    alias ls='ls -G'
  ;;

  freebsd*)
    limit coredumpsize 0

    alias ls='ls -G'
  ;;

  cygwin)
    alias ls='ls --color=auto'
    alias open='cygstart'
    alias start='cygstart'

    eval "$(dircolors -b)"
  ;;
esac

if exists rlwrap; then
  alias rlwrap='rlwrap -pBlue -s500 -D2 -i'
  alias irb='rlwrap -a irb'
fi

if exists colordiff; then
  alias diff='colordiff'
fi

if exists pry; then
  alias irb='pry'
fi

if grep --help 2>&1 | grep -q -- --exclude-dir; then
  for EXCLUDE_DIR in .cvs .git .hg .svn .deps .libs; do
    GREP_OPTIONS+=" --exclude-dir=${EXCLUDE_DIR}"
  done
fi
# }}}

# Core {{{
bindkey -e

bindkey "^?"      backward-delete-char
bindkey "^H"      backward-delete-char
bindkey "[3~" delete-char
bindkey "[1~" beginning-of-line
bindkey "[4~" end-of-line

bindkey ' ' magic-space

setopt correct
setopt no_flow_control
setopt ignore_eof
setopt print_exit_value
setopt print_eightbit

setopt multios
#setopt xtrace

setopt no_beep
setopt no_clobber

REPORTTIME=2
MAILCHECK=0

colors
zle -N self-insert url-quote-magic
# }}}
# Prompt {{{
PROMPT="[%m:%~] %n%# "
PROMPT2="%_ %# "
RPROMPT="  %D{%b.%e (%a) %k:%M} [%j]"

[[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]] && PROMPT="[%m@ssh:%~] %n%# "

setopt prompt_cr
setopt prompt_sp
PROMPT_EOL_MARK="%B%S<EOL>%s%b"

setopt prompt_subst
setopt transient_rprompt

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' stagedstr '(+)'
zstyle ':vcs_info:*' unstagedstr '(!)'
zstyle ':vcs_info:git:*' check-for-changes true

zstyle ':vcs_info:*' formats '[%s:%b%c%u]'
zstyle ':vcs_info:*' actionformats '[%s:%b%c%u]'

function precmd_vcs_info() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

add-zsh-hook precmd precmd_vcs_info
RPROMPT="  %1v${RPROMPT}"
# }}}

# Jobs {{{
setopt auto_resume
setopt bg_nice
setopt long_list_jobs
# }}}
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

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
# }}}
# Complement {{{
compinit

LISTMAX=0
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache true
zstyle ':completion:*' completer _expand _complete _correct _approximate _match _prefix _list
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select=long
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[.,_-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'

zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:*:*:users' ignored-patterns \
adm amanda apache avahi avahi-autoipd backup beaglidx bin cacti canna clamav colord \
daemon dbus distcache dovecot fax ftp games gdm git gkrellmd gnats gopher \
hacluster haldaemon halt hplip hsqldb http ident irc junkbust kernoops \
ldap libuuid lightdm list lp lxdm man mail mailman mailnull messagebus mldonkey mysql \
nagios named netdump news nfsnobody nobody nscd ntp nut nx openvpn operator \
pcap polkitd postfix postgres privoxy proxy pulse pvm quagga radvd rpc rpcuser rpm rtkit \
saned shutdown squid sshd sync sys syslog usbmux uucp uuidd vcsa www www-data xfs

zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd
cdpath=(
  $HOME
  ..
  ../..
)
typeset -U cdpath

zstyle ':completion:*:sudo:*' command-path

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,cmd -w -w"
zstyle ':completion:*:(processes|jobs)' menu yes select=2

zstyle ':completion:*:complete:scp:*:files' command command -

#predict-on

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
setopt glob_dots
setopt list_packed
setopt list_types

setopt brace_ccl
setopt equals
setopt magic_equal_subst
setopt mark_dirs
setopt path_dirs
#}}}
# Utility{{{
alias rename='noglob zmv -ivW'

function chpwd() { ls -AF }

function bak() { [[ $# -gt 0 ]] && cp -fv "$1"{,.bak} }
function rvt() { [[ $# -gt 0 ]] && mv -iv "$1"{,.new} && mv -iv "$1"{.bak,} }

sudo-command-line() {
  [[ -z $BUFFER ]] && zle up-history
  [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
  zle end-of-line
}
zle -N sudo-command-line
bindkey "^S^S" sudo-command-line
#}}}

# Alias {{{
alias l.='ls -d .*'
alias la='ls -AF'
alias ll='ls -l'
alias lla='ls -AFl'
alias llh='ls -Flh'
alias llha='ls -AFlh'
alias llr='ls -FlhR'
alias llra='ls -AFlhR'
alias lls='ls -AFl'
alias lr='ls -FR'
alias lra='ls -AFR'

alias kk='ls -l'

alias sl='screen -list'
alias srr='screen -d -RR'

alias rm='rm -i'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -v'
alias mkdir='mkdir -vp'

alias chmod='chmod -v'
alias chown='chown -v'

alias cls='tput clear'

alias vi='vim'
alias view='vim -R'

alias xs='cd'
alias vf='cd'

alias :q='exit'

alias .='pwd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias ,,='cd ..'
alias ,,,='cd ../..'

alias ~='cd ~'
alias /='cd /'

alias rst='tput clear && exec zsh'
alias hs='history 0 | grep -iE'

alias a='./a.out'
#alias b=''
#alias c=''
alias d='du -skh .'
#alias e=''
alias f='find'
alias g='git'
#alias h=''
#alias i=''
alias j='jobs -l'
#alias k=''
alias l='last -a | less'
#alias m=''
#alias n=''
#alias o=''
#alias p=''
alias q='exit'
#alias r=''
alias s='screen'
#alias t=''
#alias u=''
#alias v=''
#alias w=''
alias x='exit'
#alias y=''
#alias z=''
# }}}

[[ -f ~/.zshrc.include ]] && source ~/.zshrc.include

