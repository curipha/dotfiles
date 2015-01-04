#!/usr/bin/env bash

# Dotfiles initializer
#  * Create symlinks to dotfiles in your repository.

SOURCE_DIR=${HOME}/dotfiles

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
  SOURCE=${SOURCE_DIR}/${file}
  TARGET=${HOME}/.${file}

  makeln ${SOURCE} ${TARGET}
done

if [ -n ${SSH_CONFIG} ]; then
  SOURCE=${SOURCE_DIR}/${SSH_CONFIG}
  TARGET=${HOME}/.ssh/config

  if [ ! -d ${HOME}/.ssh ]; then
    mkdir -vp ${HOME}/.ssh
    chmod 0700 ${HOME}/.ssh
  fi

  makeln ${SOURCE} ${TARGET}
fi

