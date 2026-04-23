---
name: precepts-stack
description: Query and validate texts against the user's stack of precept-notes — an ordered collection of principles, constraints, voice guidelines, and decisions that encodes how the user thinks. Use whenever the user mentions "my precepts," "my principles," "my notes," "my stack," "my coherence stack," or "my context layer"; asks whether a text (theirs or anyone's) fits their worldview, voice, or priorities; wants to check a draft for consistency with prior decisions; says things like "does this sound like me," "is this consistent," "what do I think about X," or "run this through my stack"; or is about to ship an output (essay, post, email, strategy, plan) and wants a coherence check. The notes are a STACK — the top (most recent) precepts take priority, and newer thinking supersedes older thinking on conflict. Trigger even when the user doesn't name the skill, as long as the request is about aligning text with their own prior writing or principles.
---

# Precepts Stack

This skill is a coherence layer. It reads the user's stack of precept-notes and uses them to (a) answer questions about what the user thinks, or (b) validate new texts against the user's established principles, constraints, and voice.

## Why this exists

This skill is inspired by JA Westenberg's essay *The Coherence Premium*. The argument there is that as one person equipped with AI can now do the work of a department, the new moat is *coherence* — every output deriving from the same understanding, the same model of reality, the same priorities and tradeoffs. The user's precept-notes are that model in written form: a compressible context layer that Claude can consume so outputs stay aligned across time.

Without a coherence check, AI amplifies drift. With one, AI amplifies voice. Your job, when this skill triggers, is to be that coherence check.

## The stack metaphor — the single most important concept

The notes are ordered as a **stack**. The top of the stack is the most recent and most authoritative precept. When two precepts conflict, the one higher in the stack wins. This reflects how real understanding evolves: old notes aren't deleted — they're preserved as a record of how the user's thinking got here — but newer notes *supersede* them on any point of conflict.

Concretely:

- The **top** precept is the current word on whatever topic it covers.
- Precepts lower in the stack are still valid *unless* contradicted by something higher.
- When reasoning about a question, start from the top and work down. Weight top entries more heavily.
- When validating a draft, a conflict with a **top-of-stack** precept is a serious issue. A conflict with a **middle** precept is moderate. A conflict with a precept that has been superseded by a later one is *not a conflict at all* — it's the user's past self, correctly outvoted by their current self.

Never flatten the stack into an unordered bag. Never treat "the stack says X and also Y" as equal when X is on top and Y is buried. The ordering **is** the signal.

## Where the precepts live

Default: the `precepts/` subdirectory next to this SKILL.md. That directory is where the user drops their notes.

If the user points you to a different location at query time ("check this against the notes in `~/Writing/stack/`"), use that instead for this invocation.

## How to determine stack order

The stack's order is defined by an **index file** at `precepts/coherence stack.md`. This file is written in Obsidian-style outline format — a nested list of wikilinks pointing to the individual precept files.

Example:

    - [[coherence stack]]
    	- [[nature-humans-tech]]
    	- [[Ten precepts (Taoism)]]
    	- [[Ten principles for good design]]
    	- [[Toyota Production System]]
    	- [[Ten Precepts (Taiichi Ohno)]]

**The order of wikilinks in the list is the stack order, top to bottom.** The first child link is the **top of the stack** — most authoritative, wins on conflict. The last child link is the bottom. The top-level `[[coherence stack]]` bullet is just the label for the stack — it is not itself a precept.

Process:

1. Read `precepts/coherence stack.md`.
2. Parse the child wikilinks in the order they appear.
3. For each wikilink `[[name]]`, load the file `precepts/name.md`.
4. Treat those files as the stack — first-in-list is top, last-in-list is bottom.

A wikilink may contain spaces, parentheses, or punctuation (e.g. `[[Ten precepts (Taoism)]]`). Map the wikilink text to a filename by appending `.md` — so `[[Ten precepts (Taoism)]]` → `Ten precepts (Taoism).md`.

If a wikilinked file is missing from `precepts/`, surface it — don't silently skip. The user may have forgotten to create the file, or there may be a typo in the wikilink.

Files that exist in `precepts/` but aren't named in the index **go below the named list**, as an unordered tail. They are still part of the stack — just at the lowest priority tier. Any named precept (anywhere in the index) overrides anything in the tail. Among themselves the tail files have no defined order, so if two tail files conflict on a point, surface the tension rather than silently picking one. This gives the user a way to drop a note into the directory quickly without having to open the index immediately — it participates in the stack right away, at the bottom, and can be promoted into the named list later.

Files to always exclude from the stack entirely:

- `README.md` — scaffolding for the user, not a precept.
- `coherence stack.md` — the index itself. Its wikilinks are the signal; its body is not a precept.

