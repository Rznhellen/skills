# GCP Cloud Run Scaffold

**Ship a new GCP project onto a proven Cloud Run architecture — no Dockerfiles, no bespoke CI/CD, no auth guesswork.**

This skill teaches Claude a complete, opinionated house architecture for GCP-hosted products, distilled from a production multi-surface system (admin UI, private API, async job, public MCP server). Install it and Claude will scaffold new GCP projects — or add new deployable surfaces to existing ones — the same battle-tested way every time.

## What you get

- **No Dockerfiles.** Every service/job is just a `Procfile` + dependency manifest, built by Google Cloud Buildpacks.
- **One Cloud Build pipeline per surface**, each with a minimal build context and a path-scoped GitHub trigger — a push to one surface never rebuilds the rest.
- **A storage split that doesn't fight itself**: GCS for bytes, Firestore for table state.
- **Auth boundaries decided for you**: IAP for human-facing surfaces, OIDC identity tokens service-to-service, pluggable auth modes for public-facing APIs.
- **Immutable, promoted artifacts** — versioned outputs with a rollback story, not in-place mutation.
- A **step-by-step scaffolding checklist** (APIs to enable, service accounts to create, IAM roles to grant, trigger setup) so nothing gets missed on day one.
- Ready-to-use templates in [`reference/`](reference/): [`cloudbuild-service.yaml`](reference/cloudbuild-service.yaml), [`cloudbuild-job.yaml`](reference/cloudbuild-job.yaml), [`create-triggers.sh`](reference/create-triggers.sh), and a minimal stdlib-only [`Procfile`](reference/Procfile) setup.

## When Claude reaches for it

Starting a new GCP project, adding a new deployable surface to an existing one, or setting up its CI/CD pipeline — before writing a `Dockerfile`, GitHub Actions workflow, or Terraform for it.

See [`SKILL.md`](SKILL.md) for the full guidance Claude follows.
