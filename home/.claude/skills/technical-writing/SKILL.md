---
name: technical-writing
description: Write, revise, or polish technical documents through structured phases (Bootstrap → Polishing). Use for general technical writing or systematic refinement of existing documents. Trigger when the user says "write a technical document," "polish this text," or "improve this document."
---

# Technical Writing Skill

## Execution Model

Claude executes this skill. The user intervenes only at Confirm gates: Bootstrap Step 1 (Theme/Purpose/Audience), Step 2 (Outline), Step 3-2 (Draft), the Preparation audience-check gate, and the Final Confirm at the end of Polishing.

The procedure is mandatory in every mode. Auto Mode or "make it simple" tunes how much is asked at each gate, not whether the skill runs.

At each Confirm, report only what the user needs to accept, reject, or redirect. Diagnostic detail stays in working memory and is produced on request.

## Prerequisites

- `technical-document.md`: **language-independent rules**
- `technical-document-<lang>.md`: **language-specific rules** (currently `ja`, `en`)

**Resolution.** `technical-document.md` lives under `.claude/rules/` (project or user; project wins). `technical-document-<lang>.md` and quick-checks live under `.claude/references/` (not auto-loaded; project wins). If a needed file is missing at both locations, locate by name and warn. §numbers refer to sections in the resolved file.

**Language.** Match the document's existing language, or confirm via AskUserQuestion for new documents.

Do not write from vague guesses. Look up missing information; if still unclear, confirm via AskUserQuestion.

## Mode Selection

Determine mode from user input; confirm via AskUserQuestion if uncertain.

| Mode   | Condition                                        | Flow                  |
| ------ | ------------------------------------------------ | --------------------- |
| New    | Document does not exist yet                      | Bootstrap → Polishing |
| Revise | Modify or expand parts of an existing document   | Revise Mode           |
| Refine | Improve overall quality of an existing document  | Polishing only        |

## Preparation (all modes)

- Follow document convention files under `.claude/rules/` if present (naming, frontmatter, placement, diagram notation).
- If a project-specific documentation skill fits the request, suggest it via AskUserQuestion.
- **Audience check (Refine and Revise only).** Bootstrap fixes the audience at Step 1. Otherwise, check whether an audience is available (user-supplied definition, Bootstrap Step 1 record, or project convention). If none, ask via AskUserQuestion to (a) define one now, or (b) skip Persona Reader Review (1-3), noting that (b) degrades review to structure and rules only. Record the decision for the Completion Report.

## Bootstrap (New mode)

Two user-facing Confirms: **Outline** (Step 2) and **Draft** (Step 3-2). Prose generation runs internally; the user next sees the document at the **Final Confirm** in Polishing.

Present each Confirm via ExitPlanMode (enter plan mode first if not already). Structure the plan file:

1. **Review target** — the outline or draft to accept, redirect, or stop
2. **Supplementary context** — Claude's understanding of audience and theme
3. **Per-section role weighting** — Center / Support / Background (§3), with any deliberate misalignment noted

The plan UI carries inline feedback per item; AskUserQuestion does not. Do not proceed until the current step is confirmed. Background information may be accepted at any point and feeds Step 2 triage, not the document directly.

### Step 1: Confirm Theme, Purpose, and Audience

Confirm via AskUserQuestion:

1. Audience: technical level, assumed knowledge, use case, perspective, team
2. Theme and purpose
3. Document type: specification, architecture, interface design, ADR, procedure, design doc, etc. (use project-defined types if available)
4. Related documents: prerequisites (their defined terms need not be redefined) and siblings whose terminology this document must match. List the terms each owns, or "none".

Record a term boundary for the audience: for each technical term, decide whether the document defines it, references a prerequisite, or leaves it as persona base knowledge. The boundary drives term placement in Step 3 and Persona Reader Review in Polishing.

### Step 2: Confirm Outline

Propose an outline, then confirm via ExitPlanMode. Before proposing:

- **Triage.** Keep a section only if it contributes to what the reader can do or decide after reading (§3). Move dropped candidates into the lead's scope exclusions (§4-1) and list them so the user can promote one back.
- **Annotate roles.** Mark each section Center, Support, or Background (§3).

### Step 3: Write Sections

Expand the approved Outline into a bullet Draft, confirm the Draft, then generate prose internally.

