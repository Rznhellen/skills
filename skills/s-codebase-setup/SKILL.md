---
name: s-codebase-setup
description: >-
  Use when bootstrapping a new codebase for agent work, onboarding an existing
  repo to the harness, or when a project lacks CLAUDE.md / AGENTS.md / docs scaffold.
---

# Codebase Setup

Bootstrap a repository with the operational context agents need from day one.

## Decision Framework

Assess the repo before scaffolding:

- **Existing structure?** Read what's already there. Never overwrite real content with templates.
- **Repo complexity?** A 3-file CLI gets minimal mode. A multi-service monorepo gets full scaffold.
- **Which agents will work here?** Always create CLAUDE.md + AGENTS.md. Add platform adapters only if the team uses those tools.

## What to Create

### Always (Minimal Mode)

1. **CLAUDE.md** — canonical guidance file. All real codebase context lives here: project description, architecture overview, conventions, commands, and boundaries.
2. **AGENTS.md** — single line: `Reference CLAUDE.md`
3. **ARCHITECTURE.md** — domain map, boundaries, data flow, key invariants.

### When the Repo Has Depth (Full Mode)

Add the docs scaffold — but only sections with real content:

```
docs/
├── design-docs/
│   └── index.md
├── exec-plans/
│   ├── active/
│   └── completed/
├── generated/
├── product-specs/
└── references/
```

Optionally:
- `.claude/settings.json` — sensible default permissions
- `.claude/agents/` — project-specific subagent definitions
- Platform adapters (GEMINI.md, .cursor/rules/) that reference CLAUDE.md

## What Good Looks Like

- CLAUDE.md answers: what is this project, how do I run it, what are the boundaries, what patterns does this codebase follow
- An agent dropped into this repo can start productive work after reading only CLAUDE.md
- No empty placeholder files — every file has real content or doesn't exist yet
- AGENTS.md is one line pointing to CLAUDE.md

## Verification

After scaffolding, confirm:
- `cat AGENTS.md` shows the redirect to CLAUDE.md
- CLAUDE.md has project-specific content (not just template boilerplate)
- No files created that are empty or template-only
- Running `tree docs/` shows only directories/files with real content

## Reference Material

See `reference/` for templates:
- `reference/claude-md-template.md` — starting structure for CLAUDE.md
- `reference/architecture-md-template.md` — ARCHITECTURE.md starter
