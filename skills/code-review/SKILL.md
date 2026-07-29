---
name: code-review
description: >-
  Use when reviewing code changes for quality beyond generic lint rules.
  Adds team-specific calibration: architecture fit, boundary violations,
  harness drift, and spec adherence.
---

# Code Review

Team-calibrated review that adds judgment on top of mechanical checks. The bundled review skill handles syntax, style, and obvious bugs. This skill adds taste — architecture fit, boundary discipline, and whether the change actually solves the stated problem.

## Two-Axis Review

Evaluate changes on two independent axes:

### Axis 1: Standards Compliance
Does the code follow established patterns and conventions?
- Architecture boundaries respected (layers don't skip, dependencies flow correctly)
- Naming and structure match existing codebase conventions
- Error handling follows established patterns
- Test coverage meets the project's stated bar

### Axis 2: Spec Adherence
Does the code actually solve the problem it claims to?
- Requirements met as stated (not a different, easier problem)
- Edge cases from the spec handled (not just the happy path)
- Behavior matches what the PR/commit message promises
- No silent scope reduction (dropping hard requirements without flagging)

A change can score high on one axis and low on the other. Both matter, but spec adherence is the harder one to catch.

## Review Dimensions

Beyond generic quality:

**Architecture Fit**
- Does this change respect the system's stated boundaries?
- Does it introduce a new pattern where an existing one applies?
- Does it create coupling that will make future changes harder?

**Boundary Violations**
- Does it reach across module boundaries for data it shouldn't have?
- Does it put logic in the wrong layer (business logic in controllers, UI logic in models)?
- Does it create circular dependencies or hidden coupling?

**Harness Drift**
- Does this change mean CLAUDE.md, ARCHITECTURE.md, or other guidance is now wrong?
- Are new conventions introduced without being documented?
- Should this change update the tech-debt-tracker?

## Calibration

**Flag when it affects correctness or stated requirements:**
- Logic errors, missing error handling for likely scenarios
- Race conditions, data consistency issues
- Security boundary violations
- Spec requirements silently dropped

**Don't flag (note at most):**
- Style preferences not codified in project conventions
- Alternative approaches that aren't clearly better
- "I would have done it differently" without a concrete downside
- Missing optimizations for code that isn't in a hot path

## Integration with Tech Debt

When a review reveals shortcuts:
- If the shortcut has clear future cost, note it for tech-debt-tracker
- If the shortcut is pragmatic and the cost is low, accept it
- If the shortcut violates a stated architectural boundary, flag it

## Verification

A good review:
- Separates findings by severity (blocking vs. non-blocking)
- Explains WHY something is a problem, not just THAT it is
- Suggests direction, not full rewrites
- Acknowledges trade-offs when flagging pragmatic shortcuts
- Finishes with a clear verdict: approve, request changes, or needs discussion
