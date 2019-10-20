### .zshrc for all ###

# general
setopt no_beep
setopt correct
setopt notify
bindkey "^Z" undo
bindkey "^U" backward-kill-word
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
set -o ignoreeof # prevent Ctrl-D

# theme
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs command_execution_time root_indicator vcs context time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_DELIMITER=''
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right

## stack (cannot edit on tmux...)
## FIXME: Broken by "momo-lab/zsh-abbrev-alias"
show-buffer-stack() {
  POSTDISPLAY="
📥: ${LBUFFER}"
  zle push-line-or-edit
}
zle -N show-buffer-stack
setopt noflowcontrol
bindkey '^Q' show-buffer-stack

## env
export KEYTIMEOUT=0
export PATH=$PATH:$HOME/.local/bin
export DOCKER_BUILDKIT=1

# locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# history
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000
setopt extended_history
# setopt share_history
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt hist_ignore_all_dups
setopt hist_expand
setopt append_history

# complement
autoload -Uz compinit && compinit
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
setopt auto_list
setopt auto_menu
setopt list_packed
setopt list_types
setopt complete_in_word
setopt auto_param_slash
setopt magic_equal_subst
setopt menu_complete
setopt auto_param_keys
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2
bindkey "^[[Z" reverse-menu-complete
compdef sshrc=ssh

# prompt
PROMPT='%F{red}$ %f'
RPROMPT='%F{green}[%50<..<%~/]%f'
SPROMPT="%F{magenta}Perhaps: %f %F{white}%B%r%b%f %F{magenta}? [y/n]%f:${reset_color} "

# color
export LSCOLORS=exfxfedxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=35;44:ex=01;31:mi=05;37;41:bd=33;44:cd=37;44:su=38;5;220;1;3;100;1:sg=48;5;3;38;5;0:ow=34;40'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
case "${OSTYPE}" in
darwin*)
  alias ls="ls -AGF"
  ;;
linux*)
  alias ls='ls -AF --color'
  ;;
esac

# custom commands
## cd and then ls
function cd() {
  builtin cd $@ && ls -A;
}

## mkdir and then cd
function mkcd() {
  mkdir -p $1 && cd $1
}

if [ -z "${ANYRC_HOME:+_}" ]; then # not sshrc
  ## recent dirs
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 500
  zstyle ':chpwd:*' recent-dirs-default yes
  zstyle ':completion:*' recent-dirs-insert both

  export ZPLUG_HOME=~/.local/opt/zplug
  source ${ZPLUG_HOME}/init.zsh
  zplug "zsh-users/zsh-syntax-highlighting", defer:2
  zplug "zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-completions"
  zplug "docker/compose", use:contrib/completion/zsh
  zplug "docker/docker-ce", use:components/cli/contrib/completion/zsh, lazy:true
  zplug "plugins/git", from:oh-my-zsh
  zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
  zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
  zplug "amaya382/zsh-fzf-widgets"
  zplug "mollifier/cd-gitroot"
  zplug "momo-lab/zsh-abbrev-alias", defer:3
  zplug "b4b4r07/zsh-gomi", as:command, use:bin
  zplug "bhilburn/powerlevel9k", use:"powerlevel9k.zsh-theme", as:theme
  zplug check --verbose || zplug install
  zplug load

  bindkey '^R' fzf-cdr
  bindkey '^H' fzf-history
  bindkey '^P' fzf-kill-proc-by-list

  alias cds='cd-gitroot'

  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
  ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=cyan,bold'
  ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'
  ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'

  ## wrapped ssh
  function ssh() {
    SSSH_SSH_CMD=autossh ANYRC_SSH_CMD=sssh sshrc $@
  }

  # TODO: Expand when pushing down enter (?)
  #enter() {
  #  zle accept-line
  #  if [[ -n "$LBUFFER" && -z "$RBUFFER" ]] then;
  #    __abbrev_alias::magic_abbrev_expand
  #  else
  #    zle accept-line
  #  fi
  #}
  #zle -N enter
  #bindkey "\C-m" enter
fi


# alias
alias abbr="$($(which abbrev-alias > /dev/null) && echo abbrev-alias || echo alias)"
alias la='ls -A'
alias ll='ls -Alh'

abbr mv='mv -i'
abbr cp='cp -i'
abbr du0='du -h -d 1'
abbr tree0='tree -Chaf'
abbr d-ps='docker ps'
abbr d-exe='docker exec'
abbr d-exe0='docker exec -it'
abbr d-run='docker run'
abbr d-run0='docker run -it --rm'
abbr d-bui='docker build'
abbr dc='docker-compose'
abbr g-ini='git init'
abbr g-sta='git status'
abbr g-dif='git diff'
abbr g-dif-c='git diff --cached'
abbr g-dif-w='git diff --word-diff-regex=$'\''[^\x80-\xbf][\x80-\xbf]*'\'' --word-diff=color'
abbr g-clo='git clone --recursive'
abbr g-fet='git fetch'
abbr g-add='git add'
abbr g-rm='git rm'
abbr g-res='git reset'
abbr g-tag='git tag'
abbr g-com='git commit -m'
abbr g-com-a='git commit --amend --date=now'
abbr g-rem='git remote'
abbr g-bra='git branch'
abbr g-che='git checkout'
abbr g-mer='git merge'
abbr g-mer-dry='git merge --no-commit --no-ff'
abbr g-reb='git rebase --committer-date-is-author-date'
abbr g-chp='git cherry-pick'
abbr g-pul='git pull'
abbr g-pull='git pull origin `git symbolic-ref --short HEAD`'
abbr g-pus='git push'
abbr g-push='git push origin `git symbolic-ref --short HEAD`'
abbr g-log='git log --graph --oneline --decorate=full --name-status'
abbr g-log-f='git log --graph --oneline --decorate=full --name-status --pretty=fuller'
abbr g-sub='git submodule'
abbr g-sub-i='git submodule init && git submodule update'

alias sum='awk "{s+=\$1} END{print s}"'
alias avg='awk "{s+=\$1} END{print s/NR;}"'
alias min='awk "BEGIN{m=10000000}{if(m>\$1) m=\$1} END{print m}"'
alias max='awk "{if(m<\$1) m=\$1} END{print m}"'


# os-specific conf
[ -f ~/.zshrc.additional ] && . ~/.zshrc.additional

# local conf if exists
[ -f ~/.zshrc.local ] && . ~/.zshrc.local

# anyrc
[ ! -z "${ANYRC_DANYRC:+_}" ] && . "${ANYRC_DANYRC}"
