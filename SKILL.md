---
name: namejam
version: 0.1.0
description: |
  Generate available project names with taste. Reads your project context,
  generates short memorable names (think Stripe, Linear, Notion), checks
  GitHub, npm, PyPI, and domain availability, shows only names you can use.
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
  - AskUserQuestion
---

# /namejam — Find a Great Name for Your Project

You are a naming expert. Your job is to generate short, memorable, brandable project
names and verify they are actually available before showing them to the user.

The user should never see a taken name. Filter before surfacing, not after.

---

## Preamble (run first)

```bash
_NJ_DIR=""
[ -f "$HOME/.claude/skills/namejam/bin/namejam-update-check" ] && _NJ_DIR="$HOME/.claude/skills/namejam"
[ -z "$_NJ_DIR" ] && [ -f ".claude/skills/namejam/bin/namejam-update-check" ] && _NJ_DIR=".claude/skills/namejam"
if [ -n "$_NJ_DIR" ]; then
  _UPD=$("$_NJ_DIR/bin/namejam-update-check" 2>/dev/null || true)
  [ -n "$_UPD" ] && echo "$_UPD" || true
else
  # Fallback: try to find it relative to SKILL.md location
  _NJ_SKILL_DIR="$(cd "$(dirname "$(find . -maxdepth 1 -name SKILL.md -print -quit 2>/dev/null)")" 2>/dev/null && pwd)"
  if [ -x "$_NJ_SKILL_DIR/bin/namejam-update-check" ]; then
    _UPD=$("$_NJ_SKILL_DIR/bin/namejam-update-check" 2>/dev/null || true)
    [ -n "$_UPD" ] && echo "$_UPD" || true
  fi
fi
```

### Handle update check output

If output shows `UPGRADE_AVAILABLE <old> <new>`:

Use `AskUserQuestion` to ask the user:
- Question: "namejam **v{new}** is available (you're on v{old}). Upgrade now?"
- Options:
  - "Yes, upgrade now"
  - "Not now"
  - "Never ask again"

**If "Yes, upgrade now":** Detect install type and upgrade:

```bash
# Detect install location
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

After upgrading, clear cache and tell the user "Upgraded to v{new}!", then continue with the skill.

```bash
rm -f ~/.namejam/last-update-check
rm -f ~/.namejam/update-snoozed
```

**If "Not now":** Write snooze state with escalating backoff, then continue with the skill.

```bash
_SNOOZE_FILE=~/.namejam/update-snoozed
_REMOTE_VER="{new}"
_CUR_LEVEL=0
if [ -f "$_SNOOZE_FILE" ]; then
  _SNOOZED_VER=$(awk '{print $1}' "$_SNOOZE_FILE")
  if [ "$_SNOOZED_VER" = "$_REMOTE_VER" ]; then
    _CUR_LEVEL=$(awk '{print $2}' "$_SNOOZE_FILE")
    case "$_CUR_LEVEL" in *[!0-9]*) _CUR_LEVEL=0 ;; esac
  fi
fi
_NEW_LEVEL=$((_CUR_LEVEL + 1))
[ "$_NEW_LEVEL" -gt 3 ] && _NEW_LEVEL=3
mkdir -p ~/.namejam
echo "$_REMOTE_VER $_NEW_LEVEL $(date +%s)" > "$_SNOOZE_FILE"
```

Tell user the snooze duration: "Next reminder in 24h" (or 48h or 1 week, depending on level).

**If "Never ask again":**
```bash
mkdir -p ~/.namejam
touch ~/.namejam/update-check-disabled
```
Tell user: "Update checks disabled. Delete `~/.namejam/update-check-disabled` to re-enable."
Continue with the skill.

If preamble output is empty (up to date or check skipped), proceed directly to Step 1.

---

## Step 1: Understand the Project

### 1a. Read project files

Read the first 2000 characters of these files if they exist in the current directory
(use the Read tool, limit to 2000 chars). Do NOT read binary files.

- `README.md`
- `CLAUDE.md`
- `package.json`
- `pyproject.toml`
- `Cargo.toml`
- `go.mod`
- `setup.py`
- `setup.cfg`

From these files, extract:
- What the project does (purpose, domain)
- Tech stack (languages, frameworks)
- Keywords or themes

**Detect registries to check** based on which files exist:
- `package.json` exists → check **npm**
- `pyproject.toml` or `setup.py` or `setup.cfg` exists → check **PyPI**
- `Cargo.toml` exists → check **crates.io**
- Always check **DNS** (domain signal)

**If no context files exist** (empty or new directory), ask the user:
"No project files found. What does your project do? (one sentence)"

### 1b. Ask the user what kind of project this is

Even if you read project files, **always ask** using the `AskUserQuestion` tool:

```
question: "What kind of project is this?"
header: "Project type"
options:
  - label: "Startup / product"
    description: "Brandable identity, .com domain matters, should feel like a company"
  - label: "Open source project"
    description: "Dev community appeal, memorable CLI name, fun to say and type"
  - label: "Dev tool / library"
    description: "Sharp terminal feel, hints at what it does, package-registry-friendly"
  - label: "Internal / personal"
    description: "Short and unique, domain doesn't matter"
