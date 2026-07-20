---
name: technical-document-en
description: English-specific writing rules for technical prose. Covers voice and stance, sentence structure, English AI slop phrases, metaphor restraint, and English-specific punctuation. Use alongside technical-document.md (which covers language-independent concerns such as false agency, paragraph structure, information weighting, hierarchy and placement, logical rigor, and structural AI tells).
---

# English-Specific Rules for Technical Prose

These rules address AI writing patterns specific to English syntax, vocabulary, and idiom.
Language-independent concerns (authorial presence, paragraph structure, information weighting, hierarchy and placement, logical rigor, reader load, restraint in rhetoric, structural AI tells, redundancy, headings, honesty toward readers, examples and figures) are covered in `technical-document.md`.

---

## 1. Voice and Stance

- Default to active voice. Passive voice hides the actor when one exists; name who did it.

  | Passive                    | Active               |
  | -------------------------- | -------------------- |
  | "X was created"            | Name who created it  |
  | "It is believed that"      | Name who believes it |
  | "Mistakes were made"       | Name who made them   |
  | "The decision was reached" | Name who decided     |

  Passive voice is acceptable when the actor is unknown, irrelevant, or obvious from context (procedural steps, system behavior descriptions, log entries). In those cases, forcing an active construction distorts the meaning.

- Do not address the reader as "you" when making arguments; use a role name (developer, reader) instead. Reserve "you" for entry-level framing or closing invitations.
- Use terms established in the field. Do not substitute near-synonyms (a push "notification" is delivered, not "shipped").
- Do not repurpose technical-sounding words in non-technical contexts. Prefer plain verbs.

## 2. Sentence Structure

Fix the sentence's skeleton before touching word choice (§3). A broken skeleton stays hard to read even after the vocabulary is polished.

- **Sentence starters.** Do not open with pseudo-cleft Wh- constructions ("What makes this hard is...", "Why this matters is...", "How you fix it is..."). Name the specific thing directly ("The constraint is..." or, better, name the constraint). Ordinary subordinate clauses ("When the server restarts, the cache is lost.") are fine; the target is the cleft pattern that withholds the point.
- Do not open paragraphs with "So." or sentences with "Look,". Start with content.
- **Sentence length.** Mix sentence lengths. Three consecutive sentences of similar length need breaking. Rhetorical questions answered immediately should either breathe or be cut.
- **Rhythm.** Vary paragraph length, tone, and sentence endings. Uniform texture reads as generated.

## 3. AI Slop Elimination (English-Specific)

Cut the empty patterns LLMs mass-produce in English. Check every draft against this section.

### 3-1. Phrases to Avoid

These phrases add no argument. They perform "I am writing carefully" without carrying a claim. Do not use them.

- **Throat-clearing openers**: "Here's the thing:", "Here's what/why/this/that [X]", "The uncomfortable truth is", "It turns out", "The real [X] is", "Let me be clear", "The truth is,", "I'll say it again:", "I'm going to be honest", "Can we talk about", "Here's what I find interesting", "Here's the problem though". Any "here's what/this/that" construction is runway before the point; state the point.
- **Emphasis crutches**: "Full stop.", "Period.", "Let that sink in.", "This matters because", "Make no mistake", "Here's why that matters". If the prior sentence carries the weight, the crutch is redundant; if it does not, the crutch cannot save it.
- **Meta-commentary**: "Hint:", "Plot twist:", "Spoiler:", "You already know this, but", "But that's another post", "X is a feature, not a bug", "Dressed up as", "The rest of this essay explains...", "Let me walk you through...", "In this section, we'll...", "As we'll see...", "I want to explore...". The text should move, not announce its own structure.
- **Performative emphasis and telling**: "creeps in", "I promise", "They exist, I promise" (false intimacy); "This is genuinely hard", "This is what leadership actually looks like", "actually matters" (announcing significance rather than demonstrating it).
- **Vague declaratives**: "The reasons are structural", "The implications are significant", "This is the deepest problem", "The stakes are high", "The consequences are real". If a sentence says something is important, deep, or structural without naming what, cut it or replace it with the specific thing.
- **Business jargon**: replace with plain language.

  | Avoid                 | Use instead              |
  | --------------------- | ------------------------ |
  | Navigate (challenges) | Handle, address          |
  | Unpack (analysis)     | Explain, examine         |
  | Lean into             | Accept, embrace          |
  | Landscape (context)   | Situation, field         |
  | Game-changer          | Significant, important   |
  | Double down           | Commit, increase         |
  | Deep dive             | Analysis, examination    |
  | Take a step back      | Reconsider               |
  | Moving forward        | Next, from now           |
  | Circle back           | Return to, revisit       |
  | On the same page      | Aligned, agreed          |
  | Delve into            | Examine, explore         |
  | Leverage / Utilize / Harness | Use               |
  | Seamless              | Name the actual behavior |
  | Robust (as praise)    | Name the property        |
  | Journey (process)     | Process, path            |
  | Foster                | Encourage, support       |
  | Unlock (potential)    | Enable                   |
  | Streamline            | Simplify                 |
  | Empower               | Enable, let              |

