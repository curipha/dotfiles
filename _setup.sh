#!/usr/bin/env bash

# Dotfiles initializer
#  * Create symlinks to dotfiles in your repository.

SOURCE_DIR="$(cd `dirname "${0}"` && pwd)"

DOTFILES=( gemrc gitconfig gvimrc inputrc irbrc screenrc vimrc wgetrc zshrc )
SSH_CONFIG=ssh_config

makeln()
{
  if [ ${#} -ne 2 ]; then
    echo 'ERR: Illegal usage of makeln().'
    exit 1
  fi

  if [ ! -f ${1} ]; then
    echo "ERR: Source file (${1}) is not exists."
    exit 1
  fi

  if [ -L ${2} ]; then
    rm -fv ${2}
  fi
  if [ -f ${2} ]; then
    mv -iv ${2} ${2}.bak
  fi

  ln -sv ${1} ${2}
}


for file in ${DOTFILES[@]}; do
  makeln "${SOURCE_DIR}/${file}" "${HOME}/.${file}"
done

if [ -n ${SSH_CONFIG} ]; then

  if [ ! -d ${HOME}/.ssh ]; then
    mkdir -vp ${HOME}/.ssh
    chmod 0700 ${HOME}/.ssh
  fi

  makeln "${SOURCE_DIR}/${SSH_CONFIG}" "${HOME}/.ssh/config"
fi

