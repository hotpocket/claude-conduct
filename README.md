# claude-conduct

Canonical, machine-agnostic Claude skills and conduct scaffold.

- `skills/vault/` — persistent Obsidian memory skill (MIT; upstream
  adamtylerlynch/obsidian-agent-memory-skills, vendored copy).
- `skills/conduct/` — stamps a fresh repo with the reusable CLAUDE.md preamble,
  vault scaffold, and docs/ layout.

setup-kit's `profiles/workstation/08-claude-skills.sh` clones this repo and
symlinks each enabled skill into `~/.claude/skills/<name>`. Edit skills here,
never in the symlink target. `gstack` is third-party and cloned separately
from its own upstream — it does not live in this repo.
