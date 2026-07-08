# Shared Skills

This directory is a small library of reusable agent skills. Each skill packages a
repeatable workflow, architectural pattern, or operating protocol that can be
installed into an agent environment and reused across projects.

The goal is to keep durable guidance out of one-off chats and put it in files
agents can rediscover: each skill's `SKILL.md` for agent-facing instructions,
this root `README.md` for human-facing context, and optional reference assets
for templates or commands.

## Directory Layout

```text
shared-skills/
|-- README.md
`-- skills/
    |-- change-vscode-color/
    |   `-- SKILL.md
    |-- gcp-project-scaffold/
    |   |-- SKILL.md
    |   `-- reference/
    `-- harness-protocol/
        `-- SKILL.md
```

## Current Skills

| Skill | Purpose | Key Files |
|---|---|---|
| [`skills/change-vscode-color`](skills/change-vscode-color/) | Manual-only workflow for setting workspace-scoped VS Code title bar, status bar, and window border colors without tinting editor content, Activity Bar, Side Bar, panels, or Peacock-managed UI regions. | [`SKILL.md`](skills/change-vscode-color/SKILL.md) |
| [`skills/harness-protocol`](skills/harness-protocol/) | Repository work loop and harness-engineering protocol for coding agents. Use it at the start of codebase work, after compaction, during handoffs, and when setting up repo-local docs and plans. Inspired by OpenAI's harness engineering article. | [`SKILL.md`](skills/harness-protocol/SKILL.md) |
| [`skills/gcp-project-scaffold`](skills/gcp-project-scaffold/) | Opinionated GCP Cloud Run project scaffold using Buildpacks, Procfiles, path-scoped Cloud Build pipelines, GCS/Firestore storage boundaries, explicit auth boundaries, and immutable artifact promotion. Includes templates for Cloud Build services/jobs, trigger creation, Procfiles, and stdlib-only Python dependencies. | [`SKILL.md`](skills/gcp-project-scaffold/SKILL.md), [`reference/`](skills/gcp-project-scaffold/reference/) |

## Skill Conventions

Each skill directory should be self-contained and should use this structure:

```text
skills/<skill-name>/
|-- SKILL.md
`-- reference/        # optional templates, scripts, examples, or source docs
```

Use `SKILL.md` for the instructions an agent must follow. Keep it direct,
operational, and specific about when the skill should trigger.

Use `reference/` for reusable material the skill points to, such as templates,
sample configs, scripts, examples, or stable source material. Reference files
should be named clearly enough that an agent can select only the relevant ones.

Keep human-facing package context in this root README. Do not add individual
skill README files unless a skill has unusual external packaging needs that
cannot be handled here or in `SKILL.md`.

## Adding A Skill

1. Create `skills/<skill-name>/`.
2. Add `SKILL.md` with frontmatter containing at least `name` and
   `description`.
3. Add optional `reference/` files only when they are directly useful to the
   skill workflow.
4. Link the new skill in the table above.

Prefer small, focused skills over broad manuals. A good skill should help an
agent do a real task with fewer assumptions, clearer source material, and a
repeatable verification path.

## Maintenance Notes

- Keep this root README as a map, not a full manual.
- Keep detailed workflow guidance inside the relevant skill's `SKILL.md`.
- Avoid duplicating long instructions across skills.
- When renaming or deleting a skill, update links in this README and run a
  stale-reference search across the directory.
- Do not store secrets, raw logs, private transcripts, or environment-specific
  credentials in skill files.
