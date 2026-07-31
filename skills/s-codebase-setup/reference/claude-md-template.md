# [Project Name]

[One paragraph: what this project does, who it serves, what problem it solves.]

## Quick Start

```bash
# Install dependencies
# Run locally
# Run tests
```

## Architecture

[Brief: main components, how they connect, where state lives.]

See ARCHITECTURE.md for the full domain map.

## Conventions

- [Language/framework patterns this codebase follows]
- [Naming conventions if non-obvious]
- [File organization principles]

## Commands

| Task | Command |
|------|---------|
| Run tests | `...` |
| Lint | `...` |
| Build | `...` |
| Deploy | `...` |

## Boundaries

- [What's safe for agents to change without asking]
- [What requires human approval: secrets, infra, public APIs]
- [External services and their trust boundaries]

## Agent Guidance

- Log friction points to `docs/harness-feedback/` when something is unclear or missing
- Check `docs/exec-plans/active/` for in-progress work before starting related changes
- Update this file when your work changes behavior, setup, or conventions

### Skills to invoke proactively

- `/s-harness-protocol` — read at the start of any session in this repo; sets operating context
- `/s-plan` — before non-trivial multi-file work or when trade-offs exist
- `/s-code-review` — after completing a change, before considering it done
- `/s-documentation-scaffold` — after any change that affects setup, conventions, or public behavior
- `/s-architecture-decision` — when choosing between approaches with lasting consequences
