---
name: namejam
version: 0.4.0
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

## Step 0: Print version

Read the `version` field from this file's YAML frontmatter and print: `Running namejam v{version}`

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

**You MUST call `AskUserQuestion` and STOP here.** Do NOT proceed to Step 1c, do NOT
generate any names, do NOT skip ahead — even if the user's initial message implies a
preference (e.g., "generate startup names"). The interactive selection is required.
Wait for the user's explicit response before continuing.

### 1c. Ask the user about naming style

After the project type is selected, present naming style options **tailored to the project type**.
The available styles differ per type because some styles are natural for certain contexts
and awkward for others. Use `AskUserQuestion` with `multiSelect: true` so the user can
pick one or more styles. When multiple styles are selected, generate a proportional mix.

**If Startup / product:**
```
question: "What naming styles do you want? Pick one or more."
header: "Name styles"
options:
  - label: "Single word"
    description: "stripe, notion, vercel, ramp — clean, brandable, domain-friendly"
  - label: "Compound"
    description: "airbnb, dropbox, mailchimp, fivetran — two words fused into one"
multiSelect: true
```

**If Open source project:**
```
question: "What naming styles do you want? Pick one or more."
header: "Name styles"
options:
  - label: "Single word"
    description: "vite, bun, astro, biome — clean, memorable, easy to type"
  - label: "Hyphenated"
    description: "left-hook, fast-check, vue-router — two words with a dash"
  - label: "Compound"
    description: "turborepo, ripgrep, slidev, unplugin — two words fused into one"
multiSelect: true
```

**If Dev tool / library:**
```
question: "What naming styles do you want? Pick one or more."
header: "Name styles"
options:
  - label: "Single word"
    description: "grep, curl, ruff, bat, dust — ultra-short, typeable"
  - label: "Hyphenated"
    description: "fast-glob, ts-node, dry-run — functional, descriptive"
  - label: "Compound"
    description: "ripgrep, watchexec, difftastic — two words fused"
  - label: "Prefix pattern"
    description: "go-fiber, re-send, un-plugin — prefix signals ecosystem or function"
multiSelect: true
```

**If Internal / personal:**
```
question: "What naming styles do you want? Pick one or more."
header: "Name styles"
options:
  - label: "Single word"
    description: "cobra, phoenix, atlas, onyx — codename feel"
  - label: "Compound"
    description: "topgun, redfox, icepick, ironclad — vivid two-word codenames"
  - label: "snake_case"
    description: "red_fox, ice_pick, star_fall — internal tool / script style"
multiSelect: true
```

**You MUST call `AskUserQuestion` and STOP here.** Do NOT proceed to Step 2, do NOT
generate any names until the user responds. The style selection directly controls
which characters are allowed (Step 2 hard constraints) — skipping it produces
names with wrong character rules.

### How each style affects generation:

**Single word:** Alphanumeric only `[a-z0-9]`, no separators.

**Compound:** Two words fused into one without separator. "turborepo", "ripgrep", "airbnb".
Each component should be 2-5 characters. Total 5-12 characters.
Allowed characters: `[a-z0-9]` only.

**Hyphenated:** Two words joined by a hyphen. "left-hook", "fast-check", "vue-router".
Each word should be 2-6 characters. Total (including hyphen) 5-13 characters.
Allowed characters: `[a-z0-9-]` — hyphens required as word separators.

**Prefix pattern:** A short prefix (2-4 chars) + hyphen + descriptive word.
Common prefixes: go-, re-, un-, pre-, no-, js-, py-, ts-.
"go-fiber", "re-send", "un-plugin", "no-cache".
Allowed characters: `[a-z0-9-]` — hyphens required as separators.

**snake_case:** Two words joined by underscore. "red_fox", "ice_pick", "star_fall".
Allowed characters: `[a-z0-9_]` — underscores required as word separators.

