---
name: harness-protocol
description: "Use at the start of any repository or codebase task, in new agent chat threads, after context compaction or summarization, and during handoffs or resumes. Guides repo rehydration, harness-engineering docs, AGENTS.md adapters, plans, verification, and feedback loops."
---

# Codebase Harness Protocol

Use this skill when working in a software repository. Treat the repo as the shared operating environment for every agentic harness: Codex, Claude Code, Antigravity, Cursor, Copilot, Devin, and future tools.

Core rule: what the agent cannot discover in the repo or through approved tools effectively does not exist. Convert durable knowledge into repository-local docs, scripts, tests, generated references, and plans.

Source note: this protocol is inspired by OpenAI's harness engineering guidance:
https://openai.com/index/harness-engineering/

## Universal Scaffold

Use this scaffold for substantial codebases and for repos being prepared for repeated agent work. Do not create empty placeholder files just to satisfy the tree; create the relevant pieces when they contain real guidance.

```text
AGENTS.md
CLAUDE.md
GEMINI.md
ARCHITECTURE.md
docs/
|-- design-docs/
|   |-- index.md
|   |-- core-beliefs.md
|   `-- ...
|-- exec-plans/
|   |-- active/
|   |-- completed/
|   `-- tech-debt-tracker.md
|-- generated/
|   `-- db-schema.md
|-- product-specs/
|   |-- index.md
|   |-- new-user-onboarding.md
|   `-- ...
|-- references/
|   |-- design-system-reference-llms.txt
|   |-- platform-reference-llms.txt
|   |-- framework-reference-llms.txt
|   `-- ...
|-- DESIGN.md
|-- FRONTEND.md
|-- PLANS.md
|-- PRODUCT_SENSE.md
|-- QUALITY_SCORE.md
|-- RELIABILITY.md
`-- SECURITY.md
```

## Root Harness Files

`AGENTS.md` is the canonical shared map. Keep it short: operating rules, commands, safety gates, source-of-truth links, and where agents should look next. Do not make it a full manual.

`CLAUDE.md`, `GEMINI.md`, `.cursor/rules/`, `.github/copilot-instructions.md`, or other harness-specific files are adapters. Create them only when the platform or team uses them. They should import, point to, or briefly mirror `AGENTS.md`; they must not become competing sources of truth.

If a platform cannot read `AGENTS.md`, make its adapter say which file is canonical and keep any platform-specific notes minimal.

## Documentation Roles

`ARCHITECTURE.md` maps domains, boundaries, dependency direction, runtime shape, data flow, and system invariants.

`docs/design-docs/` stores design history. `index.md` catalogs decisions and status. `core-beliefs.md` captures durable principles that should shape future agent work.

`docs/exec-plans/` stores long-running or risky work. Use `active/` for current plans, `completed/` for finished plans and decision logs, and `tech-debt-tracker.md` for known cleanup targets.

`docs/generated/` stores machine-generated references such as schemas, API inventories, route maps, dependency graphs, or screenshots. Every generated file must include its source command and regeneration steps.

`docs/product-specs/` stores user-facing behavior, workflows, acceptance criteria, owners, open questions, and status. Keep `index.md` current.

`docs/references/` stores stable external or internal reference material that agents should read on demand, including `llms.txt`-style docs.

Focused guides are optional but should be used when the repo has enough depth:

- `docs/DESIGN.md`: product and visual design rules
- `docs/FRONTEND.md`: UI architecture, state, routes, components, accessibility, screenshots
- `docs/PLANS.md`: planning conventions and plan index
- `docs/PRODUCT_SENSE.md`: user goals, market assumptions, workflow priorities
- `docs/QUALITY_SCORE.md`: quality rubric, current grades, known gaps
- `docs/RELIABILITY.md`: observability, failure modes, SLIs, operational checks
- `docs/SECURITY.md`: trust boundaries, secrets, auth, privacy, threat model

## Agent Work Loop

1. Rehydrate. Read root harness files, README, architecture docs, relevant product/design docs, active plans, and current worktree state.
2. Scope. Turn the request into acceptance criteria, likely code changes, likely docs changes, and the narrowest useful verification.
3. Navigate by map. Start at `AGENTS.md`, then load only the deeper docs needed for the current task.
4. Use local tools. Run repo scripts, tests, linters, type checks, browser automation, logs, metrics, traces, issue tools, and review tools directly.
5. Implement the smallest complete change. Preserve boundaries and local patterns unless the task is to change them.
6. Verify behavior, not vibes. Reproduce bugs, inspect logs, run tests, capture screenshots, or exercise the workflow.
7. Update the harness. If the work changes behavior, architecture, setup, operations, product flow, or recurring agent guidance, update the relevant scaffold file.
8. Close with evidence. State what changed, what was verified, what remains risky, and which docs or checks were updated.

## Harness Engineering Rules

Prefer maps over manuals. A short entry point plus well-structured deeper docs beats one giant instruction file.

Prefer executable checks over prose. If a rule matters repeatedly, encode it as a test, linter, script, CI job, generated reference, or review checklist.

Prefer progressive disclosure. Keep high-level instructions always visible and move details into files agents load only when relevant.

Prefer repository-local knowledge. Decisions in chat, meetings, tickets, or private docs should be summarized into repo artifacts when they affect future implementation.

Prefer direct feedback loops. Give agents access to the same signals humans use: failing tests, logs, traces, screenshots, recordings, dashboards, and review comments.

Treat agent failure as missing harness. When an agent gets stuck or repeats a mistake, add the missing doc, fixture, script, validation, type boundary, architecture rule, or skill.

Control entropy continuously. Agents copy existing patterns, including bad ones. Keep cleanup small, recurring, and mechanically checkable.

## Scaffold Change Rules

When creating or changing this scaffold:

- Do not duplicate long guidance across adapter files.
- Do not create a folder README unless that folder has real complexity.
- Do not store secrets, raw logs, or private transcripts in docs.
- Do not leave stale references after renames or removals.
- Do not add generated docs without regeneration instructions.
- Do not make docs authoritative when code, tests, or schemas disagree; fix the drift.

When finishing codebase work, update the nearest relevant scaffold file or explicitly state why no documentation changed.
