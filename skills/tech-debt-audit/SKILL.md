---
name: tech-debt-audit
description: >-
  Use when identifying, recording, or prioritizing technical debt. Provides
  the decision framework for distinguishing real debt from style preferences,
  and the recording format for tracking it.
---

# Tech Debt Audit

Decision context for identifying and managing technical debt. Real debt has measurable future cost. Style preferences, even strongly held ones, are not debt.

## Decision Framework: Is This Actually Debt?

**It IS debt when:**
- A shortcut will force extra work on the next N changes to this area
- A boundary violation means one change will cascade into many files
- A missing abstraction causes the same bug pattern to recur
- Test gaps mean changes require manual verification of unrelated features
- Documentation drift means agents waste time rediscovering context

**It is NOT debt when:**
- You would write it differently but the current approach works and is clear
- It uses an older pattern that still functions correctly
- It's "not how we'd do it today" but changing it has no concrete benefit
- The code is rarely touched and carries no maintenance burden

**The litmus test:** Can you name a specific future scenario where this shortcut costs real time or causes a bug? If not, it's a preference, not debt.

## Audit Triggers

Run a debt audit when:
- Starting work in an area and encountering repeated friction
- A bug is caused by structural issues rather than logic errors
- A feature takes 3x longer than expected due to existing code
- Code review reveals systemic patterns, not one-off issues
- Before a major architectural change (to scope the real problem)

## Audit Scope

**Focused audit:** One component or boundary. Look for:
- Coupling that shouldn't exist
- Missing error handling patterns
- Test gaps in critical paths
- Documentation that contradicts implementation

**Broad audit:** Whole codebase. Look for:
- Inconsistent patterns across similar components
- Abandoned migrations (half old pattern, half new)
- Dead code that obscures live code
- Dependency risks (unmaintained, vulnerable, duplicated)

## Recording Format

Record findings in `docs/tech-debt-tracker.md` using the format in `reference/tracker-format.md`.

Key principles:
- Every entry has a concrete cost statement (not "this is messy")
- Every entry has a trigger condition (when does this become urgent?)
- Severity reflects future cost, not current ugliness
- Entries get resolved (closed) when addressed or when the area is deleted

## Remediation Thresholds

| Severity | Trigger to fix | Acceptable to defer |
|----------|---------------|-------------------|
| Critical | Next sprint / before new features in area | Never more than one cycle |
| High | When next touching this area | Until the area is actively worked on |
| Medium | When the pain is felt concretely | Indefinitely if area is stable |
| Low | Opportunistically during related work | Forever if cost stays low |

## Principles

- **Evidence over opinion:** Cite the concrete future cost, not the aesthetic offense
- **Context matters:** Debt in frequently-changed code is worse than debt in stable code
- **Debt is a choice:** Sometimes incurring debt is correct (ship now, fix when validated)
- **Track to close:** An entry that lives in the tracker forever with no trigger is not debt, it's a wish

## Verification

A debt audit is useful when:
- Each entry could convince a skeptical engineer to prioritize the fix
- Entries distinguish between "costs us time now" and "might cost us time later"
- The tracker has entries that get resolved, not just accumulated
- Audit findings lead to concrete work items, not just documentation
