---
name: s-documentation-scaffold
description: >-
  Use after making a code change to determine which docs need updating, or when
  assessing documentation health and drift. Ongoing maintenance, not initial
  setup.
---

# Documentation Scaffold

Decision context for keeping documentation current. Answers the question: "I just changed something — what docs need updating and how?"

## Decision Framework: What to Update

After any change, walk through this checklist:

| What changed | Update target | Skip if... |
|-------------|---------------|------------|
| Public API (signature, behavior, return type) | API docs, ARCHITECTURE.md if structural | Internal refactor with same external behavior |
| New feature or capability | README (if user-facing), relevant skill docs | Behind a feature flag not yet enabled |
| Architecture (new service, changed data flow) | ARCHITECTURE.md, relevant diagrams | Purely internal reorganization with same boundaries |
| Configuration (new env var, setting, flag) | Setup docs, .env.example | Only used in tests |
| Breaking change | Migration guide, changelog, version bump | N/A — always document |
| Bug fix | Only if the bug revealed a doc inaccuracy | Fix matches existing doc expectations |
| Dependency update | Only if it changes setup steps or behavior | Patch version with no interface change |

## Documentation Quality Rubric

Good documentation is:

- **Accurate** — matches current behavior (test: could someone follow it blindly and succeed?)
- **Discoverable** — reachable from the entry point (CLAUDE.md / README) within 2 hops
- **Scoped** — one doc covers one concern; if it needs "and" in the title, split it
- **Actionable** — tells you what to do or decide, not just what exists
- **Current** — has been verified against code within the last significant change cycle

## Detecting Drift

Signs that docs have drifted from reality:

- Doc references file paths, function names, or CLI flags that no longer exist
- Setup instructions require undocumented steps to actually work
- Architecture diagram shows components that have been merged or removed
- Config examples use deprecated env vars or old defaults

**When you detect drift:** Fix it immediately if the correction is obvious. If not, log friction via harness-evolution and flag for human review.

## Regeneration Triggers

For generated docs (API references, schema docs, type docs):

- Regenerate when the source schema or types change
- Regenerate when the generation tool/config is updated
- Do NOT regenerate on every commit — batch with meaningful changes
- Always verify generated output didn't lose hand-written additions

## Doc Type Templates

See `reference/` for lightweight templates:
- `reference/adr-template.md` — Architecture Decision Record
- `reference/runbook-template.md` — Operational runbook

## Anti-patterns

- Duplicating information across multiple docs (one source of truth per fact)
- Writing docs for things that change weekly (prefer generated docs or code comments)
- Documenting obvious things the code already makes clear
- Leaving TODO placeholders in docs that never get filled

## Verification

Documentation is healthy when:
- A new agent or contributor can set up and ship a change using only repo docs
- Docs that reference code are within one release of current
- No critical operational knowledge lives only in chat history or tribal memory
- Generated docs have a clear regeneration command documented
