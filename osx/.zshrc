### .zshrc for osx ###

# powerline
. `python3 -c "import site; print(site.getsitepackages()[0])"`/powerline/bindings/zsh/powerline.zsh

# alias
alias vim='reattach-to-user-namespace mvim -v'
alias psp='open -a "Adobe Photoshop CS6"'
alias pre='qlmanage -p "$@" >& /dev/null'
alias onkb="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
alias offkb="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"

# PATH
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export EDITOR=/usr/local/bin/mvim
