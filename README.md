# /namejam

Generate available project names with taste. A Claude Code slash command that reads your project, generates short memorable names (think Stripe, Linear, Notion), checks availability across npm, PyPI, crates.io, and domains, and shows only names you can actually use.

## Table of contents

- [The problem](#the-problem)
- [What it does](#what-it-does)
- [How it works](#how-it-works)
- [Install](#install)
- [Update](#update)
- [Uninstall](#uninstall)
- [Requirements](#requirements)
- [Name quality](#name-quality)
- [Checked registries](#checked-registries)
- [Future plans](#future-plans)
- [License](#license)

## The problem

AI suggests names that are already taken everywhere. Manually checking npm, PyPI, and domains is tedious. Existing generators produce generic "adjective-noun" garbage or random syllable inventions with no meaning. No tool combines good name generation with availability checking in your terminal.

## What it does

```
> /namejam

Running namejam v0.4.0

Reading project context...

What kind of project is this?
  1. Startup / product
  2. Open source project
  3. Dev tool / library
  4. Internal / personal

> 2

What naming style do you prefer?
  1. Single word (Recommended) — vite, bun, astro, biome
  2. Hyphenated — left-hook, fast-check, vue-router
  3. Compound — turborepo, ripgrep, slidev, unplugin
  4. Mix of all

> 2

Available names for your project

  1. eve-drop   — "eavesdrop" wordplay — listens for events
                   npm: available | domain: evedrop.com taken (DNS resolves)
  2. ark-feed   — arknights + feed — direct and clear
                   npm: available | domain: arkfeed.com taken (DNS resolves)
  3. cal-knit   — calendar + knit — weaving events into feeds
                   npm: available | domain: calknit.com no DNS record (does not mean unregistered — verify on registrar)
  4. ink-drop   — ink (notices) + drop — events landing
                   npm: available | domain: inkdrop.com taken (DNS resolves)
  5. ban-tap    — banner + tap — tapping into schedules
                   npm: available | domain: bantap.com no DNS record (does not mean unregistered — verify on registrar)

Close but taken
  - eve-sync   — taken on npm (eve-sync@1.0.0 exists)

Checked: npm, .com domains
Results are approximate. Verify your chosen name before creating the repo.

What would you like to do next?
  1. Shortlist favorites — pick 2-3 names for variations
  2. More names — generate 25 more with a different direction
  3. I'm done
```

## How it works

1. **Reads your project context** (README, package.json, pyproject.toml, etc.)
2. **Asks project type** — startup, open source, dev tool, or internal (each has a different naming strategy)
3. **Asks naming style** — single word, hyphenated, compound, prefix pattern, or mix (options vary by project type)
4. **Generates 25 candidate names** using compounds, blends, truncations, and meaningful single words — no random syllable inventions
5. **Checks availability** against npm/PyPI/crates.io (if relevant) and .com domains via DNS
6. **Filters by project type** — for startups, domain matters; for open source and dev tools, only registry availability counts
7. **Shows up to 5 available names** + close-but-taken alternatives
8. **Shortlist favorites** to get 5 variations per name (shorter, longer, respelled, reordered, synonym swap)
9. **Finals deep-dive** — checks .com, .ai, .io, .dev, .net + GitHub crowding for your top 2-3 finalists

## Install

### From Claude Code Marketplace (recommended)

```bash
claude plugin marketplace add FireflySentinel/namejam
claude plugin install namejam@FireflySentinel
```

Done. Type `/namejam` in any Claude Code session.

### Manual install

```bash
mkdir -p ~/.claude/skills/namejam
curl -fsSL https://raw.githubusercontent.com/FireflySentinel/namejam/main/skills/namejam/SKILL.md \
  -o ~/.claude/skills/namejam/SKILL.md
```

## Update

Marketplace installs update automatically. For manual installs, re-run the `curl` command above.

## Uninstall

```bash
# Marketplace install
claude plugin remove namejam@FireflySentinel
claude plugin marketplace remove FireflySentinel

# Manual install
rm -rf ~/.claude/skills/namejam
```

## Requirements

- [Claude Code](https://claude.ai/code) (the CLI)
- `curl` (pre-installed on macOS/Linux)
- `python3` (pre-installed on macOS and most Linux distros)
- Optional: `GITHUB_TOKEN` env var for GitHub namespace crowding checks in the finals round

## Name quality

Every generated name must pass the **origin test**:

> "[name] comes from [word1] + [word2]", or "[name] is a truncation of [word]", or "[name] means [meaning]."

If you can't complete that sentence, the name is rejected.

Generated names follow these constraints:

- 3-12 characters (4-8 ideal), 2-3 syllables
- Mix of **compounds** (Dropbox, Lefthook, Tripwire), **truncations** (monkr, flickr), **blends** (Vercel, Figma), and **single words** (Stripe, Ramp)
- No random syllable inventions (zerka, morfa, preka)
- No foreign words users won't recognize (waktu, ritmo, kurono)
- No lazy suffix-slapping (arkora, calzo, tevex)
- No -ify, -ly, -hub, -base, -io, -app suffixes
- Scored on: length, syllables, spelling clarity, terminal appearance, memorability (7+ average to be included)

## Checked registries

| Registry | When checked | Signal |
|---|---|---|
| npm | If `package.json` exists | Package availability (404 = available) |
| PyPI | If `pyproject.toml`/`setup.py` exists | Package availability |
| crates.io | If `Cargo.toml` exists | Crate availability |
| DNS (.com) | Always in initial check | Domain signal (informational for OSS/dev tools, filtering for startups) |
| DNS (.ai/.io/.dev/.net) | Finals deep-dive only | Multi-TLD availability |
| GitHub Search | Finals deep-dive only (requires `GITHUB_TOKEN`) | Namespace crowding (0-5 repos = unique, 50+ = crowded) |

## Future plans

- **Check mode:** `/namejam check vexlo kontra zikta` to verify your own name ideas
- **Benchmark regression test:** Automated quality testing for prompt changes
- **Taste engine:** Learn your naming preferences across sessions

## License

MIT
