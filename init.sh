#!/bin/bash
git submodule init
git submodule update

home=$(pwd)
ln -s $home/.tmux.conf ~/.tmux.conf
ln -s $home/.tmux ~/.tmux
ln -s $home/.config ~/.config
ln -s $home/.zshrc ~/.zshrc
ln -s $home/.zsh ~/.zsh
ln -s $home/.vimrc ~/.vimrc
ln -s $home/.vim ~/.vim
ln -s $home/.gitconfig ~/.gitconfig
ln -s $home/.gitignore_global ~/.gitignore_global

case ${OSTYPE} in
  darwin*)
    ./fonts/install.sh
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update && brew upgrade -y && brew install -y tmux zsh python3 macvim reattach-to-user-namespace
  ;;
  linux*)
    if [ `which apt-get` ]; then
      sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y tmux zsh python3 python3-pip tree vim
    elif [ `which dnf` ]; then
      sudo dnf update -y && sudo dnf install -y tmux zsh python3 python3-pip tree vim
    fi
  ;;
esac

pip3 install powerline-status psutil netifaces
