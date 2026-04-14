#!/usr/bin/env bash
set -euo pipefail

# Bump version across all sources in one shot.
# Usage: ./scripts/bump-version.sh 0.5.0

NEW_VERSION="${1:-}"

if [ -z "$NEW_VERSION" ]; then
  echo "Usage: $0 <new-version>"
  echo "Current version: $(cat VERSION)"
  exit 1
fi

if ! echo "$NEW_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "Error: version must be semver (e.g. 0.5.0)"
  exit 1
fi

OLD_VERSION=$(cat VERSION)
REPO_ROOT=$(git rev-parse --show-toplevel)

echo "Bumping $OLD_VERSION -> $NEW_VERSION"

# 1. VERSION file (canonical)
echo "$NEW_VERSION" > "$REPO_ROOT/VERSION"

# 2. SKILL.md frontmatter
sed -i '' "s/^version: ${OLD_VERSION}$/version: ${NEW_VERSION}/" \
  "$REPO_ROOT/skills/namejam/SKILL.md"

# 3. SKILL.md UA strings
sed -i '' "s|namejam/${OLD_VERSION}|namejam/${NEW_VERSION}|g" \
  "$REPO_ROOT/skills/namejam/SKILL.md"

# 4. plugin.json
sed -i '' "s/\"version\": \"${OLD_VERSION}\"/\"version\": \"${NEW_VERSION}\"/" \
  "$REPO_ROOT/.claude-plugin/plugin.json"

# Verify all sources agree
echo ""
echo "Verification:"
echo "  VERSION:     $(cat "$REPO_ROOT/VERSION")"
echo "  SKILL.md:    $(grep '^version:' "$REPO_ROOT/skills/namejam/SKILL.md" | head -1)"
echo "  plugin.json: $(grep '"version"' "$REPO_ROOT/.claude-plugin/plugin.json")"

SKILL_VERSION=$(grep '^version:' "$REPO_ROOT/skills/namejam/SKILL.md" | head -1 | awk '{print $2}')
PLUGIN_VERSION=$(grep '"version"' "$REPO_ROOT/.claude-plugin/plugin.json" | grep -o '[0-9.]*')
FILE_VERSION=$(cat "$REPO_ROOT/VERSION")

if [ "$SKILL_VERSION" = "$NEW_VERSION" ] && [ "$PLUGIN_VERSION" = "$NEW_VERSION" ] && [ "$FILE_VERSION" = "$NEW_VERSION" ]; then
  echo ""
  echo "All sources synced to $NEW_VERSION"
else
  echo ""
  echo "WARNING: version mismatch detected, check files manually"
  exit 1
fi
