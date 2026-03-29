# TODOS

## Check Mode
**What:** Support `/namejam check vexlo kontra zikta` — user supplies their own name candidates, tool checks availability across all registries + domain.
**Why:** The generation feature solves "I need a name." Check mode solves "I have a name, is it available?" Both are real user needs.
**Pros:** Doubles the tool's usefulness. Same checking infrastructure.
**Cons:** Slightly more prompt complexity. Need to handle edge cases (too many names, invalid characters).
**Effort:** XS (human: ~15min / CC: ~5min)
**Priority:** P2
**Depends on:** Nothing

## Automated Benchmark Harness
**What:** Make the 30-project benchmark suite (benchmark/test-inputs.md) runnable as a one-command regression test.
**Why:** Every prompt change risks quality regression. A one-command benchmark run catches it before shipping.
**Pros:** Prevents quality regressions. Builds confidence for faster prompt iteration.
**Cons:** Needs LLM-as-judge scoring (costs tokens per run).
**Effort:** S (human: ~1 day / CC: ~30 min)
**Priority:** P2
**Depends on:** Nothing

## Taste Engine
**What:** Persistent taste-learning profile in ~/.namejam/taste.json. The prompt adapts to your naming style over sessions.
**Why:** Names should get better each session, not start cold every time.
**Pros:** Genuinely differentiated. No other naming tool learns your preferences.
**Cons:** Unproven UX. Unclear if LLM can use taste data well.
**Effort:** M (human: ~1 week / CC: ~1 hour)
**Priority:** P3
**Depends on:** Automated benchmark (to verify taste engine doesn't regress quality)

## Strengthen Origin Test for Single Words
**What:** The origin test ("[name] means [meaning]") is trivially passed by any English dictionary word. Single-word candidates should require a specific connection to the project's domain, not just a dictionary definition.
**Why:** Outside voice from eng review caught that "Stripe means a line" passes the test but doesn't prove the name fits the project.
**Effort:** XS (human: ~15min / CC: ~5min)
**Priority:** P2
**Depends on:** Manual eval data showing whether this is actually a source of duds
