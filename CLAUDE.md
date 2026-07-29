# Shared Skills Repository

This is a portable agent harness — a collection of skills, subagents, and workflow templates installed into codebases via `npx skills install 'Rznhellen/shared-skills'`.

## Operating Principles

- Skills provide decision context (why, when, what good looks like) — not step-by-step constraints
- CLAUDE.md is the single source of truth in any codebase; AGENTS.md redirects here
- Every skill follows the Agent Skills open standard for cross-tool portability
- Agent failure is missing harness — when something goes wrong, improve the skill

## Skill Design

Skills live in `skills/<name>/SKILL.md` with optional `reference/` subdirectories. The `description` field in frontmatter controls discovery — write it as a specific trigger condition.

Keep SKILL.md under 100 lines. Push detailed specs into `reference/`. State each instruction once. Use decision frameworks over procedures.

## Repository Structure

- `skills/` — portable skills (SKILL.md format, Agent Skills standard)
- `docs/exec-plans/` — active and completed execution plans
- `docs/harness-feedback/` — friction entries for harness-evolution consolidation

## When Contributing

- Follow the skill writing guidelines in `docs/exec-plans/active/skills-suite-buildout.md`
- Test skills against a real codebase before marking complete
- Log friction points in `docs/harness-feedback/` when skills cause confusion
