# Architecture

## System Overview

[Diagram or description: major components, their responsibilities, how they connect.]

## Domain Boundaries

| Domain | Owns | Boundary |
|--------|------|----------|
| [Name] | [Responsibilities] | [What it exposes, what it hides] |

## Data Flow

[How data moves through the system: entry points → processing → storage → output.]

## Key Invariants

- [Things that must always be true for the system to be correct]
- [Consistency rules, ordering guarantees, security boundaries]

## Runtime Shape

- **Where it runs:** [Cloud provider, local, hybrid]
- **How it scales:** [Scaling strategy]
- **How it fails:** [Failure modes and recovery]

## Dependencies

| Dependency | Purpose | Boundary |
|------------|---------|----------|
| [Name] | [Why we use it] | [How we isolate from it] |
