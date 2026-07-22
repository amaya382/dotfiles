---
name: technical-writing
description: Write, revise, or polish technical documents through structured phases (Bootstrap → Polishing). Use for general technical writing or systematic refinement of existing documents. Trigger when the user says "write a technical document," "polish this text," or "improve this document."
---

# Technical Writing Skill

## Execution Model

This skill is executed by Claude. The user is not the executor; they intervene only at the Confirm points defined in Bootstrap (Step 1, Skeleton, Draft, Prose) and at the audience-check gate in Preparation.

**Skill procedure is mandatory** regardless of mode, document size, or prior conversation — Auto Mode and "make it simple" adjust how much is asked at each gate, not whether it runs.

**Confirm reports optimize for user decision resolution, not completeness.** Report only what the user needs to accept, reject, or redirect the step. Diagnostic detail is held in Claude's working memory and produced on request, not by default.

## Prerequisites

All phases follow these rule files:

- `technical-document.md`: **the language-independent rules**
- `technical-document-<lang>.md`: **the language-specific rules** (currently `ja` and `en`), selected by document language

**Resolution.** `technical-document.md` lives under project level (`.claude/rules/`) or user level (`~/.claude/rules/`); project wins per file. `technical-document-<lang>.md` and the quick-checks files live under `.claude/references/` or `~/.claude/references/` (they are not auto-loaded); project wins per file. If neither location resolves for a needed file, locate by name and warn the user. Once resolved, subsequent references in this skill use the names in bold above regardless of where the file was found; §numbers refer to sections within the resolved file.

**Language selection.** Use the document's language for existing text; for new documents, take the user's instruction or confirm via AskUserQuestion.

Do not write from vague guesses. Look up missing information first; if still unclear, confirm via AskUserQuestion.

## Mode Selection

Determine the mode from user input; confirm via AskUserQuestion if uncertain.

| Mode   | Condition                                        | Flow                  |
| ------ | ------------------------------------------------ | --------------------- |
| New    | Document does not exist yet                      | Bootstrap → Polishing |
| Revise | Modify or expand parts of an existing document   | Revise Mode           |
| Polish | Improve overall quality of an existing document  | Polishing only        |

## Preparation (all modes)

Run before entering any mode; Polish and Revise skip Bootstrap but not this.

- Follow document convention files under `.claude/rules/` if present (naming, frontmatter, placement, diagram notation).
- If a project-specific documentation skill covers the request, suggest it via AskUserQuestion.
- **Audience check (Polish and Revise only).** Bootstrap fixes the audience at Step 1. For Polish and Revise, check whether an audience is available: an explicit definition supplied by the user, a Bootstrap Step 1 record on the same document, or a project convention that pins it. If none is available, ask the user via AskUserQuestion to (a) define the audience now, or (b) proceed without Persona Reader Review (1-3), with the trade-off spelled out: 1-3 catches reader-facing gaps the writer cannot see, and skipping it degrades the review to structure and rule checks only. Record the decision so 1-3 either runs against the given definition or is skipped with the reason logged for the Completion Report.

## Bootstrap (New mode)

Step 2 and the Skeleton, Draft, and Prose confirmations in Step 3 present their material via ExitPlanMode. **Enter plan mode at the start of each of these four confirmations** — call EnterPlanMode if not already in plan mode, write the plan file, then call ExitPlanMode. Structure the plan file top-down:

1. **Review target** — the outline / skeleton / draft / prose the user is being asked to accept, redirect, or stop
2. **Supplementary context** — Claude's understanding of audience and theme
3. **Per-section role weighting** — Center / Support / Background per §3, with any deliberate misalignment reason recorded

The plan UI carries inline feedback per item; AskUserQuestion loses that affordance. Once Prose is approved, write the document to file and proceed to Polishing.

Do not proceed to the next step until the current step is confirmed. Background information may be accepted at any point; it feeds the Step 2 triage, not the document directly.

### Step 1: Confirm Theme, Purpose, and Audience

Confirm with the user via AskUserQuestion.

1. Audience: technical level, assumed knowledge, use case, perspective, team
2. Theme and purpose: information to convey and its goal
3. Document type: specification, architecture, interface design, ADR, procedure, design doc, etc. (use project-defined types as options if available)
4. Related documents: prerequisites the persona has already read (their defined terms need not be redefined here) and siblings whose terminology and notation this document must stay consistent with. List each with the terms it owns, or "none" if the document stands alone.

Record the audience with a term boundary: for each technical term, decide whether the document defines it, references a prerequisite document's definition, or leaves it unexplained as persona base knowledge. The boundary drives term placement in Step 3 and the Persona Reader Review in Polishing.

