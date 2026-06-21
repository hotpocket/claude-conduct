### `recap` — Session Recaps

Generate, review, and search session recaps.

**Usage**: `recap [action]`

#### `recap` (no arguments)

Gather context, render a session recap to the screen, then offer to write it to the vault.

##### Step 1: Gather session context

```bash
git log --oneline -20
git diff --stat HEAD~5..HEAD 2>/dev/null || git diff --stat
git branch --show-current
```

##### Step 2: Read current TODOs

CLI-first:
```bash
obsidian vault=$VAULT_NAME tasks path="todos" todo verbose
```
Fallback: Read the per-project TODO file at `$VAULT/todos/$PROJECT.md`.

##### Step 3: Read project overview

Read `$VAULT/projects/$PROJECT/$PROJECT.md` for wikilinks and context.

##### Step 4: Render the recap

Display the full session recap to the user with these sections:
- **Context**: What was being worked on (from git log context)
- **Work Done**: Numbered list of accomplishments (from commits and diffs)
- **Discoveries**: Technical findings worth remembering
- **Decisions**: Design choices made during this session
- **Next Steps**: forward engineering work, **triaged into two buckets** (see format below)

**Content rules:**
- **State-only.** Describe what exists in the final state and what was decided — not the path traveled. If something was added then removed within the session, it doesn't belong in the recap; only the resulting state does. Future readers want "what is", not "what we tried."
- **Next Steps: triage into "loose ends" vs "needs a dedicated session", don't just dump checkboxes.** Split the open work into two labelled groups, and for each item give a one-line plain-English description plus a rough effort estimate — not a bare checkbox title. The point is to let the reader decide *what's cleanable right now* vs *what needs its own focus*:
  - **Loose ends (cleanable now):** small, self-contained items knockable out in the same or next short session — a doc note, an ADR write-up, a single-function fix, a yes/no decision. Estimate in minutes.
  - **Needs dedicated focus:** real engineering tasks — new features, multi-file refactors, anything investigation-heavy or with regression risk. Estimate in hours and say *why* it's not quick (blast radius, edge cases, testing). These also go to the per-project TODO file; the recap just flags them.
  - A compact table (`item | what it is | quick?`) is a good shape at 4+ items. Be honest about effort — don't label something "quick" to make the list look tidy. If the session left nothing loose, say so rather than padding.
- **Next Steps are forward engineering work, not operational reminders or coordination tracking.** Open TODOs, deferred decisions, in-flight work. NOT: `git push`, "run X command", "user has untracked drafts", "remember to check Y" (operational); NOT "wait for team response on X", "watch the discussion", "follow up with Y", "flip status when teammate accepts" (coordination). Operational reminders are the user's next-5-minutes worklist; coordination is expected ongoing collaboration with coworkers. Neither belongs in a record future agents will read months later. If a coworker's eventual response will *trigger* engineering work, write the engineering work itself as the TODO — the wait-and-react is implicit.
- **Don't propagate prior recaps' patterns blindly.** Use them for shape only. Filter each line through "is this durable session knowledge?" before keeping.

##### Step 5: Offer to write

Ask: "Write this to the vault?" If the user confirms:

1. **Write session note** — CLI-first.

   First draft a 2-4 sentence `summary` field — concrete, not marketing copy. This is the Level 0 representation; future sessions decide whether to read the full recap based on this string alone. List the major work + final state if testable. Pick `concerns` from the controlled vocabulary (`security`, `api`, `data`, `infra`, `ops`, etc.) — typically 2-5 for sessions that touch multiple areas.

   ```bash
   obsidian vault=$VAULT_NAME create path="sessions/{YYYY-MM-DD} - {title}" template="Session Note" silent
   obsidian vault=$VAULT_NAME property:set path="sessions/{YYYY-MM-DD} - {title}" name="type" value="session" type="text"
   obsidian vault=$VAULT_NAME property:set path="sessions/{YYYY-MM-DD} - {title}" name="branch" value="{current-branch}" type="text"
   obsidian vault=$VAULT_NAME property:set path="sessions/{YYYY-MM-DD} - {title}" name="projects" value="$PROJECT" type="list"
   obsidian vault=$VAULT_NAME property:set path="sessions/{YYYY-MM-DD} - {title}" name="concerns" value="<comma-separated-list>" type="list"
   obsidian vault=$VAULT_NAME property:set path="sessions/{YYYY-MM-DD} - {title}" name="audience" value="" type="list"
   obsidian vault=$VAULT_NAME property:set path="sessions/{YYYY-MM-DD} - {title}" name="summary" value="<drafted summary>" type="text"
   ```
   Then append body content:
   ```bash
   obsidian vault=$VAULT_NAME append path="sessions/{YYYY-MM-DD} - {title}" content="..."
   ```
   Fallback: Write the file directly at `$VAULT/sessions/{YYYY-MM-DD} - {title}.md`:
   ```yaml
   ---
   tags: [session]
   type: session
   concerns: [<populated>]
   audience: []
   summary: "<drafted 2-4 sentence summary>"
   created: {YYYY-MM-DD}
   status: completed
   projects: [$PROJECT]
   branch: {current-branch}
   ---
   ```

   **Required fields are non-negotiable.** Session notes without a populated `summary` defeat the Level 0 reading strategy — every future read becomes a full-file load. Don't skip the draft step; the summary is part of the recap, not optional metadata.

2. **Update TODOs**: Edit `$VAULT/todos/$PROJECT.md` (or `$VAULT/todos/platform.md` for cross-cutting items):
   - Mark completed items (`- [x]`) based on Work Done
   - **Extract every Next Steps checkbox from the recap into the appropriate TODO file.** Next steps that only live in session recaps get lost between sessions. The TODO file is the authoritative task list — if it's not there, it doesn't get tracked.
   - Remove items that are no longer relevant
   - Keep TODO files clean — open items only, no completed cruft accumulating

3. **Update Session Log**: Add an entry to `$VAULT/sessions/Session Log.md` with the date, project, branch, and a one-line summary.

4. **Report** what was written.

#### `recap search <query>`

Search past session recaps for a keyword or topic.

```bash
obsidian vault=$VAULT_NAME search format=json query="<query>" path="sessions" matches limit=10
```
Fallback: Grep for `<query>` across `$VAULT/sessions/*.md`.

Present matching recaps with date, title, and the matching context lines.

#### `recap history`

Show a chronological list of past session recaps with one-line summaries.

##### Steps:

1. **Read Session Log** at `$VAULT/sessions/Session Log.md` — this contains the date, project, branch, and summary for each session.

2. **Present as a numbered list** with date and summary for each entry.

3. **Offer to expand**: Ask the user which recap(s) they'd like to see in full. Read and display the selected recap note(s).

