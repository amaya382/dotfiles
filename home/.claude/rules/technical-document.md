---
description: Applies when writing or revising technical prose — specs, design docs, ADRs, README, PR descriptions, commit messages, code comments, blog posts, postmortems. Pair with technical-document-ja.md or -en.md. / 技術文章を書く・推敲するときに適用する。仕様書、設計書、ADR、README、PR description、commit メッセージ、コードコメント、ブログ記事、ポストモーテムなどが対象。言語別規範（technical-document-ja.md / -en.md）と併用する。
---

# Language-Independent Rules for Technical Prose

These rules apply regardless of the language the text is written in.
Pair them with the appropriate language-specific ruleset for vocabulary, punctuation, and idiom-level concerns.

**Scope.** Any text whose job is to convey technical content falls under these rules: specifications, design docs, ADRs, RFCs, README and other repository documentation, pull request descriptions, git commit messages, code comments and docstrings, technical blog posts and explainers, postmortems, issue and ticket writeups, design review and meeting notes.

Short forms take only the sections that have room to apply. A one-line commit message has no paragraph structure (§2), no ink to allocate (§3), and no figure to draw (§13-1), but the claim it makes still needs to be precise (§5), unadorned (§7), and stated once (§10). Do not stretch a section to fit a form that cannot hold it, and do not inflate a form to satisfy a section.

**Load on demand.** The language-specific rulesets and the quick-checks references are not auto-loaded. When writing, revising, or polishing a technical document, Read the file matching the document's language before applying its rules. These rules apply to technical prose only; do not apply the language-specific rules to general conversational output.

- Japanese: `~/.claude/references/technical-document-ja.md`
- English: `~/.claude/references/technical-document-en.md`
- Quick-checks (language-independent and language-specific): `~/.claude/references/technical-document-quick-checks*.md`

Figures: §4-5 decides whether the content wants a figure; §13-1 covers quality and notation, including the Mermaid mapping.

---

## 1. Authorial Presence

AI slop originates from the absence of a situated author. Fix this section before touching surface-level wording.

- **Eliminate false agency.** Do not let inanimate objects perform human actions. "The data tells us" hides the person who read the data and drew a conclusion. "The culture shifts" hides the people who changed their behavior. Name the human actor.

  | False agency                  | Rewrite                                |
  | ----------------------------- | -------------------------------------- |
  | a complaint becomes a fix     | Someone on the team fixed it that week |
  | a bet lives or dies in days   | Someone kills the project or ships it  |
  | the decision emerges          | Someone decides                        |
  | the conversation moves toward | Someone steers the conversation        |
  | the market rewards            | Buyers pay for it                      |

- **Make falsifiable claims.** Do not stop at "this is important" or "this is fundamental." Descend to a specific claim someone could argue against. If you cannot, delete the sentence.

- **Be specific about referents.** Do not blur the subject with broad terms ("AI," "tools," "the system") when a narrower term is available. Once you introduce a term for a concept, keep using that term. Do not retreat to a vaguer word.

- **Do not narrate from a distance.** "People tend to..." and "Many engineers..." float above the scene without committing to a concrete observation. If generalities are all you have, add a specific person, failure, number, or proper noun.

- **Do not attach fictional personas.** "Imagine a second-year engineer who..." adds nothing when the persona does no work in the argument.

## 2. Paragraph Structure

Paragraphs are the unit of argument. Readers must be able to follow the logic one paragraph at a time.

- One paragraph, one topic. If a paragraph mixes multiple advances, split it.
- The first sentence of a paragraph tells the reader what the paragraph is about.
- The opening of each paragraph signals the logical relationship to the previous paragraph with an explicit connective (therefore, however, in fact, given this) when the relationship is not evident from the content alone. A connective bolted onto every paragraph is itself a monotony tell (§8).
- Arguments move in one direction. Do not state a conclusion, handle objections, then restate the conclusion. Handle objections first, then state the conclusion once.
- Do not insert caveats about an example immediately after the climax of a scene. Collect them at the start of the next section.
- When the reader might draw a wrong inference, negate it explicitly before giving the real reason.
- When you negate ("not A but B"), add one sentence of justification for why A is wrong. A counterfactual often works.
- In concessions ("granted, ..."), stick to acknowledging facts. Do not use the author's voice to assert causation that the text will later correct. Attribute the surface-level reading to conventional wisdom or the reader's likely assumption.
- Do not preview information that should land as a surprise at the climax. Hold it until it matters.
- When negating or qualifying, write out the negated proposition precisely. Do not negate vaguely.
- Forward references ("covered in a later chapter") belong at a resting point in the argument, not in the middle of a chain of reasoning.
- Do not close a section with a preview of the next section ("next we look at X," "the following section covers Y"). The bridge between sections belongs at the top of the receiving section, phrased as the question or tension that the new section takes up. A tail-end preview reads as a progress announcement (§10) and lets the reader disengage before the receiving section supplies its own reason to continue.