### Step 2: Confirm Outline

Propose an outline based on theme, purpose, and audience, then confirm via ExitPlanMode. Before proposing:

- **Triage.** Keep a section only if it contributes to what the reader can do or decide after reading (the language-independent rules §3). Move dropped candidates into the lead's scope exclusions (§4-1) and list them at confirmation so the user can promote one back.
- **Annotate roles.** Mark each section center, support, or background (§3). An outline without roles gets fleshed out uniformly.

### Step 3: Write Sections

Build the Skeleton, expand into a bullet Draft, then write prose. Weighting has two axes: between sections (role-driven, Center > Support > Background) and within a section (density concentrated at the paragraph carrying the central claim). Deliberate misalignment — a short sharp Center, a Background enlarged for reader care — is legitimate design; the default is a starting point, not a rule (the language-independent rules §3).

1. **Skeleton.** For each outline section, write only the central claim in 1-3 sentences. Alongside it, list the terms on the needs-definition side of the Step 1 boundary and pin where each is defined, before its first use.
2. **Confirm Skeleton via ExitPlanMode.** Adjust if the central claims need to shift.
3. **Draft.** Fill every section with concise bullets covering the intended content: sub-claims, evidence, examples, qualifications, transitions. One line per bullet where possible; no prose. For figures and tables, write a direction note only (what it shows, along which axes). Center sections carry more bullets than Support, Support more than Background, and within each section the bullets around the central claim carry the most concrete material. Do not extend a Support or Background section past what its role requires; a Draft that overfills a low-ink slot commits the section to prose it should not carry.
4. **Confirm Draft via ExitPlanMode.** Adjust bullets, add or drop sections, re-check role weighting. Only proceed once the user approves the Draft.
5. **Prose.** Convert the approved Draft into prose across all sections. Allocate ink deliberately along two axes; treat the default as a starting point, not a rule.

   - **Between sections (role-driven).** The default is Center > Support > Background. Center sections carry mechanism, evidence, qualifications, and counterexamples; Support carries the reasoning that connects to the Center; Background carries only orientation. Do not put mechanism into Background, do not let Support outweigh its Center, do not repeat scope or duplicate examples across Center paragraphs.
   - **Within a section (climax-driven).** Vary paragraph length and density. Keep the opening summary-level, concentrate concrete detail (numbers, proper names, mechanism, worked examples) at the paragraph carrying the section's central claim, and make that paragraph distinguishable from its neighbors by position, length, or density (§3).
   - **Upper bound (writing-too-much guard).** Ink absent from the role or from the position is not free space to fill. Support prose that recovers the Center's mechanism from a different angle, Background prose that names its own qualifications or counterexamples, Center opening paragraphs written at climax density — each is a form of writing past the section's or paragraph's assigned load. Cut the excess rather than smoothing it in; a low-ink slot writing at high-ink density flattens the section's contour just as reliably as a uniform allocation does.
   - **Deliberate misalignment.** The default beats a uniform allocation, not the writer's judgment. Legitimate misalignments run in either direction: a Center compressed to a short sharp paragraph for emphasis (a lead, a summary, a pivot), or a Background enlarged when the reader genuinely needs the orientation. Reader care is the criterion for enlarging a low-role slot; the criterion is not that the writer knows more about it. Record the reason at Confirm so Polishing does not flag the section as a weighting inversion.
6. **Confirm Prose via ExitPlanMode.** On approval, write the document to file and proceed to Polishing. Findings on individual paragraphs raised at this gate are recorded and handed to Polishing rather than absorbed here.

All sections follow the language-independent rules, the language-specific rules, and project conventions.

## Revise Mode

Revisions fail in ways new writing does not: locally fine text can break the document's register, terminology, or weight.

1. **Absorb the surroundings.** Record the document's register (formality, person), established terms, and each target section's role within the whole.
2. **Edit within those constraints.** New text uses existing terms and register. Surface any role change to the user before writing.
3. **Prefer rewriting over appending.** Fold new material into existing sentences; append only when it genuinely does not fit. Appending stacks equal-weight claims and flattens the section.
4. **Re-balance.** Check revised sections against their roles; an expanded background that now outweighs its center is a weighting inversion (the language-independent rules §3).
5. **Polish the seams.** Run Polishing on the revised sections plus the immediate neighbors; transitions are where revisions tear. Seam Polishing almost always falls under Small targets and runs in the main session.
6. **Escalate on structural findings.** If Polishing surfaces a finding under the language-independent rules §2-§4 (paragraph structure, information weighting, or hierarchy) that cannot be resolved by a local edit within the revised sections, return to Step 1 of Revise Mode for the affected sections rather than absorbing the fix inside Polishing. Structural repairs re-open the register and role assumptions that Steps 1-4 established.

