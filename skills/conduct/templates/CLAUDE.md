# <PROJECT>

<!-- One-paragraph description of what this repo is and does. Replace this. -->

## Session conduct

Session-start orientation is injected automatically by the `SessionStart` hook
(`scripts/session-start.sh`, wired in `.claude/settings.json`): it surfaces the
latest recap pointer and the open-todo count. Go deeper on demand — read the
recap body in `vault/sessions/` or open `vault/todos/<PROJECT>.md`.

**Vault access is file-first.** Use `scripts/vault-digest` for cheap reads —
grep/awk over note frontmatter, no Obsidian app/CLI/GUI, safe across parallel
sessions:
- `scripts/vault-digest summaries [subdir]` — one-line gist per note (Level 0).
- `scripts/vault-digest type <t>` / `concern <c>` — filter by frontmatter.
- `scripts/vault-digest recap` / `todos` / `backlinks <note>` / `search <q>`.
Read a full note body (Level 2) only after a summary points you to it. The
`/vault` skill (Obsidian CLI) is an optional accelerator for a single open
vault — never load-bearing.

When you discover something durable (architecture, a gotcha, a decision and its
why), write it back to the vault. **At session end**, offer `/vault recap`.

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
