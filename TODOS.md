# TODOS

## v2: Check Mode
**What:** Support `/name check vexlo kontra zikta` — user supplies their own name candidates, tool checks availability across all registries + domain.
**Why:** The generation feature solves "I need a name." Check mode solves "I have a name, is it available?" Both are real user needs. The outside voice from eng review specifically called this out.
**Pros:** Doubles the tool's usefulness. Trivial to implement (if $ARGUMENTS contains words, check those instead of generating). Same checking infrastructure.
**Cons:** Slightly more prompt complexity. Need to handle edge cases (too many names, invalid characters).
**Context:** User deferred this during CEO review (wants v1 focused on generation). Two independent outside voice reviews suggested this. The checking infrastructure already exists in v1 — check mode is just a different entry point.
**Effort:** XS (human: ~15min / CC: ~5min)
**Priority:** P2
**Depends on:** v1 shipping first

## v0.3.0: Benchmark Regression Test
**What:** Make the v0.2.0 benchmark harness reusable as a regression test for SKILL.md changes.
**Why:** Every prompt change risks quality regression. A one-command benchmark run catches it before shipping.
**Pros:** Prevents quality regressions. Builds confidence for faster prompt iteration.
**Cons:** Needs maintenance as scoring rubric evolves. LLM-as-judge costs tokens per run.
**Context:** The benchmark harness is built for v0.2.0. Making it reusable is ~5 min of cleanup (parameterize the before/after comparison, add a "pass/fail" exit code).
**Effort:** XS (human: ~15min / CC: ~5min)
**Priority:** P2
**Depends on:** v0.2.0 benchmark harness existing
