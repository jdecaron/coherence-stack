#!/bin/bash

SRC="$HOME/Documents/Logseq/Documents/pages"
DEST="$HOME/dev/coherence-stack/.claude/skills/coherence-stack/notes"

# Copy the index first
cp "$SRC/coherence stack.md" "$DEST/"

# Parse wikilinks from index and copy each referenced file
grep -oE '\[\[[^]]+\]\]' "$DEST/coherence stack.md" | \
  sed 's/\[\[//g; s/\]\]//g' | \
  while read -r name; do
    src_file="$SRC/$name.md"
    if [[ -f "$src_file" ]]; then
      cp "$src_file" "$DEST/"
      echo "Synced: $name.md"
    else
      echo "Missing: $name.md"
    fi
  done
