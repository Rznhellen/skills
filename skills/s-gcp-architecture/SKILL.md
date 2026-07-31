---
name: s-gcp-architecture
description: >-
  Use when starting a new GCP project, choosing deployable surfaces,
  designing system shape, or deciding on storage and auth boundaries.
---

# GCP Architecture — System Shape & Boundaries

## Core principles

- No Dockerfiles — Procfile + dependency manifest built by Buildpacks
- One deployable, one build config, one minimal context
- GCS owns bytes, Firestore owns table state
- Human auth is IAP; service-to-service is OIDC identity tokens
- Dedicated build identity, never Compute default SA
- Artifacts are immutable and promoted, never mutated in place

## System shape

```
Human → IAP → Frontend (Cloud Run service)
                  ↓ OIDC ID token
            Backend API (Cloud Run service)
                  ↓           ↓            ↓
            Firestore    GCS buckets    Async Job (Cloud Run Job)
                                            ↓
                                      GCS artifacts + Firestore state

External agent → OAuth/bearer → Public service (Cloud Run service)
                                      ↓
                                 GCS artifacts (read)
```

## Surface roles decision table

| You need... | Use this surface type | Auth boundary |
|---|---|---|
| Browser UI for internal users | Cloud Run service | IAP + `--no-allow-unauthenticated` |
| API called by other services | Cloud Run service | `--no-allow-unauthenticated` + caller OIDC + `roles/run.invoker` |
| Long-running / batch / async work | Cloud Run Job | Invoked by API via Cloud Run Admin API, not public |
| Externally-reachable endpoint (webhooks, agents, partners) | Cloud Run service | Pluggable auth mode (static token for testing, OAuth for production) |

Not every project needs all four. Start with what you need; the architecture supports adding surfaces later.

## Storage split decision framework

| Data characteristic | Store in | Why |
|---|---|---|
| Large, immutable blobs (uploads, exports, generated files) | GCS | Streaming, CDN-friendly, cheap at scale |
| Structured records with query patterns (status, config, mappings) | Firestore | Indexed queries, transactions, real-time listeners |
| Versioned artifacts from batch jobs | GCS with `runs/{run_id}/` prefix | Immutable promotion pattern, rollback = pointer change |
| Job state and run metadata | Firestore | Query by status, update atomically |

Never store blobs in the table store. Never treat bucket listings as the database.

## Auth boundaries

### Human access (IAP)

- Browser-facing surfaces sit behind Cloud Run IAP
- Allowed users managed in IAP screen, not in app config
- The app never implements its own login flow for internal users

### Service-to-service (OIDC)

- Caller mints an ID token from the metadata server with callee's URL as audience
- Callee trusts Cloud Run IAM via `roles/run.invoker`
- Static bearer tokens are at most defense-in-depth — never the primary boundary

### Public access (pluggable)

- Switchable at deploy time: `static` token for internal testing, OAuth/introspection for public
- Fails closed at startup if required auth settings are missing
- If `--no-invoker-iam-check` is used, validate requests in the app

## Identity model

| Identity | Purpose | Scope |
|---|---|---|
| `<prefix>-build` SA | Runs all builds across all surfaces | Project-wide, one per project |
| `<prefix>-<surface>` SA | Runtime identity for one surface | Per-surface, least-privilege |
| Operator (human) | `gcloud auth login` for CLI commands | Interactive sessions only |
| ADC | `gcloud auth application-default login` for Terraform/local dev | Local development only, never in images |

No service account JSON keys anywhere — not in source, images, or build artifacts.

## When to deviate

Reach for a Dockerfile only when Buildpacks genuinely cannot express the layout (non-supported runtime, native deps Buildpacks cannot compile). Treat that as the fallback, not the default.

Use Cloud SQL instead of Firestore when you need relational joins, complex transactions across many entities, or SQL compatibility. Document the choice in an ADR.