## 3. Information Weighting

Readers infer importance from paragraph length and detail density. When every paragraph is uniform in length and density, readers cannot tell which one carries the section, and the document reads as flat regardless of how much the writer cares about the central claim.

**Cutting is the default; retention bears the burden.** Drop any candidate you cannot justify in one sentence as "the reader acts or decides differently because of this." Coverage — the wish to include everything you know or researched — is not justification. A reader who is missing something they need will say so; a reader drowning in premises they did not need has no such feedback and stops reading. Preserving the central line matters more than preserving completeness, and information loss is recoverable when the user or a downstream review flags it.

Fix each unit's role before drafting it: center (the claim the section exists to make), support (evidence or mechanism the center cannot stand without), or background (orientation that argues nothing). Center earns ink unconditionally; support earns ink only where the center would fall without it; background earns ink only where the reader cannot enter the center without orientation.

- Allocate ink in proportion to a claim's importance. The central claim deserves more words than the premises that support it. If a background paragraph matches the main argument in length, the reader has no signal for which one to weight.
- Concentrate concrete detail (numbers, proper names, mechanism explanations, worked examples) at the argument's climax. Keep introductions and background at the summary level.
- Vary paragraph length, detail density, and level of specificity across a section. A uniform rhythm hides the writer's judgment.
- Make the central paragraph distinguishable from those around it. Compress it, place it right after the heading, or mark it with emphasis. The means do not matter, but the contrast should be visible to a reader scanning the section.
- When a support or background paragraph outweighs its section's center in length or detail, the fix is to cut the support, not to inflate the center. Inflating lengthens every paragraph and flattens the section again.
- Prefer deletion to demotion. §4-3's ladder (clause, footnote, appendix) is for material the reader would lose something by not seeing; anything softer than that goes to zero.
- When in doubt, cut and re-read. If the paragraphs on either side connect without the removed span, the removal was correct. If they no longer connect, the removed span was carrying a hidden claim — restore it, or write the missing claim explicitly.

**Asymmetric treatment of parallel items.** Listing N parallel items (three axes, four options, five causes) with equal ink asserts they are equal. If the text names one as "most important," "primary," or "dominant," that item earns depth in prose (mechanism, worked example, hesitation and resolution) while the rest collapse to a table row or a single subordinate clause. The failure mode: writing one paragraph per item at similar length so that the "most important" claim is stated and then immediately undone by the shape of the section. This shape hits three-axis and three-option sections hardest because the writer feels an obligation to "cover" each.

**Cutting is not shortening.** When a section reads flat because it lists too much, the fix is not to trim each paragraph to fewer words. Ten items at half-length is still ten items, and the ten-way weighting is still flat. Drop items so what remains can carry real depth. If every item survives every triage pass, either every item is genuinely load-bearing (rare) or the triage is not cutting hard enough (usual). Test: could the section still function as an argument if half the items were reduced to a single row in a table? If yes, that is the target shape, not the current one.

**Strengthen the center by dropping support, not by adding to it.** When a center paragraph reads thin, the instinct is to add another support paragraph explaining why. The result is a section where the center is still thin but now surrounded by more surface — the ratio worsens. The correction is the opposite: drop one of the existing support paragraphs and rewrite the center itself to absorb what it lost. A center paragraph is thin because the writer did not commit to the mechanism at the climax; more support cannot fix that.

**Do not restate what a table or figure already carries.** When a section holds a table or figure, the prose spends its ink on what the table cannot show — the reason the primary item is primary, the mechanism behind a row, the condition under which a value changes — not on walking through the rows in words. Prose that could be reconstructed by reading the table alone is a duplicate; delete it, and let the paragraph the table serves keep the ink instead.

## 4. Hierarchy and Placement

