---
name: harness-evolution
description: >-
  Use when consolidating agent friction feedback into harness improvements, or
  when assessing overall harness health. The meta-skill that makes the suite
  self-improving.
---

# Harness Evolution

Turns agent struggles into system improvements. Friction logged during work becomes concrete updates to skills, docs, and scripts on a regular cadence.

## Core Principle

Every repeated friction point is a harness bug. The fix is never "remember harder" — it's a better artifact that prevents the next agent from hitting the same wall.

## Logging Friction (During Work)

Any agent encountering friction should log it immediately. See `reference/feedback-format.md` for the entry format.

**What counts as friction:**
- Missing context that required guessing or asking
- Incorrect/outdated guidance that caused wasted work
- Ambiguity that two agents would resolve differently
- A skill that didn't cover an edge case actually encountered

**What is NOT friction (don't log):**
- Normal complexity of the problem domain
- Gaps in the agent's own knowledge/capabilities
- One-off issues unlikely to recur

## Consolidation Process

Invoke manually on a daily or weekly cadence. The consolidator:

1. **Collect** — Read all entries in `docs/harness-feedback/`
2. **Deduplicate** — Group entries by skill/area, merge duplicates
3. **Prioritize** — Rank by frequency and severity:
   - Blockers (agent couldn't proceed) > Slowdowns (extra steps needed) > Paper cuts (minor confusion)
4. **Propose** — For each high-priority cluster, draft a concrete fix:
   - Missing info → add to relevant SKILL.md or doc
   - Wrong info → correct the source
   - Missing skill → propose new skill scope
   - Recurring manual step → propose a script or hook
5. **Apply** — Implement the fixes, then archive processed feedback entries
6. **Verify** — After applying, check that the fix would have prevented the original friction

## Harness Health Assessment

Use this framework to evaluate the overall state of the harness:

| Signal | Healthy | Unhealthy |
|--------|---------|-----------|
| Agent onboarding | Productive after reading root docs | Requires chat/human context to start |
| Consistency | Same task, same quality across agents | Output varies wildly by agent |
| Feedback volume | Decreasing over time per area | Same friction reported repeatedly |
| Skill coverage | Most work fits an existing skill | Agents frequently improvise from scratch |
| Doc freshness | Docs match current code behavior | Drift detected regularly |

## Decision Framework: What to Update

| Friction pattern | Fix category |
|-----------------|--------------|
| "I didn't know X existed" | Discoverability — add cross-reference or update CLAUDE.md |
| "X said Y but reality is Z" | Accuracy — fix the source doc |
| "I wasn't sure whether to do A or B" | Judgment — add decision framework to relevant skill |
| "I had to do 5 manual steps for routine thing" | Automation — script, hook, or CI job |
| "No guidance existed for this situation" | Coverage — new skill or skill extension |

## Anti-patterns

- Logging friction then never consolidating (feedback rots)
- Over-documenting stable areas (maintenance cost exceeds value)
- Fixing friction with more prose when a script would be better
- Updating docs without verifying the fix resolves the original issue

## Verification

The evolution process is working when:
- Feedback entries for the same area trend toward zero
- New agents succeed without needing the same verbal guidance twice
- Skills grow through real friction, not speculative additions
- The harness stays lean — removals happen alongside additions
