### .zshrc for all ###

# general
setopt no_beep
setopt correct
setopt magic_equal_subst
setopt notify

# locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# export LC_ALL=ja_JP.UTF-8
# export LANG=ja_JP.UTF-8

# history
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000
setopt extended_history
setopt share_history
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt hist_ignore_all_dups
setopt hist_expand
bindkey '^H' zaw-history

# complement
autoload -Uz compinit; compinit
setopt auto_list
setopt auto_menu
setopt list_packed
setopt list_types
setopt auto_param_slash
bindkey "^[[Z" reverse-menu-complete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt auto_param_keys

# prompt
PROMPT='%F{red}$ %f'
RPROMPT='%F{green}[%50<..<%~/]%f'
SPROMPT="%F{magenta}Perhaps: %f %F{white}%B%r%b%f %F{magenta}? [y/n]%f:${reset_color} "

# color
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# custom commands
## cd and then ls
function cd() {
  builtin cd $@ && ls -a;
}

## mkdir and then cd
function mkcd() {
  mkdir -p $1 && cd $1
}

## extract
function ext() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -dc $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
    *.rar) unrar e $1;;
  esac
}

# alias
alias la='ls -a'
alias ll='ls -al'

# powerline
powerline-daemon -q

# plugins
if [ -e ~/.zsh ]; then
  ## zaw
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 500
  zstyle ':chpwd:*' recent-dirs-default yes
  zstyle ':completion:*' recent-dirs-insert both
  source ~/.zsh/zaw/zaw.zsh
  zstyle ':filter-select' case-insensitive yes
  bindkey '^R' zaw-cdr
  bindkey '^T' zaw-tmux
  bindkey '^P' zaw-process

  ## zsh-syntax-highlighting
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# os-specific conf
[ -f ~/.zshrc.additional ] && . ~/.zshrc.additional

# local conf if exists
[ -f ~/.zshrc.local ] && . ~/.zshrc.local