Weighting (§3) decides how much ink a piece of information gets; placement decides where it lives. A document reads as flat when subordinate information sits in the main line as a peer of the claims it serves: the writer knew the hierarchy, but the document's shape does not show it. Express subordination through position: overview before detail, heading levels that mirror the idea tree, secondary facts demoted to less prominent slots.

### 4-1. Overview Before Detail

- At every level (document, chapter, section), state the central point before descending into detail. A reader who stops after a section's first paragraph should leave with its main claim, not with background.
- The document's lead states its scope: what it covers, what it deliberately leaves out, and what the reader can do or decide after reading. A scope exclusion up front spares readers a full read to discover the document does not answer their question.
- Opening with the conclusion does not conflict with §2's rule against previewing climax details. The conclusion is the destination; the climax detail is the evidence that lands it. Announce the destination, hold the evidence.

### 4-2. Heading Hierarchy

- Heading levels express subordination, not sequence or emphasis. Demote a heading one level only when its content is a constituent part of the parent topic. Sections that merely follow each other stay at the same level.
- A lone sub-heading (one H3 under an H2, with no sibling) signals a hierarchy error: merge it into the parent, or find the sibling it implies.
- Sections at the same level should hold content of comparable scope. A section covering a single detail does not belong beside one covering a subsystem; nest it or absorb it.
- Three heading levels is the ceiling. Needing a fourth means the document carries more than one document's worth of structure; split it.

### 4-3. The Demotion Ladder

Apply §3 first: if a support or background paragraph outweighs its section's center, trim the support down. Demotion (this section) applies to the residue — information the trim leaves standing but that still does not deserve a slot in the main line.

The rungs, from most to least prominent:

1. Its own section: a claim the document exists to make
2. A paragraph in the main flow: support the argument cannot stand without
3. A subordinate clause or parenthetical: context the reader needs only in passing
4. A footnote: an aside that would interrupt the argument
5. An appendix or linked document: reference material for a minority of readers
6. Deletion: facts no reader of this document will act on

To place a fact, ask what the reader loses if it moves one rung down; if the answer is nothing, move it. Misplacement shows up in both directions: a parenthetical longer than its host sentence (promote or cut), a footnote the argument depends on (promote), a main-flow paragraph no claim depends on (demote).

### 4-4. List Structure

Lists carry the same weighting problem as paragraphs. When one sibling bullet names a top-level claim and the next names an implementation detail, the reader must re-sort by importance while scanning. Nest details under the parent they belong to, so the indentation reflects the hierarchy of ideas.

- Keep sibling bullets at comparable granularity. A bullet naming an outcome or capability does not belong next to a bullet naming a variable rename or a single log line.
- Keep sibling bullets semantically parallel. Siblings must share a role — the same kind of thing along the same dimension (all causes, all steps, all options, all properties of one object). Bullets that merely happen to sit at the same indent level but answer different questions are not siblings; split them into separate lists or nest each under the parent whose question it answers. Granularity match is necessary but not sufficient: two same-sized bullets that name unrelated categories still fail this rule.
- Nest concrete details, sub-cases, and supporting facts under the parent they qualify. If one candidate sibling wants three lines of context and another is a single fact, the detailed one usually wants a nested list rather than adjacency.
- Order siblings deliberately, by importance or by a sequence the content dictates (temporal, causal, frequency of use). A list left in drafting order makes the reader do the sorting.
- A flat list beyond roughly seven items hides a grouping the writer has not done. Find the clusters inside it and name them.
- Three or four levels is the practical ceiling. Deeper nesting means the list is carrying a section's worth of argument; split it or move the detail into prose or a linked doc.
- A single-item nested list is fine when it labels a sub-case. Do not invent siblings to fill the level.
- The umbrella-term rule (§5) applies to parents too. If a top-level bullet groups several children, its wording should name what the children share.

### 4-5. Prose, List, Table, or Figure

- Prose carries reasoning. Causation, concession, and inference need the connectives that bullets amputate; if the items only make sense read in order with logic between them, they are a paragraph wearing list formatting.
- A list implies siblings that share a role. Using one for a sequence of unrelated remarks is a formatting shortcut that misleads the reader.
- A table carries comparison along two axes: each row a case, each column a property. Keep cells to short facts; put interpretation in the surrounding prose.
- A figure carries structure the reader must hold at once rather than read in sequence. Prefer one whenever the content has two or more dimensions, is a state machine, turns on ordering or concurrency, or claims a boundary — leaving that structure in prose charges the reader (§6) to rebuild it. The tell is a sentence chaining three or more actors. Quality and notation are in §13-1.

