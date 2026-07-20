# baretree Worktree Rule

Applies only when `bt status` succeeds. Otherwise skip this rule entirely.

- **Decide**: new features, multi-file changes, or large edits need a new worktree. Always confirm via `AskUserQuestion` (whether creating or not).
- **Create**: `bt add -b feat/<name>` (bugs: `fix/<name>`, exploration: `task/<id>`). All subsequent Bash calls must use `cd "<worktree>" && <cmd>` — bare `cd` does not persist across calls.
- **Shared files**: anything listed by `bt post-create list` or shown as a symlink affects every worktree. Warn via `AskUserQuestion` before editing.
- **Cleanup**: after merge, ask via `AskUserQuestion` then `bt rm <path> --with-branch`. Remove `task/*` immediately on completion.
