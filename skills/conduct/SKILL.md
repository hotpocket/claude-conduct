---
name: conduct
description: "Stamp a fresh repo with reusable Claude conduct: a CLAUDE.md preamble (session orientation from the Obsidian vault, rules of conduct, available-skills pointer, docs/ layout), a vault/ memory scaffold, and the matching .gitignore lines. Use when starting Claude on a new project, when the user says 'set up conduct here', 'stamp this repo', or '/conduct init'."
metadata:
  author: setup-kit
  version: "1.0"
license: MIT
---

# Claude Conduct

Stamp a repo with the reusable scaffold that tells Claude how to behave on this
project: orient from memory at session start, write discoveries back, follow a
predictable docs layout, and obey the rules of conduct. The *project-specific*
content (pipelines, prompts) is NOT part of this kit — only the reusable shell.

## Commands

### `init` (default)
Stamp the current repo (git root). Idempotent — never clobber an existing file;
report what already exists and what was created.

1. **`CLAUDE.md`** — if absent, copy `templates/CLAUDE.md` to the git root and
   replace `<PROJECT>` with the repo's directory name. If present, leave it and
   tell the user (offer to show the template diff).
2. **`vault/` scaffold** — if `vault/Home.md` is absent, bootstrap a vault via the
   `/vault init` command (the canonical vault skill owns the structure). Then make
   it cross-project discoverable:
   `ln -s "$(git rev-parse --show-toplevel)/vault" ~/Documents/AgentMemory/<PROJECT>`
   (skip if the symlink already exists; `mkdir -p ~/Documents/AgentMemory` first).
3. **`.gitignore`** — ensure the lines from the "Gitignore" section below are
   present (append any missing; don't duplicate).

### `check`
Report what a fresh `init` would create — change nothing.

## The docs/ layout (baked into the template)

- `docs/` — generated documents (working notes, plans, analyses).
- `docs/reports/` — persistent, prepared deliverables meant to be kept and shared.
- `docs/logs/` — transient/ephemeral output of repeatable processes. **Gitignored.**

## Gitignore

Commit vault notes and shared Obsidian config; ignore UI state and transient docs:

```
# Claude conduct
docs/logs/
vault/.obsidian/workspace*.json
vault/.obsidian/plugins/
vault/.obsidian/themes/
vault/.obsidian/hotkeys.json
vault/.obsidian/appearance.json
vault/.obsidian/graph.json
```

## Notes

- This skill is the canonical source; it is symlinked into `~/.claude/skills/conduct`
  by setup-kit's `08-claude-skills.sh`. Edit it here, not in the symlink target.
- The CLAUDE.md template references the `vault` and `gstack` skills by name; those
  are installed alongside this one. If a referenced skill isn't installed on a given
  machine, the pointer is harmless — Claude just won't have that capability.
