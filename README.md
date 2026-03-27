# /namejam

Generate available project names with taste. A Claude Code slash command that reads your project, generates short memorable names (think Stripe, Linear, Notion), checks availability across GitHub, npm, PyPI, and domains, and shows only names you can actually use.

## Table of contents

- [The problem](#the-problem)
- [What it does](#what-it-does)
- [How it works](#how-it-works)
- [Install](#install)
- [Requirements](#requirements)
- [Name quality](#name-quality)
- [Checked registries](#checked-registries)
- [Future plans](#future-plans)
- [License](#license)

## The problem

AI suggests names that are already taken everywhere. Manually checking GitHub, npm, PyPI, and domains is tedious. Existing generators produce generic "adjective-noun" garbage. No tool combines good name generation with availability checking in your terminal.

## What it does

```
> /namejam

Reading project context...

What kind of project is this?
  1. Startup / product
  2. Open source project
  3. Dev tool / library
  4. Internal / personal

> 2

Available names for your project

  1. callit    — "call it" — literally what the tool does
                 npm: available | domain: callit.com appears free
  2. stampo    — evokes stamping an identity, playful and memorable
                 domain: stampo.com appears free
  3. namae     — Japanese for "name" (名前), distinctive, easy to say
                 npm: available | domain: namae.com appears free
  4. tagit     — "tag it" — quick, decisive, CLI-friendly
                 domain: tagit.com appears free
  5. scelta    — Italian for "choice" — naming is choosing
                 domain: scelta.com appears free

Close but taken
  - monkr    — "moniker" truncated, great semantics — monkr.com resolves
  - forja    — Spanish "forge," perfect metaphor — forja.com resolves
  - coind    — "coined," the exact creative act — coind.com resolves

Checked: npm, .com domains
Results are approximate. Verify your chosen name before creating the repo.

Don't love these? Say "more" and I'll generate 25 more with a different creative direction.
```

## How it works

1. Reads your project context (README, package.json, pyproject.toml, etc.)
2. Asks what kind of project this is — startup, open source, dev tool, or internal (different naming strategies)
3. Generates 25 candidate names prioritizing meaningful names over random syllables
4. Checks all 25 against npm/PyPI/crates.io (if relevant) and .com domains via DNS
5. Optionally checks GitHub namespace crowding (requires `GITHUB_TOKEN`)
6. Shows up to 5 available names + close-but-taken alternatives
7. Say "more" to generate 25 more with a different creative direction

## Install

### Option A: Global install (recommended — works in any project)

```bash
git clone https://github.com/FireflySentinel/namejam.git ~/.claude/skills/namejam
cd ~/.claude/skills/namejam && ./setup
```

This gives you `/namejam` everywhere, with automatic update checks.

### Option B: Per-project install (vendored)

```bash
git clone https://github.com/FireflySentinel/namejam.git .claude/skills/namejam
rm -rf .claude/skills/namejam/.git
cd .claude/skills/namejam && ./setup
```

Commit `.claude/skills/namejam/` and `.claude/commands/namejam.md` to your repo so the whole team gets `/namejam`.

### Option C: Clone and run directly

```bash
git clone https://github.com/FireflySentinel/namejam.git
cd namejam
```

Then use `/namejam` in Claude Code from that directory (no setup needed).

## Requirements

- [Claude Code](https://claude.ai/code) (the CLI)
- `curl` (pre-installed on macOS/Linux)
- `dig` (pre-installed on macOS/Linux, part of `dnsutils` on some distros)
- Optional: `GITHUB_TOKEN` env var to enable GitHub namespace crowding checks

## Name quality

Generated names follow these taste constraints:

- 4-12 characters (4-8 ideal)
- 2-3 syllables
- CVCV/CVCCV phoneme patterns (like "Stripe", "Slack", "Vercel")
- No common English dictionary words
- No -ify, -ly, -hub, -base suffixes
- Scored on: length, syllables, spelling clarity, terminal appearance, memorability

## Checked registries

| Registry | When checked | Signal |
|---|---|---|
| GitHub Search | Only if `GITHUB_TOKEN` is set | Namespace crowding (how many repos use this name) |
| npm | If `package.json` exists | Package availability (404 = available) |
| PyPI | If `pyproject.toml`/`setup.py` exists | Package availability |
| crates.io | If `Cargo.toml` exists | Crate availability |
| DNS (.com) | Always | Approximate domain signal |

## Future plans

- **Check mode:** `/namejam check vexlo kontra zikta` to verify your own name ideas
- **Scoring system:** Rate names on memorability, pronounceability, SEO, cultural sensitivity
- **Style presets:** `--style japanese`, `--style latin`, `--style compound`
- **MCP server:** Use with any AI coding tool, not just Claude Code

## License

MIT
