---
name: pr-guide
description: Use whenever a human is about to review a PR and asks for help understanding the diff, before reading it themselves. Produces a per-perspective guide that groups changed code by outcome-level themes and traces the flow inside each. Triggers on a PR URL, a PR number (`#123`), a branch name, or "review the current branch", and on phrasings like "PR レビューしたい", "この PR 見せて", "diff 追いたい", "レビュー用に整理して", "help me review this PR", "walk me through this diff".
---

# pr-guide

Help a human reviewer grasp a PR's diff before they read it. The reviewer's scarce resource is attention: they want to know **what to look at, in what order, and why**.

## What the reviewer needs

The reviewer already knows how to read code. What they cannot get from the diff alone:

1. **The perspectives inside this PR.** A diff arrives as a pile of hunks; the reviewer's first job is to sort them into meaningful themes. Do that for them.
2. **The causal chain inside each perspective.** For each theme, the sequence of entry → intermediate → exit — where the change starts, what it flows through, what observable effect it produces.
3. **The interactions between perspectives.** When two themes touch a shared file or helper, the reviewer must not encounter the same change twice with no context. Name the interaction once, cross-reference from the other side.
4. **What is safe to skim.** Renames, formatting, dependency bumps, generated files — call them out and set them aside so the reviewer does not spend attention on them.

Everything the guide contains should serve one of these four. If a piece of information serves none, cut it.

## Extracting perspectives

A *perspective* is an outcome-level theme that explains **why a group of hunks belong together**. Cut the diff along axes the reviewer would actually think in ("auth flow change", "new webhook endpoint", "logging unification"), not along mechanical axes ("files under `src/`", "renames", "test changes").

Extract from the diff itself, not from a fixed taxonomy. The number varies by PR — a focused PR may have one, a broad PR five or more. Do not force a target count.

- Start from what became **possible or different** after this merge. Each such outcome is a candidate perspective.
- Fold pure-mechanical changes (renames, moves, formatting) into the perspective they serve. If they serve none, group them last under "Incidental changes".
- Tests, docs, and fixtures belong under the perspective they exercise, not in their own bucket — unless the PR is genuinely a test-only or docs-only change.
- If two candidates share more than half their files, they are one perspective with two facets. Merge and note the facets as sub-bullets.
- If a candidate has only one hunk and no downstream effect, demote it into a neighboring perspective or into "Incidental changes".
- A shared file touched by two perspectives — name the interaction in one and cross-reference from the other, do not silently split it.

Order by importance to the reviewer's decision: the ones needing careful reading first, incidental last. Not by file path, not by commit sequence.

## Guide structure

- **TL;DR** (1-3 sentences): the PR's overall intent and the perspectives you extracted. A reviewer who reads only this should know what kind of review this is (feature? refactor? risky migration?) and roughly how many threads to follow.
- **Perspective sections**, one per perspective, in importance order.
- **Incidental changes** (only if any): one line each. Omit the section entirely when there is nothing.
- **Reading order suggestion** (optional, 1-2 lines): only when the perspectives have a natural read order the importance ordering does not already imply (e.g. "read B first — A's tests depend on its new helper").

### Each perspective section

For each perspective, provide:

- **Outcome**: one line naming what became possible or different.
- **Entry**: where this perspective's flow starts, with a `file:line` pointer and one sentence on what happens there.
- **Flow**: the middle steps in causal order — each a `file:line` pointer plus one sentence. The reader should follow the chain top-to-bottom without re-reading; if a step does not follow from the previous one, either the order is wrong or a step is missing.
- **Exit / effect**: what the flow produces or changes — the observable effect or the downstream contract, with a pointer.
- **Tests**: which tests exercise this perspective — pointers only. Do not describe what each verifies unless the reviewer asks. Skip the line when there are none (and let that absence stand — the reviewer will notice).
- **Diagram** (optional): a Mermaid figure when the flow crosses 3+ actors, branches, or changes state. One figure, one claim. Skip for straight chains.
- **Watch for** (optional): a specific thing worth extra attention — a subtle invariant, a case the flow does not cover, an API contract that changed. One sentence. Omit when nothing stands out; do not fabricate concerns to fill the slot. This names *what to look at*, not *what is wrong* — evaluation is the reviewer's job.

When a perspective touches only 1-2 files, collapse the above into 2-3 total bullets. The template is a ceiling, not a floor.

## Output

Emit the guide as chat text. If it contains any Mermaid, also write the same content to a Markdown file in the scratchpad and report the path.

## Judgment

- The reviewer can decide their reading order and per-perspective attention level from the guide alone, before opening any file.
- Perspectives are **disentangled**: reading one does not require holding another's context in mind.
- No perspective duplicates another; no changed hunk goes uncounted (either in a perspective or in "Incidental changes").
- **Every bullet adds information the diff does not** — a grouping, an ordering, a name for a flow. Never a line-by-line diff restatement. Never paste diff hunks or full function bodies; point and name, do not re-print.
- **Brevity over completeness.** A guide the reviewer actually reads beats an exhaustive one they skim. When in doubt, cut.
- The guide is descriptive, not evaluative. Do not write "this looks correct" or "consider extracting a helper".
- If the diff genuinely resists perspective grouping (a scattergun PR of unrelated fixes), say so in the TL;DR and fall back to a flat list of one-liner change summaries. Do not invent structure that is not there.
- If the diff is large enough that reading it fully would blow the context budget, say so up front and produce the guide from file-level shape plus spot-reads of the heaviest hunks. Do not silently guess.