## Polishing

Improve the quality of text written during Bootstrap or existing text (Revise, Polish modes).

Maximum 3 iterations. Exit on zero new findings (a finding is a reappearance if it targets the same span and rule section as a prior iteration, regardless of wording). Iteration 1 reviews the whole target; iterations 2-3 review only what the previous Edit changed. Report zero as zero; a manufactured finding costs an extra iteration.

**Small targets.** Judge by the document's structural scope, not by character or word count. A target is Small when it has one or two sections, a single Center, and no Support the reader could not reconstruct from the Center — the same criterion Bootstrap uses for compression. For Small targets, skip subagents: run 1-1, 1-2, and 1-3 sequentially in the main session, then Edit. If Bootstrap recorded a compression choice, inherit it here rather than re-judging; a document Bootstrap treated as Small stays Small in Polishing. For external documents entering Polish mode without a Bootstrap record, apply the structural criterion directly. Run subagents when a boundary target would benefit. Iteration and exit rules still apply.

**Escalation on structural findings.** Polishing is bounded by three iterations of local edits and is not the right place to unwind decisions made in earlier phases. A finding under the language-independent rules §2-§4 that would cross a paragraph boundary (splitting a section, promoting a footnote to the main flow, reordering siblings, revisiting the outline established in Bootstrap Step 2) is not a Polishing edit. Stop and confirm with the user via AskUserQuestion; in Revise mode, this triggers Revise Mode Step 1 for the affected sections (the same escalation stated at Revise Mode step 6).

### Iteration 1: Full Review

Run 1-1, 1-2, and 1-3 in parallel as subagents. A fast mid-tier model (e.g. Sonnet) suffices; these reviews apply checklists, not design. Give each subagent only its listed inputs.

#### 1-1. Rule Check

Inputs: the document, the language-independent rules, the language-specific rules, and the quick checks (`~/.claude/references/technical-document-quick-checks.md` and the corresponding language file `~/.claude/references/technical-document-quick-checks-<lang>.md`). Load the quick-checks files explicitly for this reviewer; they are not part of the Prerequisites auto-load, and they live in `references/` rather than alongside the language-independent rule file.

Evaluate against the quick checks and report findings. Report zero as zero; do not manufacture findings to fill a quota.

The language-independent quick checks are two-tiered: run Priority 1 by default (fifteen high-yield checks covering the AI slop symptoms that drive most rewrites), and extend to Priority 2 in the same reviewer run when the document is long, the target is a full pass rather than a seam or Small-target review, or Priority 1 came back with fewer than three findings and iteration budget remains. The language-specific quick checks are short enough to run in full each time.

If zero findings, output the observation "no violations detected" and stop.

#### 1-2. Structural Review

Inputs: the document and §2-§4 and §10 of the language-independent rules.

Surface unnecessary content and missing arguments. Do not rewrite. Two phases in one run; complete Phase 1 in full before starting Phase 2, and do not revise the annotations afterward.

**Phase 1 (annotate).** For each paragraph, output: (1) the topic in one phrase, (2) the logical relationship to the preceding paragraph, (3) which dimensions (hierarchical, parallel, comparative, temporal, causal) it serves, (4) which claims it supports, and (5) its role (center, support, or background; §3), judged from the text as written. When Step 2's role assignments are available (Bootstrap mode, or Revise mode with the Step 2 record preserved), record the assigned role alongside the read role and mark any divergence; a divergence is a candidate finding for Phase 2 (writer intent vs. document result). When Step 2 assignments are not available (Polish mode on external documents), record only the read role and note "no reference assignment".

**Phase 2 (detect).** Against the Phase 1 annotations, flag: paragraphs serving no dimension or claim (redundancy candidates); claims lacking supporting paragraphs (qualifications, counterexample handling, mechanism explanations); weighting inversions where support or background outweighs the section's center, center paragraphs indistinguishable from neighbors, or heading levels contradicting the role structure (§4); and over-carry — Support paragraphs recovering the Center's mechanism from a different angle, Background paragraphs asserting their own qualifications or counterexamples, or Center opening paragraphs written at climax density. When a low-role slot's expanded length was declared at Confirm as deliberate misalignment for reader care, treat it as intended and do not flag; over-carry findings target undeclared writing past the role, not the sanctioned exception.

