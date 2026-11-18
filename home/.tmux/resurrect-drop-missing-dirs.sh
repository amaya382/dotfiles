#!/bin/sh
# Rewrites a tmux-resurrect state file so that panes whose working directory no
# longer exists, and windows left without any pane, are not restored.
set -eu

state_file=$1
tmp_file=$(mktemp "${state_file}.XXXXXX")

awk -F '\t' '
  function is_dir(dir) {
    gsub(/'\''/, "'\''\\'\'''\''", dir)
    return system("test -d '\''" dir "'\''") == 0
  }
  NR == FNR {
    if ($1 == "pane") {
      dir = substr($8, 2)
      sub(/^~/, ENVIRON["HOME"], dir)
      if (is_dir(dir)) kept_windows[$2 FS $3] = 1
      else dropped_lines[FNR] = 1
    }
    next
  }
  $1 == "pane" && (FNR in dropped_lines) { next }
  $1 == "window" && !(($2 FS $3) in kept_windows) { next }
  { print }
' "$state_file" "$state_file" > "$tmp_file"

mv "$tmp_file" "$state_file"
