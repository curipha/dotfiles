#!/usr/bin/env bash

# Dotfiles initializer
#  * Create symlinks to dotfiles in your repository.

set -o nounset
set -o errexit

DOTFILES=( gemrc gitconfig gvimrc inputrc irbrc pryrc screenrc tmux.conf vimrc zshrc )
SSH_CONFIG=ssh_config

abort() {
  echo "$@"
  exit 1
}

makeln() {
  [[ ! -f "${1}" ]] && abort "ERR: Source file (${1}) is not exists."

  [[ -f "${2}" && ! -L "${2}" ]] && mv -iv "${2}" "${2}.bak"

  ln -fsv "${1}" "${2}"
}

cd "$(dirname "${0}")"

for file in "${DOTFILES[@]}"; do
  makeln "${PWD}/${file}" "${HOME}/.${file}"
done

if [[ -n "${SSH_CONFIG}" ]]; then
  if [[ ! -d "${HOME}/.ssh" ]]; then
    mkdir -vp "${HOME}/.ssh"
    chmod -v 0700 "${HOME}/.ssh"
  fi

  makeln "${PWD}/${SSH_CONFIG}" "${HOME}/.ssh/config"
fi

if [[ ! "${SHELL}" =~ /zsh$ ]]; then
  ZSH=$(grep -m1 zsh /etc/shells)

  echo Change login shell to Zsh...
  chsh -s "${ZSH}"
fi

