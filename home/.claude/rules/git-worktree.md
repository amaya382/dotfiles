# baretree Worktree Rule

Applies only when `bt status` succeeds. Otherwise skip this rule entirely.

## MUST: Pre-work confirmation

**In a baretree repository, before touching any file (Edit / Write / Bash side effects / commits), you MUST call `AskUserQuestion` to confirm whether to create a new worktree.** No exceptions — not for "small" fixes, not for "just one line", not for follow-up asks in the same session. Read-only exploration (Read / Grep / `bt status`) is allowed before the ask; anything that mutates state is not.

The question must include at minimum:
- Create a new worktree (recommended default for feat / fix / task)
- Continue in the current worktree (only when the user explicitly wants to stay)

Skip the ask only if the user has already answered it in this session for the current task. A new task = a new ask.

## Rules

- **Decide**: new features, multi-file changes, or large edits need a new worktree. The pre-work ask above covers this.
- **Create**: `bt add -b feat/<name>` (bugs: `fix/<name>`, exploration: `task/<id>`). All subsequent Bash calls must use `cd "<worktree>" && <cmd>` — bare `cd` does not persist across calls.
- **Shared files**: anything listed by `bt post-create list` or shown as a symlink affects every worktree. Warn via `AskUserQuestion` before editing.
- **Cleanup**: after merge, ask via `AskUserQuestion` then `bt rm <path> --with-branch`. Remove `task/*` immediately on completion.
