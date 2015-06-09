### general ###
setopt no_beep           # ビープ音を鳴らさないようにする
setopt auto_cd           # ディレクトリ名の入力のみで移動する
setopt auto_pushd        # cd時にディレクトリスタックにpushdする
setopt correct           # コマンドのスペルを訂正する
setopt magic_equal_subst # =以降も補完する(--prefix=/usrなど)
setopt prompt_subst      # プロンプト定義内で変数置換やコマンド置換を扱う
setopt notify            # バックグラウンドジョブの状態変化を即時報告する
setopt equals            # =commandを`which command`と同じ処理にする

### zaw ###
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

### history ###
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt extended_history   # ヒストリに実行時間も保存する
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存する
setopt hist_verify
setopt hist_ignore_all_dups
setopt hist_expand
bindkey '^H' zaw-history

### command syntax highlighting ###
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

### prompt ###
PROMPT='%F{red}(๑╹◡╹)  %f'
RPROMPT='%F{green}[%50<..<%~/]%f'
SPROMPT="%F{red}(/ω・＼)ﾁﾗｯ%f %F{magenta}もしかして%f %F{white}%B%r%b%f %F{magenta}？ [y/n]%f:${reset_color} "

### complement ###
autoload -Uz compinit; compinit # 補完機能を有効にする
setopt auto_list                # 補完候補を一覧で表示する(d)
setopt auto_menu                # 補完キー連打で補完候補を順に表示する(d)
setopt list_packed              # 補完候補をできるだけ詰めて表示する
setopt list_types               # 補完候補にファイルの種類も表示する
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない

### color ###
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

### ls after cd ###
function cd() {
  builtin cd $@ && ls -a;
}

### extract ###
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

### mkdir & cd ###
function mkcd() {
  mkdir -p $1 && cd $1
}

### PATH ###
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export ANDROID_HOME=/usr/local/opt/android-sdk
export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:/opt/local/bin:/opt/local/sbin:$PATH
export EDITOR=/usr/local/bin/mvim

### locale ###
export LC_ALL=ja_JP.UTF-8
export LANG=ja_JP.UTF-8

### alias ###
alias v='reattach-to-user-namespace mvim -v'
alias ls='ls -a'
alias lsl='ls -al'
alias psp='open -a "Adobe Photoshop CS6"'
alias did='docker ps -l -q'
alias pre='qlmanage -p "$@" >& /dev/null'
alias onkb="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
alias offkb="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
