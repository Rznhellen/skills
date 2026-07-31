---
name: s-harness-protocol
description: >-
  Use when working in any software repository. Guides how agents interact with
  repo-local knowledge, when to update documentation, and how to treat failures
  as missing harness. The foundational operating philosophy for agent work.
---

# Harness Protocol

The repo is the shared operating environment for every agent. What the agent cannot discover in the repo or through approved tools does not exist.

## Core Philosophy

- **Agent failure is missing harness.** When an agent gets stuck or repeats a mistake, the fix is a better doc, fixture, script, test, or skill — not a smarter prompt.
- **Maps over manuals.** A short entry point plus well-structured deeper docs beats one giant instruction file.
- **Executable checks over prose.** If a rule matters repeatedly, encode it as a test, linter, script, or CI job.
- **Progressive disclosure.** High-level guidance always visible; details in files agents load only when relevant.
- **Repository-local knowledge.** Decisions from chat, meetings, or tickets should be summarized into repo artifacts when they affect future implementation.

## Decision Framework

### When Starting Work

1. Read CLAUDE.md (or equivalent root guidance) and ARCHITECTURE.md
2. Check `docs/exec-plans/active/` for in-progress work that might conflict
3. Understand the scope before writing code

### When Something Is Unclear

Ask: "Would the next agent hitting this same situation be confused?" If yes — update the harness. Add the missing doc, fixture, or reference rather than just solving it for yourself.

### When Finishing Work

Ask: "Did my work change behavior, architecture, setup, operations, or conventions?" If yes — update the relevant harness file. State what changed in your closing summary.

## Autonomy Policy

**Safe to do without asking:**
- Read any file, run tests, run linters, check git state
- Create/modify implementation files within the stated scope
- Update documentation that reflects your changes
- Log friction to `docs/harness-feedback/`

**Confirm before doing:**
- Changes to infrastructure or deploy configuration
- Modifications to CI/CD pipelines
- Deleting files you didn't create
- Changes outside the stated scope of current work

## Feedback Loop

When you encounter friction — unclear guidance, missing context, wrong assumptions in docs — log it:

```markdown
## [date] [skill-or-area]
**Friction:** [what went wrong or was missing]
**Context:** [what you were trying to do]
**Suggested fix:** [your idea for improvement]
```

Place entries in `docs/harness-feedback/`. These get consolidated by the harness-evolution skill on a regular cadence.

## Verification

The harness is working when:
- Agents can start productive work after reading only the root guidance files
- The same task done by different agents produces consistent quality
- Friction entries decrease over time for the same skill areas
- No critical knowledge lives only in chat history or human memory
