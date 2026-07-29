# Skills Suite & Agent Harness Buildout Plan

**Status:** Active
**Created:** 2026-07-29
**Scope:** Full skills suite for software factory / harness engineering across codebases

---

## Executive Summary

Build out the shared-skills repository into a complete, portable agent harness: a set of skills, subagents, workflows, and scaffold templates that can be installed into any new codebase to give coding agents (Claude Code, Codex, Cursor, Gemini CLI, etc.) full operational context from day one.

The design philosophy follows two converging signals from the latest model generations:

1. **Anthropic (Claude 5 / Fable 5):** "Delete constraints, leverage judgment. Move from rigid rules to rich interfaces and progressive disclosure." — [claude.com/blog/the-new-rules-of-context-engineering-for-claude-5-generation-models](https://claude.com/blog/the-new-rules-of-context-engineering-for-claude-5-generation-models)
2. **OpenAI (GPT-5.6 Luna/Terra/Sol):** "Favor lean prompts. State each instruction once. Define autonomy/approval boundaries as compact policy." — [developers.openai.com/api/docs/guides/latest-model](https://developers.openai.com/api/docs/guides/latest-model)

Both agree: skills should provide **decision context** (why, when, what good looks like) rather than **step-by-step constraints** (do X, never Y). The new generation handles nuance; our job is to give it the right map.

---

## Reference Documents

These sources informed this plan and should be consulted during implementation:

| Source | URL | Key Takeaway |
|--------|-----|--------------|
| Claude 5 Context Engineering | https://claude.com/blog/the-new-rules-of-context-engineering-for-claude-5-generation-models | Design interfaces not examples; progressive disclosure; let models use judgment |
| GPT-5.6 Prompting Guide | https://developers.openai.com/api/docs/guides/latest-model | Lean prompts, compact autonomy policy, PTC routing, effort levels |
| Claude Code Best Practices | https://code.claude.com/docs/en/best-practices | Verification-first, context management, subagent patterns, skills architecture |
| Claude Code Skills Docs | https://code.claude.com/docs/en/skills | Skill file format, discovery, progressive disclosure, dynamic context injection |
| Claude Code Subagents Docs | https://code.claude.com/docs/en/sub-agents | Frontmatter format, tool scoping, model routing, project vs user scope |
| Claude Code Workflows | https://code.claude.com/docs/en/workflows | Dynamic workflows, fan-out patterns, adversarial verification, save/reuse |
| Agent Skills Open Standard | https://agentskills.io | Cross-tool portability, SKILL.md format, discovery/activation/execution |
| OpenAI Harness Engineering (referenced) | https://openai.com/index/harness-engineering | Repo-local knowledge, executable checks over prose, progressive disclosure |
| mattpocock/skills (194k stars) | https://github.com/mattpocock/skills | AGENTS.md symlink trick, wayfinder planning, tracer-bullet tickets, two-axis code review, CONTEXT.md domain lexicon, handoff documents, grilling sessions for alignment |

---

## Design Principles (Derived from References)

These principles govern how every skill in the suite should be written:

### 1. Decision Context Over Constraints

**Old pattern:** "Never write multi-line docstrings. Always use snake_case."
**New pattern:** "Match the surrounding code's density and idiom. Here's what good looks like in this repo: [rubric/reference]."

Skills should explain the **why** and provide **rubrics** so the agent can make contextual judgments. Reserve hard constraints only for safety-critical rules (secrets, destructive operations).

### 2. Progressive Disclosure

Skills load only when relevant. Within a skill, front-load the decision framework and push detailed reference material into `reference/` subdirectories the agent reads on demand. Never dump everything upfront.

### 3. Interfaces Over Examples

Design rich parameter interfaces and rubrics rather than showing usage examples. The new models infer usage from well-designed interfaces.

### 4. Verification Is a First-Class Concern

Every skill that produces output should define what "done well" looks like as a checkable condition — a test, a lint rule, a screenshot comparison, a structured rubric — not just prose.

### 5. Cross-Tool Portability

Follow the [Agent Skills open standard](https://agentskills.io). Skills should work in Claude Code, Cursor, Codex, Gemini CLI, JetBrains Junie, and any other compliant tool.

### 6. Lean by Default

Per both Anthropic and OpenAI's latest guidance: state each instruction once, remove anything the model already does correctly without being told, and track context growth.

### 7. CLAUDE.md as Single Source of Truth

All codebase guidance lives in CLAUDE.md. AGENTS.md points to CLAUDE.md so any agent — regardless of which file it reads first — arrives at the same guidance. Platform adapters (GEMINI.md, .cursor/rules/) similarly reference CLAUDE.md rather than duplicating content.

### 8. Self-Updating Harness

The harness is a living system, not a static document. Agents log friction (missing context, unclear guidance, failed approaches) as structured feedback. On a regular cadence, those entries are consolidated and the harness evolves. Skills that cause confusion get simplified. Missing patterns become new skills. The goal: every agent failure improves the system for next time.

---

## Current State

```
skills/
├── change-vscode-color/     (utility — small, complete)
├── gcp-project-scaffold/    (domain — mature, has references)
└── harness-protocol/        (meta — good foundation, needs modernization)
```

**Gaps identified:**
- No automated testing/verification skill
- No security review skill
- No technical debt tracking skill (protocol exists but no dedicated skill)
- No frontend/design system skill
- No documentation scaffolding skill
- No "bootstrap a new codebase" setup skill
- No code review skill (relying on bundled `/code-review`)
- No architecture decision record skill
- No self-updating feedback loop (agents struggle but don't improve the harness)
- Harness protocol is over-constrained for new model generation
- GCP scaffold is 460 lines monolithic — needs splitting into focused sub-skills
- No deploy.sh pattern for single-command deployments

---

## Proposed Skills Suite

### Phase 1: Foundation (Setup & Scaffold)

#### 1.1 `codebase-setup` (Priority: HIGH)

The "day zero" skill. Bootstraps a new or existing codebase with the full harness scaffold.

**What it does:**
- Detects existing structure (monorepo vs single, language, framework)
- Creates CLAUDE.md as the **canonical guidance file** (all real content lives here)
- Creates AGENTS.md that points to CLAUDE.md
- Creates ARCHITECTURE.md (domain map, boundaries, data flow)
- Scaffolds `docs/` structure based on repo complexity
- Generates `.claude/settings.json` with sensible permissions
- Creates initial subagent definitions (`.claude/agents/`)
- Optionally creates platform adapters (GEMINI.md, .cursor/rules/, etc.) that also point to CLAUDE.md

**Design notes:**
- CLAUDE.md is the single source of truth. AGENTS.md exists only for tools that look for it (Codex, etc.) and contains a single redirect line. This ensures all agents — regardless of which file they read first — end up at the same guidance.
- Should use dynamic context injection (`!` commands) to inspect the repo before scaffolding
- Should NOT create empty placeholders — only create files with real content
- Should offer a "minimal" and "full" mode based on repo size
- Reference: harness-protocol scaffold definition

#### 1.2 `plan` (Priority: HIGH)

Consistent planning skill that produces the same plan format regardless of which agent (Claude, Codex, Cursor) is executing. Inspired by mattpocock/skills' `wayfinder` and `to-tickets` but adapted to our preferred Claude-style approach.

**What it does:**
- Produces structured execution plans with clear phases, decision points, and verification criteria
- Plans are written as documents (in `docs/exec-plans/active/`) not issue tracker tickets
- Each plan has: goal statement, phases with acceptance criteria, blocking dependencies between phases, open questions, and verification strategy
- Supports both "big picture" planning (new features, architecture changes) and "tactical" planning (bug fixes, refactors that touch many files)

**Why not Codex-style plans:**
- Codex plans tend toward flat task lists without decision context
- Claude-style plans emphasize WHY (decision frameworks, trade-offs) alongside WHAT
- Our plans should read as "here's the shape of the work and the judgment calls within it" not "here's a checklist to execute blindly"

**Plan format (Claude-style):**
```markdown
# [Plan Title]

**Goal:** [One sentence — what does "done" look like?]
**Scope:** [What's in, what's explicitly out]

## Phases

### Phase N: [Name]
**Acceptance criteria:** [How we know this phase is done]
**Depends on:** [Prior phases or external inputs]
**Key decisions:** [Trade-offs the agent will need to navigate]
**Verification:** [Concrete check — test, command, screenshot]

## Open Questions
[Things that need answering before or during execution]

## Risks
[What could go wrong, and what's the fallback]
```

**Design notes:**
- Should support both user-invoked (`/plan`) and model-invoked (agent decides to plan before a complex task)
- Plans go in `docs/exec-plans/active/` and move to `completed/` when done
- Integrates with tracer-bullet thinking from mattpocock/skills: break work into vertical slices that are independently completable and demoable
- Unlike wayfinder, our plans don't live on an issue tracker — they live in the repo alongside the code
- The skill should also handle plan updates: when the approach changes mid-execution, update the plan document rather than abandoning it

#### 1.3 `harness-protocol` (MODERNIZE existing)

Update the existing protocol to align with new model guidance:

**Changes needed:**
- Remove over-prescriptive steps (agents don't need a 9-step loop spelled out)
- Convert to decision framework: "Here's what good harness looks like" + rubric
- Add compact autonomy policy (query/action/approval boundaries per OpenAI guide)
- Reduce scaffold prescription — let the setup skill handle creation
- Focus on: when to update docs, what signals harness is missing, how to treat failures

---

### Phase 2: Quality & Verification

#### 2.1 `test-strategy` (Priority: HIGH)

Guides agents on testing decisions rather than prescribing test patterns.

**What it does:**
- Defines the testing rubric for the codebase (unit/integration/e2e boundaries)
- Provides verification criteria templates
- Guides: what to test, what level, what constitutes "covered"
- Integrates with `/verify` and `/run` bundled skills

**Design notes:**
- NOT a "write tests for me" skill — it's the decision context for HOW to test
- Should include a `reference/rubric.md` defining quality thresholds
- Should define when to use mocks vs real dependencies (decision framework, not rule)

#### 2.2 `security-review` (Priority: HIGH)

Structured security assessment skill with adversarial verification.

**What it does:**
- Defines threat model structure for the codebase
- Provides OWASP-aligned review dimensions
- Defines what findings look like (severity, evidence, remediation direction)
- Supports both "review this change" and "audit this area" modes

**Design notes:**
- Should pair with a `security-reviewer` subagent (read-only, Opus-tier)
- Should define a compact trust boundary model the agent can reference
- Verification: findings should be adversarially checked (can the agent reproduce the vulnerability path?)

#### 2.3 `code-review` (Priority: MEDIUM)

Custom code review skill that overrides the bundled `/code-review`.

**What it does:**
- Defines team-specific review dimensions (beyond the bundled generic review)
- Provides rubric for what constitutes a finding vs noise
- Calibrates: "Flag gaps that affect correctness or stated requirements, not style"
- Integrates with the tech debt protocol

**Design notes:**
- Per Claude Code docs: a project-level skill with the same name overrides the bundled one
- Should be lean — the bundled skill handles mechanics; this adds team taste
- Reference the Anthropic guidance: "A reviewer prompted to find gaps will always report some... tell it to flag only gaps that affect correctness"

#### 2.4 `tech-debt-audit` (Priority: MEDIUM)

Dedicated skill for the technical debt protocol (currently embedded in harness-protocol).

**What it does:**
- Extracts and modernizes the debt protocol from harness-protocol
- Defines audit triggers and scope
- Provides the recording format for `docs/exec-plans/tech-debt-tracker.md`
- Defines remediation thresholds

**Design notes:**
- Currently the protocol is too detailed for new models — convert to decision framework
- Key question it answers: "Is this actually debt, or just a style preference?"

---

### Phase 3: Architecture & Design

#### 3.1 `frontend-design` (Priority: HIGH)

Frontend architecture and design system guidance.

**What it does:**
- Defines component architecture patterns for the codebase
- Provides design system reference (colors, spacing, typography rubric)
- Guides accessibility requirements
- Integrates with visual verification (screenshots)

**Design notes:**
- Should use `reference/` directory for design tokens, component patterns
- Should integrate with the existing `dataviz` skill for chart/visualization work
- Rubric-based: "here's what good UI looks like in this project" rather than rules
- Per Claude 5 guidance: prefer code references and HTML mockups over descriptions

#### 3.2 `architecture-decision` (Priority: MEDIUM)

Guides creation of Architecture Decision Records (ADRs).

**What it does:**
- Provides ADR template and conventions
- Guides: when to write one (decision with trade-offs that future agents need)
- Integrates with `docs/design-docs/` structure
- Maintains `docs/design-docs/index.md`

**Design notes:**
- Lightweight — the format is the value, not extensive guidance
- Should define: context, decision, consequences, status lifecycle

#### 3.3 GCP Skills Suite (SPLIT from existing monolithic `gcp-project-scaffold`)

The current skill is 460 lines covering 6 distinct concerns. Split into focused sub-skills with their own triggers. This is our house architecture going forward — the content stays, the organization improves.

**Split plan:**

| New Skill | Trigger | Content (from current skill) |
|-----------|---------|------------------------------|
| `gcp-architecture` | Starting a new GCP project, choosing surfaces, designing system shape | Core principles, system shape diagram, surface roles table |
| `gcp-deploy` | First deploy, bootstrap, deploy.sh creation, credential setup | First-deploy operating contract, scaffolding checklist, credential stores, secret handling, **NEW: deploy.sh pattern** |
| `gcp-buildpacks` | Setting up a deployable surface, Procfile questions, Dockerfile alternatives | No-Dockerfile technique, frontend sub-technique, staged context rules |
| `gcp-cicd` | Setting up CI/CD, Cloud Build triggers, pipeline troubleshooting | CI/CD pipeline section, Cloud Build YAML guardrails, GitHub triggers, static scans |
| `gcp-triage` | Build failures, deploy failures, log retrieval, Terraform validation | Failure triage section, log commands, Terraform validation |

**Shared reference files** stay in a common location accessible to all GCP skills. Options:
- Each sub-skill gets its own `reference/` with only the files it needs
- Or a shared `skills/gcp-shared/reference/` that all GCP skills point to

**NEW: `deploy.sh` pattern (lives in `gcp-deploy`):**

The `deploy.sh` script is a single idempotent entry point that wraps the entire deployment lifecycle:

```bash
./deploy.sh              # Full deploy: terraform + all surfaces
./deploy.sh --plan       # Terraform plan only (dry run)
./deploy.sh --surface=api  # Deploy only one surface
./deploy.sh --skip-terraform  # Skip infra, just redeploy services
```

Design principles for deploy.sh:
- Idempotent and re-runnable (matches first-deploy state machine philosophy)
- Wraps terraform init/plan/apply + gcloud run deploy in dependency order
- Handles credential preflight checks before doing anything destructive
- Supports partial deploys (single surface, skip-terraform, plan-only)
- Prints clear status at each phase so the operator (or agent) knows what happened
- Fails fast with actionable error messages, not silent failures
- Should be the ONLY thing an operator needs to run after code changes

The `gcp-deploy` skill should include a `reference/deploy-sh-template.sh` that agents use as a starting point when scaffolding new projects.

**Evolution notes:**
- Each sub-skill should be rewritten in decision-framework style (not 460 lines of procedure)
- No separate generic `ci-pipeline` skill needed — `gcp-cicd` owns this for our stack
- If we ever need non-GCP CI (GitHub Actions for other platforms), add that as a separate skill at that time

---

### Phase 4: Operations & Automation

#### 4.1 `harness-evolution` (Priority: HIGH)

The self-updating harness skill. Builds a continuous feedback loop where agent struggles become harness improvements.

**What it does:**
- Defines how agents should document friction points during work (where they got stuck, what context was missing, what guidance was unclear or wrong)
- Provides a structured format for logging "harness feedback" entries
- On a daily/weekly cadence (via `/loop` or manual invocation), consolidates all feedback entries and proposes concrete skill/doc updates
- Tracks which skills are working well vs causing confusion
- Produces a "harness health" summary: what's serving agents well, what's degrading, what's missing

**Design notes:**
- This is the meta-skill that makes the whole suite self-improving
- Agents should be instructed (via CLAUDE.md or harness-protocol) to log friction to a known location (e.g., `docs/harness-feedback/` or a structured section in the tech-debt tracker)
- The evolution skill reads those logs, deduplicates, and proposes changes as a batch
- Changes might be: update a skill's wording, add a missing reference, create a new skill for a recurring pattern, simplify an over-constrained section
- Should pair with a `/loop` invocation for automated cadence: `/loop 1d /harness-evolution`
- Verification: after applying proposed changes, check that the same friction patterns don't recur

**Feedback entry format (lightweight):**
```markdown
## [date] [skill-or-area]
**Friction:** [what went wrong or what was missing]
**Context:** [what the agent was trying to do]
**Suggested fix:** [optional — agent's idea for improvement]
```

#### 4.2 `documentation-scaffold` (Priority: MEDIUM)

Ongoing documentation maintenance (distinct from initial setup).

**What it does:**
- Guides: when to update which doc, what level of detail, what format
- Defines documentation quality rubric
- Provides templates for common doc types (API docs, runbooks, guides)
- Detects documentation drift from code

**Design notes:**
- NOT for initial scaffold creation (that's `codebase-setup`)
- For ongoing: "I just made a change, what docs need updating?"
- Should define when generated docs (schemas, API inventories) need regeneration

#### 4.3 `release-workflow` (Priority: LOW)

Release process guidance.

**What it does:**
- Defines versioning strategy
- Guides changelog generation
- Provides release checklist
- Integrates with CI pipeline skill

---

### Phase 5: Subagents & Orchestration

#### 5.1 Subagent Definitions

Create `.claude/agents/` definitions that pair with skills:

| Agent | Model | Tools | Purpose |
|-------|-------|-------|---------|
| `security-reviewer` | opus | Read, Grep, Glob, Bash | Security audit with adversarial verification |
| `architecture-analyst` | sonnet | Read, Grep, Glob | Architecture review, boundary analysis |
| `test-strategist` | sonnet | Read, Grep, Glob, Bash | Test coverage analysis, test design |
| `debt-auditor` | sonnet | Read, Grep, Glob | Technical debt identification |
| `doc-checker` | haiku | Read, Grep, Glob | Documentation freshness and drift detection |

**Design notes per Claude Code docs:**
- Use `description` field carefully — Claude uses it to decide when to delegate
- Keep system prompts focused on the decision framework, not step-by-step instructions
- Route expensive analysis to Opus, routine checks to Haiku

#### 5.2 Workflow Templates

Saved workflow scripts (`.claude/workflows/`) for common multi-agent patterns:

| Workflow | Pattern | When to use |
|----------|---------|-------------|
| `full-review` | Fan-out + adversarial verify | Pre-merge review across all dimensions |
| `security-audit` | Multi-modal sweep + verify | Audit a directory/feature for security issues |
| `debt-sweep` | Loop-until-dry + dedup | Comprehensive debt identification |
| `migration-check` | Pipeline per file | Validate a migration across many files |

---

## Implementation Order

```
Phase 1 (Foundation)     ─── Week 1-2
  ├── 1.1 codebase-setup
  ├── 1.2 plan (consistent planning skill)
  └── 1.3 harness-protocol modernization

Phase 2 (Quality)        ─── Week 2-3
  ├── 2.1 test-strategy
  ├── 2.2 security-review
  ├── 2.3 code-review
  └── 2.4 tech-debt-audit

Phase 3 (Architecture)   ─── Week 3-4
  ├── 3.1 frontend-design
  ├── 3.2 architecture-decision
  └── 3.3 GCP split (gcp-architecture, gcp-deploy + deploy.sh,
          gcp-buildpacks, gcp-cicd, gcp-triage)

Phase 4 (Operations)     ─── Week 4-5
  ├── 4.1 harness-evolution (self-updating feedback loop)
  ├── 4.2 documentation-scaffold
  └── 4.3 release-workflow

Phase 5 (Orchestration)  ─── Week 5-6
  ├── 5.1 Subagent definitions
  └── 5.2 Workflow templates
```

---

## File Structure (Target State)

```
shared-skills/
├── CLAUDE.md                          # NEW: canonical guidance (single source of truth)
├── AGENTS.md                          # NEW: points to CLAUDE.md
├── README.md                          # UPDATE: reflect full suite
├── CHANGELOG.md
├── docs/
│   ├── exec-plans/
│   │   ├── active/
│   │   │   └── skills-suite-buildout.md  (this file)
│   │   └── completed/
│   └── references/
│       ├── claude5-context-engineering.md  # Captured guidance
│       ├── gpt56-prompting-guide.md       # Captured guidance
│       └── agent-skills-standard.md       # Standard reference
├── skills/
│   ├── codebase-setup/
│   │   ├── SKILL.md
│   │   └── reference/
│   │       ├── claude-md-template.md      # Primary — all guidance lives here
│   │       ├── architecture-md-template.md
│   │       └── minimal-scaffold.md
│   ├── plan/
│   │   └── SKILL.md                   # NEW: consistent planning across agents
│   ├── harness-protocol/
│   │   └── SKILL.md                   # MODERNIZED
│   ├── test-strategy/
│   │   ├── SKILL.md
│   │   └── reference/
│   │       └── quality-rubric.md
│   ├── security-review/
│   │   ├── SKILL.md
│   │   └── reference/
│   │       ├── threat-model-template.md
│   │       └── owasp-dimensions.md
│   ├── code-review/
│   │   └── SKILL.md
│   ├── tech-debt-audit/
│   │   ├── SKILL.md
│   │   └── reference/
│   │       └── tracker-format.md
│   ├── frontend-design/
│   │   ├── SKILL.md
│   │   └── reference/
│   │       ├── component-patterns.md
│   │       └── accessibility-rubric.md
│   ├── architecture-decision/
│   │   ├── SKILL.md
│   │   └── reference/
│   │       └── adr-template.md
│   ├── harness-evolution/
│   │   ├── SKILL.md
│   │   └── reference/
│   │       └── feedback-format.md
│   ├── documentation-scaffold/
│   │   └── SKILL.md
│   ├── release-workflow/
│   │   └── SKILL.md
│   ├── gcp-architecture/             # SPLIT from gcp-project-scaffold
│   │   └── SKILL.md
│   ├── gcp-deploy/
│   │   ├── SKILL.md
│   │   └── reference/
│   │       └── deploy-sh-template.sh
│   ├── gcp-buildpacks/
│   │   ├── SKILL.md
│   │   └── reference/
│   │       ├── Procfile
│   │       └── requirements-stdlib-only.txt
│   ├── gcp-cicd/
│   │   ├── SKILL.md
│   │   └── reference/
│   │       ├── cloudbuild-service.yaml
│   │       ├── cloudbuild-job.yaml
│   │       └── create-triggers.sh
│   ├── gcp-triage/
│   │   └── SKILL.md
│   ├── change-vscode-color/          # EXISTING
│   │   └── SKILL.md
│   └── dataviz/                       # EXISTING (personal)
│       └── SKILL.md
├── agents/
│   ├── security-reviewer.md
│   ├── architecture-analyst.md
│   ├── test-strategist.md
│   ├── debt-auditor.md
│   └── doc-checker.md
└── workflows/
    ├── full-review.js
    ├── security-audit.js
    ├── debt-sweep.js
    └── migration-check.js
```

---

## Skill Writing Guidelines (for Implementing Agent)

When writing each skill, follow these patterns derived from the reference documents:

### Frontmatter

```yaml
---
name: skill-name
description: >-
  One clear sentence describing WHEN to use this skill. Claude uses this
  to decide whether to load it, so be specific about the trigger condition.
---
```

The `description` field is the most important line. It controls discovery. Write it as: "Use when [specific trigger condition]." Not: "A skill for [vague category]."

### Body Structure

```markdown
# Skill Name

## Decision Framework

[The core judgment model — when to do what, not step-by-step procedures]

## What Good Looks Like

[Rubric or reference that defines quality for this domain]

## Verification

[How the agent confirms the work is correct — checkable conditions]

## Reference Material

[Only if needed — point to reference/ subdirectory for detailed specs]
```

### Anti-Patterns to Avoid

Per Claude 5 and GPT-5.6 guidance:

- **Don't** write numbered step-by-step procedures (agents navigate better with judgment)
- **Don't** repeat instructions that appear elsewhere in the harness
- **Don't** use "NEVER" / "ALWAYS" / "YOU MUST" except for genuine safety boundaries
- **Don't** provide usage examples (design expressive interfaces instead)
- **Don't** over-constrain with conflicting rules
- **Don't** create empty placeholder files

### Patterns to Follow

- **Do** provide decision frameworks ("If X, consider Y because Z")
- **Do** define verification criteria (what "done" looks like)
- **Do** use dynamic context injection (`!` commands) to ground in current state
- **Do** reference external material by linking to `reference/` files
- **Do** keep the main SKILL.md under 100 lines where possible
- **Do** write for the Agent Skills standard (cross-tool portability)

---

## Ideas from mattpocock/skills (https://github.com/mattpocock/skills)

This repo (194k stars) has strong patterns we should selectively adopt:

**Adopt directly:**
- AGENTS.md pointing to CLAUDE.md (single source of truth, zero maintenance)
- Tracer-bullet ticket thinking: break work into vertical slices that cut through all layers, independently completable and demoable — inform our `plan` skill
- Two-axis code review: Standards vs. Spec as separate concerns — inform our `code-review` skill
- Handoff documents: compact a conversation into a resumable artifact — useful for our multi-session workflows

**Adapt (don't copy):**
- Wayfinder's "decision map" concept: good for foggy work, but we prefer plans as repo documents not issue tracker tickets. Our `plan` skill captures the spirit (break unknowns into resolvable questions) without the issue-tracker coupling.
- CONTEXT.md / domain lexicon: their idea of a shared vocabulary file reducing verbosity. For us, this belongs inside CLAUDE.md's project description rather than a separate file.
- Grilling sessions: their "interview the user until alignment is reached" pattern. Good concept; for us this is a technique agents should use naturally (via AskUserQuestion) rather than a separate skill.
- Router skill (ask-matt): they use a central router that maps requests to skills. We don't need this — Claude Code's description-based skill discovery handles routing.

**Skip:**
- Issue tracker integration (triage, to-tickets): over-engineered for our use case
- Plugin marketplace packaging: we install via `npx skills install 'Rznhellen/<repo>'`
- Promoted/non-promoted bucket governance: too formal for our repo size
- Symlink scripts / linking infrastructure: `npx skills install` handles distribution

---

## Modernization Notes for Harness Protocol

The existing `harness-protocol/SKILL.md` is 166 lines of detailed procedure. Per the new model guidance, it should be restructured:

**Current issues:**
- 9-step agent work loop is over-prescriptive (new models handle this naturally)
- Technical debt protocol is detailed enough to be its own skill
- Scaffold definition is detailed enough for the setup skill to own
- Harness engineering rules are good but could be more concise

**Target structure:**
- Keep: harness engineering principles (maps over manuals, executable checks, progressive disclosure)
- Keep: the concept of agent failure = missing harness
- Add: instruction to log friction points for harness-evolution feedback loop
- Extract: technical debt protocol → `tech-debt-audit` skill
- Extract: scaffold definition → `codebase-setup` skill
- Simplify: work loop → compact decision framework, not numbered steps
- Add: compact autonomy policy (what's safe to do vs. what needs confirmation)
- Update: replace AGENTS.md-centric language with CLAUDE.md-as-canonical approach

---

## Verification Strategy for This Plan

Each phase should be verified before moving to the next:

1. **Phase 1 verification:** Run `codebase-setup` on a test repo and confirm it produces a usable scaffold (CLAUDE.md + AGENTS.md symlink). Run `/plan` on a real task and confirm both Claude and Codex produce the same plan format. Run `/harness-protocol` and confirm it loads cleanly without over-constraining.
2. **Phase 2 verification:** Run each quality skill against a real codebase change. Confirm findings are actionable, not noise.
3. **Phase 3 verification:** Run frontend/architecture skills and confirm they produce decision-useful output (not generic advice).
4. **Phase 4 verification:** Run CI/docs skills in a project with existing pipelines. Confirm they integrate rather than conflict.
5. **Phase 5 verification:** Run a workflow end-to-end. Confirm subagents are delegated to appropriately and results synthesize correctly.

---

## Open Questions

- Should workflows live in this shared-skills repo (portable) or only in target project repos?
- Should subagent definitions be personal (`~/.claude/agents/`) or project-level?
- How to handle skill versioning as models evolve further?
- Should there be a "skill linter" that checks skills against the design principles?
- How to test skills in isolation (without a full project context)?

---

## Success Criteria

This plan is complete when:

1. A new codebase can be bootstrapped with `/codebase-setup` and have full agent operational context (CLAUDE.md as canonical, AGENTS.md as redirect)
2. Every skill in the suite follows the modern prompting principles (judgment over constraints)
3. Skills are portable across Claude Code, Cursor, Codex, and Gemini CLI via Agent Skills standard
4. Quality skills (test, security, review, debt) produce actionable findings with adversarial verification
5. The harness protocol is lean enough that new models follow it without ignoring half of it
6. Workflow templates demonstrate scalable multi-agent patterns for common tasks
7. The harness-evolution feedback loop is operational: agents log friction, and regular consolidation produces measurable skill improvements over time
8. GCP suite is split into focused sub-skills with a `deploy.sh` template, each triggering only when relevant to the specific concern
