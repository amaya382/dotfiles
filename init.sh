#!/bin/bash

dotfiles=$(pwd)
dotfiles_old=~/dotfiles.old
[[ ! $dotfiles =~ dotfiles$ ]] && echo 'execute in dotfiles directory' && exit 1

git submodule init
git submodule update

mkdir -p ${dotfiles_old}
[ $# -gt 1 ] && [ $1 -eq 1 ] && copy_mode=1 || copy_mode=0

apply() {
  from=$1
  [ $# -eq 1 ] && to=$1 || to=$2
  [ -e ~/$to ] && mkdir -p ${dotfiles_old}/`dirname $to` && mv ~/$to ${dotfiles_old}/$to
  if [ $copy_mode -eq 1 ]; then
    cp -r $dotfiles/$from ~/$to
  else
    ln -s $dotfiles/$from ~/$to
  fi
}

if [ "`whoami`" = 'root' ]; then
  sudo=''
else
  sudo='sudo'
fi

case ${OSTYPE} in
  darwin*)
    apply osx/.zshrc .zshrc.additional
    apply osx/.tmux.conf .tmux.conf.additional
    [ `which brew` ] || \
      /usr/bin/ruby -e \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update
    brew upgrade -y
    brew install \
      tmux zsh python3 vim reattach-to-user-namespace sshrc zplug
  ;;
  linux*)
    apply linux/.zshrc .zshrc.additional
    apply linux/.tmux.conf .tmux.conf.additional
    if [ `which apt-get` ]; then
      $sudo apt-get update
      $sudo apt-get upgrade -y
      $sudo apt-get install -y \
        tmux zsh python3 python3-dev python3-pip tree vim xsel gawk
    elif [ `which dnf` ]; then
      $sudo dnf update -y
      $sudo dnf install -y \
        tmux zsh python3 python3-devel python3-pip tree vim gcc redhat-rpm-config xsel util-linux-user gawk
    elif [ `which yum` ]; then
      $sudo yum update -y
      $sudo yum install -y \
        tmux zsh python3 python3-devel python3-pip tree vim gcc redhat-rpm-config xsel gawk
    else
      echo 'unexpected distribution' && exit 1
    fi

    mkdir -p ~/.local/bin
    wget https://raw.githubusercontent.com/Russell91/sshrc/master/sshrc \
     -O ~/.local/bin/sshrc
    chmod +x ~/.local/bin/sshrc
    export ZPLUG_HOME=~/.local/opt/zplug
    [ -z "${ZPLUG_HOME}" ] || \
      ( mkdir -p ${ZPLUG_HOME} && \
        curl -sL --proto-redir -all,https \
        https://raw.githubusercontent.com/zplug/installer/master/installer.zsh \
        | zsh )
  ;;
esac

for f in .zshrc .tmux .tmux.conf .vim .vimrc .gitconfig .gitignore_global .sshrc .sshrc.d; do
  apply $f
done

pip3 install --user powerline-status psutil netifaces

chsh -s `which zsh`

# dein.vim
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh \
  > installer.sh
sh ./installer.sh ~/.vim/dein
rm installer.sh

echo 'done.'
echo 'tmux: `prefix + I`'
echo 'vim: `:call dein#install()`'

