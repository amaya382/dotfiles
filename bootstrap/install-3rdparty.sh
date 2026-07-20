#!/bin/bash
# Invoked from the mise bootstrap post-packages hook.
# Installs user tools that no system package manager carries (anyrc / zplug / dein.vim).
# Idempotent: exits silently when everything is already present.
set -eu

mkdir -p ~/.local/bin

# anyrc
if [ ! -x ~/.local/bin/anyrc ]; then
  curl -sSL https://raw.githubusercontent.com/amaya382/anyrc/master/install.sh \
    | DIR=~/.local/bin bash
fi

# dein.vim
if [ ! -d ~/.cache/dein/repos/github.com/Shougo/dein.vim ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Shougo/dein-installer.vim/master/installer.sh)" \
    -- --use-vim-config -y
fi
