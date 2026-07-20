---
name: technical-document
description: Language-independent rules for technical prose. Covers authorial presence, false agency, paragraph structure, information weighting, hierarchy and placement (overview-first ordering, heading levels, the demotion ladder, list structure), logical rigor, reader load, restraint in rhetoric, structural AI tells, redundancy elimination, headings, honesty toward readers, and standards for examples, code samples, and figures. Pair with a language-specific ruleset (technical-document-ja.md, technical-document-en.md) for vocabulary, punctuation, and idiom-level checks.
---

# Language-Independent Rules for Technical Prose

These rules apply regardless of the language the text is written in.
Pair them with the appropriate language-specific ruleset for vocabulary, punctuation, and idiom-level concerns.

**Load on demand.** The language-specific rulesets and the quick-checks references are not auto-loaded. When writing, revising, or polishing a technical document, Read the file matching the document's language before applying its rules. These rules apply to technical prose only; do not apply the language-specific rules to general conversational output.

- Japanese: `~/.claude/references/technical-document-ja.md`
- English: `~/.claude/references/technical-document-en.md`
- Quick-checks (language-independent and language-specific): `~/.claude/references/technical-document-quick-checks*.md`

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

Readers infer importance from paragraph length and detail density. When every paragraph is uniform in length and density, readers cannot tell which one carries the section, and the document reads as flat regardless of how much the writer cares about the central claim. The remaining rules in this section are additive: they govern what to keep and how much weight to give it, not what to cut.