**Multiple styles selected:** Generate a proportional mix of the selected styles.
Roughly equal split across the chosen styles (e.g., if user picks Single word + Compound,
generate ~12-13 of each).

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
- **Allowed characters** (determined by the user's Step 1c style selection):
  - Single word / Compound → `[a-z0-9]` only
  - Hyphenated / Prefix pattern → `[a-z0-9-]` (hyphens as separators)
  - snake_case → `[a-z0-9_]` (underscores as separators)
  - Mixed styles → union of allowed characters for all selected styles
- No names ending in: -ify, -ly, -hub, -base, -io, -app
- No names starting with: i (iSomething), e- (eSomething), my (mySomething)
- **Stem diversity:** No more than 3 names may share the same root word or prefix.
  E.g., if you already have "namr", "namex", "namtik", stop using "nam-" and move on.

### Name shape diversity (MANDATORY)
Names must NOT all be single dictionary words. Mix these shapes across the 25 candidates:
- **Compounds:** Two short words jammed together — Dropbox, Turborepo, Lefthook, Tripwire, Lockstep
- **Truncations:** Chopped/respelled real words — monkr, flickr, tumblr, brandr, pickr, titlr
- **Blends:** Parts of two words fused — Vercel (universal+excel), Figma (figure+magma), Twilio (twilight+IO)
- **Single words:** Real or invented standalone words — Stripe, Notion, Ramp, Bun, Husky

**Minimum diversity rule:** Of the 25 names, at least 10 must be compounds or blends, at least 4 must be
truncations, and no more than 6 may be single standalone words.
Single real English words (bolt, forge, slate, prism) score high on taste but are almost always
taken on npm/PyPI/domains. Compounds and blends are where available names live. Weight accordingly.

### What makes a GOOD compound (vs a bad one)

Good compounds have **wordplay, double meaning, or a vivid image**. Bad compounds are
**mechanical verb+noun gluing** with no wit.

**GOOD compounds — study these:**
- **Lefthook** — left+hook. Boxing term (a surprise punch) AND git hooks. Double meaning.
- **Tripwire** — trip+wire. Security term (an alarm trigger) AND triggered-on-events. Vivid image.
- **Lockstep** — lock+step. Means "in perfect sync." The compound IS an idiom.
- **Dropbox** — drop+box. "Drop files in a box." The name IS the action.
- **Turborepo** — turbo+repo. "Turbo" modifies "repo" — you instantly know it's a fast repo tool.
- **Airbnb** — air+bnb. "Air bed and breakfast." Compressed a whole concept into 5 letters.
- **Mailchimp** — mail+chimp. Unexpected animal pairing creates memorability.
- **Difftastic** — diff+fantastic. Portmanteau with attitude.

**BAD compounds — never do this:**
- **ripfast** — rip+fast. Two generic "speed" words glued together. No wit, no image.
- **zapgrep** — zap+grep. Action verb + tool name. Mechanical, forgettable.
- **lintjet** — lint+jet. Tool function + speed metaphor. Could describe any fast tool.
- **payvel** — pay+velocity. Truncated second word makes it look like suffix-slapping.
- **snapbuild** — snap+build. "Fast build." You've described the feature, not named the product.
- **codesweep** — code+sweep. Generic verb+noun. Sounds like a cleanup script, not a brand.

**The compound test:** A good compound makes you smile, nod, or think "clever." A bad compound
makes you think "that's just two words stuck together." If the name works as an existing
English idiom, metaphor, or phrase, it's almost always good.

### NEVER generate these (negative examples)
These patterns consistently score poorly. Reject any name that fits these patterns:
- **Random syllable inventions with no meaning:** zerka, zelka, morfa, preka, dvora, fenka, genzo, pulzo.
  If you can't explain what the name means or what two words it comes from, don't use it.
- **Foreign words the user won't recognize:** waktu, ritmo, kurono, vakti, quando, zaman.
  Exception: words that are widely known in English (e.g., "vite" meaning fast is borderline OK).
- **Suffix-slapping on a root:** Adding -ka, -ra, -zo, -al, -va to a root is lazy.
  "arkora", "calzo", "tevex" — these aren't blends, they're a root with noise appended.
- **"Abstract, fun phonetics":** This is code for "I ran out of ideas." Every name must have
  a traceable origin — either a real word, a compound of real words, or a recognizable truncation.
- **Mechanical verb+noun compounds:** ripfast, zapgrep, snapbuild, codesweep, lintjet, payvel.
  Two generic words glued together with no wordplay, double meaning, or vivid image.
  Good compounds are idioms, metaphors, or puns (tripwire, lockstep, dropbox). See "What makes a GOOD compound" above.

**The test:** For every name, you must be able to complete this sentence:
"[name] comes from [word1] + [word2]" or "[name] is a truncation of [word]" or "[name] means [meaning]."
If you can't, delete it and generate a replacement.

### Safety check (MANDATORY)
Before including any name, check that it does NOT:
- **Read as or sound like a sexual/profane term** in English or common languages.
  Watch for accidental readings when two words are fused: "penisland", "therapist" → "the rapist", etc.
  Read the compound both as intended AND as a single unbroken string. If either reading is problematic, drop it.
- **Resemble a racial, ethnic, or gender slur** — even phonetically. When in doubt, drop it.
- **Contain a slang drug or violence reference** that would make the name unprofessional.

If a name passes all other quality checks but fails safety, delete it silently and generate a replacement.
Do not mention the rejected name to the user.

### Name generation strategy (DIFFERENT per project type)

The user's project type selection **completely changes** the naming style, not just the
count. Follow the section that matches the user's choice.

---

#### If Startup / product:

Think pitch deck, investor meeting, domain name on a business card. Every name should
feel like it could be a $1B company. Avoid anything techy, nerdy, or that sounds like
a side project.

**Reference names:** Stripe, Notion, Vercel (blend), Resend (compound), Clerk, Neon, Ramp, Fivetran (blend), Plaid

**Remember:** Apply all constraints from the NEVER block and the compound quality guide above. Every name must pass the origin test.

**Generate in this order:**
1. **~12 brand-first blends/compounds:** Two concepts fused into one word that evokes the
   product's value. "Vercel" = universal+excel, "Resend" = re+send, "Fivetran" = five+transform.
   Should look good on a landing page hero section.
   Aim for **double meanings, idioms, or visual metaphors** — not mechanical verb+noun.
   Good: "Airbnb" (compressed concept), "Mailchimp" (unexpected pairing), "Plaid" (trust pattern).
   Bad: "payvel", "cashlux", "fundmint" (generic word + generic word, no wit).
2. **~8 truncated/respelled real words:** Chop or respell a meaningful word. "Clerk" from clerical,
   "Plaid" = the fabric pattern (trust/weaving), "Neon" = the element (bright/new).
3. **~3 sharp single words:** Real English words repurposed. "Stripe" = a line (payments),
   "Ramp" = acceleration. Must connect to the product's purpose.
   Note: single real words are almost always taken on registries. Include a few for aspiration
   but don't rely on them.
4. **~2 creative compounds:** Two short words jammed together. Think "Airbnb", "Dropbox", "Mailchimp".

---

#### If Open source project:

Think GitHub trending page, dev Twitter, conference lightning talks. Names should be
fun to say, fun to type, and make people curious. Can be playful, quirky, unexpected.
Domain is nice-to-have, not critical — README and GitHub stars matter more.

**Reference names:** Vite, Bun, Astro, Tauri, Turborepo (compound), Biome, Lefthook (compound), Husky, Slidev (blend), Unplugin (blend)

**Remember:** Apply all constraints from the NEVER block and the compound quality guide above. Every name must pass the origin test.

**Generate in this order:**
1. **~12 semantic compounds/blends:** Two concepts fused or jammed together that hint at purpose.
   "Turborepo" = turbo+repo, "Slidev" = slide+dev, "Unplugin" = un+plugin, "Lefthook" = left+hook.
   The name should make someone curious about what it does.
   Aim for **wordplay or double meaning** — "Lefthook" works because it's a boxing term AND git hooks.
   Bad: "snapbuild", "devburn", "rushpack" (mechanical verb+noun, no double meaning).
2. **~6 truncated/respelled words:** Chop or respell a word that connects to the project.
   "Astro" from astronomy/fast, "Biome" from ecosystem, "Husky" = guard dog (git hooks).
   Must have a clear semantic connection — not random syllables.
3. **~4 sharp single words:** Real English words that fit. "Bun" = a bun (bundler), "Vite" (ok
   this is French but it means "fast" and everyone knows it). Strong, short, purposeful.
   Note: single real words are almost always taken. Include a few but don't rely on them.
4. **~3 creative respellings:** Drop vowels or swap letters. "flickr", "tumblr", "monkr" style.
   Only if the base word connects to the project.

---

#### If Dev tool / library:

Think terminal, man page, dotfile config. Names should telegraph what the tool does.
Ultra-short is ideal (3-6 chars). The name should make someone guess the tool's
purpose, or at least not be surprised when they learn it.

**Reference names:** Grep, Curl, Ruff, Bat, Httpie (blend), Ripgrep (compound), Tokei (single), Difftastic (blend), Watchexec (compound), Dust

**Remember:** Apply all constraints from the NEVER block and the compound quality guide above. Every name must pass the origin test.

**Generate in this order:**
1. **~12 function-telegraphing compounds:** Two short words or abbreviations that describe
   the tool's action. "Ripgrep" = rip+grep, "Watchexec" = watch+exec, "Difftastic" = diff+fantastic.
   Should answer "what does this do?" from the name.
   Best dev tool compounds use a **vivid verb + the domain noun**: ripgrep, watchexec, difftastic.
   Bad: "zapgrep", "lintjet", "codesweep" (generic verb, no personality).
2. **~6 truncated action words:** Chopped verbs or nouns that hint at purpose. "Ruff" = rough/fast,
   "Bat" = better cat, "Dust" = du+rust. 3-6 chars, punchy, typeable.
3. **~4 sharp blends:** Fuse two concepts. "Httpie" = HTTP+pie, "Tokei" = Japanese for clock.
   Must telegraph function.
4. **~3 creative respellings:** "grepr", "difft", "logr" style. Only if the base word is obvious.

---

#### If Internal / personal:

Think project codenames, internal Slack channels, team wikis. Fun, short, memorable
within a small group. No need for global uniqueness or domain availability.

**Reference names:** Cobra, Phoenix, Atlas, Falcon, Topgun (compound), Redfox (compound), Onyx, Nova, Icepick (compound), Echo

**Remember:** Apply all constraints from the NEVER block and the compound quality guide above. Every name must pass the origin test.

**Generate in this order:**
1. **~8 meaningful codenames:** Words from nature, mythology, space, or materials
   that loosely relate to the project's purpose or personality.
2. **~10 compound codenames:** Two short words that form a vivid image. "Topgun", "Redfox",
   "Icepick", "Starfall", "Ironclad". Like military operation names.
3. **~4 truncated words:** Chopped versions of meaningful words. Short, punchy.
4. **~3 respelled words:** Drop vowels or swap letters for a unique twist.

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

Auto-run all availability checks without asking. DNS and registry checks are fast (~10s)
and the results are the whole point. If the environment can't run checks (missing tools,
no DNS), the preflight logic below handles fallbacks gracefully.

