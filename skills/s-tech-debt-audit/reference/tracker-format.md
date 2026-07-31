# Tech Debt Tracker Format

Recording format for `docs/tech-debt-tracker.md`. Each entry follows this structure.

## Entry Format

```markdown
## [ID] Short descriptive title

**Severity:** Critical | High | Medium | Low
**Area:** [component, module, or boundary affected]
**Identified:** [date] | **By:** [agent or person]
**Status:** Open | In Progress | Resolved | Accepted

### Cost Statement
[One to three sentences: what concrete future cost does this debt impose?
Not "this is messy" — what specifically takes longer, breaks more often,
or confuses future work because of this?]

### Evidence
[What triggered this identification? A bug, slow feature work, repeated
friction, code review finding? Include file paths or patterns.]

### Trigger Condition
[When does this become urgent? "Next time someone adds a new X" or
"When we need to change Y" or "Already blocking — every change to Z
requires touching N files."]

### Remediation Direction
[High-level approach. Not a full implementation plan — just enough that
someone picking this up knows the shape of the fix.]

### Resolution
[Filled in when closed: what was done, or why it was accepted/deleted.]
```

## Example Entry

```markdown
## TD-007 Payment service error handling is stringly-typed

**Severity:** High
**Area:** services/payment/
**Identified:** 2026-03-15 | **By:** code-review agent
**Status:** Open

### Cost Statement
Every new payment integration requires manually matching error strings
to determine retry behavior. Last two integrations each had a bug from
mismatched strings that took ~4 hours to diagnose.

### Evidence
- Bug #234: Stripe retry on "card_declined" vs "card declined" mismatch
- Bug #251: PayPal error string changed between API versions, silent failure
- Five different error-matching patterns across payment handlers

### Trigger Condition
Next payment provider integration, or next time Stripe/PayPal changes
their error format.

### Remediation Direction
Define an enum of payment error categories. Map provider-specific errors
to the enum at the adapter boundary. All retry/routing logic uses the enum,
never raw strings.

### Resolution
[pending]
```

## Tracker File Structure

```markdown
# Technical Debt Tracker

Last audit: [date]
Open items: [count] | Resolved this quarter: [count]

## Critical

[entries]

## High

[entries]

## Medium

[entries]

## Low

[entries]

## Resolved (last 90 days)

[closed entries with resolution notes]
```

## ID Convention

Use `TD-NNN` sequential numbering. Don't reuse IDs from resolved items.
When referencing debt in code comments, use the ID: `// TODO(TD-007): replace with error enum`
