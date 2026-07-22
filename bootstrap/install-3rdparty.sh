#!/bin/bash
# Invoked from the mise bootstrap post-packages hook.
# Installs user tools that no system package manager carries (anyrc / dein.vim)
# and, on macOS, applies Homebrew casks from ~/Brewfile.
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

# Homebrew casks (macOS). `brew bundle` reads ~/Brewfile, which is symlinked
# from home/Brewfile via the [dotfiles] entry in mise/config.macos.toml.
# No --cleanup: mise's brew: backend installs formulae into the same prefix
# and cleanup would remove them since they are not listed in Brewfile.
if [ "$(uname -s)" = "Darwin" ] && [ -f ~/Brewfile ]; then
  if command -v brew >/dev/null; then
    brew bundle --file=~/Brewfile
  else
    echo "install-3rdparty: Homebrew not installed; skipping cask bundle." >&2
    echo "install-3rdparty: install it from https://brew.sh then re-run 'mise bootstrap'." >&2
  fi
fi
