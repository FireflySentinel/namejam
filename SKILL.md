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

### Name shape diversity (MANDATORY)
Names must NOT all be single dictionary words. Mix these shapes across the 25 candidates:
- **Compounds:** Two short words jammed together — callit, tagit, namejam, nametap, getpick, shiplog
- **Truncations:** Chopped/respelled real words — monkr, flickr, tumblr, brandr, pickr, titlr
- **Blends:** Parts of two words fused — Vercel (universal+excel), Figma (figure+magma), Twilio (twilight+IO)
- **Single words:** Real or invented standalone words — Stripe, Notion, Ramp, Bun, Husky

**Minimum diversity rule:** Of the 25 names, at least 8 must be compounds or blends, at least 4 must be
truncations, and no more than 8 may be single standalone words.

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

**The test:** For every name, you must be able to complete this sentence:
"[name] comes from [word1] + [word2]" or "[name] is a truncation of [word]" or "[name] means [meaning]."
If you can't, delete it and generate a replacement.

### Name generation strategy (DIFFERENT per project type)

The user's project type selection **completely changes** the naming style, not just the
count. Follow the section that matches the user's choice.

---

#### If Startup / product:

Think pitch deck, investor meeting, domain name on a business card. Every name should
feel like it could be a $1B company. Avoid anything techy, nerdy, or that sounds like
a side project.

**Reference names:** Stripe, Notion, Vercel (blend), Resend (compound), Clerk, Neon, Ramp, Fivetran (blend), Plaid

**Generate in this order:**
1. **~10 brand-first blends/compounds:** Two concepts fused into one word that evokes the
   product's value. "Vercel" = universal+excel, "Resend" = re+send, "Fivetran" = five+transform.
   Should look good on a landing page hero section.
2. **~8 truncated/respelled real words:** Chop or respell a meaningful word. "Clerk" from clerical,
   "Plaid" = the fabric pattern (trust/weaving), "Neon" = the element (bright/new).
3. **~4 sharp single words:** Real English words repurposed. "Stripe" = a line (payments),
   "Ramp" = acceleration. Must connect to the product's purpose.
4. **~3 creative compounds:** Two short words jammed together. Think "Airbnb", "Dropbox", "Mailchimp".

---

#### If Open source project:

Think GitHub trending page, dev Twitter, conference lightning talks. Names should be
fun to say, fun to type, and make people curious. Can be playful, quirky, unexpected.
Domain is nice-to-have, not critical — README and GitHub stars matter more.

**Reference names:** Vite, Bun, Astro, Tauri, Turborepo (compound), Biome, Lefthook (compound), Husky, Slidev (blend), Unplugin (blend)

**Generate in this order:**
1. **~10 semantic compounds/blends:** Two concepts fused or jammed together that hint at purpose.
   "Turborepo" = turbo+repo, "Slidev" = slide+dev, "Unplugin" = un+plugin, "Lefthook" = left+hook.
   The name should make someone curious about what it does.
2. **~8 truncated/respelled words:** Chop or respell a word that connects to the project.
   "Astro" from astronomy/fast, "Biome" from ecosystem, "Husky" = guard dog (git hooks).
   Must have a clear semantic connection — not random syllables.
3. **~4 sharp single words:** Real English words that fit. "Bun" = a bun (bundler), "Vite" (ok
   this is French but it means "fast" and everyone knows it). Strong, short, purposeful.
4. **~3 creative respellings:** Drop vowels or swap letters. "flickr", "tumblr", "monkr" style.
   Only if the base word connects to the project.

---

#### If Dev tool / library:

Think terminal, man page, dotfile config. Names should telegraph what the tool does.
Ultra-short is ideal (3-6 chars). The name should make someone guess the tool's
purpose, or at least not be surprised when they learn it.

**Reference names:** Grep, Curl, Ruff, Bat, Httpie (blend), Ripgrep (compound), Tokei (single), Difftastic (blend), Watchexec (compound), Dust

**Generate in this order:**
1. **~10 function-telegraphing compounds:** Two short words or abbreviations that describe
   the tool's action. "Ripgrep" = rip+grep, "Watchexec" = watch+exec, "Difftastic" = diff+fantastic.
   Should answer "what does this do?" from the name.
2. **~8 truncated action words:** Chopped verbs or nouns that hint at purpose. "Ruff" = rough/fast,
   "Bat" = better cat, "Dust" = du+rust. 3-6 chars, punchy, typeable.
3. **~4 sharp blends:** Fuse two concepts. "Httpie" = HTTP+pie, "Tokei" = Japanese for clock.
   Must telegraph function.
4. **~3 creative respellings:** "grepr", "difft", "logr" style. Only if the base word is obvious.

---

#### If Internal / personal:

Think project codenames, internal Slack channels, team wikis. Fun, short, memorable
within a small group. No need for global uniqueness or domain availability.

**Reference names:** Cobra, Phoenix, Atlas, Falcon, Topgun (compound), Redfox (compound), Onyx, Nova, Icepick (compound), Echo

**Generate in this order:**
1. **~10 meaningful codenames:** Words from nature, mythology, space, or materials
   that loosely relate to the project's purpose or personality.
2. **~8 compound codenames:** Two short words that form a vivid image. "Topgun", "Redfox",
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