### 3-2. Filler Adverbs and Intensifiers

Do not scatter these across a document. Adverbs that specify precision, sequence, or scope are not filler; keep them (approximately, previously, respectively, currently, partially, optionally, recursively, conditionally).

- **Filler adverbs**: really, just, literally, genuinely, honestly, simply, actually.
- **Empty intensifiers**: deeply, truly, fundamentally, inherently, inevitably.
- **Announcement adverbs**: interestingly, importantly, crucially.
- **Filler phrases performing the same function**: "At its core", "In today's [X]", "It's worth noting", "At the end of the day", "When it comes to", "In a world where", "The reality is".

### 3-3. Metaphor Restraint

Do not borrow decorative metaphors for concepts that plain verbs already cover. "Journey" for a process, "landscape" for a field, "unlock" for enable, "harness" for use are the same failure mode as `technical-document-ja.md` §3-3: dressing up a common action in imported vocabulary. When the field has established a term as a term (architecture, layer, cache, pipeline), it is not a metaphor and stays. When in doubt, ask whether readers in the target field use a standard plain term; if yes, use it.

### 3-4. English-Specific Structural AI Tells

Structural AI tells common to all languages (thesis-statement headings, "not A but B" reversal, three-item lists, dramatic fragmentation, uniform texture) are covered in `technical-document.md` §7-§8. This section adds only tells whose surface form is English-specific.

- Do not use em dashes in prose. Use a comma, colon, semicolon, or period instead. En dashes for ranges and code samples are out of scope.
- Do not open paragraphs with a filler discourse marker ("So.", "Look,", "Now,") when the paragraph could start with content.

### 3-5. Intensity Expressions

Hedging rules (proportional to verification, no false certainty on settled claims, lowered evaluative intensity) are covered in `technical-document.md` §5 and §9. This section adds only the English lexical items that carry those rules.

- "Reportedly", "appears to", "seems to" mark unverified or secondhand claims; verified claims are stated plainly (§9).
- Reserve "might", "may", "could" for genuine uncertainty, counterfactuals, or reported states of mind. Do not use them to weaken claims the text's own evidence has already settled (§5).
- When lowering intensity one notch (§9), reach for mid-temperature assessments ("adequate", "uneven", "mixed") instead of maximum-temperature ones ("incredible", "essential", "game-changing"). Technically verifiable facts are stated as facts, not softened.

## 4. Formatting and Punctuation

- One idea per paragraph; separate paragraphs with a blank line.
- Code, diffs, logs, and configuration fragments go in code blocks.
- Asides that leave the main line go in footnotes.
- Bold a term at its definition; use quotation marks for subsequent references.
- Do not stack two ideas into a heading with a separator; keep headings a single natural phrase.
- Do not end a heading with a period; headings are names, not sentences.
- Strip stray `**` markers and decorative emoji (🚀🎯✨💡).

---

## Quick Checks

English-specific quick checks live in `technical-document-quick-checks-en.md` (same directory). Combined with the language-independent checks (`technical-document-quick-checks.md`), they are used during Polishing 1-1 Rule Check.
