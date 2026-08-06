---
name: technical-writing
description: Write, revise, or polish technical documents through structured phases (Bootstrap → Polishing). Use for general technical writing or systematic refinement of existing documents. Trigger when the user says "write a technical document," "polish this text," or "improve this document," including Japanese equivalents — 執筆: 「技術文書書いて」「設計書作って」「ブログ書いて」「解説記事作って」「ADR書いて」「RFC作って」「README書いて」「仕様書作成」; 推敲・リライト: 「推敲して」「リライトして」「文章を締めて」「誤字直して」; 改善: 「もっと良くして」「読みやすくして」「ブラッシュアップ」「磨いて」「文章を良くして」.
---

# Technical Writing Skill

## Execution Model

Claude executes this skill. The user intervenes only at Confirm gates: Bootstrap Step 1 (Theme/Purpose/Audience), Step 2 (Outline), Step 3-2 (Draft), the Preparation audience-check gate, and the Final Confirm at the end of Polishing. The three ExitPlanMode gates (Step 2, Step 3-2, Final Confirm) follow the shared structure in **Review Gates**.

The procedure is mandatory in every mode. Auto Mode or "make it simple" tunes how much is asked at each gate, not whether the skill runs.

At each Confirm, report only what the user needs to accept, reject, or redirect. Diagnostic detail stays in working memory and is produced on request.

**Stance: preserve the line, not the coverage.** A document that keeps its central line under a small amount of dropped context is worth more than a document that keeps every fact under a flattened line. When cutting and inclusion are in tension, cut. The user's review at the Final Confirm gate catches anything the reader actually needed back; it is a strictly cheaper repair path than diagnosing why the finished document feels flat.

**Cutting means dropping items, not shortening each one.** When a section reads flat because it develops too many parallel items at equal depth, the fix is to drop items and let the survivors carry depth — not to trim every item to a smaller version of the same flatness. Ten items at half-length is still ten items in flat symmetry. This applies especially to three-axis, three-option, and N-component sections that read as reference tables written out as prose.

**Shortness is a goal.** Between two versions that preserve the same central line and cognitive rhythm, prefer the one built from fewer facts. Fewer facts is achieved by dropping information units, not by rewriting the same information into shorter sentences. Compressing sentences without reducing information content trades clarity for terseness and typically fails both.

## Prerequisites

- `technical-document.md`: **language-independent rules** (includes figure notation in §13-1)
- `technical-document-<lang>.md`: **language-specific rules** (currently `ja`, `en`)

**Resolution.** `technical-document.md` lives under `.claude/rules/` (project or user; project wins). `technical-document-<lang>.md` and quick-checks live under `.claude/references/` (not auto-loaded; project wins). If a needed file is missing at both locations, locate by name and warn. §numbers refer to sections in the resolved language-independent file.

**Language.** Match the document's existing language, or confirm via AskUserQuestion for new documents.

Do not write from vague guesses. Look up missing information; if still unclear, confirm via AskUserQuestion.

## Mode Selection

Determine mode from user input; confirm via AskUserQuestion if uncertain.

| Mode   | Condition                                        | Flow                  |
| ------ | ------------------------------------------------ | --------------------- |
| New    | Document does not exist yet                      | Bootstrap → Polishing |
| Revise | Modify or expand parts of an existing document   | Revise Mode           |
| Refine | Improve overall quality of an existing document  | Polishing only        |

## Review Gates

Three gates present work to the user via ExitPlanMode (enter plan mode first if not already). Each gate asks one question and defers the rest; the questions do not overlap.

- **Step 2 (Outline).** Are the sections the reader needs all present, each earning its place, ordered and nested to match the hierarchy of ideas (§4-2, §4-4), assigned the right role (§3), and carrying a figure wherever the section's claim is structural (§4-5)?
- **Step 3-2 (Draft).** Is each section's central claim the right one, backed by the evidence the audience needs, free of material that changes nothing for the reader (§3, §6), with terms defined where the Step 1 boundary puts them, and with each planned figure's claim and prose division settled?
- **Final Confirm.** Does the argument run in one direction (§2), with ink allocated to importance (§3), cognitive modes shifting across consecutive paragraphs and at least one tension staying open across section boundaries (§14), claims carrying their mechanisms and conditions (§5), and a surface that reads as a situated author wrote it (§1, §8-§10)? Deleted material the user needs restored is caught here.

