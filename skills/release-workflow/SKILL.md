---
name: release-workflow
description: >-
  Use when preparing a release, deciding version bumps, generating changelogs,
  or verifying release readiness. Lightweight release conventions.
---

# Release Workflow

Decision context for releases. Defines conventions without imposing heavy process.

## Versioning Decision Framework

Use semantic versioning (MAJOR.MINOR.PATCH). The decision is always: "what kind of change is this from the consumer's perspective?"

| Consumer impact | Bump | Examples |
|----------------|------|----------|
| Must change their code/config to upgrade | MAJOR | Removed API, changed behavior, breaking schema migration |
| Gets new capability, no changes required | MINOR | New endpoint, new feature, new optional config |
| Same behavior, better quality | PATCH | Bug fix, performance improvement, dependency update |

**Edge cases:**
- Pre-1.0: breaking changes can be MINOR (consumers expect instability)
- Internal tools with no external consumers: use your judgment, consistency matters more than strictness
- Multiple changes in one release: highest bump wins

## Changelog Approach

**What goes in the changelog:**
- Every user-visible change, grouped by: Added, Changed, Fixed, Removed, Security
- Written for the consumer, not the developer ("Fixed login timeout" not "Refactored auth retry logic")

**What stays out:**
- Internal refactors with no behavior change
- Dev tooling updates (unless they affect contributors)
- Dependency bumps (unless they fix a user-facing bug or add a capability)

**Generation strategy:**
- Derive from commit history between tags
- Commits following conventional format (feat:, fix:, breaking:) can be auto-grouped
- Always human-review generated changelogs before publishing — auto-generated text is a draft

## Release Checklist

Before tagging a release, verify:

- [ ] All CI checks pass on the release branch/commit
- [ ] Version number bumped in relevant files (package.json, pyproject.toml, etc.)
- [ ] Changelog updated with entries since last release
- [ ] No known regressions from the previous release
- [ ] Breaking changes documented with migration guidance
- [ ] Dependent services/packages tested against the new version (if applicable)

## CI Integration

Releases should be triggered by git tags, not manual deploy steps:

- Tag format: `vMAJOR.MINOR.PATCH` (e.g., `v2.1.0`)
- CI pipeline detects the tag and runs: build, test, publish/deploy
- Failed release pipeline: fix forward with a new patch tag, don't delete/move tags

**Branch strategy for releases:**
- Simple projects: tag from main
- Projects needing stabilization: release branch cut from main, cherry-pick fixes, tag from release branch
- Avoid long-lived release branches — merge back to main immediately after tagging

## Anti-patterns

- Manual version bumps that drift from actual semver meaning
- Changelogs that are just git log dumps
- Releasing without CI verification ("it works on my machine")
- Skipping patch versions to "save" nice numbers
- Tagging before the changelog is updated

## Verification

The release process is working when:
- Any team member can cut a release by following the documented steps
- Consumers can read the changelog and know if they need to act
- Rollback to the previous version is always possible and documented
- Release frequency is limited by readiness, not by process overhead