### 3a. Preflight check (run once before any availability checks)

Before running any DNS or registry checks, verify that required tools exist:

```bash
command -v python3 >/dev/null 2>&1 && echo "python3: ok" || echo "python3: missing"
command -v curl >/dev/null 2>&1 && echo "curl: ok" || echo "curl: missing"
```

**If `python3` is missing:** Tell the user:
"Domain checking requires `python3` (pre-installed on macOS and most Linux distros).
Skipping domain checks — registry checks will still run."

Mark all domain results as "unchecked" and proceed to Step 3c.

**If `curl` is missing:** Tell the user:
"Registry checking requires `curl`. Cannot check availability without it."
Skip all availability checks and go to Step 4 with all names marked "Unchecked".

### 3b. Domain availability (DNS signal — always run first)

For each of the 25 names, check if `{name}.com` resolves via `python3` socket lookup.
A resolved address means the domain is in use; a failure suggests it might be free.

This is an approximate signal — domains can be registered without DNS records
(parked, held, for sale).

**IMPORTANT:** Run a sentinel check first to verify DNS works at all. Without this,
environments with no DNS (sandboxes, proxies, offline) silently report every domain
as "available" — a 100% false positive rate.

```bash
# Sentinel: verify DNS resolution works before trusting results
if python3 -c "import socket; socket.gethostbyname('google.com')" 2>/dev/null; then
  echo "DNS_AVAILABLE=1"
else
  echo "DNS_AVAILABLE=0"
fi
```