1. **Draft.** For each section, open with the central claim in one sentence, then list terms on the needs-definition side of the Step 1 boundary and pin where each is defined before its first use. Fill with concise bullets (sub-claims, evidence, examples, qualifications, transitions), one line each. For figures and tables, write a direction note only. Center carries more bullets than Support, Support more than Background.
2. **Confirm Draft via ExitPlanMode.** Adjust claims, bullets, sections, and roles.
3. **Prose (internal).** Convert the approved Draft into prose. Allocate ink along two axes:
   - **Between sections (role-driven).** Default Center > Support > Background. Center carries mechanism, evidence, qualifications; Support carries connecting reasoning; Background carries orientation only.
   - **Within a section (climax-driven).** Keep the opening summary-level; concentrate concrete detail at the paragraph carrying the central claim (§3).
   - **Deliberate misalignment.** A compressed Center or enlarged Background is legitimate when reader care requires it. Record the reason so Polishing does not flag it.
   - **Guard.** Do not fill absent ink. Support prose recovering the Center's mechanism, Background asserting its own qualifications, or Center openings at climax density are all writing past the assigned load — cut, don't smooth.
4. **Write to file and proceed to Polishing.**

All sections follow the language-independent rules, the language-specific rules, and project conventions.

## Revise Mode

Revisions break in ways new writing does not: locally fine text can drift the document's register, terminology, or weight.

1. **Absorb the surroundings.** Record register (formality, person), established terms, and each target section's role.
2. **Edit within those constraints.** New text uses existing terms and register. Surface any role change before writing.
3. **Prefer rewriting over appending.** Fold new material into existing sentences; appending stacks equal-weight claims and flattens the section.
4. **Re-balance.** Check revised sections against their roles; an expanded background outweighing its center is a weighting inversion (§3).
5. **Polish the seams.** Run Polishing on the revised sections plus immediate neighbors — transitions are where revisions tear. Revise runs one Polishing iteration, then Final Confirm. Seam Polishing typically qualifies as a Small target and runs in the main session.
6. **Escalate on structural findings.** If Polishing surfaces a §2-§4 finding that a local edit cannot resolve, return to Step 1 for the affected sections rather than absorbing the fix inside Polishing.

## Polishing

Improve text written in Bootstrap (New) or existing text (Revise, Refine).

**Iteration budget.** New and Revise run **one** iteration; Refine runs **two**. Exit early on zero new findings (same span and rule section as a prior iteration = reappearance). Report zero as zero.

**Small targets.** Judge by structural scope, not word count: one or two sections, a single Center, no Support the reader could not reconstruct from the Center. For Small targets, skip subagents — run 1-1, 1-2, 1-3 sequentially in the main session, then Edit. Inherit any Bootstrap compression choice.

**Escalation on structural findings.** A §2-§4 finding crossing a paragraph boundary (splitting a section, promoting a footnote, reordering siblings, revisiting the Bootstrap outline) is not a Polishing edit. Stop and confirm via AskUserQuestion; in Revise mode this triggers Revise Mode Step 1.

### Iteration 1: Full Review

Run 1-1, 1-2, and 1-3 in parallel as subagents (a fast mid-tier model suffices). Give each only its listed inputs.

#### 1-1. Rule Check

Inputs: the document, the language-independent rules, the language-specific rules, and the quick checks (`~/.claude/references/technical-document-quick-checks.md` and `-<lang>.md`). Load the quick-checks explicitly; they are not part of the Prerequisites auto-load.

The language-independent quick checks are two-tiered: run Priority 1 by default; extend to Priority 2 when the document is long, the target is a full pass, or Priority 1 returned fewer than three findings and budget remains. Language-specific quick checks run in full.

Report zero as zero. On zero findings, output "no violations detected" and stop.

#### 1-2. Structural Review

Inputs: the document, and §2-§4 and §10 of the language-independent rules.

Two phases in one run; complete Phase 1 before starting Phase 2. Do not rewrite.

**Phase 1 (annotate).** For each paragraph, output: topic, logical relationship to the previous paragraph, dimensions served (hierarchical, parallel, comparative, temporal, causal), claims supported, and role read from the text (§3). When a Step 2 role assignment is available (Bootstrap or Revise with the record preserved), record it alongside and mark divergences as candidate findings. On external documents (Refine), note "no reference assignment".