If the index file doesn't exist or the outline has no child links, tell the user plainly and point them to `precepts/README.md` for the convention.

## The two modes

The skill operates in one of two modes depending on what the user asked. Usually you don't need to announce the mode — just do the work.

### Mode A: Query

The user wants to know what the stack says about something. Typical asks:

- "What do my precepts say about scope?"
- "How do I usually handle X?"
- "Pull anything about voice from my stack."
- "Do I have a rule about Y?"

Steps:

1. Read every file in the precepts directory, in stack order.
2. Find the precepts that touch on the query topic.
3. Answer using the **top-most relevant precept first**. Note when older precepts said something different and have been superseded — that context is often useful ("you used to think X, but after `2026-03-08-llm-relevance.md` you moved to Y").
4. If precepts disagree and the stack order doesn't cleanly resolve it (e.g. two recent notes say different things), surface the tension openly rather than picking one.
5. If no precept covers the topic, say so. Don't invent a position. Ungrounded answers are the exact failure mode this skill exists to prevent.

Cite by filename (e.g. "per `2026-04-22_voice.md`, top of stack"). Citations give the user a trail back to their own source.

### Mode B: Validate

The user hands you a text and wants a coherence check against the stack. Typical asks:

- "Does this sound like me?"
- "Run this through my stack."
- "Is this consistent with what I've written?"
- "Would past-me approve of this?"
- "Coherence check this draft before I post it."

Steps:

1. Read every file in the precepts directory, in stack order. Build a mental model of what the user stands for — not just a list of rules, but the shape of their thinking.
2. Read the draft the user wants validated.
3. Walk through the draft. For each claim, choice, framing, or stylistic move: does it fit the model? Where does it fit? Where does it drift?
4. Produce a coherence report in the format below.

## Validation output format

Use this structure. It makes the signal legible at a glance. Omit any section that is empty — don't manufacture problems to fill it.

```
## Coherence report

**Verdict:** Aligned | Aligned with minor drift | Misaligned | Outside scope

### Conflicts with top-of-stack precepts
(Serious — address before shipping.)
- [precept filename, in a phrase: what it says] vs. [what the draft says, in a phrase]

### Conflicts with middle precepts
(Moderate — either the draft is off, or the precept needs updating.)
- [precept filename, gist] vs. [draft, gist]

### Voice / tone drift
(Stylistic deviations from the voice the stack establishes.)
- [example from draft] vs. [voice guideline from stack]

### Supported by the stack
(Things the draft gets right, traceable to precepts.)
- [claim in draft] ← [precept filename]

### Outside the stack
(Claims or moves the draft makes that no precept covers — not wrong, just ungrounded here. May be worth adding a precept for.)
- [claim, briefly]
```

If the Verdict is "Aligned," a one-line report is enough. Don't pad.

If the Verdict is "Outside scope" (the draft is about something the stack doesn't speak to), say so directly and offer to help the user extract a precept from the draft if they want — new stacks grow this way.

## Anti-patterns

These are the failure modes to watch for. They are how this skill goes wrong.

- **Flattening the stack.** Treating all precepts as equal. The ordering carries meaning; using it is the whole point.
- **Forcing a fit.** If the draft is about a topic no precept addresses, say so cleanly. Don't strain an old precept to apply.
- **Reproducing precepts verbatim at length.** These are the user's own words — they already know what they wrote. Paraphrase, cite filenames, keep any direct quotes short (under 15 words) and rare.
- **Refusing to disagree.** If the draft contradicts a top-of-stack precept, say so plainly. Soft-pedaling here defeats the skill's purpose.
- **Ignoring recency in a conflict.** If a recent precept and an older one seem to disagree, recency wins. Note the older one, don't quietly drop it.
- **Context starvation.** Don't validate without reading the stack. Don't query the stack on vibes from the filename — open the files that matter.
- **Over-citing.** If the stack has forty notes and only three are relevant, cite three. Don't bury the signal by name-dropping the whole directory.

## If the stack is empty or missing

If the precepts directory is empty or doesn't exist, tell the user plainly. Point them to `precepts/README.md` for the conventions. Offer to help them extract a first precept from something they've already written. Don't fake a coherence check against nothing — that's the exact kind of AI-theater the coherence premium is meant to replace.

## If the stack contradicts itself internally

Two recent precepts, both near the top, saying different things? This happens when thinking is still live. Surface it: "Your stack has tension here — `A.md` says X, `B.md` says Y, and they're both recent." That surfacing is useful in itself; the user may want to reconcile them by adding a new top-of-stack note.

---

A final note. The point of this skill is not to make the user's writing into a closed system that only echoes itself. It is to make drift *visible* so the user can decide, each time, whether a deviation is growth or slippage. You are a mirror with a good memory, not a gatekeeper.
