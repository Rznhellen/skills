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

`docs/exec-plans/` stores long-running or risky work. Use `active/` for current plans, `completed/` for finished plans and decision logs, and `tech-debt-tracker.md` for evidence-backed debt. The tracker is an inventory, not an automatic remediation commitment.

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
7. Before deploying each `0.1` version increment, run the bounded macro debt audit below after verification.
8. Update the harness. If the work changes behavior, architecture, setup, operations, product flow, recurring agent guidance, or the technical-debt inventory, update the relevant scaffold file.
9. Close with evidence. State what changed, what was verified, what remains risky, and which docs or checks were updated.

## Technical Debt Protocol

Technical debt is the future cost of shortcuts that make code harder to understand, change, test, operate, or extend. Shipping quickly may justify it; leaving it unrecorded lets it compound.

Do not label bugs, feature requests, unsupported style preferences, or speculative rewrites as debt. Record only evidence of avoidable maintenance cost, risk, or change friction. Treat naming and formatting as debt only when systemic.

### Routine Audit

For each `0.1` release increment, such as `1.1`, `1.2`, or `2.0`, run one short audit after verification and before deployment. For other version schemes, use the closest minor-release cadence.

- Review the changed area, its immediate callers and dependencies, and one adjacent architectural boundary.
- Start with maps, diffs, file sizes, dependencies, and repeated logic; follow evidence, not speculation.
- Record a few high-confidence findings, then return to the release. Do not plan or remediate unless debt blocks correctness, security, operations, or deployment, or the user asks.

Check:

- **Ownership and structure:** Are functions and modules grouped around clear domain responsibilities? Would moving, merging, or splitting them reduce mixed ownership? Treat large functions and files near or above 700 lines as review triggers, not proof.
- **Reuse and abstraction:** Is repeated logic intentionally separate, or should one source of truth or broader function replace it without erasing real domain differences?
- **Boundaries and change cost:** Do dependencies cross intended boundaries, cycle, leak internals, or make simple changes touch unrelated areas?
- **Sources of truth:** Are models, configuration, states, or lifecycle rules duplicated or conflicting? Are obsolete paths still present?
- **Testability and operability:** Does the structure make important behavior difficult to isolate, verify, observe, or recover?

Compare alternatives by change cost, ownership, coupling, testability, and evolvability. Prefer fewer lines only when clarity remains; avoid premature abstractions.

### Recording Findings

Treat `docs/exec-plans/tech-debt-tracker.md` as a live queue of unresolved debt, not a history. Create it with the first evidence-backed finding, never as an empty placeholder.

Each entry needs a short title, affected area, evidence, future cost or risk, impact (`LOW`, `MEDIUM`, or `HIGH`), and likely remediation direction or trigger. Update existing entries instead of duplicating them.

When remediation is implemented and verified, remove the resolved entries. Keep implementation history in the completed plan and `CHANGELOG.md`; keep only unimplemented debt in the tracker.

Mention new debt at closeout. When any threshold is met, recommend a separate remediation thread for all or a selected subset, but do not create the plan unless asked:

- 10 or more entries
- 3 or more `HIGH`-impact entries
- 3 or more entries in the same subsystem or architectural boundary
- one structural finding remains across 3 consecutive minor-release audits

Keep the warning to one sentence so the release continues: “The debt tracker has reached the remediation threshold; consider a separate remediation thread after this release.”

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