Structure every gate's plan file in this order:

1. **Review perspective** — the gate's question, in the terms above, narrowed to what this document actually puts at stake. One sentence.
2. **Review target** — the full artifact under review: the outline (Step 2), the bullet draft (Step 3-2), or the document's full prose (Final Confirm). Present it inline, not as a file path; the user must be able to review without opening the file.
3. **Supplementary context** — anything the user needs to judge the target, omitted when there is nothing to add. Content varies by gate; see each gate's section.

Do not proceed until the current gate is confirmed. The plan UI carries inline feedback per item; AskUserQuestion does not. Background information may be accepted at any point and feeds Step 2 triage, not the document directly.

## Preparation (all modes)

- Follow document convention files under `.claude/rules/` if present (naming, frontmatter, placement). For diagram notation, a project convention wins over §13-1's Mermaid mapping; absent one, match the format the repository's existing documents use.
- If a project-specific documentation skill fits the request, suggest it via AskUserQuestion.
- **Audience check (Refine and Revise only).** Bootstrap fixes the audience at Step 1. Otherwise, check whether an audience is available (user-supplied definition, Bootstrap Step 1 record, or project convention). If none, ask via AskUserQuestion to (a) define one now, or (b) skip Persona Reader Review (1-3), noting that (b) degrades review to structure and rules only.

## Bootstrap (New mode)

Two user-facing Confirms: **Outline** (Step 2) and **Draft** (Step 3-2), both following **Review Gates**. Prose generation runs internally; the user next sees the document at the **Final Confirm** in Polishing.

Supplementary context at both gates: Claude's understanding of audience and theme, per-section role weighting — Center / Support / Background (§3), with any deliberate misalignment noted — and the figure plan (Step 2: which sections carry a figure and of what kind; Step 3-2: each figure's claim and what the prose keeps).

### Step 1: Confirm Theme, Purpose, and Audience

Confirm via AskUserQuestion:

1. Audience: technical level, assumed knowledge, use case, perspective, team
2. Theme and purpose
3. Document type: specification, architecture, interface design, ADR, procedure, design doc, etc. (use project-defined types if available)
4. Related documents: prerequisites (their defined terms need not be redefined) and siblings whose terminology this document must match. List the terms each owns, or "none".

Record a term boundary for the audience: for each technical term, decide whether the document defines it, references a prerequisite, or leaves it as persona base knowledge. The boundary drives term placement in Step 3 and Persona Reader Review in Polishing.

### Step 2: Confirm Outline

Propose an outline, then confirm via ExitPlanMode following **Review Gates**. The gate asks whether the structural components are right, so the outline carries section titles, their order, nesting, and roles — not the content each section will hold. Before proposing:

- **Triage.** Keep a section only if it contributes to what the reader can do or decide after reading (§3). Move dropped candidates into the lead's scope exclusions (§4-1) and list them so the user can promote one back.
- **Annotate roles.** Mark each section Center, Support, or Background (§3).
- **Assign figures.** Where a section's claim is structural (§4-5), mark it with the figure kind from §13-1's table. A Center section with a structural claim and no figure needs a stated reason. Assigning here rather than in Polishing avoids prose that has already spent its ink on the structure.
- **Flag parallel-item sections.** For each Center section whose content is inherently a list of parallel items (N axes, N options, N causes, N components with the same role), mark it as a *parallel-item section* and identify — even provisionally — which item is primary. If none is primary, either the section is a table with no prose (mark it) or it is not one section but N (split it, or reconsider whether the parallel form is right at all). This decision drives Step 3's Draft.

### Step 3: Write Sections

Expand the approved Outline into a bullet Draft, confirm the Draft, then generate prose internally.

