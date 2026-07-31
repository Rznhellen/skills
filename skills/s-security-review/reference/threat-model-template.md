# Threat Model Template

Use this structure when assessing a component, service, or change.

## System Context

**Component:** [Name and brief purpose]
**Trust boundary:** [Where this component sits relative to untrusted input]
**Data sensitivity:** [What data flows through — PII, credentials, financial, public]

## Assets

| Asset | Sensitivity | Impact if compromised |
|-------|------------|----------------------|
| [e.g., user credentials] | High | Account takeover |
| [e.g., session tokens] | High | Impersonation |
| [e.g., business data] | Medium | Data leak, compliance violation |

## Actors

| Actor | Access level | Motivation |
|-------|-------------|------------|
| Anonymous external | Network access only | Opportunistic, automated |
| Authenticated user | Valid session | Privilege escalation, data access |
| Adjacent service | Internal network | Lateral movement |
| Insider / compromised dependency | Code-level | Exfiltration, persistence |

## Attack Surfaces

| Surface | Entry point | Current controls |
|---------|-------------|-----------------|
| [e.g., REST API] | [endpoints] | [auth, rate limiting, validation] |
| [e.g., file upload] | [upload handler] | [type check, size limit, scanning] |
| [e.g., config/env] | [deployment] | [secrets manager, rotation policy] |

## Trust Assumptions

List what this component trusts implicitly:
- [ ] Runtime environment is not compromised
- [ ] Upstream service responses are well-formed
- [ ] Database layer enforces schema constraints
- [ ] [Other assumptions specific to this component]

## Identified Risks

[Use the findings format from SKILL.md for each risk]

## Accepted Risks

| Risk | Rationale for acceptance | Review date |
|------|-------------------------|-------------|
| [risk] | [why it's acceptable] | [when to reassess] |

## Out of Scope

Explicitly state what this threat model does NOT cover:
- [e.g., physical access to servers]
- [e.g., social engineering of administrators]
- [e.g., denial of service at infrastructure layer]