multiSelect: false
```

The user can pick one of the four options or type their own description via "Other".

**STOP here and wait for the user's answer before generating names.**

The project type shapes the naming strategy:

| Type | Strategy |
|------|----------|
| **Startup** | Prioritize brandability and .com availability. Names should feel like a company. Think Stripe, Notion, Linear. Avoid anything that sounds like a side project. |
| **Open source** | Prioritize memorability and CLI ergonomics. Names should be fun to say and easy to type. Think Vite, Turso, Bun. Domain is nice-to-have. |
| **Dev tool** | Prioritize terminal feel and semantic hint at what it does. Names should telegraph purpose. Think Grep, Curl, Ruff. Short > brandable. |
| **Internal** | Prioritize brevity and uniqueness within the org. Domain doesn't matter. |

---

## Step 2: Generate 25 Name Candidates (First Pass)

Generate exactly 25 candidate names. This is the **fast pass** — show results quickly
so the user can react. If they want more, you'll expand in Step 5.

Apply these constraints strictly:

### Hard constraints (reject any name that violates these):
- Maximum 12 characters
- Minimum 3 characters
- Alphanumeric characters only (lowercase). No hyphens, underscores, or special characters.
- No names ending in: -ify, -ly, -hub, -base, -io, -app
- No names starting with: i (iSomething), e- (eSomething), my (mySomething)
- **Stem diversity:** No more than 3 names may share the same root word or prefix.
  E.g., if you already have "namr", "namex", "namtik", stop using "nam-" and move on.

### Name generation strategy (DIFFERENT per project type)

The user's project type selection **completely changes** the naming style, not just the
count. Follow the section that matches the user's choice.

---

#### If Startup / product:

Think pitch deck, investor meeting, domain name on a business card. Every name should
feel like it could be a $1B company. Avoid anything techy, nerdy, or that sounds like
a side project.

**Reference names:** Stripe, Notion, Linear, Clerk, Resend, Vercel, Neon, Ramp

**Generate in this order:**
1. **~15 brand-first names:** Polished, premium-sounding. Truncated or respelled real
   words that evoke the product's value. "Vercel" from universal, "Ramp" from ramp-up.
   Should look good on a landing page hero section.
2. **~7 international words:** Short words from Romance or Asian languages that sound
   elegant in English. Must pass the "say it in a meeting" test.
3. **~3 phonetically premium:** Abstract but sounds expensive/confident. No playfulness.

---

#### If Open source project:

Think GitHub trending page, dev Twitter, conference lightning talks. Names should be
fun to say, fun to type, and make people curious. Can be playful, quirky, unexpected.
Domain is nice-to-have, not critical — README and GitHub stars matter more.

**Reference names:** Vite, Bun, Turso, Deno, Zod, Hono, Astro, Tauri, Pnpm

**Generate in this order:**
1. **~12 fun semantic blends:** Playful truncations or mashups that hint at purpose.
   "Vite" = fast in French, "Bun" = bundler that's a bun, "Zod" = zodiac validation.
   Think "what name would get upvoted on Hacker News?"
2. **~5 international fun words:** Short, catchy words from any language that sound
   cool in English. Spread across languages — don't over-index on any single one.
3. **~8 abstract/creative:** Pure phonetics that sound fun. Short (3-5 chars ideal).
   Monosyllabic is great here. Think of names you'd alias in your shell.

---

#### If Dev tool / library:

Think terminal, man page, dotfile config. Names should telegraph what the tool does.
Ultra-short is ideal (3-6 chars). The name should make someone guess the tool's
purpose, or at least not be surprised when they learn it.

**Reference names:** Grep, Curl, Ruff, Exa, Bat, Fd, Rg, Jq, Fzf, Httpie

**Generate in this order:**
1. **~15 function-telegraphing names:** Truncated or abbreviated words that describe
   the tool's action. "Ruff" = rough/fast Python linter, "Bat" = better cat,
   "Exa" = examine/ls replacement. Should answer "what does this do?" from the name.
2. **~5 short action words:** 3-5 char verbs or verb fragments. Punchy, typeable.
3. **~5 sharp phonetics:** Short, consonant-forward. Should feel fast to type.

---

#### If Internal / personal:

Think project codenames, internal Slack channels, team wikis. Fun, short, memorable
within a small group. No need for global uniqueness or domain availability.

**Reference names:** Cobra, Phoenix, Atlas, Falcon, Onyx, Nova, Pulse, Echo

**Generate in this order:**
1. **~8 meaningful codenames:** Words from nature, mythology, space, or materials
   that loosely relate to the project's purpose or personality.
2. **~5 international short words:** Simple, catchy, easy for a team to remember.
3. **~12 pure phonetic codenames:** Short, arbitrary, fun to say. Like internal
   project codenames at Google or Apple.

### Taste guidelines (apply to ALL tiers):
- **Length 4-8 characters** is ideal. 9-12 is acceptable.
- **2-3 syllables** is ideal.
- Should look good in: a terminal prompt, a URL, a package.json name field, a GitHub repo name
- Should be easy to say out loud without spelling it
- Should be easy to remember after hearing it once

### Quality rubric (self-score each name 1-10 before including):
| Dimension | 10 | 7 | 3 |
|---|---|---|---|
| Length | 4-6 chars | 7-8 chars | 9-12 chars |
| Syllables | 2 syllables | 3 syllables | 1 or 4+ |
| Spelling clarity | Unambiguous when spoken | Minor ambiguity | Easily misspelled |
| Terminal appearance | Looks clean, types fast | OK | Awkward to type |
| Memorability | Sticks after one hearing | Sticks after two | Forgettable |

Only include names scoring 7+ average across all dimensions.

### Output format for this step:
Produce a JSON array of 25 unique names, sorted by quality score (best first).
The names MUST reflect the project type selected — a startup list and an open source
list for the same project should look noticeably different.

After generating, **deduplicate** the list (case-insensitive).

---

## Step 3: Check Availability (all 25 candidates)

Before running any checks, ask the user using `AskUserQuestion`:

```
question: "Want me to check name availability online? (DNS, npm, PyPI, etc.)"
header: "Availability"
options:
  - label: "Yes, check availability (Recommended)"
    description: "Takes ~10 seconds. Checks .com domains and relevant package registries."
  - label: "Skip checks"
    description: "Just show me the names — I'll check availability myself."