1. **Draft.** For each section, open with the central claim in one sentence, then list terms on the needs-definition side of the Step 1 boundary and pin where each is defined before its first use. Fill with concise bullets (sub-claims, evidence, examples, qualifications, transitions), one line each. Center carries more bullets than Support, Support more than Background.

   **Parallel-item plan (§3 asymmetric treatment).** Whenever a section will develop N sub-items (three axes, four options, five causes, a comparison table with axes to interpret), mark exactly one bullet as *primary* — the one the prose will develop in depth. The rest are *collapse*: to a table row, a single subordinate clause, or a compressed sentence. If you cannot pick one as primary, either (a) the items are genuinely equal and prose treatment is inappropriate (use only a table), or (b) the section has no center and should be split or merged. Do not leave the decision to prose generation; it defaults to symmetric coverage.

   Do not draw the figures marked in Step 2; specify each in four lines — **kind**, **elements**, **claim** in one sentence (the caption), and **prose division**: what the prose keeps (the why and the conditions). Skipping the fourth line lets prose generation re-narrate the figure (§10). Tables get a direction note only.
2. **Confirm Draft via ExitPlanMode following Review Gates.** The gate asks whether the information the document will carry is the expected set, so keep bullets at note density; do not pre-polish them into finished sentences. Adjust claims, bullets, sections, and roles.
3. **Prose (internal).** Convert the approved Draft into prose and render the specified figures per §13-1. Allocate ink along three axes:
   - **Between sections (role-driven).** Default Center > Support > Background. Center carries mechanism, evidence, qualifications; Support carries connecting reasoning; Background carries orientation only. Support and Background earn ink only where cutting them would break the Center's argument — write the minimum, not the maximum, of each.
   - **Within a section (climax-driven).** Keep the opening summary-level; concentrate concrete detail at the paragraph carrying the central claim (§3).
   - **Between prose and figure.** Hold to the Draft's prose division: the ink the prose would have spent naming the structure goes to why and under what conditions.
   - **Cognitive rhythm (§14).** Vary cognitive mode across consecutive paragraphs; do not chain three assertions. Insert deliberate hesitations (naive expectation, suspended judgment) as setups for assertions rather than treating them as weakness. Use the 立てる→流す→止める beat (short setup, longer flow, short landing) as a default paragraph shape when the content admits it. Keep at least one raised question open at each section boundary. Do not open every paragraph with a bare topic sentence.
   - **Parallel-item execution (§3).** Honor the Draft's *primary* / *collapse* marking. The primary sub-item gets a full paragraph (mechanism, worked example, hesitation-then-assertion); the *collapse* sub-items get a table row, a subordinate clause, or a single sentence — not a paragraph each. Symmetric N-paragraph development of N items is the failure mode this rule exists to prevent.
   - **Deliberate misalignment.** A compressed Center or enlarged Background is legitimate when reader care requires it. Record the reason so Polishing does not flag it.
   - **Guard against over-carry.** Do not fill absent ink. Support prose recovering the Center's mechanism, Background asserting its own qualifications, Center openings at climax density, or prose re-narrating a figure are all writing past the assigned load — cut, don't smooth.
   - **Guard against defensive premises.** Existing ink also gets cut when it does not change the reader's next decision. Related-work paragraphs, prior-context recaps, and definitions the audience already carries all read as flat regardless of writing quality. If a Support or Background paragraph cannot be justified in one sentence as "the reader acts or decides differently because of this," delete it — the Final Confirm redirect is the safety net for the rare case a cut removed something the user needed.
4. **Write to file and proceed to Polishing.**

All sections follow the language-independent rules, the language-specific rules, and project conventions.

## Revise Mode

Revisions break the surroundings: a locally fine edit can drift the document's register, terminology, or weight. Before editing, record the section's role, established terms, and the register the document uses; edit within those constraints. Prefer folding new material into existing sentences over appending — appending stacks equal-weight claims and flattens the section. Then run Polishing scoped to the revised sections plus immediate neighbors (typically a Small target). If Polishing surfaces a §2-§4 finding a local edit cannot resolve, escalate rather than absorbing it into Polishing.

## Polishing

Improve text written in Bootstrap (New) or existing text (Revise, Refine).

**Iteration budget.** One iteration in every mode. Exit early on zero findings.

**Small targets.** Judge by structural scope, not word count: one or two sections, a single Center, no Support the reader could not reconstruct from the Center. For Small targets, skip subagents — run 1-1, 1-2, 1-3 sequentially in the main session, then Edit. Inherit any Bootstrap compression choice.

