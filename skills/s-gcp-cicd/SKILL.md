---
name: s-gcp-cicd
description: >-
  Use when setting up CI/CD pipelines, Cloud Build triggers, writing
  cloudbuild.yaml files, or troubleshooting pipeline configuration.
---

# GCP CI/CD — Cloud Build Pipelines & Triggers

## Pipeline architecture

One `deploy/cloudbuild.<surface>.yaml` per deployable surface. Each pipeline:

1. **Prepares a minimal build context** — copies only that surface's app + its shared packages into `/workspace/.deploy/<surface>/`
2. **Auto-discovers upstream URLs** — calls `gcloud run services describe <upstream>` and writes result to a file; decides per-dependency whether missing upstream is a hard-fail or graceful degradation
3. **Deploys with pinned identities** — `--update-env-vars` / `--update-secrets` (never `--set-*`)
4. **Pins build identity** in the YAML via `serviceAccount:` field
5. **Sets `options: { logging: CLOUD_LOGGING_ONLY }`**

See `reference/cloudbuild-service.yaml` and `reference/cloudbuild-job.yaml` for full templates.

## Cloud Build YAML guardrails

| Pattern | Correct | Wrong |
|---|---|---|
| User substitutions | `${_REGION}`, `${_SERVICE_NAME}` | Substitutions without `_` prefix |
| Bash variables in YAML | `$$VAR`, `$${VAR}` | `$VAR` (Cloud Build eats it) |
| Custom substitution values | Store prefix, construct email in command | `_SA: svc@${PROJECT_ID}.iam...` (recursive expansion) |
| Env vars on deploy | `--update-env-vars` | `--set-env-vars` (wipes operator-set vars) |
| Secrets on deploy | `--update-secrets` | `--set-secrets` |
| Values with commas | `--substitutions=^|^_KEY=a,b|_OTHER=c` | Default comma delimiter with comma values |

## Static scans (add to CI)

```bash
# Catch accidental recursive substitution in SA emails
rg -n '_BUILD_SERVICE_ACCOUNT: .*PROJECT_ID|_RUNTIME_SERVICE_ACCOUNT: .*PROJECT_ID' deploy/*.yaml

# Catch un-escaped bash vars that Cloud Build will eat
rg -n -P '(?<!\$)\$\{(FIRESTORE_DB|ASSET_BUCKET|API_URL)\}|(?<!\$)\$(FIRESTORE_DB|ASSET_BUCKET|API_URL)\b' deploy/*.yaml
```

## GitHub triggers (Cloud Build v2)

One trigger per surface, all branch-restricted to `^main$`. Uses Cloud Build v2 connections (not legacy 1st-gen repository mapping).

### Setup sequence

1. Create GitHub connection (one-time, requires browser authorization)
2. Link repository through the connection
3. Create path-scoped triggers per surface

See `reference/create-triggers.sh` for the rerunnable setup script.

### Trigger scoping

Each trigger's `--included-files` limits it to that surface's tree plus shared dependencies:

```
apps/<surface>/**,packages/<shared-deps>/**,deploy/cloudbuild.<surface>.yaml
```

A push that only touches an unrelated surface does not rebuild this one.

### Connection prerequisites

- The browser-authorizing Google account needs `roles/cloudbuild.connectionAdmin`
- During incomplete connection setup, Cloud Build service agent may need temporary `roles/secretmanager.admin`
- Remove or narrow the secret manager grant after setup if security policy requires

### Terraform modeling

If Terraform owns triggers, use `google_cloudbuildv2_repository` and `repository_event_config`. Do not use the old `github { owner/name }` mapping.

## Build identity

- One build SA (`<prefix>-build`) runs all builds across all surfaces
- Pinned in YAML: `serviceAccount: projects/${PROJECT_ID}/serviceAccounts/${_BUILD_SERVICE_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com`
- Required roles: `cloudbuild.builds.builder`, `run.builder`, `run.sourceDeveloper`, `run.admin`, `artifactregistry.writer`, `logging.logWriter`
- Also needs `iam.serviceAccountUser` on every runtime SA and on itself
