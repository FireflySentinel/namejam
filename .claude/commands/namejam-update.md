---
description: Check for namejam updates and upgrade if available
---

Read and follow the instructions in the namejam-update skill.

Find the skill at one of these locations (check in order):
- ~/.claude/skills/namejam/SKILL.md (global install)
- .claude/skills/namejam/SKILL.md (project-local install)

Look for the "namejam-update" skill section, or run:
```bash
~/.claude/skills/namejam/bin/namejam-update-check
```

If `UPGRADE_AVAILABLE <old> <new>` is returned, offer to upgrade by running:
```bash
cd ~/.claude/skills/namejam && git pull
```

If nothing is returned, namejam is up to date.
