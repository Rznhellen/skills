# OWASP-Aligned Review Dimensions

Assessment categories mapped to what agents should look for in code.

## 1. Injection and Input Validation

**Question:** Can untrusted input change the intended operation?

Look for:
- SQL/NoSQL queries built with string concatenation
- Shell commands incorporating user input
- Template rendering with unescaped variables
- Regular expressions vulnerable to ReDoS
- Deserialization of untrusted data

**Good:** Parameterized queries, allowlist validation, typed inputs, sandboxed evaluation.

## 2. Authentication and Session Management

**Question:** Can identity be forged, stolen, or bypassed?

Look for:
- Credential storage (plaintext, weak hashing, missing salt)
- Session token generation (predictability, entropy)
- Token expiration and rotation policies
- Password reset flows (enumeration, token reuse)
- Multi-factor bypass paths

**Good:** Industry-standard libraries, short-lived tokens, secure cookie flags, rate limiting on auth endpoints.

## 3. Authorization and Access Control

**Question:** Can a user access resources or operations they shouldn't?

Look for:
- Missing authorization checks on endpoints or operations
- Client-side-only enforcement (server trusts client claims)
- IDOR (direct object references without ownership checks)
- Role/permission checks that can be bypassed via parameter manipulation
- Horizontal privilege escalation (accessing other users' data)

**Good:** Centralized authz middleware, resource-level ownership checks, deny-by-default policies.

## 4. Data Exposure and Cryptography

**Question:** Is sensitive data protected at rest and in transit?

Look for:
- Secrets in source code, logs, or error messages
- Sensitive data in URLs (logged by proxies, browsers)
- Weak or custom cryptographic implementations
- Missing encryption for data at rest
- Overly broad API responses (returning more fields than needed)

**Good:** Secrets in environment/vault, structured logging with redaction, standard crypto libraries, minimal API responses.

## 5. Security Misconfiguration

**Question:** Are defaults and configurations secure?

Look for:
- Debug mode or verbose errors enabled in production
- Default credentials or API keys
- Overly permissive CORS policies
- Missing security headers (CSP, HSTS, X-Frame-Options)
- Unnecessary services, ports, or features enabled

**Good:** Environment-specific configs, security headers middleware, principle of least privilege in IAM.

## 6. Dependency Vulnerabilities

**Question:** Do third-party components introduce known risks?

Look for:
- Dependencies with known CVEs (check lock files)
- Unmaintained or abandoned packages in critical paths
- Pinned versions far behind security patches
- Dependencies that request excessive permissions

**Good:** Automated dependency scanning, regular update cadence, minimal dependency surface.

## 7. Logging and Monitoring Gaps

**Question:** Would an attack be detected and traceable?

Look for:
- Authentication failures not logged
- Authorization violations silently swallowed
- No audit trail for sensitive operations
- Sensitive data in logs (credentials, tokens, PII)
- Missing alerting on anomalous patterns

**Good:** Structured audit logs, security event alerting, log retention policies, PII redaction in logs.
