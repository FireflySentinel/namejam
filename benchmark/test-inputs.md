# namejam Benchmark Test Inputs

30 tests: 10 Startup, 10 OSS, 10 Dev Tool. All are real successful projects.
Run /namejam on each. Compare generated names against the real adopted name.

**How to use:**
1. cd into an empty temp directory for each test
2. Create a minimal project file matching the type (package.json, pyproject.toml, etc.)
3. Run /namejam, select the project type and style indicated
4. Record the top 5 available names in the Results section
5. After all tests, reveal the real names and compare

---

## Startup (10 tests)

### Test S1: Payments API
**Type:** Startup / product | **Style:** Single word
**Description:** "An API for accepting online payments. Developers integrate it into their website or app to process credit cards, subscriptions, and invoices. The core value is making payments infrastructure invisible — developers never think about PCI compliance or bank integrations."
**Setup:** `package.json` | **Real name:** ||Stripe||

### Test S2: Design Collaboration Platform
**Type:** Startup / product | **Style:** Single word
**Description:** "A collaborative interface design tool that runs entirely in the browser. Designers and developers work on the same file simultaneously, like Google Docs for design. Replaces desktop apps like Sketch and Adobe XD. The product is the real-time collaboration — seeing cursors move, leaving comments on specific pixels."
**Setup:** `package.json` | **Real name:** ||Figma||

### Test S3: Note-taking / Knowledge Base
**Type:** Startup / product | **Style:** Single word
**Description:** "An all-in-one workspace for notes, docs, databases, wikis, and project management. Every page is a collection of blocks (text, tables, code, embeds) that users arrange freely. Teams use it to replace Google Docs, Confluence, Trello, and spreadsheets with one tool."
**Setup:** `package.json` | **Real name:** ||Notion||

### Test S4: Frontend Cloud Platform
**Type:** Startup / product | **Style:** Single word
**Description:** "A cloud platform for frontend developers. Deploy websites and web apps instantly from a git push. Automatic HTTPS, global CDN, serverless functions, and preview deployments for every pull request. Built for the modern JavaScript ecosystem — works natively with React, Next.js, and other frameworks."
**Setup:** `package.json` | **Real name:** ||Vercel||

### Test S5: Project Management for Software Teams
**Type:** Startup / product | **Style:** Single word
**Description:** "A project management tool built specifically for software engineering teams. Issue tracking, sprint planning, and roadmaps with a keyboard-first interface designed for speed. Every interaction is instant — no loading spinners, no page refreshes. Built to replace Jira for teams who care about speed and craft."
**Setup:** `package.json` | **Real name:** ||Linear||

### Test S6: Developer Authentication
**Type:** Startup / product | **Style:** Single word
**Description:** "A drop-in authentication and user management service for web applications. Provides pre-built sign-in UI components, session management, multi-factor auth, and user profile pages. Developers add auth to their app in minutes instead of building it from scratch. Handles the full identity lifecycle."
**Setup:** `package.json` | **Real name:** ||Clerk||

### Test S7: Financial Data Connectivity
**Type:** Startup / product | **Style:** Single word
**Description:** "An API that connects applications to users' bank accounts. Apps use it to verify identity, check balances, and initiate payments by linking directly to financial institutions. The product sits between fintech apps and banks — a middleware layer for financial data access."
**Setup:** `package.json` | **Real name:** ||Plaid||

### Test S8: Corporate Card & Spend Management
**Type:** Startup / product | **Style:** Single word
**Description:** "A corporate charge card with built-in expense management. Employees get physical and virtual cards with spend limits set by managers. Every transaction is automatically categorized, receipts are matched, and expense reports are eliminated. The core pitch: save finance teams 10+ hours per month on expense reconciliation."
**Setup:** `package.json` | **Real name:** ||Ramp||

### Test S9: Serverless Postgres Database
**Type:** Startup / product | **Style:** Single word
**Description:** "A serverless Postgres database service. Separates compute from storage so databases scale to zero when idle and auto-scale up under load. Developers get a standard Postgres connection string but only pay for actual usage. Key feature: instant database branching for development and CI — spin up a copy of your production schema in milliseconds."
**Setup:** `package.json` | **Real name:** ||Neon||

### Test S10: Internal Tools Builder
**Type:** Startup / product | **Style:** Single word
**Description:** "A platform for building internal business tools quickly. Drag-and-drop UI builder that connects to any database or API. Engineers build admin panels, dashboards, CRUD apps, and approval workflows in hours instead of weeks. The target user is the backend engineer who needs to ship an internal tool but doesn't want to write frontend code."
**Setup:** `package.json` | **Real name:** ||Retool||