A strictly linear flow is the exception: a numbered list reads faster and costs less to maintain.

## 5. Logical Rigor

Leave no opening for the reader to object on the claims a section exists to make. Rigor is a budget, not a coating: spend mechanism, conditions, and handled objections on central claims, and let peripheral facts pass as plain short sentences. When every sentence carries a qualifier and a justification, the prose turns uniformly heavy, and the reader loses the formal cue for which claims are load-bearing (§3 at the sentence level).

After drafting, check:

- Do not mechanically convert hedges to assertions. "Might," "seems," "appears" are legitimate when the proposition is genuinely uncertain, when reporting someone else's state of mind, when reasoning from incomplete evidence, when voicing the reader's likely doubt, or in counterfactuals. Remove them only when they weaken a claim that the text's own evidence has already settled.
- To decide whether a hedge is legitimate uncertainty or hesitant weakening: remove the hedge and read the sentence as an assertion. If the text provides evidence that settles the proposition, the hedge was weakening; remove it. If the text does not settle it, or the proposition concerns someone else's state of mind, a counterfactual, or an unverified fact, the hedge is legitimate; keep it. When in doubt, keep the hedge; false certainty is a worse failure mode than unnecessary caution.
- Do not collapse distinct things into one label. If two things differ, the text must acknowledge the difference.
- Do not reduce a multi-causal event to a single cause. Separate the factors and match each to the mechanism it explains.
- Keep the treatment of a concept consistent across sections. Its classification, definition, and terminological status must not shift.
- When asserting causation, state the mechanism in one sentence. "A leads to B" with no explanation of why is insufficient.
- Do not write as though detection, guarantees, or resolution are always possible. State conditions precisely.
- Check that the examples you cite actually support the full scope of the claim. If they support only part, narrow the claim to match.
- If you defer a point with "covered in the next section," verify that you actually cover it there.
- After a concession or qualification, always advance the argument. Do not leave the reader hanging on a "but."
- Define key terms before using them as load-bearing concepts in a section.
- When grouping several concepts under one umbrella term, state in one sentence that they share the same underlying property, then name the group.

## 6. Reader Load

Treat the reader's memory and attention as finite resources. Every premise, term definition, and orientation paragraph the reader must hold to follow the argument is a debit against a fixed budget; nothing is free because it "provides context."

- **Cut premise blocks to what changes the reader's next decision.** Prior work, historical background, related tools, definitions the audience already knows — none of these earn ink unless the reader would misread the central claim without them. Fear of missing context is not evidence that context is missing.
- **Do not front-load out of unease.** Writers stack premises when they are unsure the reader will trust the claim. Trust comes from the mechanism at the climax, not from more setup before it. If the opening keeps growing, the fix is in the center, not in more prelude.
- **Cap independent facts per section.** A section that carries more than three independent facts (facts a reader could learn separately, each in its own sentence) forces the reader to hold a growing list while following the argument. Combine facts under one mechanism, demote the weakest to a subordinate clause, or drop them. This is a soft ceiling — a section that genuinely turns on four coordinated facts is legitimate — but a section stacking five or six loosely-related facts almost always has candidates to cut. The count applies to independent facts; a single fact broken across two sentences for rhythm (§14-2) counts once.
- Do not introduce proper names (file names, function names, identifiers) that the reader will not need to reference later. Use a general description instead.
- When an abstract phrase could refer to more than one thing, disambiguate it immediately with a parenthetical.
- Before adding a new example, state how it differs from the previous one and why another is needed.
- Do not front-load the opening of a chapter or section with excessive detail unrelated to what follows.
- In example sections, omit details that do not bear on the section's question or conclusion. Keep details that the argument needs.

## 7. Restraint in Rhetoric

Rhetorical devices earn their keep once per section at most.

- Reserve buildup, rhetorical questions, and short standalone punchline paragraphs for genuine climaxes. Dramatic fragmentation ("Simple. That's it.") is the same failure mode as the standalone punchline.
- Limit bold emphasis to one or two per section.
- State the turning point once in a factual sentence. Piled-up consequences and repeated alarms weaken the same claim.
- Avoid metaphors whose referent is ambiguous; use plain verbs.

## 8. Structural AI Tells