**If `DNS_AVAILABLE=0`:** Tell the user:
"DNS resolution is unavailable in this environment — domain checks skipped."
Mark all domain results as "unchecked" and proceed to Step 3c. In Step 4, treat
"unchecked" domains as unknown — never classify them as "available" or use them
to filter names.

**If `DNS_AVAILABLE=1`:** Run the per-name checks in parallel:

```bash
check_domain() {
  local name=$1
  # Sanitize: reject names that aren't valid domain labels
  if ! echo "$name" | grep -qE '^[a-z0-9]([a-z0-9-]*[a-z0-9])?$'; then
    echo "$name domain INVALID_NAME"
    return
  fi
  if python3 -c "import socket; socket.gethostbyname('${name}.com')" 2>/dev/null; then
    echo "$name domain DNS_RESOLVES"
  else
    echo "$name domain NO_DNS"
  fi
}
export -f check_domain

echo "NAME1 NAME2 ... NAME25" | tr ' ' '\n' | xargs -P 8 -I {} bash -c 'check_domain "$1"' _ {}
```

Interpret domain results for display:
- `DNS_RESOLVES` → "{name}.com taken (DNS resolves)"
- `NO_DNS` → "{name}.com no DNS record (does not mean unregistered — verify on registrar)"
- `INVALID_NAME` → skip from domain display