---

## Open Source (10 tests)

### Test O1: JavaScript Build Tool
**Type:** Open source project | **Style:** Single word
**Description:** "A next-generation frontend build tool that is significantly faster than webpack. Uses native ES modules during development (no bundling step), so the dev server starts instantly regardless of project size. Written to replace the slow feedback loop in large JavaScript projects."
**Setup:** `package.json` | **Real name:** ||Vite||

### Test O2: JavaScript Runtime
**Type:** Open source project | **Style:** Single word
**Description:** "An all-in-one JavaScript runtime and toolkit. Replaces Node.js for most use cases — runs JS/TS files, has a built-in package manager, test runner, and bundler. The key differentiator is speed: starts up and installs packages 10-100x faster than Node+npm."
**Setup:** `package.json` | **Real name:** ||Bun||

### Test O3: Git Hooks Manager
**Type:** Open source project | **Style:** Compound
**Description:** "A fast and configurable git hooks manager. Runs linters, formatters, and tests on staged files before each commit. Configured via a YAML file — define which commands run on which file types for pre-commit, pre-push, etc. Written in Go for zero-dependency installs."
**Setup:** `go.mod` | **Real name:** ||Lefthook||

### Test O4: Content-Driven Web Framework
**Type:** Open source project | **Style:** Single word
**Description:** "A web framework for content-driven websites. Generates static HTML by default but lets you add interactive components (React, Vue, Svelte) only where needed — called 'islands architecture.' Ships zero JavaScript to the browser unless a component specifically needs it. Built for blogs, docs sites, and marketing pages."
**Setup:** `package.json` | **Real name:** ||Astro||

### Test O5: Desktop App Framework
**Type:** Open source project | **Style:** Single word
**Description:** "A framework for building tiny, fast desktop applications using web technologies. Each app has a Rust backend for performance and security, with a webview frontend (HTML/CSS/JS). Produces binaries 10x smaller than Electron apps. The security model prevents the frontend from accessing the filesystem directly — all system access goes through the Rust backend."
**Setup:** `package.json` + `Cargo.toml` | **Real name:** ||Tauri||

### Test O6: JavaScript Toolchain (Linter + Formatter)
**Type:** Open source project | **Style:** Single word
**Description:** "A unified toolchain for JavaScript and TypeScript. Combines linting and formatting in one tool — replaces ESLint and Prettier. Written in Rust for speed. The design philosophy: one config file, zero plugins, opinions baked in. Targets teams exhausted by JavaScript tooling configuration."
**Setup:** `package.json` | **Real name:** ||Biome||

### Test O7: Git Hooks for npm
**Type:** Open source project | **Style:** Single word
**Description:** "A tool that makes git hooks easy for JavaScript projects. Install it as an npm dependency and it automatically sets up git hooks — typically pre-commit hooks that run linters before each commit. Zero configuration needed. The most popular git hooks tool in the npm ecosystem."
**Setup:** `package.json` | **Real name:** ||Husky||

### Test O8: Presentation Slides for Developers
**Type:** Open source project | **Style:** Compound
**Description:** "A tool that turns Markdown files into presentation slides. Write your talk in a .md file with slide separators and it renders a full slide deck in the browser. Supports code highlighting, LaTeX math, diagrams, and live coding. Built for developers who want to present from their editor, not PowerPoint."
**Setup:** `package.json` | **Real name:** ||Slidev||

### Test O9: Secure JavaScript Runtime
**Type:** Open source project | **Style:** Single word
**Description:** "A JavaScript and TypeScript runtime built with security as the primary design goal. No file, network, or environment access by default — every permission must be explicitly granted via command-line flags. Supports TypeScript natively without a compile step. Ships as a single binary with built-in formatter, linter, and test runner."
**Setup:** `package.json` | **Real name:** ||Deno||

### Test O10: Monorepo Build System
**Type:** Open source project | **Style:** Compound
**Description:** "A high-performance build system for JavaScript and TypeScript monorepos. Caches task results (build, test, lint) and never repeats work that's already been done. Understands the dependency graph between packages and runs tasks in the correct order. Remote caching lets the whole team share build artifacts — if your teammate already built a package, your machine skips it."
**Setup:** `package.json` | **Real name:** ||Turborepo||

