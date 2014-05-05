# .bash_profile
history -c
unset HISTFILE

# zsh executor http://blog.kenichimaehashi.com/?article=12851025960
if [ -z "${BASH_EXECUTION_STRING}" ]; then
  ZSH="/bin/zsh"
  [ -x "${ZSH}" ] && SHELL="${ZSH}" exec "${ZSH}" -l
fi