**IMPORTANT:** "no DNS record" does NOT mean available. Domains can be registered without
A records (parked, held for sale, MX-only). Conversely, DNS can resolve for unregistered
domains (registrar parking pages, catch-all DNS). Domain status from DNS is a weak signal.
Never tell the user a domain "appears free" or "available" based solely on DNS.

### 3c. Package registry checks (conditional)

Only run if the relevant manifest file was detected in Step 1a. If no manifest files
were detected, skip this step entirely (nothing to check).

Auto-run all detected registry checks without asking.

#### Input sanitization (MANDATORY — run before any registry query)

LLM-generated names enter shell commands and URLs. Sanitize every name before use:

```bash
sanitize_name() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9._-]//g'
}
```

Apply `sanitize_name` to every candidate before building registry URLs. If a name
becomes empty after sanitization, skip it.

#### npm pre-validation

npm (v3+) rejects package names that contain uppercase letters, don't match
`^[a-z0-9][a-z0-9._-]*$`, or are reserved/too-similar to popular packages.

Before querying the npm registry, validate the name:

```bash
validate_npm_name() {
  local name=$1
  if ! echo "$name" | grep -qE '^[a-z0-9][a-z0-9._-]*$'; then
    echo "$name npm INVALID"
    return 1
  fi
  return 0
}
```

If `validate_npm_name` fails, mark the name as "npm: invalid name" and do NOT query
the registry. A 404 for an invalid name does not mean "available."

#### PyPI name normalization (PEP 503)

PyPI normalizes names: `Foo_Bar`, `foo-bar`, `foo.bar` all resolve to `foo-bar`.
Always normalize before querying to avoid false "available" results:

```bash
normalize_pypi_name() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[-_.]\{1,\}/-/g'
}
```

Use the normalized name in the URL: `pypi.org/pypi/$(normalize_pypi_name "$name")/json`

#### Registry queries

Registries to check:
- **npm** (if `package.json` exists) — validate name first, then query `registry.npmjs.org/{name}`, 404 = likely available
- **PyPI** (if `pyproject.toml`/`setup.py` exists) — normalize name first, then query `pypi.org/pypi/{normalized}/json`, 404 = available
- **crates.io** (if `Cargo.toml` exists) — query `crates.io/api/v1/crates/{name}`, 404 = available

