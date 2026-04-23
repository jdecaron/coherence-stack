# Precepts

This directory holds the stack of precept-notes and the index that orders them.

## The stack

The notes here form a **stack**. The top of the stack is the most authoritative precept. When two notes conflict, the one higher in the stack wins. Older notes aren't deleted — they're preserved as a record of how the thinking got here — but newer notes supersede them on any point of conflict.

## How order is defined

Stack order lives in one file: **`coherence stack.md`**. This is an Obsidian-style outline that lists the precepts in order via wikilinks.

Example:

    - [[coherence stack]]
    	- [[nature-humans-tech]]
    	- [[Ten precepts (Taoism)]]
    	- [[Ten principles for good design]]
    	- [[Toyota Production System]]
    	- [[Ten Precepts (Taiichi Ohno)]]

**First child link = top of the stack** (most authoritative).
**Last child link = bottom of the stack.**
The top-level `[[coherence stack]]` bullet is just the label; it isn't itself a precept.

Each wikilink resolves to a sibling `.md` file in this directory. `[[nature-humans-tech]]` → `nature-humans-tech.md`. Wikilinks can contain spaces, parentheses, and punctuation — just append `.md` to the link text to get the filename.

## Adding a precept

1. Create the note as a `.md` file in this directory (e.g. `my-new-principle.md`).
2. Open `coherence stack.md` and add `- [[my-new-principle]]` at the position in the list that reflects its priority. Top of the list is the most authoritative position.

To reorder, just move the line in `coherence stack.md`. No renaming needed.

## What goes in a precept-note

Anything that would help Claude — or a future collaborator — understand how you think. Some prompts from *The Coherence Premium* that tend to produce useful precepts:

- What problem do I solve, and for whom specifically?
- What's my actual thesis for why my approach works?
- What are the core tradeoffs I've chosen?
- What do I explicitly *not* do?
- How do I sound? (Include a short example that exemplifies the voice, and one that doesn't.)
- What decision did I just make, and why?

Keep each note short enough to fit comfortably in context alongside the others. Compression without loss of generative power is the goal.

## What the skill ignores

- `README.md` — this file. Scaffolding, not a precept.
- `coherence stack.md` — the index itself. Its wikilinks are the stack; its body is not a precept.

## Unlisted files become the tail of the stack

Any other `.md` file in this directory that isn't named in `coherence stack.md` still counts as a precept — it just sits **below the named list, unordered** among other unlisted files. Named precepts always override tail precepts. This means you can drop a new note into the directory without editing the index right away; it joins the stack at the bottom, and you can promote it into the named list later when you know where it belongs.

If two tail files conflict on a point, the skill surfaces the tension rather than picking one — tail files have no priority relationship with each other.

## If a wikilink points to a missing file

The skill will flag it rather than silently skip. Either create the file or remove the link.

## Syncing from Logseq

If your precepts live in Logseq, run:

```bash
./sync-precepts.sh
```

This copies `coherence stack.md` and all files it references from `~/Documents/Logseq/Documents/pages/` into the precepts directory. Edit `SRC` in the script if your Logseq pages live elsewhere.
