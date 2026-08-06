#!/bin/bash
# Prints the merged ~/.claude/settings.json to stdout, for the `template`
# dotfile entry that owns that path.
#
# Claude Code reads exactly one user-scope settings file, so per-machine
# settings cannot live in a second file it would pick up on its own. The merge
# happens here instead: repo-tracked base ⊕ untracked local overlay.
#
# Claude Code also writes to the rendered file itself (/permissions at user
# scope, /plugin enable). Those writes are absorbed into the overlay before
# re-rendering, so they survive the next `mise dotfiles apply` while staying
# out of git.
#
# The absorbed set is the difference against the previous render, not against
# the base: diffing against the base would capture every value the base itself
# supplied, and the overlay would then pin those values forever, silently
# masking later base edits.
#
# Arrays merge as an order-preserving union. The overlay therefore has no way
# to express a deletion — dropping an entry means editing the base or the
# overlay itself.
#
# Run this from a plain terminal. Claude Code sandboxes its own settings files
# against writes from any process it spawns, so a `mise dotfiles apply` issued
# from inside a session fails on both the rendered file and the overlay.
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
base="$repo/home/.claude/settings.base.json"
live="$HOME/.claude/settings.json"
overlay="$HOME/.claude/settings.local.json"
snapshot="$HOME/.claude/.settings.rendered.json"

jq_lib='
def union(a; b): a + (b - a);
def merge(a; b):
  reduce (b | keys_unsorted[]) as $k (a;
    if   (a[$k] | type) == "object" and (b[$k] | type) == "object"
    then .[$k] = merge(a[$k]; b[$k])
    elif (a[$k] | type) == "array"  and (b[$k] | type) == "array"
    then .[$k] = union(a[$k]; b[$k])
    else .[$k] = b[$k]
    end);
def delta(old; new):
  reduce (new | keys_unsorted[]) as $k ({};
    if   old[$k] == new[$k]
    then .
    elif (old[$k] | type) == "object" and (new[$k] | type) == "object"
    then .[$k] = delta(old[$k]; new[$k])
    elif (old[$k] | type) == "array"  and (new[$k] | type) == "array"
    then (new[$k] - old[$k]) as $added
         | if ($added | length) == 0 then . else .[$k] = $added end
    else .[$k] = new[$k]
    end);
'

valid_json() { [ -f "$1" ] && [ ! -L "$1" ] && jq -e . "$1" >/dev/null 2>&1; }

die() { echo "render-claude-settings: $1" >&2; exit 1; }

# Bail out before rendering rather than after: overwriting the snapshot while
# the overlay is stale would drop whatever Claude Code wrote since last time.
write_overlay() { mv "$overlay.tmp" "$overlay" 2>/dev/null || die "cannot write $overlay"; }

touch "$overlay.tmp" 2>/dev/null ||
  die "cannot write $overlay — run this from a plain terminal, not from inside a Claude Code session"

if ! valid_json "$overlay"; then
  printf '{}\n' >"$overlay.tmp"
  write_overlay
fi

# No snapshot means nothing has been rendered here yet — a fresh machine, or
# the pre-migration layout where $live is a symlink straight at the base. There
# is no post-render change to attribute, so absorbing would only mask the base.
if valid_json "$snapshot" && valid_json "$live"; then
  jq -n \
    --slurpfile snapshot "$snapshot" --slurpfile live "$live" --slurpfile overlay "$overlay" \
    "$jq_lib"'merge($overlay[0]; delta($snapshot[0]; $live[0]))' >"$overlay.tmp"
  write_overlay
fi

jq -n --slurpfile base "$base" --slurpfile overlay "$overlay" \
  "$jq_lib"'merge($base[0]; $overlay[0])' | tee "$snapshot.tmp"
mv "$snapshot.tmp" "$snapshot"
