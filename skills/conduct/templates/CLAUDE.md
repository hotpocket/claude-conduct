# <PROJECT>

<!-- One-paragraph description of what this repo is and does. Replace this. -->

## Session conduct

**At session start**, orient from the project's Obsidian memory before acting:
1. Read `vault/sessions/Session Log.md` → most recent recap.
2. Read `vault/todos/<PROJECT>.md` → open work.
Then proceed with the user's request. Use the `/vault` skill for all memory
operations (lookup, note, recap, todo). When you discover something durable
(architecture, a gotcha, a decision and its why), write it back to the vault.

**At session end**, offer `/vault recap` to capture what changed.

## Docs layout

- `docs/` — generated documents: working notes, plans, analyses.
- `docs/reports/` — persistent, prepared deliverables meant to be kept/shared.
- `docs/logs/` — transient/ephemeral output of repeatable processes (gitignored).

## Skills available here

- `vault` — persistent Obsidian memory (orient, look up, write back).
- `gstack` — drive a real browser to research the web and produce results.
- `code-review` — review the current diff for bugs and cleanups.
<!-- Add/remove per what this repo actually uses. -->

## Rules of conduct

- Be brief: no preamble, no recap of what the user knows, no surveying paths not taken.
- Idempotent, reversible-by-default; confirm before hard-to-undo or outward-facing actions.
- Report outcomes faithfully — if a step failed or was skipped, say so.
<!-- Add project-specific rules below. -->
