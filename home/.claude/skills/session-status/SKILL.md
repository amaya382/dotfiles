---
name: session-status
description: Print the current Claude Code session's status — version, session ID, cwd, API provider, model, IDE, MCP servers — as a plain aligned table, the way the built-in `/status` screen shows it. Use when the user asks for session status or one of its fields, e.g. "status 出して", "セッション情報教えて", "今どのモデル/プロバイダ使ってる", "MCP どうなってる", "show session status", "what model am I on".
---

# session-status

Print status. Do not diagnose, summarize, or suggest fixes unless asked.

## Steps

1. Run the collector:

   ```sh
   bash ~/.claude/skills/session-status/status.sh
   ```

2. Print its output verbatim inside a fenced code block.

3. Append rows for facts the script cannot see, only when you actually know them from the current session context. Keep the same `%-24s` alignment.

   - `Session name` — the name set via `/rename`, if this session has one.
   - `Permission mode` — the active mode (`plan`, `acceptEdits`, `bypassPermissions`, …) when it is not the default.
   - MCP runtime state — the script reports configuration only. If system reminders in this session named servers that are connected, still connecting, failed, or need authentication, rewrite the `MCP servers` count line to reflect that (`9 configured, 6 connected, 1 needs auth, 2 failed`) and mark the affected names inline.

Omit any row whose value you do not know. Do not guess, and do not substitute a plausible-looking value.

## Notes

- The script reads environment variables, `~/.claude.json`, `~/.claude/settings.json`, `<cwd>/.mcp.json`, and enabled plugins' `.mcp.json` files. It writes nothing.
- `Model` comes from `ANTHROPIC_MODEL`. When the session was switched with `/model` after launch, that variable is stale — prefer the model you know you are running as, and say which one the environment claims if they differ.
- Under the Claude Code sandbox, `~/.claude/ide/` may be unreadable. IDE detection then falls back to `CLAUDE_CODE_ENTRYPOINT`, which is enough to name the IDE but not to prove the connection is live.
