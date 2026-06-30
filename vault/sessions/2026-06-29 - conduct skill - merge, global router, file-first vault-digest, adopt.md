---
tags: [session]
type: session
concerns: [ops, infra]
audience: []
summary: "Evolved the conduct skill from a fresh-repo stamper into a full memory/orientation system: section-aware CLAUDE.md merge (no clobber), a file-based vault-digest tool (grep/awk over frontmatter — drops the Obsidian GUI/CLI dependency), orientation via ONE global SessionStart router instead of per-repo hooks, and an `adopt` mode for repos you don't own (external vault, nothing committed to their tree). Also gave the repo its GitHub remote + got it stamped. Committed on main, unpushed."
created: 2026-06-29
status: completed
projects: [claude-conduct]
branch: main
---

# Session — 2026-06-29 — conduct skill: merge, global router, file-first vault-digest, adopt

## Context
`claude-conduct` is the canonical source for the `vault` + `conduct` skills
(symlinked into `~/.claude/skills` by setup-kit phase 08). This session matured
the `conduct` skill and the surrounding memory architecture.

## Work Done (final state)
- **Repo went live on GitHub** (`git@github.com:hotpocket/claude-conduct.git`) and
  setup-kit phase 08 now has the real clone URL — vault/conduct skills install on
  fresh boxes (were local-only and silently skipped).
- **`conduct init` is section-aware** on an existing `CLAUDE.md`: scans for the
  canonical sections, reports present vs missing, merges only the missing ones
  (folds into existing rules, never clobbers). Truly idempotent.
- **`templates/vault-digest`** — file-based vault reader (pure grep/awk over note
  frontmatter): Level-0 `summaries`, `type`/`concern` filters, `recap`, `todos`,
  `backlinks`, `search`. No Obsidian app/CLI/GUI. Hardened (empty Session Log →
  "(none yet)", missing todos never greps stdin, dotted `.configs.md` found via
  `find`).
- **Orientation via ONE global SessionStart router**, not per-repo hooks: `init`
  installs `scripts/{vault-digest,session-start.sh}` but stamps NO project
  `.claude/settings.json` hook; the global `~/bin/claude-orient` (shipped by
  `.configs`) execs the repo's `session-start.sh`. `session-start.sh` delegates
  to `vault-digest` (Obsidian-launch coupling removed).
- **`adopt` command** for repos you don't own: creates an external vault at
  `~/Documents/AgentMemory/<repo>` and relies on the global router +
  `~/bin/vault-digest` — touches nothing in their tree.
- CLAUDE.md template made **file-first** (Obsidian CLI demoted to optional
  accelerator). This repo got stamped (CLAUDE.md, scripts/, vault/, gitignore).

Commits (unpushed, main): `c3c347c` (section merge), `c91777c` (SessionStart
hook), `3887ed0` (file-based vault-digest), `48dc33f` (global router + adopt).

## Discoveries
- The Obsidian CLI **requires the app running** and remote-controls the
  **most-recently-focused** vault; targeting a non-open vault is undocumented.
  Wrong for parallel multi-repo agents → file-first is the correct default.
- Frontmatter `summary` is the Level-0 keyframe whether read by the CLI or by
  `awk`; reading just frontmatter is ~36× cheaper than bodies. The CLI-oriented
  schema is *also* the optimal file-based structure — no note changes needed.
- A project `.claude/settings.json` hook breaks when the repo's settings file IS
  the global one (the `.configs` case) → the global router sidesteps it.

## Decisions
- One global guarded router over per-repo hooks (no per-repo hook-trust; serves
  owned and un-owned repos).
- File-first vault access; Obsidian optional.
- Owned repos = repo-local vault + committed stamp; un-owned = external vault via
  `adopt`, nothing in their tree.

## Next Steps

### Loose ends (cleanable now)
- (none)

### Needs dedicated focus
- Add a "durability over precision" rule of conduct to `templates/CLAUDE.md`
  (deferred this session) and import the remaining skills the user wants going
  forward — then propagate via re-stamp.
- A `conduct check`/`init` self-test (stamp a throwaway repo, assert scripts +
  vault + orientation) so skill changes don't silently regress.
