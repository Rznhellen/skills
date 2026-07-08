# Shared Skills

This directory is a small library of reusable agent skills. Each skill packages a
repeatable workflow, architectural pattern, or operating protocol that can be
installed into an agent environment and reused across projects.

The goal is to keep durable guidance out of one-off chats and put it in files
agents can rediscover: `SKILL.md` for agent-facing instructions, `README.md` for
human-facing context, and optional reference assets for templates or commands.

## Directory Layout

```text
shared-skills/
|-- README.md
`-- skills/
    |-- gcp-project-scaffold/
    |   |-- README.md
    |   |-- SKILL.md
    |   `-- reference/
    `-- harness-protocol/
        |-- README.md
        `-- SKILL.md
```

## Current Skills

| Skill | Purpose | Key Files |
|---|---|---|
| [`skills/harness-protocol`](skills/harness-protocol/) | Repository work loop and harness-engineering protocol for coding agents. Use it at the start of codebase work, after compaction, during handoffs, and when setting up repo-local docs and plans. | [`SKILL.md`](skills/harness-protocol/SKILL.md), [`README.md`](skills/harness-protocol/README.md) |
| [`skills/gcp-project-scaffold`](skills/gcp-project-scaffold/) | Opinionated GCP Cloud Run project scaffold using Buildpacks, Procfiles, path-scoped Cloud Build pipelines, GCS/Firestore storage boundaries, and explicit auth boundaries. | [`SKILL.md`](skills/gcp-project-scaffold/SKILL.md), [`README.md`](skills/gcp-project-scaffold/README.md), [`reference/`](skills/gcp-project-scaffold/reference/) |

## Skill Conventions

Each skill directory should be self-contained and should use this structure:

```text
skills/<skill-name>/
|-- SKILL.md
|-- README.md
`-- reference/        # optional templates, scripts, examples, or source docs
```

Use `SKILL.md` for the instructions an agent must follow. Keep it direct,
operational, and specific about when the skill should trigger.

Use `README.md` for human-facing context: what the skill is for, when to use it,
what files it includes, and any important caveats.

Use `reference/` for reusable material the skill points to, such as templates,
sample configs, scripts, examples, or stable source material. Reference files
should be named clearly enough that an agent can select only the relevant ones.

## Adding A Skill

1. Create `skills/<skill-name>/`.
2. Add `SKILL.md` with frontmatter containing at least `name` and
   `description`.
3. Add a concise `README.md` that explains the skill for humans.
4. Add optional `reference/` files only when they are directly useful to the
   skill workflow.
5. Link the new skill in the table above.

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