**IMPORTANT:** Always include a User-Agent header. crates.io returns 403 for all
requests without one, causing every name to be misclassified.

**npm caveat:** A 404 from the npm registry means the exact name isn't published, but
npm may still reject it on publish due to its reserved name list or name similarity
filter (names too close to `react`, `express`, `angular`, etc.). Note this in the
output: registry 404 means "not yet taken," not "guaranteed publishable."

Run all registry checks in parallel (8 concurrent) to keep total time under ~3s:

```bash
UA="namejam/0.4.0 (https://github.com/FireflySentinel/namejam)"

check_registry() {
  local name=$1 registry=$2 url=$3
  code=$(curl -s -A "$UA" -o /dev/null -w "%{http_code}" --max-time 3 "$url" 2>/dev/null)
  echo "$name $registry $code"
}
export -f check_registry
export UA

# Build the job list (only include detected registries)
JOBS=""
for name in NAME1 ... NAME25; do
  clean=$(sanitize_name "$name")
  [ -z "$clean" ] && continue

  # npm (if detected) — skip invalid names
  if validate_npm_name "$clean" 2>/dev/null; then
    JOBS="$JOBS\n$clean npm https://registry.npmjs.org/$clean"
  fi
  # PyPI (if detected) — use normalized name in URL
  pypi_name=$(normalize_pypi_name "$clean")
  JOBS="$JOBS\n$clean pypi https://pypi.org/pypi/$pypi_name/json"
  # crates.io (if detected)
  JOBS="$JOBS\n$clean crates https://crates.io/api/v1/crates/$clean"
done

echo -e "$JOBS" | xargs -P 8 -L 1 bash -c 'check_registry "$1" "$2" "$3"' _
```

### 3d. GitHub namespace crowding

GitHub crowding is checked in the **Finals Deep-Dive** (Step 7), not here. It requires
`GITHUB_TOKEN` to be set and is reserved for the final 2-3 candidates the user is
most serious about.

---

## Step 4: Present Results

### Filter and rank

Filtering rules depend on the project type selected in Step 1b:

**If Startup / product:**
Domain is a primary signal. A taken .com domain counts against the name.
- **Available:** Not taken on any checked package registry AND .com has no DNS record.
- **Likely available:** Not taken on registries but .com has DNS record (likely taken or parked).
- **Taken:** Taken on at least one package registry.
- **Inconclusive:** Could not verify one or more registries.

**If Open source project or Dev tool / library:**
Registry availability is what matters. Domain is informational only — never disqualify a name for having a taken domain.
- **Available:** Not taken on any checked package registry (npm/PyPI/crates.io).
- **Likely available:** Not taken on registries, domain status unknown or not checked.
- **Taken:** Taken on at least one package registry.
- **Inconclusive:** Could not verify one or more registries.

Note: GitHub namespace crowding is checked in Step 7 (Finals Deep-Dive) only, not here.
Do not reference GitHub data in Step 4 filtering.
Show domain status as a reference column, but do NOT move names to "Close but taken" based on domain alone.

**If Internal / personal:**
No external availability matters. Show all 25 names as available — no filtering.
Domain and registry info can be shown as reference if the user opted into checks, but do not categorize any name as "taken".
**Important:** Even if Step 3 returned "taken" results for some names, IGNORE that data
for categorization purposes. The Internal type does not use availability to rank or filter.
Present all 25 names under "Available names" regardless of DNS or registry results.

### Output format

Present results in this exact format:

```
## Available names for your project

  1. callit    — [one-line rationale: why this name fits your project]
                 npm: available | domain: callit.com no DNS record (verify on registrar)
  2. monkr     — [rationale]
                 domain: monkr.com likely taken
  3. ...

## Close but taken

  - forja     — forja.com DNS resolves (taken or parked)
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
- Domain phrasing: "no DNS record (verify on registrar)" or "taken (DNS resolves)".
  Never say "appears free" or "available" for domains based solely on DNS.
- If any registry was inconclusive, note it.

### After presenting results, ask what's next

Use `AskUserQuestion` to let the user choose a direction:

```
question: "What would you like to do next?"
header: "Next step"
options:
  - label: "Shortlist favorites"
    description: "Pick 2-3 names you like — I'll generate variations and run a deep check"
  - label: "More names"
    description: "Generate 25 more with a different creative direction"
  - label: "I'm done"
    description: "Use one of the names above"