When Phase 1 recorded "no reference assignment" (Polish mode on external documents), weighting inversion findings rest on the reviewer's read role alone; a misread of the writer's intended center produces a false inversion. Emit such findings as **advisory** rather than actionable: Edit does not apply an advisory weighting finding directly, but asks the user via AskUserQuestion whether the flagged section's center matches their intent. Redundancy and missing-support findings are unaffected and remain actionable.

#### 1-3. Persona Reader Review

Inputs: the document, the audience definition, and the related-documents list with the terms each owns. Do not load the rule files.

Read as the audience defined for this run (Bootstrap Step 1, Preparation audience check, or project convention) and find comprehension gaps the writer cannot see: undefined terms, assumed background, logical leaps, drift of terms the persona owns from prerequisite documents, weighting that misses the writer's intent. If the Preparation audience check recorded a skip, 1-3 does not run in this Polishing invocation; log the skip reason for the Completion Report and continue with 1-1 and 1-2 only.

**Scope boundary.** 1-2 finds gaps in support for claims against the document's own argument. 1-3 finds gaps in the reader's ability to follow the text against the audience definition. Do not duplicate 1-2's role.

**Tasks.**

1. Read paragraph by paragraph as the persona. For each gap, output: **Span** (quote or line range), **Unclear term or leap**, **Missing knowledge** (per the audience definition), **Minimal fix** (parenthetical, one-sentence definition, or forward reference).
2. Scan the document at reading speed and record which paragraph felt like each section's central claim. Report mismatches with the writer's intended center as Information Weighting findings (the language-independent rules §3).

Discard impressions without span, missing knowledge, and fix. "Confusing" alone is not a finding.

### Iterations 2-3: Differential Review

One subagent per iteration. Inputs: the changed spans plus one paragraph of context on each side, the edit list (each with its motivating rule section), the rejected-findings list, and the language rule file.

Check: (a) each edit against its motivating rule section, (b) new text against the language quick checks, (c) seams (register, terminology, connectives) against surrounding paragraphs. Do not review unchanged text or re-raise rejected findings without new evidence.

**Seam findings are lower-tier.** Report them tagged as such. At Edit, seam findings rank below every rule tier in Revision Priority and are subject to the same precedence check as §8-§10 surface findings: apply a seam fix only when it does not undo, weaken, or fragment an upper-tier fix, and only when the seam is broken by the edit itself rather than being a pre-existing property of the surrounding paragraph. Do not touch unchanged surrounding paragraphs to accommodate a seam finding; if the seam is broken, adjust the edited span instead.

### Edit (main session, after each review)

- Apply fixes in Revision Priority order (the language-independent rules): structure before surface. A structural fix often deletes the span a surface finding points at.
- Merge findings that target the same span before editing. Upper-tier rules (§1 authorial presence, §3 weighting, §4 hierarchy, §5 logical rigor) take precedence over lower-tier rules (§8-§10 surface and rhetoric): apply lower-tier fixes only when they do not undo, weaken, or fragment the upper-tier fix on the same span. When a lower-tier violation exists because an upper-tier rule required it (e.g., a §10 exception (1) rebuttal that surface review flagged as document-updating), reject the lower-tier finding and log the upper-tier reason.
- Keep fixes local. Do not smooth sentences that violate no rule; whole-document smoothing converges toward rule-safe flatness.
- Run project convention validation if available.

**Rejected-findings ledger.** Maintain a single ledger across the Polishing run. Each entry records: the source iteration and reviewer (1-1, 1-2, 1-3, or a later differential review), the target span, the cited rule section, and the reason for rejection (upper-tier precedence, false positive, out of scope for this pass, user override). At the start of the next review — whether subagent-based or main-session — pass the ledger in as an explicit input alongside the document and rule files, and instruct the reviewer not to re-raise a ledgered finding without new evidence (a different span, a different rule section, or a change in the surrounding text that voids the prior reason). Ledger entries persist for the whole Polishing run; do not prune between iterations.

**Edit list.** Alongside the ledger, maintain an edit list recording each applied fix: the span, the motivating rule section, and a one-line note on what changed. Iterations 2-3 take this list as input to check edits against their motivating rule sections.

### Final Edit Verification

If exiting at the 3-iteration cap, re-check the final edit's spans against their motivating rule sections in the main session before the completion report. Fix regressions; do not open new lines of review. Exiting on zero new findings needs no such pass.

### Completion Report

After the iteration loop exits, output the following in the document's language, one or two sentences each:

1. **Persona used in 1-3**: the audience definition, or the skip reason.
2. **Document summary**: what the final document covers and its central claim.
3. **Document type and direction**: type from Step 1 and what the document optimizes for.