---

## Dev Tool / Library (10 tests)

### Test D1: Fast grep Replacement
**Type:** Dev tool / library | **Style:** Compound
**Description:** "A command-line search tool that recursively searches directories for a regex pattern — like grep but much faster. Written in Rust for performance. Respects .gitignore, skips binary files, and supports Unicode. Designed to replace grep/ack/ag for large codebases."
**Setup:** `Cargo.toml` | **Real name:** ||ripgrep||

### Test D2: Fast Python Linter
**Type:** Dev tool / library | **Style:** Single word
**Description:** "An extremely fast Python linter and code formatter. Written in Rust, it replaces flake8, isort, pyflakes, and black — all in one tool. 10-100x faster than the tools it replaces. Designed for large Python monorepos where existing linters are too slow."
**Setup:** `pyproject.toml` | **Real name:** ||Ruff||

### Test D3: Better cat
**Type:** Dev tool / library | **Style:** Single word
**Description:** "A command-line tool that displays file contents with syntax highlighting, line numbers, and git integration. A replacement for cat that makes reading code in the terminal pleasant. Automatically pages long output, highlights diffs, and supports hundreds of programming languages."
**Setup:** `Cargo.toml` | **Real name:** ||Bat||

### Test D4: Disk Usage Analyzer
**Type:** Dev tool / library | **Style:** Single word
**Description:** "A command-line disk usage analyzer — a modern replacement for du. Shows directory sizes with a visual breakdown, sorted largest-first. Instant results on large filesystems. Written in Rust. Answers 'what's taking up all the space?' in one command."
**Setup:** `Cargo.toml` | **Real name:** ||Dust||

### Test D5: HTTP Client for Humans
**Type:** Dev tool / library | **Style:** Compound
**Description:** "A command-line HTTP client designed for testing APIs. Like curl but with a human-friendly syntax — colored output, JSON formatting by default, intuitive request syntax. You type the URL and method, it does the right thing. Built for developers who test APIs from the terminal every day."
**Setup:** `pyproject.toml` | **Real name:** ||HTTPie||

### Test D6: Code Statistics
**Type:** Dev tool / library | **Style:** Single word
**Description:** "A command-line tool that counts lines of code, comments, and blank lines in a codebase. Supports 150+ programming languages. Shows a breakdown by language in a formatted table. Used for getting a quick overview of a project's composition — 'how big is this codebase and what's it written in?'"
**Setup:** `Cargo.toml` | **Real name:** ||Tokei||

### Test D7: File Watcher & Command Runner
**Type:** Dev tool / library | **Style:** Compound
**Description:** "A command-line tool that watches files for changes and runs a command when they change. You give it a command and it re-runs it every time a source file is modified. Respects .gitignore, debounces rapid changes, and supports complex filter rules. Used for auto-running tests, rebuilding projects, and restarting servers during development."
**Setup:** `Cargo.toml` | **Real name:** ||Watchexec||

### Test D8: Better find
**Type:** Dev tool / library | **Style:** Single word
**Description:** "A command-line tool for finding files and directories — a simpler, faster alternative to the unix find command. Intuitive syntax: just type the pattern and it searches recursively. Respects .gitignore, colorized output, smart case matching, regex support. Written in Rust for speed."
**Setup:** `Cargo.toml` | **Real name:** ||fd||

### Test D9: Structural Diff Tool
**Type:** Dev tool / library | **Style:** Compound
**Description:** "A diff tool that understands programming language syntax. Instead of comparing text line-by-line, it parses source code into an AST and shows structural changes. Knows the difference between 'moved a function' and 'changed a function.' Supports 30+ languages. Shows what actually changed, not what lines shifted."
**Setup:** `Cargo.toml` | **Real name:** ||Difftastic||

### Test D10: Smarter cd Command
**Type:** Dev tool / library | **Style:** Single word
**Description:** "A smarter cd command for the terminal. Remembers which directories you visit frequently and lets you jump to them by typing a partial name. Type 'z proj' and it takes you to ~/projects/ because that's where you go most often. Learns from your habits — the more you use a path, the higher it ranks."
**Setup:** `Cargo.toml` | **Real name:** ||Zoxide||

---

## Results — v0.1.1 Baseline

### Startup (S1-S10)

