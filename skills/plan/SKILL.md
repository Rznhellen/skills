---
name: plan
description: >-
  Use when starting non-trivial work that spans multiple files or has trade-offs,
  when the user asks for a plan, or when you need to align on approach before
  implementing. Produces Claude-style execution plans with decision context.
---

# Plan

Produce structured execution plans that capture the shape of work and the judgment calls within it — not flat task checklists.

## Decision Framework

**When to plan:**
- Work touches 3+ files or has architectural implications
- Multiple valid approaches exist and you need to pick one
- The task will take more than one session or involve handoffs
- The user explicitly asks for a plan

**When NOT to plan:**
- Simple bug fixes with obvious solutions
- Single-file changes with no trade-offs
- Work that's faster to just do than to plan

## Plan Format

```markdown
# [Plan Title]

**Goal:** [One sentence — what does "done" look like?]
**Scope:** [What's in, what's explicitly out]

## Phases

### Phase N: [Name]
**Acceptance criteria:** [How we know this phase is done]
**Depends on:** [Prior phases or external inputs]
**Key decisions:** [Trade-offs the agent will need to navigate]
**Verification:** [Concrete check — test, command, screenshot]

## Open Questions
[Things that need answering before or during execution]

## Risks
[What could go wrong, and what's the fallback]
```

## What Good Looks Like

- Plans read as "here's the shape of the work and the judgment calls" not "here's a checklist"
- Each phase is a vertical slice: independently completable and verifiable
- Key decisions are surfaced explicitly — not buried in implementation
- Plans live in `docs/exec-plans/active/` and move to `completed/` when done
- Plans get updated when the approach changes — they're living documents, not commitments

## Principles

- **Decision context over task lists:** explain WHY at each fork, not just WHAT
- **Vertical slices:** each phase cuts through all layers, is demoable on its own
- **Explicit scope boundaries:** what's OUT is as important as what's IN
- **Verification per phase:** don't batch all testing to the end
- **Open questions are first-class:** unknowns belong in the plan, not hidden in the work

## Verification

A good plan passes this check:
- Could a different agent pick this up cold and make the same decisions?
- Are the phase boundaries at natural integration points?
- Is every "Key decisions" entry actually a fork (not just "do the obvious thing")?
- Does the verification criteria tell you what to run, not just "test it"?
