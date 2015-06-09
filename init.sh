#!/bin/bash
git submodule init
git submodule update

ln -s $(pwd)/.tmux.conf ~/.tmux.conf
ln -s $(pwd)/.tmux ~/.tmux
ln -s $(pwd)/.zshrc ~/.zshrc
ln -s $(pwd)/.zsh ~/.zsh
ln -s $(pwd)/.vimrc ~/.vimrc
ln -s $(pwd)/.vim ~/.vim
ln -s $(pwd)/.config ~/.config
ln -s $(pwd)/.gitconfig ~/.gitconfig
ln -s $(pwd)/.gitignore_global ~/.gitignore_global

./fonts/install.sh

brew install tmux zsh macvim python reattach-to-user-namespace tree
easy_install pip
pip install powerline-status psutil