multiSelect: false
```

The user can also type their own direction via "Other" (e.g., "more names but shorter",
"try Japanese-inspired names", etc.).

---

## Step 5: Expand (when the user picks "More names")

1. Generate **25 more** candidates using the same constraints but a **different creative
   direction** — if the first pass leaned toward compounds, try more truncations and blends,
   and vice versa. Try different root words and metaphor domains (e.g., if round 1 used
   tech metaphors, try nature, music, or craft metaphors). Foreign words are OK only if
   widely known in English (same threshold as the NEVER block). Do NOT repeat any names
   from previous passes.
2. Check all 25 of the new batch (same process as Step 3).
3. Present results (same format as Step 4), then ask "What would you like to do next?" again.
4. You may repeat this step up to 3 times (total 100 names across all rounds).
   After the 3rd expansion, tell the user:
   "That's 100 names checked. If none of these work, try describing your project
   differently and I'll start fresh."

---

## Step 6: Variant Round (when the user picks "Shortlist favorites")

The user liked 2-3 names but isn't fully committed. Generate variations to help them find
the perfect version.

### 6a. Collect favorites

Use `AskUserQuestion`:
```
question: "Which names do you like? I'll generate variations of each. (Type 2-3 names, separated by commas. You can include names from the list or your own.)"
header: "Favorites"
```

No pre-selected options — the user types their own favorites.

### 6b. Generate variations

For each favorited name, generate **5 variations** using these techniques:
- **Shorter version:** Truncate or abbreviate (e.g., "mintname" → "mintn", "namejam" → "namjm")
- **Longer version:** Extend with a meaningful suffix or prefix (e.g., "callit" → "callitout", "pluck" → "pluckr")
- **Respelling:** Drop vowels or swap letters (e.g., "namecast" → "namcast", "coinword" → "coynwrd")
- **Reorder:** Swap the two components (e.g., "mint-name" → "name-mint", "call-it" → "it-call")
- **Synonym swap:** Replace one component with a synonym (e.g., "mint-name" → "mint-tag", "call-it" → "dub-it")

Maintain the user's chosen naming style (single word, hyphenated, compound, etc.) from Step 1c.

Apply the same origin test: every variant must have a traceable origin.

### 6c. Check and present variations

Check availability (DNS + any registries detected in Step 1a) for all variations.
Present in this format:

```
## Variations of "callit"

  ✓ callitout   — callit extended — domain: callitout.com appears free
  ✓ dubit       — synonym swap (dub + it) — domain: dubit.com likely taken
  ✗ calit       — truncation — taken on npm
  ...

## Variations of "mintname"

  ✓ nametag     — synonym swap — domain: nametag.com likely taken
  ...
```

### 6d. Ask what's next

After presenting variations, use `AskUserQuestion`:
```
question: "Found some variations. What next?"
header: "Next step"
options:
  - label: "Finals deep-dive"
    description: "Pick your top 2-3 finalists — I'll check .ai, .io, .dev, .net and GitHub"
  - label: "More variations"
    description: "Pick different favorites to explore"
  - label: "I'm done"
    description: "I've found my name"
multiSelect: false
```

---

## Step 7: Finals Deep-Dive (when the user picks "Finals deep-dive")

The user has narrowed down to 2-3 finalists. Run a comprehensive check to help them make
the final decision.

### 7a. Collect finalists

Use `AskUserQuestion`:
```
question: "Which names are your finalists? (Type 2-3 names, separated by commas. You can include names from previous rounds or entirely new names you thought of.)"
header: "Finalists"
```

No pre-selected options — the user types their own finalists. They may pick from
earlier rounds or enter names they came up with themselves.

### 7b. Multi-TLD domain check

For each finalist, check .com, .ai, .io, .dev, and .net.

**Re-run the DNS sentinel check** (the user's network may have changed since Step 3):

```bash
if python3 -c "import socket; socket.gethostbyname('google.com')" 2>/dev/null; then
  echo "DNS_AVAILABLE=1"
