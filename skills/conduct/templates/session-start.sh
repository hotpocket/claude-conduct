#!/usr/bin/env bash
# SessionStart hook, wired via .claude/settings.json. Stdout is injected into
# the agent's context at session start, making vault orientation deterministic
# instead of prose-dependent. Cheap by design — pointers only, never full bodies
# (the agent reads the recap/todo files on demand).
set -u
repo="$(cd "$(dirname "$0")/.." && pwd)"

# Obsidian's CLI silently times out unless the desktop app is running.
if pgrep -x obsidian >/dev/null 2>&1; then
  echo "Obsidian: running"
elif command -v obsidian >/dev/null 2>&1; then
  (nohup obsidian >/dev/null 2>&1 &)
  echo "Obsidian: launched just now — wait a few seconds before the first CLI call"
else
  echo "Obsidian: not installed — CLI vault queries unavailable on this machine"
fi

# Latest recap pointer — row order in the Session Log is authoritative
# (filename mtime drifts on touched files).
log="$repo/vault/sessions/Session Log.md"
if [[ -f "$log" ]]; then
  recap="$(grep -oE '\[\[20[0-9]{2}-[^]]+\]\]' "$log" | tail -1)"
  echo "Latest session recap: ${recap:-none yet}"
else
  echo "No vault Session Log at vault/sessions/Session Log.md — run /vault init"
fi

# Open-todo count for this project (count only; read the file for detail).
todos="$repo/vault/todos/$(basename "$repo").md"
if [[ -f "$todos" ]]; then
  open="$(grep -cE '^- \[ \]' "$todos" 2>/dev/null || true)"
  echo "Open todos (${todos##*/}): ${open:-0}"
fi
