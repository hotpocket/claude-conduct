---
name: conduct
description: "Stamp a repo with reusable Claude conduct: a CLAUDE.md preamble (rules of conduct, available-skills pointer, docs/ layout), a file-based vault-digest tool + SessionStart hook for deterministic Obsidian-free vault orientation, a vault/ memory scaffold, and the matching .gitignore lines. Works on fresh AND existing repos — on an existing CLAUDE.md it reports which canonical sections are present vs missing and offers to merge only the missing ones (idempotent, never clobbers). Use when starting Claude on a project, when the user says 'set up conduct here', 'stamp this repo', or '/conduct init'."
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
Stamp the current repo (git root). Idempotent — never clobber existing content;
add only what's missing and report what already existed vs what was created.

1. **`CLAUDE.md`** — section-aware, idempotent:
   - **If absent**, copy `templates/CLAUDE.md` to the git root and replace
     `<PROJECT>` with the repo's directory name.
   - **If present**, do NOT overwrite. Scan it for each canonical section the
     template provides — `## Session conduct`, `## Docs layout`,
     `## Skills available here`, `## Rules of conduct` — matching by intent, not
     just exact heading text (a repo may already cover "rules" under another
     name). **Report** which are present vs missing. If any are missing, show the
     user the exact content that would be added and **ask to merge**. On confirm,
     intelligently merge ONLY the missing sections: preserve every existing line
     and the user's own rules, place each new section sensibly, fold rather than
     duplicate where a section partially exists (e.g. add the brevity rule to an
     existing rules list instead of starting a second one), and never add a
     section that's already covered. Re-running converges — once all sections
     exist, there is nothing to add.
2. **Vault tooling + `SessionStart` hook** — make orientation deterministic and
   vault access cheap, all **file-based (no Obsidian app/CLI/GUI)**:
   - Copy `templates/vault-digest` to `scripts/vault-digest` (create `scripts/`
     if needed) and `chmod +x` it. It does pure grep/awk reads of the vault's
     frontmatter — Level-0 summaries, `type`/`concern` filters, the recap
     pointer, todos, backlinks — and is the agent's default low-token access
     path. (See "Vault access" in the CLAUDE.md template.)
   - Copy `templates/session-start.sh` to `scripts/session-start.sh` and
     `chmod +x` it. It delegates to `vault-digest` and prints *pointers only*
     (latest recap + open-todo count); its stdout is injected into context at
     session start, so orientation no longer depends on the model reading prose.
   - Ensure the repo's project `.claude/settings.json` has a `SessionStart` hook
     running `"$CLAUDE_PROJECT_DIR"/scripts/session-start.sh`. If the file is
     absent, create it with just that hook; if present, merge the hook in without
     touching other settings; if it's already there, leave it. Idempotent.
   - Note: project-level hooks trigger Claude Code's one-time hook-trust prompt.
3. **`vault/` scaffold** — if `vault/Home.md` is absent, bootstrap a vault via the
   `/vault init` command (the canonical vault skill owns the structure). Then make
   it cross-project discoverable:
   `ln -s "$(git rev-parse --show-toplevel)/vault" ~/Documents/AgentMemory/<PROJECT>`
   (skip if the symlink already exists; `mkdir -p ~/Documents/AgentMemory` first).
4. **`.gitignore`** — ensure the lines from the "Gitignore" section below are
   present (append any missing; don't duplicate).

### `check`
Report what a fresh `init` would create or merge — change nothing. For an
existing `CLAUDE.md`, list which canonical sections are present vs missing (the
same scan `init` performs), plus whether `scripts/vault-digest`, the
`SessionStart` hook (`scripts/session-start.sh` + `.claude/settings.json`), the
`vault/` scaffold, and the `.gitignore` lines exist.

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
