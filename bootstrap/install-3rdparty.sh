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
    # --no-upgrade keeps this call to installing what is missing; `brew bundle`
    # otherwise upgrades every outdated cask, turning a re-run of `mise
    # bootstrap` into an unasked-for GUI app update. Upgrades are handled below.
    brew bundle --file=~/Brewfile --no-upgrade

    outdated_casks=$(comm -12 \
      <(brew bundle list --cask --file=~/Brewfile | sort) \
      <(brew outdated --cask --quiet | sort))

    if [ -n "$outdated_casks" ]; then
      # A controlling terminal is what makes the prompt answerable; stdin alone
      # is not, since mise runs this hook with its own stdin. MISE_YES (mise's
      # `yes` setting) means the caller already opted out of being asked.
      if [ -z "${MISE_YES:-}" ] && [ -c /dev/tty ] && : 2>/dev/null >/dev/tty; then
        selected_casks=""
        for cask in $outdated_casks; do
          printf 'install-3rdparty: upgrade %s? [y/N]: ' "$cask" >/dev/tty
          read -r reply </dev/tty || reply=""
          case "$reply" in
            [yY]*) selected_casks="$selected_casks $cask" ;;
          esac
        done
        if [ -n "$selected_casks" ]; then
          # shellcheck disable=SC2086  # intentional word splitting into args
          brew upgrade --cask $selected_casks
        fi
      else
        # shellcheck disable=SC2086  # intentional word splitting into args
        brew upgrade --cask $outdated_casks
      fi
    fi
  else
    echo "install-3rdparty: Homebrew not installed; skipping cask bundle." >&2
    echo "install-3rdparty: install it from https://brew.sh then re-run 'mise bootstrap'." >&2
  fi
fi