- **Avoid thesis-statement headings.** Headings should name a topic (noun phrase), not assert a conclusion ("X is Y").
- **State B directly.** "Not A but B" and "more than just A, it's B" become "B." Drop the negation. This also covers negative-listing runways ("Not a framework... Not a methodology... A mindset.") — collapse to the positive claim.
- **Question three-item lists.** "Three key points" or "three pillars" should be trimmed to two or one when possible.

## 9. Intensity and Stance

- Lower the intensity by one notch. Mix in middle-temperature assessments ("adequate," "uneven," "mixed results") instead of running everything at maximum ("incredible," "essential," "game-changing"). This rule applies to evaluative and interpretive statements. Do not hedge technically verifiable facts (API behavior, algorithm properties, specification guarantees); state them as facts.
- Hedge facts obtained through research in proportion to their verification: secondhand or unverified claims carry "reportedly," "seems to," or "appears to," while claims you verified are stated plainly. Avoid the encyclopedic style that asserts every researched claim as settled.
- "X has its merits, and Y does too" is an abdication of judgment. Commit to the choice you made and explain why.
- Do not dodge conclusions with "it depends" or "case by case."

## 10. Redundancy

- **Delete first, restore on demand.** When a paragraph, sentence, or premise is on the edge of earning its place, cut it and read the result. If the argument still runs, the cut was right. Restore only if a reviewer flags the missing piece; do not preemptively insert out of anxiety.
- **Treat "the reader might not understand" as a signal to try deletion, not addition.** A comprehension gap has three responses, in order: (1) delete the surrounding scaffolding so the gap disappears, (2) rewrite the central line to remove the leap, (3) add a targeted sentence. Reach for (3) only when (1) and (2) both fail.
- State each claim once. If adjacent sections make the same point from different angles, absorb one into the other. Do not summarize a scene immediately after describing it.
- Merge parallel facts that play the same logical role into one sentence. Omit intermediate steps the reader can infer.
- Do not write sentences whose only function is connection, evaluation, meta-framing ("There is a natural continuation…"), author disclaimer, or imaginary reader Q&A. Handle concessions in running prose.
- Do not default to weak predicates out of hesitation. Preserve them only for genuine uncertainty.
- Apply the update-target test (see §10-1) to every short assertion and every paragraph opener; short cadence does not exempt a sentence from the test.

### 10-1. Update-Target Test

Every short assertion and every paragraph-opening sentence must update the *situation*, not only the *document*.

- **Situation update.** The sentence changes the subject world (events, data, quoted speech), the argument's substance (a new claim, mechanism, or piece of evidence), or the writer's judgment state (a concession, a suspended decision, a belief the text will later overturn).
- **Document update.** The sentence only reports how this chapter, section, or explanation looks so far, or what the writer will do next.

Document-only sentences are redundant. The common leak path is compressing a document-updating sentence into a short, rhythmic declarative ("So it comes down to this.") so that it reads like a punchline; short length and good rhythm do not exempt a sentence from the test.

**Apply.** Delete the candidate; read the paragraph without it. If the reader loses a fact about the subject world, a claim or evidence in the argument, or a shift in the writer's stance, keep it. If not, delete it, unless it earns one of the four exceptions below.

**Exceptions.**

1. **Rebutting a stated or implied misreading.** The preceding paragraph states or clearly implies the wrong inference, and this sentence negates it before the section gives the real reason (see §2).
2. **Posing or discharging a section-defining question.** The question is the one the section exists to answer, not a rhetorical prompt for the reader.
3. **Reader-facing framing at chapter boundaries only.** An opening scope note or a closing invitation at the boundary of a chapter, not a subsection.
4. **Opening or closing a hypothetical example.** Phrases like "suppose that..." or "returning to the case at the top" that mark the entry to or exit from a worked scenario.

Vague sentences like "do not misunderstand me" or "this section covers X" do not qualify. Common leak paths: punchline-style short declaratives that only announce a conclusion the paragraph has already delivered; section-opening previews that name the topic instead of advancing the argument; section-closing summaries that restate the paragraph the reader just finished.

## 11. Headings

- A heading should name the question the section answers or the subject it covers, as a concrete phrase.
- Do not write headings that merely name a procedural step or carry no information.
- Do not write headings that deliver the section's conclusion as a slogan.
- Choose between a question form and a noun-phrase form based on the tone of the surrounding text.