| Test | Top 5 Names | Duds | Best | Notes |
|------|-------------|------|------|-------|
| S1 (Stripe) | vendex, payvel, slate, remit, coinark | 1 | slate | coinark forced. Too many pay-/coin- stems. |
| S2 (Figma) | pixync, canvox, vizjam, slate, prism | 3 | prism | pixync/canvox/vizjam are suffix-slap duds. |
| S3 (Notion) | canvex, pagecraft, loom, prism, scribe | 1 | loom | loom is excellent. canvex is suffix-slap. |
| S4 (Vercel) | | | | |
| S5 (Linear) | | | | |
| S6 (Clerk) | | | | |
| S7 (Plaid) | | | | |
| S8 (Ramp) | | | | |
| S9 (Neon) | | | | |
| S10 (Retool) | | | | |

### Open Source (O1-O10)

| Test | Top 5 Names | Duds | Best | Notes |
|------|-------------|------|------|-------|
| O1 (Vite) | forge, blitz, spark, hotmod, surge | 0 | forge | All solid single words. |
| O2 (Bun) | bolt, jolt, torq, rune, spark | 0 | bolt | Strong set. bolt/jolt/torq punchy. |
| O3 (Lefthook) | hookforge, tripwire, lockstep, gitsnap, precheck | 0 | tripwire | tripwire is clever. All usable. |
| O4 (Astro) | | | | |
| O5 (Tauri) | | | | |
| O6 (Biome) | | | | |
| O7 (Husky) | | | | |
| O8 (Slidev) | | | | |
| O9 (Deno) | | | | |
| O10 (Turborepo) | | | | |

### Dev Tool (D1-D10)

| Test | Top 5 Names | Duds | Best | Notes |
|------|-------------|------|------|-------|
| D1 (ripgrep) | ripfast, snapgrep, zapgrep, scandir, seekline | 2 | scandir | Too many -grep compounds. Mechanical. |
| D2 (Ruff) | lintjet, pyblaze, flint, blitz, snapfmt | 1 | flint | flint good. lintjet/pyblaze too literal. |
| D3 (Bat) | | | | |
| D4 (Dust) | | | | |
| D5 (HTTPie) | | | | |
| D6 (Tokei) | | | | |
| D7 (Watchexec) | | | | |
| D8 (fd) | | | | |
| D9 (Difftastic) | | | | |
| D10 (Zoxide) | | | | |

**Dud criteria:** Random syllables, suffix-slaps, unrecognizable foreign words, mechanical verb+noun with no wordplay, or names that fail the origin test.

---

## Results — v0.2.0 After Changes

### Startup (S1-S10)

| Test | Top 5 Names | Duds | Best | Notes |
|------|-------------|------|------|-------|
| S1 (Stripe) | | | | |
| S2 (Figma) | | | | |
| S3 (Notion) | | | | |
| S4 (Vercel) | | | | |
| S5 (Linear) | | | | |
| S6 (Clerk) | | | | |
| S7 (Plaid) | | | | |
| S8 (Ramp) | | | | |
| S9 (Neon) | | | | |
| S10 (Retool) | | | | |

### Open Source (O1-O10)

| Test | Top 5 Names | Duds | Best | Notes |
|------|-------------|------|------|-------|
| O1 (Vite) | | | | |
| O2 (Bun) | | | | |
| O3 (Lefthook) | | | | |
| O4 (Astro) | | | | |
| O5 (Tauri) | | | | |
| O6 (Biome) | | | | |
| O7 (Husky) | | | | |
| O8 (Slidev) | | | | |
| O9 (Deno) | | | | |
| O10 (Turborepo) | | | | |

### Dev Tool (D1-D10)

| Test | Top 5 Names | Duds | Best | Notes |
|------|-------------|------|------|-------|
| D1 (ripgrep) | | | | |
| D2 (Ruff) | | | | |
| D3 (Bat) | | | | |
| D4 (Dust) | | | | |
| D5 (HTTPie) | | | | |
| D6 (Tokei) | | | | |
| D7 (Watchexec) | | | | |
| D8 (fd) | | | | |
| D9 (Difftastic) | | | | |
| D10 (Zoxide) | | | | |

---

## Comparison

| Metric | v0.1.1 (n=150) | v0.2.0 (n=150) | Delta |
|--------|----------------|----------------|-------|
| Total duds | /150 | /150 | |
| Dud rate | % | % | |
| Names scoring 8+/10 | | | |
| "Would use over real name" | /30 | /30 | |
| Startup dud rate | /50 | /50 | |
| OSS dud rate | /50 | /50 | |
| Dev tool dud rate | /50 | /50 | |