Cutting happens before weighting: drop candidates the reader will not act on or decide with (§4-3's deletion rung, applied before drafting instead of after). Having material is not a reason to include it. Research notes, background the writer happens to know, and edge cases noticed along the way are inputs to select from, not entitlements to ink.

Fix each unit's role before drafting it: center (the claim the section exists to make), support (evidence or mechanism the center cannot stand without), or background (orientation that argues nothing). The role dictates the ink. Deciding roles after drafting means recovering them from a flat draft in which every paragraph already looks equally important.

- Allocate ink in proportion to a claim's importance. The central claim deserves more words than the premises that support it. If a background paragraph matches the main argument in length, the reader has no signal for which one to weight.
- Concentrate concrete detail (numbers, proper names, mechanism explanations, worked examples) at the argument's climax. Keep introductions and background at the summary level.
- Vary paragraph length, detail density, and level of specificity across a section. A uniform rhythm hides the writer's judgment.
- Make the central paragraph distinguishable from those around it. Compress it, place it right after the heading, or mark it with emphasis. The means do not matter, but the contrast should be visible to a reader scanning the section.
- Distinguish the main argument from its support structurally, not just lexically. Position, length, and density carry more signal than phrases like "the key point is" (which §7 forbids anyway).
- When a support or background paragraph outweighs its section's center in length or detail, cut the support down first. Inflating the center to win back the ratio lengthens every paragraph and flattens the section again.
- Background and premises remain in the document. Match their length and detail to their secondary role, not to zero. Removing them when they are load-bearing produces a different failure mode (unsupported assertion) and does not improve weighting.

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
- A table earns its place when the reader will compare items along two axes (each row a case, each column a property). Keep cells to short facts; put interpretation in the surrounding prose.
- A figure earns its place when the relationships have more crossings than prose can hold (an architecture, a lifecycle, a dependency graph). For a linear flow, a numbered list is cheaper to read and to maintain. Quality rules for figures are in §15.

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

Treat the reader's memory and attention as finite resources.

- Do not introduce proper names (file names, function names, identifiers) that the reader will not need to reference later. Use a general description instead.
- When an abstract phrase could refer to more than one thing, disambiguate it immediately with a parenthetical.
- Before adding a new example, state how it differs from the previous one and why another is needed.
- Do not front-load the opening of a chapter or section with excessive detail unrelated to what follows.
- In example sections, omit details that do not bear on the section's question or conclusion. Keep details that the argument needs.

## 7. Restraint in Rhetoric

Use rhetorical devices in moderation, only where they earn their keep.

- Reserve buildup and rhetorical questions for moments where tension serves the argument.
- Do not overuse short punchline sentences as standalone paragraphs. Short fragments within a paragraph should appear only at a genuine climax.
- Limit bold emphasis to logical pivot points, one or two per section at most.
- Do not overdramatize turning points. A single factual sentence is often enough.
- Do not pile up consequences to alarm the reader.
- Do not preview a claim with "what matters is..." or "the key point is...". State the claim directly.
- Do not overuse the "not A but B" punchline pattern.
- Avoid twisted idioms and metaphors whose referent is ambiguous. Use plain verbs.
- Do not use dramatic fragmentation ("Simple. That's it. That's the whole thing.").

## 8. Structural AI Tells

- **Avoid thesis-statement headings.** Headings should name a topic (noun phrase), not assert a conclusion ("X is Y").
- **State B directly.** "Not A but B" and "more than just A, it's B" should become "B." Drop the negation.
- **Vary texture.** Deliberately vary paragraph length, tone, density, and sentence endings. Uniform texture reads as generated.
- **Question three-item lists.** "Three key points" or "three pillars" should be trimmed to two or one when possible.
- Check whether the introduction follows a setup-then-reversal template.
- Check whether the experience → quotation → abstraction template repeats for three or more consecutive sections.

## 9. Intensity and Stance

- Lower the intensity by one notch. Mix in middle-temperature assessments ("adequate," "uneven," "mixed results") instead of running everything at maximum ("incredible," "essential," "game-changing"). This rule applies to evaluative and interpretive statements. Do not hedge technically verifiable facts (API behavior, algorithm properties, specification guarantees); state them as facts.
- Hedge facts obtained through research in proportion to their verification: secondhand or unverified claims carry "reportedly," "seems to," or "appears to," while claims you verified are stated plainly. Avoid the encyclopedic style that asserts every researched claim as settled.
- "X has its merits, and Y does too" is an abdication of judgment. Commit to the choice you made and explain why.
- Do not dodge conclusions with "it depends" or "case by case."

## 10. Redundancy

- State each claim once. Do not rephrase it and state it again.
- If adjacent sections make the same point from different angles, absorb one into the other.
- Do not summarize a scene immediately after describing it. One sentence of interpretation is enough.
- Merge parallel facts that play the same logical role into one sentence.
- Omit intermediate steps the reader can infer on their own.
- If a multi-sentence argument compresses to one sentence without losing meaning, keep only the compressed version.
- Do not write sentences whose only function is connection or evaluation.
- Apply the update-target test to every short assertion and every paragraph-opening sentence (see §10-1).
- Do not name the devices this rulebook uses in the running text. If the prose contains phrases like "unresolved tension," "return the answer in halves," "let me draw the line once more," or "I will place the answer first," the writer has announced the device instead of executing it. Delete the announcement and let the next paragraph carry the device by its content alone. The reader should not be able to name the technique that produced their reading experience.
- Do not use imaginary reader Q&A as a rhetorical device. State claims directly. Handle concessions in running prose.
- Do not introduce an idea through meta-framing ("There is a natural continuation of this line of thought"). Write the idea itself.
- Do not write disclaimers about the author's position. State facts.
- Do not default to weak predicates out of hesitation. Assert firmly what the evidence supports. Preserve weak predicates only where genuine uncertainty exists.
- Connectives that create rhythm are not redundancy.

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

## 12. Negative Listing

Listing what something is _not_ before revealing what it _is_ is a rhetorical runway the reader does not need.

"Not a framework... Not a methodology... A mindset."

State the positive claim directly. The reader does not need the buildup.

## 13. Rhetorical Setups

These announce insight rather than deliver it.

| Pattern               | Problem                |
| --------------------- | ---------------------- |
| "What if [reframe]?"  | Socratic posturing     |
| "Here's what I mean:" | Redundant preview      |
| "Think about it:"     | Condescending prompt   |
| "And that's okay."    | Unnecessary permission |

Make the point. Let readers draw their own conclusions.

## 14. Honesty Toward Readers

- When an example could look contrived, do not hide it. Acknowledge the reader's likely skepticism and briefly ground the example in a plausible real-world occurrence.
- Ground that justification in common experience or conventional wisdom, not in the author's assertion.
- Do not write smoothly about things you have not verified.

## 15. Examples, Code, and Figures

An example exists to make one claim concrete. Its quality is measured against that claim, not by realism or completeness.

- Keep the example minimal: every element it contains should be load-bearing for the claim. An extra config key or a second actor invites the reader to wonder why it is there.
- Make the main example typical. Edge cases go in follow-up examples, labeled as such; leading with the exotic case makes the reader misjudge the normal one.
- State in prose which claim the example supports, before or immediately after it. An unanchored example reads as decoration.
- Code samples must run as shown, or say what was cut: mark elisions explicitly (`...` or a comment), name the language and version assumptions that matter, and show output when the output is the point.
- A figure supports the text; the text must survive without it. Reference every figure from prose, and caption it with the one thing it shows, not a restatement of its title.

---

## Quick Checks

The full checklist covering §1-§15 lives in `~/.claude/references/technical-document-quick-checks.md`. Load it during Polishing 1-1 Rule Check.

## Revision Priority

When time is limited, work top to bottom. Fixing surface wording (sections 8–10) without fixing authorial presence (section 1), paragraph structure (section 2), information weighting (section 3), and hierarchy and placement (section 4) leaves AI slop intact.

1. **Authorial presence:** falsifiable claims and named actors
2. **Information weighting and hierarchy:** ink allocated to importance, central paragraphs distinguishable from background, secondary facts demoted down the ladder (clause, footnote, appendix) instead of standing in the main line, list hierarchy matches idea hierarchy
3. **Structural tells:** thesis-statement headings, setup-then-reversal openings, uniform texture
4. **Redundancy:** repeated claims, unnecessary framing, weak predicates
5. **Rhetoric and rhythm:** punchline overuse, dramatic fragmentation, negative listing