## 12. Honesty Toward Readers

- When an example could look contrived, do not hide it. Acknowledge the reader's likely skepticism and briefly ground the example in a plausible real-world occurrence.
- Ground that justification in common experience or conventional wisdom, not in the author's assertion.
- Do not write smoothly about things you have not verified.

## 13. Examples, Code, and Figures

An example exists to make one claim concrete. Its quality is measured against that claim, not by realism or completeness.

- Keep the example minimal: every element it contains should be load-bearing for the claim. An extra config key or a second actor invites the reader to wonder why it is there.
- Make the main example typical. Edge cases go in follow-up examples, labeled as such; leading with the exotic case makes the reader misjudge the normal one.
- State in prose which claim the example supports, before or immediately after it. An unanchored example reads as decoration.
- Code samples must run as shown, or say what was cut: mark elisions explicitly (`...` or a comment), name the language and version assumptions that matter, and show output when the output is the point.

### 13-1. Figures

§4-5 decides whether the content wants a figure; these rules govern the one you commit to.

- **One figure, one claim**, statable in one sentence — that sentence is the caption. A request path plus a deployment topology is two figures. The exception is a figure whose claim *is* the whole: an overview or summary exists to show how the parts sit together, and splitting it destroys what the reader came for.
- **The figure owns the structure; the prose owns why, the conditions, and what the figure cannot draw.** Prose walking the reader node by node is redundancy (§10).
- **Label every edge with its condition or event; name nodes as the prose names them.** A node whose label diverges from the prose forces the reader to re-map on every mention.

