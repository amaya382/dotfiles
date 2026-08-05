# Click-to-move-cursor for the zsh line editor.
#
# Mouse reporting is requested as the X10 protocol (\e[?9h) with SGR encoding
# (\e[?1006h). X10 reports button presses only, so the wheel stays with the
# terminal and keeps scrolling the scrollback, while SGR encoding removes the
# 223-column ceiling of the legacy encoding. Inside tmux the protocol drops to
# VT200 (\e[?1000h), which tmux does implement; see _zsh_mouse_proto below.
#
# A click is resolved against $BUFFER relative to where the cursor currently
# sits on screen, queried with DSR (\e[6n). Nothing here parses the prompt, so
# dynamic prompts such as powerlevel10k need no special handling.
#
# Known gaps: tabs and control characters rendered as ^X are measured as one
# cell, so a click on a line containing them can land a position off. A
# full-width character that does not fit at the right margin shifts the rest of
# its screen row by one cell for the same reason.
#
# In VSCode, pair this with terminal.integrated.macOptionClickForcesSelection =
# true: while mouse reporting is on, a plain drag no longer selects text.

[[ -o interactive ]] || return 0

# A terminal that ignores DSR would block the widget until its read times out
# on every click, so only opt in the families known to answer.
[[ $TERM == (xterm*|screen*|tmux*|rxvt*|vte*|alacritty|foot*|contour*|wezterm|ghostty*) ]] || return 0

typeset -g  ZSH_MOUSE_ENABLED=${ZSH_MOUSE_ENABLED:-1}
# Column the buffer starts at, i.e. the width of the prompt's last line.
typeset -gi _zsh_mouse_pcol=0

# tmux's DECSET handler covers 1000/1002/1003/1004/1005/1006 but not 9, so X10
# is silently dropped there and VT200 has to stand in. VT200 additionally
# reports releases and the wheel; the click widget discards both, and
# .tmux.conf keeps the wheel bound to copy-mode so scrollback still works.
if [[ -n $TMUX || $TERM == (screen*|tmux*) ]]; then
  typeset -g _zsh_mouse_proto=1000
else
  typeset -g _zsh_mouse_proto=9
fi

_zsh_mouse_on()  { print -n "\e[?${_zsh_mouse_proto}h\e[?1006h" }
_zsh_mouse_off() { print -n "\e[?1006l\e[?${_zsh_mouse_proto}l" }

