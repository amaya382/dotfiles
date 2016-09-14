#!/bin/bash
dotfiles=$(pwd)
[ ! $dotfiles =~ dotfiles$ ] && echo 'execute in dotfiles directory' && exit 1

git submodule init
git submodule update

[ ! -e ~/dotfiles_saved ] && mkdir ~/dotfiles_saved
[ $# -eq 1 ] && copy_mode=1

apply () {
  from=$1
  [ $# -eq 1 ] && to=$1 || to=$2
  [ -e ~/$to ] && mv ~/$to ~/dotfiles_saved/$to
  if [ $copy_mode -eq 1 ]; then
    cp -r $dotfiles/$from ~/$to
  else
    ln -s $dotfiles/$from ~/$to
  fi
}

case ${OSTYPE} in
  darwin*)
    apply osx/.zshrc .zshrc.additional
    apply osx/.tmux.conf .tmux.conf.additional
    ./fonts/install.sh
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update && brew upgrade -y && brew install -y tmux zsh sshrc python3 macvim reattach-to-user-namespace
  ;;
  linux*)
    if [ `which sudo` ]; then
      prefix='sudo'
    else
      prefix=''
    fi
    apply linux/.zshrc .zshrc.additional
    apply linux/.tmux.conf .tmux.conf.additional
    if [ `which apt-get` ]; then
       $prefix add-apt-repository ppa:russell-s-stewart/ppa && $prefix apt-get update && $prefix apt-get upgrade -y && $prefix apt-get install -y tmux zsh sshrc python3 python3-dev python3-pip tree vim xsel
    elif [ `which dnf` ]; then
      $prefix dnf update -y && $prefix dnf install -y tmux zsh sshrc python3 python3-devel python3-pip tree vim gcc redhat-rpm-config xsel
    elif [ `which yum` ]; then
      $prefix yum update -y && $prefix yum install -y tmux zsh sshrc python3 python3-devel python3-pip tree vim gcc redhat-rpm-config xsel
    else
      echo 'unexpected distribution' && exit 1
    fi
  ;;
esac

for f in .zsh .zshrc .tmux .tmux.conf .vim .vimrc .config .gitconfig .gitignore_global; do
  apply $f
done

pip3 install powerline-status psutil netifaces