else
  echo "DNS_AVAILABLE=0"
fi
```

**If `DNS_AVAILABLE=0`:** Tell the user "DNS unavailable — domain columns will show 'unchecked'."
Show "unchecked" for all TLD columns in the comparison table (Step 7d).

**If `DNS_AVAILABLE=1`:** Run DNS checks, then whois for domains without DNS records
(only 2-3 finalists, so the extra ~2s per whois lookup is acceptable):

```bash
for name in FINALIST1 FINALIST2 FINALIST3; do
  # Strip hyphens/underscores for domain check
  domain=$(echo "$name" | tr -d '-_')
  for tld in com ai io dev net; do
    fqdn="${domain}.${tld}"
    if python3 -c "import socket; socket.gethostbyname('${fqdn}')" 2>/dev/null; then
      echo "$name .${tld} DNS_RESOLVES"
    elif command -v whois >/dev/null 2>&1; then
      # No DNS — use whois for a more definitive answer
      if whois "$fqdn" 2>/dev/null | grep -qi "no match\|not found\|no data found"; then
        echo "$name .${tld} WHOIS_FREE"
      else
        echo "$name .${tld} WHOIS_REGISTERED"
      fi
    else
      echo "$name .${tld} NO_DNS_ONLY"
    fi
  done
done
```

Interpret finals domain results for the comparison table:
- `DNS_RESOLVES` → "taken"
- `WHOIS_FREE` → "likely available"
- `WHOIS_REGISTERED` → "registered (no DNS but whois confirms)"
- `NO_DNS_ONLY` → "no DNS (verify on registrar)"

### 7c. GitHub crowding check

Check if `GITHUB_TOKEN` is set:

```bash
[ -n "$GITHUB_TOKEN" ] && echo "GITHUB_TOKEN set" || echo "GITHUB_TOKEN not set"
```

**If not set:** Tell the user:
"GitHub crowding check requires a `GITHUB_TOKEN` env var. Set it with `export GITHUB_TOKEN=ghp_...`
and run `/namejam` again to include GitHub data in the finals. Skipping for now."

Show "n/a" in the GitHub column of the comparison table.

**If set:** Check each finalist:

```bash
UA="namejam/0.4.0 (https://github.com/FireflySentinel/namejam)"
for name in FINALIST1 FINALIST2 FINALIST3; do
  count=$(curl -s -A "$UA" -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $GITHUB_TOKEN" \
    --max-time 3 \
    "https://api.github.com/search/repositories?q=${name}+in:name&per_page=1" 2>/dev/null \
    | grep -o '"total_count":[0-9]*' | grep -o '[0-9]*')
  echo "$name github ${count:-error}"
done
```

Interpret: 0 = unique namespace, 1-5 = low crowding, 6-50 = moderate, 50+ = crowded.

### 7d. Present comparison table

```
## Finals: Deep-Dive Comparison

  Name        .com    .ai     .io     .dev    .net    GitHub    Registry
  ──────────  ──────  ──────  ──────  ──────  ──────  ────────  ────────
  callit      avail   avail   taken   avail   taken   3 repos   npm: avail
  mintname    avail   taken   taken   avail   avail   0 repos   npm: avail
  namecast    reg'd   avail   avail   taken   taken   12 repos  npm: avail

  Legend: avail = whois not found | taken = DNS resolves | reg'd = whois registered, no DNS
          no DNS = no A record, verify on registrar | N repos = GitHub search results
```

After the table, give a brief recommendation:
- Which name has the best overall availability?
- Which has the cleanest GitHub namespace?
- Note any concerns (e.g., "namecast has 12 GitHub repos, might cause confusion").

Then tell the user: "Verify your final choice on the actual registrar before creating the repo."

---

## Notes

- Future versions may add: check mode (verify user-supplied names),
  taste engine (learn your preferences across sessions), and automated benchmarking.
- The quality rubric is a guideline for the LLM, not an external scoring engine.
  Name quality will improve as the prompt is calibrated through real usage.