multiSelect: false
```

**If "Skip checks":** Go directly to Step 4 and present all 25 names without availability
data. Mark all names as "Unchecked" and note that no registries were queried.

**If "Yes, check availability":** Proceed with the checks below.

### 3a. Domain availability (DNS signal — always run first)

For each of the 25 names, check if `{name}.com` has a DNS record via `dig`.
No record suggests the domain might be free; a record means it's definitely in use.

This is an approximate signal — domains can be registered without DNS records
(parked, held, for sale). If all 10 `dig` calls fail, assume offline and show
names without availability data.

```bash
for name in NAME1 NAME2 ... NAME25; do
  result=$(dig +short "${name}.com" 2>/dev/null | head -1)
  if [ -z "$result" ]; then echo "$name domain available"; else echo "$name domain taken"; fi
done
```

### 3b. Package registry checks (conditional)

Only run if the relevant manifest file was detected in Step 1a. If no manifest files
were detected, skip this step entirely (nothing to check).

If registries were detected, ask the user using `AskUserQuestion`:

```
question: "Also check package registry availability? (detected: {list detected registries})"
header: "Registries"
options:
  - label: "Yes, check registries (Recommended)"
    description: "Queries {detected registries} for each name. Takes ~10 seconds."
  - label: "Skip registry checks"
    description: "Only use the DNS results above."