**Escalation on structural findings.** A §2-§4 finding crossing a paragraph boundary (splitting a section, promoting a footnote, reordering siblings, revisiting the Bootstrap outline, converting a structural passage into a figure) is not a Polishing edit. Stop and confirm via AskUserQuestion; in Revise mode, re-scope the revision before proceeding.

Converting prose to a figure moves the paragraph's ink with it (§13-1), so present the figure and the rewritten prose together at the confirmation.

### Full Review

Run 1-1, 1-2, and 1-3 in parallel as subagents (a fast mid-tier model suffices). Give each only its listed inputs.

#### 1-1. Rule Check

Inputs: the document, the language-independent rules, the language-specific rules, and the quick checks (`~/.claude/references/technical-document-quick-checks.md` and `-<lang>.md`). Load the quick-checks explicitly; they are not part of the Prerequisites auto-load.

Run the language-independent quick checks in full; language-specific quick checks run in full as well.

Report zero as zero. On zero findings, output "no violations detected" and stop.

#### 1-2. Structural Review

Inputs: the document, and §2-§4, §6, §10, §13-1, and §14 of the language-independent rules.

Two phases in one run; complete Phase 1 before starting Phase 2. Do not rewrite.

**Phase 1 (annotate).** For each paragraph, output: topic, logical relationship to the previous paragraph, dimensions served (hierarchical, parallel, comparative, temporal, causal), claims supported, role read from the text (§3), and cognitive mode (observation, hesitation, assertion, re-observation — §14). When a Step 2 role assignment is available (Bootstrap or Revise with the record preserved), record it alongside and mark divergences as candidate findings. On external documents (Refine), note "no reference assignment".

Mark paragraphs carrying structural content (§4-5) with the figure kind the content fits.

**Phase 2 (detect).** Flag:

- Paragraphs serving no dimension or claim (redundancy — candidates for cut before rewrite)
- Premise or orientation paragraphs the reader would not act or decide differently for (§3, §6 — candidates for cut)
- Claims lacking supporting paragraphs
- Weighting inversions and indistinguishable center paragraphs (§3-§4)
- Over-carry as defined in the Step 3-3 Guard
- **Parallel-item symmetry:** sections listing N sub-items (three axes, four options, five causes) at similar paragraph length and structure when the text names one as most important. Propose promoting the named one to depth and collapsing the rest to a table row or subordinate clause (§3 asymmetric treatment). This is a **candidate-drop**, not a candidate-shorten: the fix is fewer items with real depth, not smaller items evenly.
- Three-plus consecutive paragraphs in the same cognitive mode (§14-1); three-plus consecutive paragraphs whose first sentence is a bare assertion (§14-5)
- Uniform paragraph size across a section (every paragraph within ±30% of neighbors — §14-5)
- Sections closing with tail-end previews (§2, §14-4)
- Sections where no open tension crosses into the next section (§14-3)
- Tensions raised and discharged inside the same paragraph (§14-3)
- Every paragraph opening with a bare topic sentence, section-wide (§14-5)

Do not flag declared deliberate misalignment.

For candidate-cut and candidate-drop findings, propose the cut (which items to drop, which item to promote, what would be lost); Edit decides whether to take the cut or preserve the paragraph.

Figure findings, from Phase 1's marks and the document's existing figures (§4-5, §13-1): structural paragraphs left for the reader to diagram (report span and figure kind; this escalates); prose re-narrating an existing figure; figures carrying two unrelated claims (overviews excepted).

When Phase 1 recorded "no reference assignment", weighting-inversion findings are **advisory**: Edit does not apply them directly, but asks the user via AskUserQuestion whether the flagged section's center matches their intent. Redundancy and missing-support findings remain actionable.

#### 1-3. Persona Reader Review

Inputs: the document, the audience definition, and the related-documents list with the terms each owns. Do not load the rule files.

Read as the audience; find comprehension gaps: undefined terms, assumed background, logical leaps, drift of terms owned by prerequisites, weighting that misses the writer's intent, and passages where the persona had to hold several relationships at once or re-read to recover an ordering (a missing figure). If the audience check recorded a skip, 1-3 does not run this invocation.

**Scope.** 1-2 finds gaps against the argument. 1-3 finds gaps against the audience. Do not duplicate 1-2.