# Reads a cursor position report into _zsh_mouse_row / _zsh_mouse_col, giving
# up after $1 seconds.
_zsh_mouse_dsr() {
  local buf= c
  print -n '\e[6n'
  while read -k 1 -t $1 c; do
    buf+=$c
    [[ $c == R ]] && break
  done
  [[ $buf == (#b)(*)$'\e'\[([0-9]##)\;([0-9]##)R ]] || return 1
  # Anything ahead of the reply is keystrokes typed during the round trip.
  [[ -n $match[1] ]] && zle -U -- "$match[1]"
  _zsh_mouse_row=$match[2]
  _zsh_mouse_col=$match[3]
}

# Display width of BUFFER over the 0-based half-open range [$1, $2), into
# _zsh_mouse_w. Buffer subscripts are 1-based and inclusive, hence the shift.
_zsh_mouse_width() {
  local -i s=$(( $1 + 1 )) e=$2
  if (( e < s )); then
    _zsh_mouse_w=0
  else
    _zsh_mouse_w=${(m)#BUFFER[s,e]}
  fi
}

# Moves $CURSOR to the buffer index drawn at cell $2, given that $CURSOR is
# drawn at cell $1 and the screen is $3 columns wide. Cells are numbered
# row-major across the screen, which makes line wrapping fall out of the
# arithmetic instead of needing a separate case.
_zsh_mouse_seek() {
  local -i here=$1 want=$2 cols=$3
  local -i i j n cell w sc rows
  local ch

  # Logical line boundaries as 0-based buffer indices: line k spans
  # [starts[k], ends[k]), excluding its terminating newline.
  local -a starts ends
  starts=(0)
  for (( i = 1; i <= $#BUFFER; i++ )); do
    if [[ $BUFFER[i] == $'\n' ]]; then
      ends+=$(( i - 1 ))
      starts+=$i
    fi
  done
  ends+=$#BUFFER
  n=$#starts

  # The line holding $CURSOR anchors everything: its start cell follows from
  # the known cursor cell minus the width of the text preceding the cursor.
  local -i jc=1
  for (( i = 1; i <= n; i++ )); do
    (( CURSOR >= starts[i] )) && jc=$i
  done
  _zsh_mouse_width $starts[jc] $CURSOR

  # Start cell of every line, walked outward from the anchor. A line occupies
  # ceil((start column + width) / cols) screen rows, at least one, and the
  # newline puts the next line at the start of the row following them. Only
  # line 1 begins indented, by the prompt.
  local -a scell
  scell[jc]=$(( here - _zsh_mouse_w ))
  for (( i = jc; i < n; i++ )); do
    sc=$(( scell[i] % cols ))
    _zsh_mouse_width $starts[i] $ends[i]
    rows=$(( (sc + _zsh_mouse_w + cols - 1) / cols ))
    (( rows < 1 )) && rows=1
    scell[i+1]=$(( scell[i] - sc + rows * cols ))
  done
  for (( i = jc; i > 1; i-- )); do
    sc=$(( i - 1 == 1 ? _zsh_mouse_pcol : 0 ))
    _zsh_mouse_width $starts[i-1] $ends[i-1]
    rows=$(( (sc + _zsh_mouse_w + cols - 1) / cols ))
    (( rows < 1 )) && rows=1
    scell[i-1]=$(( scell[i] - rows * cols + sc ))
  done

  # A click above the buffer clamps to the first line, below it to the last.
  j=1
  for (( i = 1; i <= n; i++ )); do
    (( want >= scell[i] )) && j=$i
  done

  cell=$scell[j]
  for (( i = starts[j]; i < ends[j]; i++ )); do
    ch=$BUFFER[i+1]
    w=${(m)#ch}
    (( cell % cols + w > cols )) && cell=$(( (cell / cols + 1) * cols ))
    if (( want < cell + w )); then
      CURSOR=$i
      return 0
    fi
    (( cell += w ))
  done
  CURSOR=$ends[j]
}

_zsh_mouse_click() {
  emulate -L zsh
  setopt extendedglob

  # Rest of the SGR report after the "\e[<" prefix: <btn>;<col>;<row>M
  local buf= c
  while read -k 1 -t 1 c; do
    buf+=$c
    [[ $c == [Mm] ]] && break
  done
  [[ $buf == (#b)([0-9]##)\;([0-9]##)\;([0-9]##)M ]] || return 0

  local -i btn=$match[1] mcol=$match[2] mrow=$match[3]
  # Left press only. X10 sends neither releases nor motion; masking keeps the
  # modifier bits out so shift-click still positions the cursor.
  (( (btn & 0x43) == 0 )) || return 0

  local -i _zsh_mouse_row _zsh_mouse_col _zsh_mouse_w
  _zsh_mouse_dsr 1 || return 0

  local -i cols=${COLUMNS:-80}
  _zsh_mouse_seek \
    $(( (_zsh_mouse_row - 1) * cols + _zsh_mouse_col - 1 )) \
    $(( (mrow - 1) * cols + mcol - 1 )) \
    $cols
}
zle -N _zsh_mouse_click
bindkey -M emacs '\e[<' _zsh_mouse_click
bindkey -M viins '\e[<' _zsh_mouse_click
bindkey -M vicmd '\e[<' _zsh_mouse_click

# Escape hatch for when the terminal's own drag-select is wanted back.
zsh-mouse-toggle() {
  if (( ZSH_MOUSE_ENABLED )); then
    ZSH_MOUSE_ENABLED=0
    _zsh_mouse_off
  else
    ZSH_MOUSE_ENABLED=1
    _zsh_mouse_on
  fi
}
zle -N zsh-mouse-toggle
bindkey -M emacs '\em' zsh-mouse-toggle
bindkey -M viins '\em' zsh-mouse-toggle
bindkey -M vicmd 'M'   zsh-mouse-toggle

# Reporting is confined to the line editor so full-screen programs keep their
# own mouse handling while a command runs.
_zsh_mouse_line_init() {
  (( ZSH_MOUSE_ENABLED )) || return 0
  _zsh_mouse_on
  # Measure the prompt once per line. The timeout is short because a missing
  # reply only costs accuracy on multi-line buffers, not the feature itself.
  local -i _zsh_mouse_row _zsh_mouse_col
  _zsh_mouse_dsr 0.1 && _zsh_mouse_pcol=$(( _zsh_mouse_col - 1 ))
  return 0
}
_zsh_mouse_line_finish() { _zsh_mouse_off; return 0 }
zle -N _zsh_mouse_line_init
zle -N _zsh_mouse_line_finish

autoload -Uz add-zle-hook-widget add-zsh-hook
add-zle-hook-widget line-init   _zsh_mouse_line_init
add-zle-hook-widget line-finish _zsh_mouse_line_finish
add-zsh-hook zshexit _zsh_mouse_off
