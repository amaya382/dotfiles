#!/bin/bash
dotfiles=$(pwd)
[[ ! $dotfiles =~ dotfiles$ ]] && echo 'execute in dotfiles directory' && exit 1

git submodule init
git submodule update

[ -e ~/dotfiles_saved/ ] || mkdir ~/dotfiles_saved
[ $# -eq 1 ] && copy_mode=1 || copy_mode=0

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

if [ `which sudo` ]; then
  prefix='sudo'
else
  prefix=''
fi

PATH_TO_PACKAGE=`python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"`
case ${OSTYPE} in
  darwin*)
    sed -i -e "s!PATH_TO_PACKAGE!$PATH_TO_PACKAGE!" osx/.tmux.conf
    apply osx/.zshrc .zshrc.additional
    apply osx/.tmux.conf .tmux.conf.additional
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update && brew upgrade -y && brew install -y tmux zsh python3 macvim reattach-to-user-namespace
  ;;
  linux*)
    sed -i -e "s!PATH_TO_PACKAGE!$PATH_TO_PACKAGE!" linux/.tmux.conf
    apply linux/.zshrc .zshrc.additional
    apply linux/.tmux.conf .tmux.conf.additional
    if [ `which apt-get` ]; then
      $prefix apt-get update && $prefix apt-get upgrade -y && $prefix apt-get install -y tmux zsh python3 python3-dev python3-pip tree vim xsel
    elif [ `which dnf` ]; then
      $prefix dnf upgrade -y && $prefix dnf install -y tmux zsh python3 python3-devel python3-pip tree vim gcc redhat-rpm-config xsel
    elif [ `which yum` ]; then
      $prefix yum update -y && $prefix yum install -y tmux zsh python3 python3-devel python3-pip tree vim gcc redhat-rpm-config xsel
    else
      echo 'unexpected distribution' && exit 1
    fi
  ;;
esac

./fonts/install.sh

[ -e ~/.config/ ] || mkdir ~/.config
[ -e ~/.vim/bundle/ ] || mkdir -p ~/.vim/bundle
for f in .zsh .zshrc .tmux.conf .vim/bundle/neobundle.vim .vimrc .gitconfig .gitignore_global .config/powerline; do
  apply $f
done

$prefix pip3 install powerline-status psutil netifaces
