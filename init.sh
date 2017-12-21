#!/bin/bash

dotfiles=$(pwd)
dotfiles_saved=~/dotfiles_saved
[[ ! $dotfiles =~ dotfiles$ ]] && echo 'execute in dotfiles directory' && exit 1

git submodule init
git submodule update

mkdir -p ${dotfiles_saved}
[ $# -gt 1 ] && [ $1 -eq 1 ] && with_font=1 || with_font=0
[ $# -gt 2 ] && [ $2 -eq 1 ] && copy_mode=1 || copy_mode=0

apply () {
  from=$1
  [ $# -eq 1 ] && to=$1 || to=$2
  [ -e ~/$to ] && mkdir -p ${dotfiles_saved}/`dirname $to` && mv ~/$to ${dotfiles_saved}/$to
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

case ${OSTYPE} in
  darwin*)
    apply osx/.zshrc .zshrc.additional
    apply osx/.tmux.conf .tmux.conf.additional
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update && brew upgrade -y && brew install -y tmux zsh python3 vim reattach-to-user-namespace
  ;;
  linux*)
    apply linux/.zshrc .zshrc.additional
    apply linux/.tmux.conf .tmux.conf.additional
    if [ `which apt-get` ]; then
      $prefix apt-get update && $prefix apt-get upgrade -y && $prefix apt-get install -y tmux zsh python3 python3-dev python3-pip tree vim xsel
    elif [ `which dnf` ]; then
      $prefix dnf upgrade -y && $prefix dnf install -y tmux zsh python3 python3-devel python3-pip tree vim gcc redhat-rpm-config xsel util-linux-user
    elif [ `which yum` ]; then
      $prefix yum update -y && $prefix yum install -y tmux zsh python3 python3-devel python3-pip tree vim gcc redhat-rpm-config xsel
    else
      echo 'unexpected distribution' && exit 1
    fi
  ;;
esac

[ $with_font -eq 1 ] && ./fonts/install.sh

[ -e ~/.config ] || mkdir ~/.config
for f in .zsh .zshrc .tmux .tmux.conf .vim .vimrc .gitconfig .gitignore_global .config/powerline .sshrc .sshrc.d; do
  apply $f
done

pip3 install --user powerline-status psutil netifaces

chsh -s `which zsh`

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.vim/dein
rm installer.sh

mkdir -p ~/.zsh/completion
wget https://github.com/docker/docker-ce/raw/master/components/cli/contrib/completion/zsh/_docker -O ~/.zsh/completion/_docker
wget https://github.com/docker/compose/raw/master/contrib/completion/zsh/_docker-compose -O ~/.zsh/completion/_docker-compose

echo 'done.'
echo 'tmux: `prefix + I`'
echo 'vim: `:call dein#install()`'

