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
| [s-codebase-setup](skills/s-codebase-setup/) | Bootstrapping a new codebase for agent work |
| [s-plan](skills/s-plan/) | Non-trivial work needing structured planning |
| [s-harness-protocol](skills/s-harness-protocol/) | Working in any software repository |

### Quality & Verification
| Skill | Trigger |
|-------|---------|
| [s-test-strategy](skills/s-test-strategy/) | Deciding how to test a change |
| [s-security-review](skills/s-security-review/) | Security assessment of changes or areas |
| [s-code-review](skills/s-code-review/) | Pre-merge code review |
| [s-tech-debt-audit](skills/s-tech-debt-audit/) | Identifying and recording technical debt |

### Architecture & Design
| Skill | Trigger |
|-------|---------|
| [s-frontend-design](skills/s-frontend-design/) | Frontend architecture and design decisions |
| [s-architecture-decision](skills/s-architecture-decision/) | Decisions with trade-offs that future agents need |
| [s-gcp-architecture](skills/s-gcp-architecture/) | Starting a GCP project, choosing surfaces |
| [s-gcp-deploy](skills/s-gcp-deploy/) | First deploy, bootstrap, deploy.sh creation |
| [s-gcp-buildpacks](skills/s-gcp-buildpacks/) | Setting up deployable surfaces with Buildpacks |
| [s-gcp-cicd](skills/s-gcp-cicd/) | Setting up CI/CD, Cloud Build triggers |
| [s-gcp-triage](skills/s-gcp-triage/) | Build/deploy failures, log retrieval |

### Operations
| Skill | Trigger |
|-------|---------|
| [s-harness-evolution](skills/s-harness-evolution/) | Consolidating feedback into harness improvements |
| [s-documentation-scaffold](skills/s-documentation-scaffold/) | Ongoing documentation maintenance |
| [s-release-workflow](skills/s-release-workflow/) | Release process guidance |

### Utility
| Skill | Trigger |
|-------|---------|
| [s-change-vscode-color](skills/s-change-vscode-color/) | Setting workspace VS Code colors |

## Design Philosophy

Skills provide **decision context** (why, when, what good looks like) rather than step-by-step constraints. The new model generation handles nuance; our job is to give it the right map.

See [docs/exec-plans/active/skills-suite-buildout.md](docs/exec-plans/active/skills-suite-buildout.md) for the full design rationale and implementation plan.

## Adding a Skill

1. Create `skills/s-<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`)
2. Keep SKILL.md under 100 lines — push detail into `reference/`
3. Write `description` as a specific trigger condition ("Use when...")
4. Add optional `reference/` files for templates, specs, or examples
5. Update this README's skills table