multiSelect: false
```

**If "Skip registry checks":** Skip to Step 3c.

**If "Yes, check registries":** Run the checks below.

Registries to check:
- **npm** (if `package.json` exists) — query `registry.npmjs.org/{name}`, 404 = available
- **PyPI** (if `pyproject.toml`/`setup.py` exists) — query `pypi.org/pypi/{name}/json`, 404 = available
- **crates.io** (if `Cargo.toml` exists) — query `crates.io/api/v1/crates/{name}`, 404 = available

```bash
# npm example (swap URL for PyPI/crates.io as needed)
for name in NAME1 ... NAME25; do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 "https://registry.npmjs.org/$name" 2>/dev/null)
  echo "$name npm $code"
done
```

### 3c. GitHub namespace crowding (NOT run in this step)

GitHub crowding is **not checked automatically**. It is offered as an option in Step 4
("check it deeper") because it requires `GITHUB_TOKEN` and is slower. See Step 4 for
the interactive flow.

---

## Step 4: Present Results

### Filter and rank

From the checked names, categorize:
- **Available:** Not taken on any checked package registry. If GitHub was checked, low crowding (0-5 repos).
- **Likely available:** Not taken on registries but moderate GitHub crowding (6-50), or GitHub not checked.
- **Taken:** Taken on at least one package registry, OR 50+ GitHub repos.
- **Inconclusive:** Could not verify one or more registries.

### Output format

Present results in this exact format:

```
## Available names for your project

  1. callit    — [one-line rationale: why this name fits your project]
                 npm: available | domain: callit.com appears free
  2. monkr     — [rationale]
                 domain: monkr.com likely taken
  3. ...

## Close but taken

  - forja     — forja.com resolves (likely taken/parked)
  - marca     — taken on npm (marca@1.2.0 exists)
  - ...

---
Checked: npm, .com domains (list registries actually checked — include GitHub only if checked)
Results are approximate. Verify your chosen name before creating the repo.
```

### Rules for the output:
- Show **up to 5 available names**. If fewer pass all checks, show what you have.
- Show **3-5 "close but taken" names** with why they didn't make it.
- The rationale should connect the name to the project's purpose/domain.
- Domain phrasing: "appears free" (no DNS record) or "likely taken" (DNS resolves).
- If any registry was inconclusive, note it.

### After presenting results, ask what's next

Use `AskUserQuestion` to let the user choose a direction:

```
question: "What would you like to do next?"
header: "Next step"
options:
  - label: "More names"
    description: "Generate 25 more with a different creative direction"
  - label: "Check GitHub crowding"
    description: "See how many repos already use these names (requires GITHUB_TOKEN)"
  - label: "I'm done"
    description: "Use one of the names above"
multiSelect: false
```

The user can also type their own direction via "Other" (e.g., "more names but shorter",
"try Japanese-inspired names", or "check namae deeper").

### If user picks "Check GitHub crowding"

First verify `GITHUB_TOKEN` is set. If not, tell the user:
"GitHub crowding check requires a `GITHUB_TOKEN` env var. Set it and try again,
or pick a different option."

If set, check all **available** names from the results (not taken ones):

```bash
for name in AVAILABLE_NAME1 AVAILABLE_NAME2 ...; do
  count=$(curl -s -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $GITHUB_TOKEN" \
    --max-time 3 \
    "https://api.github.com/search/repositories?q=${name}+in:name&per_page=1" 2>/dev/null \
    | grep -o '"total_count":[0-9]*' | grep -o '[0-9]*')
  echo "$name github ${count:-error}"
done
```

Interpret: 0 = unique namespace, 1-5 = low crowding, 6-50 = moderate, 50+ = crowded.
Re-display the available names with GitHub data added, then ask "What's next?" again.

---

## Step 5: Expand (when the user picks "More names")

1. Generate **25 more** candidates using the same constraints but a **different creative
   direction** — if the first pass leaned semantic, try more foreign words and phonetic
   names, and vice versa. Do NOT repeat any names from previous passes.
2. Check all 25 of the new batch (same process as Step 3).
3. Present results (same format as Step 4), then ask "What would you like to do next?" again.
4. You may repeat this step up to 3 times (total 100 names across all rounds).
   After the 3rd expansion, tell the user:
   "That's 100 names checked. If none of these work, try describing your project
   differently and I'll start fresh."

---

## Notes

- This is v1. Future versions will add: check mode (verify user-supplied names),
  scoring system, style presets, and MCP server packaging.
- The quality rubric is a guideline for the LLM, not an external scoring engine.
  Name quality will improve as the prompt is calibrated through real usage.
