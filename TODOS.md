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