**Phase 2 (detect).** Flag: paragraphs serving no dimension or claim (redundancy); claims lacking supporting paragraphs; weighting inversions and indistinguishable center paragraphs (§3-§4); over-carry (Support recovering Center mechanism, Background asserting qualifications, Center openings at climax density). Do not flag declared deliberate misalignment.

When Phase 1 recorded "no reference assignment", weighting-inversion findings are **advisory**: Edit does not apply them directly, but asks the user via AskUserQuestion whether the flagged section's center matches their intent. Redundancy and missing-support findings remain actionable.

#### 1-3. Persona Reader Review

Inputs: the document, the audience definition, and the related-documents list with the terms each owns. Do not load the rule files.

Read as the audience; find comprehension gaps: undefined terms, assumed background, logical leaps, drift of terms owned by prerequisites, weighting that misses the writer's intent. If the audience check recorded a skip, 1-3 does not run this invocation; log the skip for the Completion Report.

**Scope.** 1-2 finds gaps against the argument. 1-3 finds gaps against the audience. Do not duplicate 1-2.

**Tasks.**

1. Read paragraph by paragraph as the persona. For each gap, output: **Span**, **Unclear term or leap**, **Missing knowledge**, **Minimal fix**.
2. Scan at reading speed and record which paragraph felt like each section's central claim. Report mismatches with the writer's intended center as §3 findings.

Discard impressions without span, missing knowledge, and fix.

### Iteration 2: Differential Review (Refine mode only)

One subagent. Inputs: **each section containing an Iter1 change, in full**, plus the edit list (each with motivating rule section), the rejected-findings ledger, and the language rule file. Section boundaries follow the heading structure (§4-2); when an Edit crosses a boundary, include both sections. Scope covers the section so the reviewer can judge how Iter1 rebalanced weighting and internal flow, not just seams.

Check: (a) each edit against its motivating rule, (b) new text against the language quick checks, (c) seams against surrounding paragraphs, (d) whether Iter1 rebalanced the section into a new inversion or over-carry. Do not review untouched sections or re-raise ledgered findings without new evidence.

**Seam findings are lower-tier.** Apply a seam fix only when it does not undo an upper-tier fix and only when the seam is broken by the edit itself. Do not touch unchanged surrounding paragraphs; adjust the edited span instead.

### Edit (main session, after each review)

- Apply fixes in Revision Priority order: structure before surface. A structural fix often deletes the span a surface finding points at.
- Merge findings on the same span. Upper-tier rules (§1, §3, §4, §5) take precedence over lower-tier (§8-§10); apply lower-tier only when it does not undo the upper-tier fix. If an upper-tier rule required the lower-tier violation (e.g., a §10 exception (1) rebuttal), reject the lower-tier finding and log the reason.
- Keep fixes local. Do not smooth sentences that violate no rule.
- Run project convention validation if available.

**Rejected-findings ledger.** One ledger across the run. Each entry records: source iteration and reviewer, target span, cited rule section, rejection reason. Pass the ledger into the next review; instruct the reviewer not to re-raise entries without new evidence (different span, different rule section, or changed surrounding text).

**Edit list.** Records each applied fix: span, motivating rule, one-line note. Iteration 2 (Refine) uses this as input; Final Confirm uses it as the change summary.

### Final Edit Verification

If Refine exits at the 2-iteration cap, re-check the final edit's spans against their motivating rule sections in the main session before Final Confirm. Fix regressions; do not open new lines of review. Not needed on zero-finding exits or in New/Revise modes.

### Final Confirm

Runs in all modes, including Small targets. Present via ExitPlanMode. Structure:

1. **Change summary** — the Edit list, grouped by rule tier (structure §2-§5, surface §8-§10, seams). For each: section or span, motivating rule, one-line note. Include mid-Polishing escalations.
2. **Pointer to the final document** — file path; do not inline the full document.
3. **Persona and mode** — audience definition used in 1-3 (or skip reason) and the mode.

On approval, proceed to the Completion Report. On redirect: local fixes stay within one additional Polishing iteration (regardless of mode budget); a broader re-review escalates to Revise Mode Step 1.

### Completion Report

Output in the document's language, one or two sentences each:

1. **Persona used in 1-3**: the audience definition, or the skip reason.
2. **Document summary**: what the document covers and its central claim.
3. **Document type and direction**: type from Step 1 and what the document optimizes for.
