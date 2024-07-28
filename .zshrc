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
export COMPOSE_DOCKER_CLI_BUILD=1
export EDITOR=vim
export GPG_TTY=$(tty)

# locale
export LANGUAGE=C
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# history
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000
setopt extended_history
setopt share_history
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
#compdef dockerrc=docker
#compdef kubectlrc=kubectl

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

function notify() {
  [ -v SLACK_WEBHOOK ] \
    && curl -s -X POST -H 'Content-Type: application/json' -d "{\"username\": \"$(hostname)\", \"text\": \"$1\"}" "${SLACK_WEBHOOK}" \
       > /dev/null \
    || echo "Set \$SLACK_WEBHOOK"
}

function after() {
  pid="$1"; shift
  tail -f /dev/null --pid "${pid}"; $@
}

## ssh
function sshrc() {
  $(sh -c 'which sshrc') -A $@
}

if [ -z "${ANYRC_HOME:+_}" ]; then # not sshrc
  ## ssh
  eval `ssh-agent` &> /dev/null
  ssh-add ~/.ssh/id_rsa &> /dev/null
  ssh-add ~/.ssh/id_ed25519 &> /dev/null

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
  #zplug "nnao45/zsh-kubectl-completion"
  zplug "plugins/git", from:oh-my-zsh
  #gh-r looks broken. install it via package manager instead
  #zplug "junegunn/fzf", from:gh-r, as:command, use:"*$(uname -s | tr '[:upper:]' '[:lower:]')*$([ $(uname -m) = 'x86_64' ] && echo 'amd64' || echo 'arm64')*"
  zplug "junegunn/fzf", from:github, as:command, use:bin/fzf-tmux
  zplug "amaya382/zsh-fzf-widgets"
  zplug "mollifier/cd-gitroot"
  zplug "momo-lab/zsh-abbrev-alias", defer:3
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
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias sudo='sudo '

abbr mv='mv -i'
abbr cp='cp -i'
abbr du0='du -h -d 1'
abbr tree0='tree -Chaf'
abbr d-ps='docker ps'
abbr d-exe='docker exec'
abbr d-exe0='dockerrc exec -it'
abbr d-run='docker run --name'
abbr d-run0='dockerrc run -it --rm'
abbr d-bui='docker build -t'
abbr dc='docker-compose'
abbr tele='telepresence --logfile=/dev/null'
abbr tele-s='telepresence --logfile=/dev/null --swap-deployment'
abbr tele-n='telepresence --logfile=/dev/null --new-deployment'
abbr g-ini='git init'
abbr g-sta='git status'
abbr g-dif='git diff'
abbr g-dif-c='git diff --cached'
abbr g-dif-w='git diff --word-diff-regex=$'\''[^\x80-\xbf][\x80-\xbf]*'\'' --word-diff=color'
abbr g-clo='git clone -c user.name=$(git config user.name) -c user.email=$(git config user.email) --recursive'
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
function g-wta(){ git worktree add .worktrees/$1 $1 }
abbr g-wtr='git worktree remove .worktrees/'
abbr apts='apt search'
abbr aptu='apt update'
abbr apti='apt install -y --no-install-recommends'

alias sum='awk "{s+=\$1} END{print s}"'
alias avg='awk "{s+=\$1} END{print s/NR;}"'
alias min='awk "BEGIN{m=10000000}{if(m>\$1) m=\$1} END{print m}"'
alias max='awk "{if(m<\$1) m=\$1} END{print m}"'
alias median='sort -n | awk "{v[i++]=\$1;}END {x=int((i+1)/2); if(x>(i+1)/2) print (v[x-1]+v[x])/2; else print v[x-1];}"'


# os-specific conf
[ -f ${ANYRC_HOME:-${HOME}}/.zshrc.additional ] && . ${ANYRC_HOME:-${HOME}}/.zshrc.additional

# local conf if exists
[ -f ${ANYRC_HOME:-${HOME}}/.zshrc.local ] && . ${ANYRC_HOME:-${HOME}}/.zshrc.local

# anyrc
[ ! -z "${ANYRC_DANYRC:+_}" ] && . "${ANYRC_DANYRC}"
