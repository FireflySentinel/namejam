---
description: Check for namejam updates and upgrade if available
---

# /namejam-update — Check for Updates

Check if a new version of namejam is available and offer to upgrade.

## Step 1: Run update check

```bash
_NJ_DIR=""
[ -f "$HOME/.claude/skills/namejam/bin/namejam-update-check" ] && _NJ_DIR="$HOME/.claude/skills/namejam"
[ -z "$_NJ_DIR" ] && [ -f ".claude/skills/namejam/bin/namejam-update-check" ] && _NJ_DIR=".claude/skills/namejam"
if [ -n "$_NJ_DIR" ]; then
  _UPD=$("$_NJ_DIR/bin/namejam-update-check" --force 2>/dev/null || true)
  [ -n "$_UPD" ] && echo "$_UPD" || echo "UP_TO_DATE"
else
  _NJ_SKILL_DIR="$(cd "$(dirname "$(find . -maxdepth 1 -name SKILL.md -print -quit 2>/dev/null)")" 2>/dev/null && pwd)"
  if [ -x "$_NJ_SKILL_DIR/bin/namejam-update-check" ]; then
    _UPD=$("$_NJ_SKILL_DIR/bin/namejam-update-check" --force 2>/dev/null || true)
    [ -n "$_UPD" ] && echo "$_UPD" || echo "UP_TO_DATE"
  else
    echo "UPDATE_CHECK_NOT_FOUND"
  fi
fi
```

## Step 2: Handle result

**If `UP_TO_DATE`:** Tell the user "namejam is up to date." and show the current version from the VERSION file.

**If `UPDATE_CHECK_NOT_FOUND`:** Tell the user "Update checker not found. If you installed via direct clone, pull manually: `git pull`"

**If `UPGRADE_AVAILABLE <old> <new>`:**

Use `AskUserQuestion` to ask the user:
- Question: "namejam **v{new}** is available (you're on v{old}). Upgrade now?"
- Options:
  - "Yes, upgrade now"
  - "Not now"

**If "Yes, upgrade now":** Detect install type and upgrade:

```bash
INSTALL_DIR=""
if [ -d "$HOME/.claude/skills/namejam/.git" ]; then
  INSTALL_DIR="$HOME/.claude/skills/namejam"
  INSTALL_TYPE="git"
elif [ -d ".claude/skills/namejam/.git" ]; then
  INSTALL_DIR=".claude/skills/namejam"
  INSTALL_TYPE="git"
elif [ -d "$HOME/.claude/skills/namejam" ]; then
  INSTALL_DIR="$HOME/.claude/skills/namejam"
  INSTALL_TYPE="vendored"
elif [ -d ".claude/skills/namejam" ]; then
  INSTALL_DIR=".claude/skills/namejam"
  INSTALL_TYPE="vendored"
fi
echo "INSTALL_TYPE=$INSTALL_TYPE INSTALL_DIR=$INSTALL_DIR"
```

For **git installs**:
```bash
cd "$INSTALL_DIR" && git fetch origin && git reset --hard origin/main
```

For **vendored installs**:
```bash
TMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/FireflySentinel/namejam.git "$TMP_DIR/namejam"
mv "$INSTALL_DIR" "$INSTALL_DIR.bak"
mv "$TMP_DIR/namejam" "$INSTALL_DIR"
rm -rf "$INSTALL_DIR.bak" "$TMP_DIR"
```

After upgrading, clear cache:
```bash
rm -f ~/.namejam/last-update-check
rm -f ~/.namejam/update-snoozed
```

Tell the user: "Upgraded to v{new}!"

**If "Not now":** Tell the user "No problem. Run `/namejam-update` anytime to check again."
