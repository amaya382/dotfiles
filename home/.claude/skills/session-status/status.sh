#!/usr/bin/env bash
# Print /status-equivalent session info from environment variables and config files.
# Everything here is observable from outside the agent; runtime-only facts
# (MCP connection state, session name) are left to the caller to overlay.
set -uo pipefail

row() { printf '%-24s%s\n' "$1:" "$2"; }
row_if() { [ -n "${2:-}" ] && row "$1" "$2"; return 0; }

# --- version -----------------------------------------------------------------
version=""
case "${AI_AGENT:-}" in
  claude-code_*) version=$(printf '%s' "${AI_AGENT}" | sed -E 's/^claude-code_([0-9-]+).*/\1/; s/-/./g') ;;
esac
if [ -z "$version" ]; then
  version=$("${CLAUDE_CODE_EXECPATH:-claude}" --version 2>/dev/null | head -1)
fi

# --- session kind ------------------------------------------------------------
case "${CLAUDE_CODE_ENTRYPOINT:-}" in
  claude-vscode|claude-jetbrains) kind="interactive (IDE extension)" ;;
  cli)                            kind="interactive (CLI)" ;;
  "")                             kind="" ;;
  *)                              kind="${CLAUDE_CODE_ENTRYPOINT}" ;;
esac
[ "${CLAUDE_CODE_CHILD_SESSION:-}" = "1" ] && kind="${kind:+$kind, }child session"

# --- API provider ------------------------------------------------------------
if [ "${CLAUDE_CODE_USE_VERTEX:-}" = "true" ] || [ "${CLAUDE_CODE_USE_VERTEX:-}" = "1" ]; then
  provider="Google Vertex AI"
elif [ "${CLAUDE_CODE_USE_BEDROCK:-}" = "true" ] || [ "${CLAUDE_CODE_USE_BEDROCK:-}" = "1" ]; then
  provider="AWS Bedrock"
elif [ -n "${ANTHROPIC_BASE_URL:-}" ]; then
  provider="Custom endpoint (${ANTHROPIC_BASE_URL})"
else
  provider="Anthropic API"
fi

# --- IDE ---------------------------------------------------------------------
case "${CLAUDE_CODE_ENTRYPOINT:-}" in
  claude-vscode)    ide="Connected to Visual Studio Code" ;;
  claude-jetbrains) ide="Connected to JetBrains IDE" ;;
  *)                ide="" ;;
esac
if [ -z "$ide" ] && ls "${HOME}/.claude/ide/"*.lock >/dev/null 2>&1; then
  ide="Connected (IDE lock present)"
fi

row_if "Version"               "$version"
row_if "Session ID"            "${CLAUDE_CODE_SESSION_ID:-}"
row_if "Session kind"          "$kind"
row    "cwd"                   "$(pwd)"
row    "API provider"          "$provider"
row_if "GCP project"           "${ANTHROPIC_VERTEX_PROJECT_ID:-}"
row_if "Default region"        "${CLOUD_ML_REGION:-${AWS_REGION:-}}"
row_if "Additional CA cert(s)" "${NODE_EXTRA_CA_CERTS:-}"
row_if "Model"                 "${ANTHROPIC_MODEL:-}"
row_if "Subagent model"        "${CLAUDE_CODE_SUBAGENT_MODEL:-}"
row_if "Effort"                "${CLAUDE_EFFORT:-}"
row_if "IDE"                   "$ide"

# --- MCP servers -------------------------------------------------------------
# Only configuration is visible here; whether a server actually connected is not.
command -v python3 >/dev/null 2>&1 || exit 0
python3 - "$(pwd)" <<'PY'
import json, os, sys, glob

cwd = sys.argv[1]
home = os.path.expanduser("~")
sources = []  # (label, [names])

def names(path, key="mcpServers", sub=None):
    try:
        with open(path) as f:
            d = json.load(f)
    except Exception:
        return []
    if sub is not None:
        d = d.get("projects", {}).get(sub, {}) or {}
    return sorted((d.get(key) or {}).keys())

for label, got in [
    ("User (~/.claude.json)",   names(f"{home}/.claude.json")),
    ("User settings",           names(f"{home}/.claude/settings.json")),
    ("Project (.mcp.json)",     names(f"{cwd}/.mcp.json")),
    ("Project local",           names(f"{home}/.claude.json", sub=cwd)),
]:
    if got:
        sources.append((label, got))

plugin = []
enabled = set()
try:
    with open(f"{home}/.claude/settings.json") as f:
        enabled = {k.split("@")[0] for k, v in (json.load(f).get("enabledPlugins") or {}).items() if v}
except Exception:
    pass
for path in sorted(glob.glob(f"{home}/.claude/plugins/cache/*/*/*/.mcp.json")):
    owner = path.split("/")[-3]
    if enabled and owner not in enabled:
        continue
    plugin += [n if n == owner else f"{n} ({owner})" for n in names(path)]
if plugin:
    sources.append(("Plugin", plugin))

total = sum(len(v) for _, v in sources)
print(f"{'MCP servers:':<24}{total} configured" if total else f"{'MCP servers:':<24}none configured")
for label, got in sources:
    print(f"  {label:<22}{', '.join(got)}")
PY
