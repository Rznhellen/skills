# Shared Skills

A portable agent harness — skills, subagents, and workflows for software factory / harness engineering. Install into any codebase via:

```bash
npx skills install 'Rznhellen/shared-skills'
```

Skills follow the [Agent Skills open standard](https://agentskills.io) for cross-tool portability (Claude Code, Cursor, Codex, Gemini CLI, JetBrains Junie).

## Directory Layout

```text
shared-skills/
├── CLAUDE.md                    # Canonical guidance
├── AGENTS.md                    # Points to CLAUDE.md
├── skills/                      # Portable skills (SKILL.md format)
└── docs/
    ├── exec-plans/              # Execution plans
    └── harness-feedback/        # Friction entries for evolution
```

## Skills

### Foundation
| Skill | Trigger |
|-------|---------|
| [codebase-setup](skills/codebase-setup/) | Bootstrapping a new codebase for agent work |
| [plan](skills/plan/) | Non-trivial work needing structured planning |
| [harness-protocol](skills/harness-protocol/) | Working in any software repository |

### Quality & Verification
| Skill | Trigger |
|-------|---------|
| [test-strategy](skills/test-strategy/) | Deciding how to test a change |
| [security-review](skills/security-review/) | Security assessment of changes or areas |
| [code-review](skills/code-review/) | Pre-merge code review |
| [tech-debt-audit](skills/tech-debt-audit/) | Identifying and recording technical debt |

### Architecture & Design
| Skill | Trigger |
|-------|---------|
| [frontend-design](skills/frontend-design/) | Frontend architecture and design decisions |
| [architecture-decision](skills/architecture-decision/) | Decisions with trade-offs that future agents need |
| [gcp-architecture](skills/gcp-architecture/) | Starting a GCP project, choosing surfaces |
| [gcp-deploy](skills/gcp-deploy/) | First deploy, bootstrap, deploy.sh creation |
| [gcp-buildpacks](skills/gcp-buildpacks/) | Setting up deployable surfaces with Buildpacks |
| [gcp-cicd](skills/gcp-cicd/) | Setting up CI/CD, Cloud Build triggers |
| [gcp-triage](skills/gcp-triage/) | Build/deploy failures, log retrieval |

### Operations
| Skill | Trigger |
|-------|---------|
| [harness-evolution](skills/harness-evolution/) | Consolidating feedback into harness improvements |
| [documentation-scaffold](skills/documentation-scaffold/) | Ongoing documentation maintenance |
| [release-workflow](skills/release-workflow/) | Release process guidance |

### Utility
| Skill | Trigger |
|-------|---------|
| [change-vscode-color](skills/change-vscode-color/) | Setting workspace VS Code colors |

## Design Philosophy

Skills provide **decision context** (why, when, what good looks like) rather than step-by-step constraints. The new model generation handles nuance; our job is to give it the right map.

See [docs/exec-plans/active/skills-suite-buildout.md](docs/exec-plans/active/skills-suite-buildout.md) for the full design rationale and implementation plan.

## Adding a Skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`)
2. Keep SKILL.md under 100 lines — push detail into `reference/`
3. Write `description` as a specific trigger condition ("Use when...")
4. Add optional `reference/` files for templates, specs, or examples
5. Update this README's skills table
