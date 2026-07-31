---
name: s-security-review
description: >-
  Use when assessing security of a code change, auditing an area for
  vulnerabilities, or building a threat model. Structured assessment with
  adversarial verification.
---

# Security Review

Structured security assessment for code changes and system areas. Two modes: targeted review (a specific change) and area audit (a component or boundary).

## Modes

### Review This Change
Scope: a diff, PR, or set of modifications.
Question: "Does this change introduce or worsen a vulnerability?"

### Audit This Area
Scope: a component, service boundary, or data flow.
Question: "What are the attack surfaces and how well are they defended?"

## Threat Model Structure

For any review, establish:

1. **Assets** — What's worth protecting? (data, access, availability)
2. **Actors** — Who might attack? (anonymous, authenticated, insider, adjacent service)
3. **Surfaces** — Where can actors interact? (APIs, inputs, config, dependencies)
4. **Assumptions** — What's trusted implicitly? (runtime, infra, upstream services)

See `reference/threat-model-template.md` for the full template.

## Review Dimensions

Assess against OWASP-aligned categories (see `reference/owasp-dimensions.md`):

- Injection and input validation
- Authentication and session management
- Authorization and access control
- Data exposure and cryptography
- Security misconfiguration
- Dependency vulnerabilities
- Logging and monitoring gaps

## Findings Format

Each finding should include:

```markdown
### [SEVERITY] Finding title

**Category:** [OWASP dimension]
**Location:** [file:line or component]
**Evidence:** [What you observed — code path, config, or data flow]
**Impact:** [What an attacker gains if exploited]
**Reproduction path:** [Steps to trigger, or why it's exploitable]
**Remediation direction:** [Fix approach, not full implementation]
```

Severity levels:
- **Critical** — Exploitable now, high impact, no mitigating controls
- **High** — Exploitable with moderate effort, significant impact
- **Medium** — Requires specific conditions or has partial mitigations
- **Low** — Theoretical, defense-in-depth improvement
- **Info** — Not a vulnerability, but worth noting for future awareness

## Adversarial Verification

For High and Critical findings, attempt to verify:

1. Can you trace input from an untrusted source to the vulnerable operation?
2. Are there intermediate sanitization/validation steps that block the path?
3. What's the minimal payload or condition to trigger the issue?
4. Does the runtime environment add protections not visible in code?

If you cannot construct a plausible attack path, downgrade the severity.

## Decision Framework

**Flag it** when:
- Untrusted input reaches a sensitive operation without validation
- Secrets appear in logs, URLs, client bundles, or version control
- Authorization checks are missing or bypassable
- Cryptographic choices are non-standard without documented rationale

**Don't flag** when:
- The "vulnerability" requires access the attacker already has
- Defense-in-depth is missing but primary controls are sound
- A theoretical attack requires unrealistic preconditions
- The risk is acknowledged and accepted in a threat model

## Verification

A security review is complete when:
- All data flows crossing trust boundaries are assessed
- Findings have evidence, not just suspicion
- Critical/High findings have adversarial verification attempted
- Remediation directions are actionable (not "fix the security")
- The review states what was NOT examined (scope boundaries)
