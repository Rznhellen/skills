---
name: test-strategy
description: >-
  Use when deciding how to test a change — what level, what to mock, what
  constitutes sufficient coverage. Decision context for testing, not a test
  generator.
---

# Test Strategy

Decision context for how to test. This skill helps agents make judgment calls about test boundaries, isolation, and coverage — not write boilerplate.

## Testing Rubric

### Unit Tests
- Pure logic, transformations, calculations, parsers
- Fast, deterministic, zero I/O
- Mock: anything with latency, state, or side effects
- One concept per test — if the name needs "and", split it

### Integration Tests
- Verify that components compose correctly at seams
- Real dependencies where cheap (in-memory DB, local filesystem)
- Mock: external services, network calls, third-party APIs
- Test the contract, not the implementation

### End-to-End Tests
- Critical user paths only — the "smoke test" set
- Real stack, real (or realistic) data
- Few in number, high in signal
- If it breaks, a user notices

## Mock Decision Framework

**Use real dependencies when:**
- Setup cost is low (in-memory, local, fast)
- The integration IS the thing being tested
- Mocking would hide bugs at the boundary

**Use mocks when:**
- The dependency is slow, flaky, or costly
- You're testing YOUR logic, not the dependency's behavior
- The dependency has side effects you can't reverse (email, billing, deploy)

**Never mock:**
- The thing you're actually testing
- Data structures or value objects

## Coverage Criteria

"Covered" means:
1. Happy path verified with representative input
2. Error paths tested for each failure mode that changes behavior
3. Edge cases covered where the type system doesn't prevent them
4. Regression test exists for any bug that was fixed

"Covered" does NOT mean:
- 100% line coverage (coverage is a signal, not a target)
- Every branch of defensive code tested
- Getter/setter tests

## Quality Thresholds

See `reference/quality-rubric.md` for concrete thresholds.

**Key judgment call:** A test suite is good when it catches real bugs without slowing down development. If tests break on every refactor but miss real bugs, the suite is testing implementation, not behavior.

## Verification

The testing strategy is working when:
- Tests fail for the right reasons (behavior changed, not implementation shuffled)
- New bugs in production could plausibly have been caught by a test someone chose not to write
- Test suite runs fast enough that developers run it before pushing
- Flaky tests are rare and get fixed immediately, not retried
