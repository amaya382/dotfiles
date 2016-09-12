#!/bin/bash
git submodule init
git submodule update

dotfiles=$(pwd)
ln -s $dotfiles/.zsh ~/.zsh
ln -s $dotfiles/.zshrc ~/.zshrc
ln -s $dotfiles/.tmux ~/.tmux
ln -s $dotfiles/.tmux.conf ~/.tmux.conf
ln -s $dotfiles/.vim ~/.vim
ln -s $dotfiles/.vimrc ~/.vimrc
ln -s $dotfiles/.config ~/.config
ln -s $dotfiles/.gitconfig ~/.gitconfig
ln -s $dotfiles/.gitignore_global ~/.gitignore_global

if [ `which sudo` ]; then
  prefix='sudo'
else
  prefix=''
fi

case ${OSTYPE} in
  darwin*)
    ln -s $dotfiles/osx/.zshrc ~/.zshrc.additional
    ln -s $dotfiles/osx/.tmux.conf ~/.tmux.conf.additional
    ./fonts/install.sh
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update && brew upgrade -y && brew install -y tmux zsh sshrc python3 macvim reattach-to-user-namespace
  ;;
  linux*)
    ln -s $dotfiles/linux/.zshrc ~/.zshrc.additional
    ln -s $dotfiles/linux/.tmux.conf ~/.tmux.conf.additional
    if [ `which apt-get` ]; then
       $prefix add-apt-repository ppa:russell-s-stewart/ppa && $prefix apt-get update && $prefix apt-get upgrade -y && $prefix apt-get install -y tmux zsh sshrc python3 python3-dev python3-pip tree vim xsel
    elif [ `which dnf` ]; then
      $prefix dnf update -y && $prefix dnf install -y tmux zsh sshrc python3 python3-devel python3-pip tree vim gcc redhat-rpm-config xsel
    elif [ `which yum` ]; then
      $prefix yum update -y && $prefix yum install -y tmux zsh sshrc python3 python3-devel python3-pip tree vim gcc redhat-rpm-config xsel
    fi
  ;;
esac

pip3 install powerline-status psutil netifaces
