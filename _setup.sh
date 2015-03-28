#!/usr/bin/env bash

# Dotfiles initializer
#  * Create symlinks to dotfiles in your repository.

set -o nounset
set -o errexit

SOURCE_DIR="$(cd `dirname "${0}"` && pwd)"

DOTFILES=( gemrc gitconfig gvimrc inputrc irbrc screenrc vimrc wgetrc zshrc )
SSH_CONFIG=ssh_config

abort() {
  echo $@
  exit 1
}

makeln() {
  [[ ! -f "${1}" ]] && abort "ERR: Source file (${1}) is not exists."

  [[ -f "${2}" ]] && [[ ! -L "${2}" ]] && mv -iv "${2}" "${2}.bak"

  ln -fsv "${1}" "${2}"
}


for file in ${DOTFILES[@]}; do
  makeln "${SOURCE_DIR}/${file}" "${HOME}/.${file}"
done

if [[ -n ${SSH_CONFIG} ]]; then
  if [[ ! -d "${HOME}/.ssh" ]]; then
    mkdir -vp "${HOME}/.ssh"
    chmod -v 0700 "${HOME}/.ssh"
  fi

  makeln "${SOURCE_DIR}/${SSH_CONFIG}" "${HOME}/.ssh/config"
fi