Pick the figure kind by content shape. Notate as Mermaid in a fenced ` ```mermaid ` block, inline; do not also commit a rendered image. Fall back to a checked-in SVG for precise spatial layout or annotation over a screenshot. A project convention, or the format the repository's documents already use, wins over this table.

| Content shape                             | Figure kind    | Mermaid type                |
| ----------------------------------------- | -------------- | --------------------------- |
| Time × actor, message ordering            | Sequence       | `sequenceDiagram`           |
| State × event, allowed transitions        | State diagram  | `stateDiagram-v2`           |
| Boundary × dependency, what contains what | Component      | `flowchart` with `subgraph` |
| Branching on conditions                   | Flowchart      | `flowchart TD`              |
| Entities and their relations              | ER             | `erDiagram`                 |
| Duration and overlap                      | Gantt          | `gantt`                     |
| Class or type structure                   | Class          | `classDiagram`              |

## 14. Cognitive Rhythm

Dense prose reads as flat not because the writer added too much information, but because every sentence puts the reader in the same cognitive mode. Readers stay awake when their mode shifts — observing a fact, doubting a claim, accepting a conclusion, revisiting the observation with new eyes. This section governs the rhythm those shifts create. It applies once §3 (weighting, including asymmetric treatment of parallel items) and §10 (redundancy) have done their cutting; rhythm layered onto uncut, evenly-weighted prose is decoration on the wrong shape.

### 14-1. Modes and Their Alternation

- **The four modes.** *Observation* states what is (data, event, protocol behavior). *Hesitation* voices a doubt, a naive expectation, or a suspended judgment ("this looks fine, but..." "one would expect X"). *Assertion* delivers the conclusion the evidence lands. *Re-observation* revisits the earlier fact through the new conclusion, so the reader sees the same object differently. Not every section needs all four; the rule is that **consecutive paragraphs must not sit in the same mode**.
- **Common failure: all-assertion.** Technical prose defaults to stringing assertions ("A is X. B is Y. C is Z."). Three assertions in a row read flat regardless of how good each one is. Break the string with a hesitation the assertions then answer, an observation the assertions then interpret, or a re-observation that closes the section.
- **Deliberate hesitation as setup.** A hesitation is not weakness — it is a setup that lets an assertion land. "One would expect the second option to win; the numbers say otherwise" gives the assertion a shape the reader remembers. Bare assertion ("the numbers favor the first option") does not.

### 14-2. The Beat: 立てる → 流す → 止める

Within a paragraph or across a few paragraphs, prose has a beat:

- **立てる (Plant).** A short sentence sets the scene or names the question. It is short because the reader has to hold it while the next sentences unfold.
- **流す (Flow).** A longer, denser sentence carries the mechanism, the evidence, the qualifications.
- **止める (Stop).** A short sentence lands the conclusion, or leaves a question hanging for the next paragraph to pick up.

A section that is all "flow" (uniform medium-length sentences) or all "stop" (staccato short sentences) reads flat. Plant-flow-stop is one pattern; observe-hesitate-assert-reobserve is another. Both work by refusing to keep the reader in the same posture.

### 14-3. Tension

- **One tension always open.** From the opening through the last few paragraphs, the reader should always be holding at least one question that has been raised but not yet answered. When every open question closes, the reader can put the document down without loss.
- **Cheap way to open a tension:** state a naive expectation, then delay its resolution ("the second option seems obviously better — the axis that decides it is not the one that first comes to mind"). The resolution goes in the next paragraph or the next section, not the same sentence.
- **Track tensions.** During Polishing, list each raised question and where it discharges. A tension raised and never closed is a broken promise; a tension closed inside the same paragraph is not a tension.

### 14-4. Prohibitions

- **Implement devices; do not announce them.** A device works by shaping the reader's experience, not by naming itself. "I will state the answer in two halves" fails as a device — write the first half as content and let the second half arrive later. Phrases like "let me draw the line," "the tension resolves here," "I place the answer first" name a technique the reader was supposed to feel without seeing. Cut such sentences.
- **The topic test governs short punchy sentences too.** §10-1's update-target test flags document-only sentences. The most common bypass is compressing such a sentence into a short, well-cadenced declarative that reads like a climax — "So it comes to this." "That is the whole story." Good rhythm is not a pass; apply the test regardless of length or cadence.
- **No tail-end previews between sections.** A section closing with "next we look at X" (already forbidden by §2) also breaks rhythm: the reader has no reason to keep the previous section's tension open, and no reason to start the next section with fresh attention. Put the bridge at the head of the receiving section, in the form of the question or hesitation that section takes up.
- **Rhythm from content, not from form.** A short paragraph earns its brevity from the situation it updates (a decisive event, a compressed conclusion after long reasoning), not from a decision to insert a short paragraph for rhythm. Rhythm forced by form without content behind it is what makes AI prose sound artificially punchy.

### 14-5. Diagnostic Symptoms

When a section reads flat despite following §1-§14, run these checks in order:

1. **Uniform paragraph size.** Every paragraph within ±30% length of its neighbors? Likely uniform mode.
2. **All-assertion sequence.** Three or more consecutive paragraphs whose first sentence is a bare assertion? Break with hesitation or observation.
3. **N parallel items at equal depth.** Section develops N sub-topics at similar length and structure? Apply §3's asymmetric treatment: promote one, demote the rest.
4. **No open tension at midpoint.** Every question raised in the first third resolved before the midpoint? Add one that carries into the second half.
5. **Every paragraph opens with a topic sentence.** Consistent "topic sentence + support" template? Alternate: start some paragraphs with the naive expectation, the observation, or the qualification, and let the topic emerge in the second or third sentence (still consistent with §2 as long as the paragraph's topic is unambiguous after 2-3 sentences).

---

## Quick Checks

The full checklist covering §1-§14 lives in `~/.claude/references/technical-document-quick-checks.md`. Load it during Polishing 1-1 Rule Check.

## Revision Priority

When time is limited, work top to bottom. Cutting comes before smoothing; smoothing prose that should not exist wastes both passes.

1. **Aggressive cutting (§3, §6, §10):** every paragraph, premise, and orientation sentence deleted unless the reader acts or decides differently because it is there. Try deletion first; restore only if the argument breaks. Comprehension gaps are answered by cutting scaffolding or rewriting the center before adding.
2. **Authorial presence (§1):** falsifiable claims and named actors.
3. **Information weighting and hierarchy (§3, §4):** ink allocated to importance, central paragraphs distinguishable from background, secondary facts demoted down the ladder (clause, footnote, appendix) instead of standing in the main line, list hierarchy matches idea hierarchy, structural content carried by a figure rather than reconstructed by the reader.
4. **Cognitive rhythm (§14):** cognitive modes alternate, at least one tension stays unresolved across each section boundary, devices work from content rather than being announced.
5. **Structural tells (§8):** thesis-statement headings, setup-then-reversal openings, uniform texture.
6. **Redundancy (§10):** repeated claims, unnecessary framing, weak predicates.
7. **Rhetoric and rhythm (§7, §12, §13):** punchline overuse, dramatic fragmentation, negative listing.
