---
name: create-pr
description: Use whenever the user asks to create, open, draft, or write a pull request (PR), or to write/update a PR description / body / summary. ALSO use whenever the user pushes commits to a branch that already has an open PR (the description must be refreshed). Triggers on `gh pr create`, `git push` to an existing PR branch, "PR を作って", "PR description 書いて", "プルリク作成", "open a PR", "update the PR", and similar phrasings.
---

# create-pr

Write a PR description that lets reviewers grasp **why / outcome / what / how / verification** before reading the diff.

## Modes

Detect the mode with `gh pr view --json number,url,body` (failure = no PR).

- **Create**: no PR yet → draft the body → confirm with user → `gh pr create --draft`
- **Update**: PR exists → regenerate the body for the *whole branch* (not just new commits), preserving hand-written content (checklist ticks, reviewer notes) → `gh pr edit <n> --body`

## Context to gather (parallel)

- `git diff <base>...HEAD`, `git log <base>..HEAD`, `git status` (base: the PR's base branch, else the repo default branch)
- PR template: `.github/PULL_REQUEST_TEMPLATE.md` etc.
- Linked issue / ticket (`PROJ-123`, `#456`): the *why* often lives there
- Repo language (README / past PRs): Japanese by default, English only if the repo is clearly English-first

## Description structure

The sections define the *content* reviewers need; a PR template controls only the surface layout.

- No template: use the sections below as top-level headings.
- Template exists: follow its headings. If it collapses everything into one catch-all section (e.g. only `## Description`), keep the full structure inside it as sub-bullets or short paragraphs; never drop sections the template does not name.

Sections, in body order:

- **Why**: motivation, one sentence. Tickets: just the link ("Fixes #123"). Unusual decisions: 1-2 sentences.
- **Outcome**: what becomes possible *after* the merge, 1-3 bullets. Nothing observable (refactor, rename, dead code): "No user-facing changes."
- **Risks / Breaking changes**: only when they exist, placed this early so reviewers see them before the implementation details.
- **What**: the change at intent level (not a diff translation), 1-3 lines.
- **How**: a doc link over prose; otherwise 2-3 one-sentence bullets. Skip mechanical changes.
- **Test plan**: concrete verification steps; one command or line for simple changes.
- **Out of scope / Follow-ups**: deferred work, one line per item.

### List structure

Group items hierarchically when granularity differs: a flat list mixing outcome-level and implementation-level items as siblings forces the reader to re-sort by importance. Applies especially to **Outcome**, **What**, and **Test plan**.

- Top-level bullets name outcomes, capabilities, or verification targets; nested bullets carry the sub-cases, commands, and details under them.
- Keep siblings at comparable granularity. A sibling needing several lines of detail wants a nested list instead.
- 2-3 levels is the ceiling. Deeper nesting means the section carries too much: split it or link a doc.

Example (flat list with mixed granularity):

```
## Outcome
- Users can bulk-export orders as CSV
- New `--format=csv` flag on `orders export`
- CSV columns include shipping address
- Pagination off-by-one fix on the last page
- Renamed `parseOrder` to `deserializeOrder`
```

Rewrite (grouped by outcome, siblings at the same altitude):

```
## Outcome
- Users can bulk-export orders as CSV
  - New `--format=csv` flag on `orders export`
  - CSV columns: order id, buyer, shipping address, total
- Pagination returns the correct final page
  - Previously off-by-one when the last page had exactly `pageSize` items
```

(The rename belongs in **What** as an internal refactor note, not in **Outcome**.)

## Judgment

- A reviewer can decide their review strategy from the description alone.
- Someone reading `git log` in 6 months understands *why* without external systems.
- Each section adds information the diff does not: never a line-by-line diff restatement or a verbatim commit list.
- **Brevity over completeness.** Omit low-value or diff-inferable information; one meaningful sentence beats three redundant bullets.
- A section with nothing to say is omitted, not filled with "N/A".
- Scope and description match.

## Mechanics

- PR title under 70 chars; details go in the body.
- Use a HEREDOC for `--body` to preserve formatting.
- References to other PRs must use the `<org>/<repo>#<pr_number>` form, even for same-repo PRs. Bare `#123` renders identically in the current repo but breaks once quoted elsewhere.
- Defaults (assignee, labels, etc.) follow the user's global rules unless told otherwise.
- Report the PR URL when done; for updates, add a one-line summary of what changed.

## Troubleshooting

`gh pr edit --body` can fail with `GraphQL: Projects (classic) is being deprecated ...`. Fall back to the REST API, which bypasses the deprecated projectCards query:

```bash
gh api repos/OWNER/REPO/pulls/NUMBER --method PATCH --field body=@pr-body.md
```
