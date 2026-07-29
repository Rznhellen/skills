---
name: architecture-decision
description: >-
  Use when making a technical decision that involves trade-offs future
  developers or agents will need to understand — architecture, library
  choice, data model, protocol, or integration approach.
---

# Architecture Decision Records

## When to write an ADR

Write one when:

- The decision is **reversible but expensive** to reverse (migration cost)
- Multiple reasonable options exist and you chose one for non-obvious reasons
- A future agent or developer will ask "why did we do it this way?"
- The decision constrains future decisions (creates a dependency or rules something out)

Skip when:

- The choice is obvious and uncontroversial (use the standard library's HTTP client)
- It's easily changeable with no downstream impact (variable naming)
- It's already documented elsewhere (framework docs, existing ADR)

## ADR format

Use the template in `reference/adr-template.md`. The format is:

1. **Title** — short imperative phrase ("Use Firestore for job state")
2. **Status** — proposed | accepted | deprecated | superseded by [ADR-xxx]
3. **Context** — the forces at play, what problem triggered this decision
4. **Decision** — what we chose and why (the "why" is the most important part)
5. **Consequences** — what becomes easier, what becomes harder, what we accept

## Where ADRs live

```
docs/design-docs/
  adr-001-use-firestore-for-state.md
  adr-002-buildpacks-over-dockerfiles.md
  ...
```

Number them sequentially. Never renumber. Superseded ADRs stay in place with updated status pointing to the replacement.

## Decision quality checklist

Before finalizing an ADR, verify:

- [ ] Context explains *why now* — what triggered this decision?
- [ ] At least two alternatives were considered (even if briefly)
- [ ] The decision states what was chosen AND why the alternatives lost
- [ ] Consequences are honest — includes downsides and accepted risks
- [ ] A reader unfamiliar with the project can understand the reasoning

## Linking ADRs to code

When implementing a decision:

- Reference the ADR in a code comment at the architectural boundary
- Example: `// See docs/design-docs/adr-003-oidc-auth.md for why we use ID tokens here`
- Don't duplicate the ADR content in code comments — just point to it

## Lightweight by design

An ADR should take 10-20 minutes to write. If it's taking longer, you're either:

- Including implementation details that belong in code (trim the ADR)
- Making multiple decisions that should be separate ADRs (split them)
- Not yet clear enough on the decision (think more before writing)