**Findings are candidates for triage, not repair orders.** A gap flagged here does not automatically add prose. Edit chooses between three responses in order (§10 delete-first): (a) cut the scaffolding around the gap so the gap disappears, (b) rewrite the central line so the leap is not there, (c) add a targeted sentence. This review does not decide which; it surfaces the gap and Edit picks the response. The user's final review at the Final Confirm gate is the last catch — a gap that survived (a) and (b) but was not repaired by (c) will be caught there and can be fixed then. Optimize this review for surfacing, not for pre-writing fixes.

**Tasks.**

1. Read paragraph by paragraph as the persona. For each gap, output: **Span**, **Unclear term or leap**, **Missing knowledge**, **Suggested response** (one of: cut-scaffolding, rewrite-center, add-sentence, defer-to-final).
2. Scan at reading speed and record which paragraph felt like each section's central claim. Report mismatches with the writer's intended center as §3 findings.

Discard impressions without span, missing knowledge, and suggested response. A **Suggested response** of *defer-to-final* is legitimate for low-risk gaps where the persona could still follow the argument — surface it and let the user decide at Final Confirm.

### Edit (main session, after each review)

- Apply fixes in Revision Priority order: cutting first, then structure, then surface. A cut often eliminates the span a structural or surface finding points at; a structural fix often deletes the span a surface finding points at.
- **Try deletion before addition.** For any finding whose fix could be either "add clarifying prose" or "remove surrounding scaffolding," delete first and read the result. If the argument still runs, take the deletion. If it does not, then rewrite the center; addition of new prose is the third option, not the first.
- For 1-3 findings with **Suggested response** of *cut-scaffolding* or *rewrite-center*, take that action; the response tag is a shortcut past the delete-first trial. For *add-sentence*, still run the trial — the reviewer's suggestion may have missed a possible cut.
- For *defer-to-final*, do nothing this iteration. Log it in the Edit list as a deferred item; it surfaces at Final Confirm as supplementary context so the user can catch what the persona review chose not to repair.
- Merge findings on the same span. Upper-tier rules (§1, §3, §4, §5, §14) take precedence over lower-tier (§8-§10); apply lower-tier only when it does not undo the upper-tier fix. If an upper-tier rule required the lower-tier violation (e.g., a §10 exception (1) rebuttal), reject the lower-tier finding and log the reason.
- Keep fixes local. Do not smooth sentences that violate no rule.
- Run project convention validation if available.

**Bias toward loss over inflation.** Preserving the central line matters more than covering every corner. If a cut removes a fact the user later says they wanted, the Final Confirm redirect (or the user's own edit) restores it — a single-pass loss. If a preemptive addition flattens the section, the flatness has to be diagnosed and undone across every paragraph it touched — a multi-pass loss.

**Edit list.** Records each applied fix (span, motivating rule, one-line note) and deferred 1-3 items (span, gap). Final Confirm uses it as the change summary.

### Final Confirm

Runs in all modes, including Small targets. Present via ExitPlanMode following **Review Gates**. The review target is the **final document in full, inline**. The user reviews the finished prose, not a diff: the pre-Polishing text was never theirs to accept.

Supplementary context, in this order, each omitted when it has nothing to report:

1. **Structural divergence from the approved Draft** — sections added, dropped, reordered, or re-roled since Step 3-2, and figures added, dropped, or changed in kind against the Step 2 assignment. Report only divergence; a document matching its Draft has none. In Refine mode there is no approved Draft, so report structural edits against the document as received.
2. **Change summary** — the Edit list, grouped by rule tier (cutting §3/§6/§10, structure §2/§4/§5, rhythm §14, surface §8-§10, seams). For each: section or span, motivating rule, one-line note. Include mid-Polishing escalations.
3. **Deferred 1-3 items** — persona-review gaps tagged *defer-to-final* and not repaired this pass. For each: span, gap, why deferred. The user decides at this gate whether to add prose or leave the gap.
4. **Persona and mode** — audience definition used in 1-3 (or skip reason), and the mode.

The file path appears alongside the inline text, not in place of it.

On approval, the skill ends. On redirect: local fixes stay within one additional Polishing iteration; a broader re-review escalates to a fresh Revise Mode pass on the affected sections.
