---
name: gcp-triage
description: >-
  Use when a Cloud Build or Cloud Run deploy fails, when you need to
  retrieve logs, validate Terraform, or diagnose common GCP failure patterns.
---

# GCP Triage — Failure Diagnosis & Recovery

## Decision framework: where to look first

```
Build failed?
  → gcloud builds log <BUILD_ID>
  → Check: substitution errors, missing files, permission denied

Deploy succeeded but service crashes?
  → gcloud logging read (Cloud Run revision logs)
  → Check: import errors, missing env vars, wrong PYTHONPATH

Service runs but returns errors?
  → gcloud logging read (application logs)
  → Check: auth failures (403), missing secrets, upstream unreachable

Terraform failed?
  → terraform plan (what was it trying to do?)
  → Check: state drift, missing APIs, permission denied
```

## Log retrieval commands

### Cloud Build logs

```bash
# Get the build ID from the trigger output or builds list
gcloud builds list --project="$PROJECT_ID" --region="$REGION" --limit=5

# Full build log
gcloud builds log "$BUILD_ID" --project="$PROJECT_ID" --region="$REGION"

# Build metadata (status, timing, errors)
gcloud builds describe "$BUILD_ID" --project="$PROJECT_ID" --region="$REGION" --format=json
```

### Cloud Run logs

```bash
# Recent logs for a service
gcloud logging read \
  'resource.type="cloud_run_revision" AND resource.labels.service_name="<service>"' \
  --project="$PROJECT_ID" \
  --limit=80

# Error-only logs
gcloud logging read \
  'resource.type="cloud_run_revision" AND resource.labels.service_name="<service>" AND severity>=ERROR' \
  --project="$PROJECT_ID" \
  --limit=30

# Startup logs (crash loops)
gcloud logging read \
  'resource.type="cloud_run_revision" AND resource.labels.service_name="<service>" AND textPayload=~"Starting|started|listening|import|Error"' \
  --project="$PROJECT_ID" \
  --limit=50
```

## Terraform validation

```bash
# Format check (catches style drift)
terraform fmt -check -recursive infra/terraform

# Validate configuration (catches syntax and reference errors)
terraform -chdir=infra/terraform/envs/dev validate -no-color

# Plan (shows what would change, catches state drift)
terraform -chdir=infra/terraform/envs/dev plan -no-color
```

Note: `terraform validate` can be environment-sensitive in agent sandboxes because provider plugins may not instantiate. Still require operator-environment checks before deployment.

## Common failure patterns

### Build failures

| Symptom | Likely cause | Fix |
|---|---|---|
| `permission denied` on `--source` deploy | Build SA missing `run.sourceDeveloper` | Grant the role (required even when staging bucket exists) |
| `could not find runtime` | Buildpacks can't detect language | Ensure `requirements.txt` or `package.json` exists in staged context |
| `$$VAR` shows as literal `$VAR` | YAML not escaping bash variable | Use `$$` for bash vars in Cloud Build YAML |
| `substitution _X not found` | Substitution not declared in YAML | Add to `substitutions:` block or pass via `--substitutions` |
| Image push fails | Build SA missing `artifactregistry.writer` | Grant the role on the target AR repo |

### Deploy / runtime failures

| Symptom | Likely cause | Fix |
|---|---|---|
| Container crashes immediately | Import error from staged context | Run staged-layout import check locally |
| `ModuleNotFoundError` | PYTHONPATH not set or packages not copied | Verify `--update-env-vars="PYTHONPATH=packages:."` and context prep |
| 403 from service-to-service call | Caller missing `roles/run.invoker` on callee | Add IAM binding |
| 403 from IAP-protected service | User not in IAP allowed list | Add in IAP console, not IAM |
| Service starts but env var empty | Used `--set-env-vars` (wiped others) | Switch to `--update-env-vars` |
| Secret not found at runtime | Secret version not enabled or name mismatch | `gcloud secrets versions list <name>` to verify |

### Terraform failures

| Symptom | Likely cause | Fix |
|---|---|---|
| `invalid_grant` / `invalid_rapt` | ADC expired or RAPT policy | `gcloud auth application-default login` |
| Resource already exists | Created manually or by prior partial apply | Import into state: `terraform import` |
| API not enabled | Missing from enable list | Add to API enable step in deploy script |
| State lock timeout | Prior apply crashed without releasing | `terraform force-unlock <LOCK_ID>` (with caution) |

## Recovery principles

- **Reruns should converge.** If a deploy fails partway, rerunning the same script should pick up where it left off.
- **Never delete the state bucket** after a failed apply. Fix the issue and re-apply.
- **Check before creating.** Every resource creation should be gated on existence check.
- **Fetch logs before editing code.** With `CLOUD_LOGGING_ONLY`, local output can be generic — the real error is in Cloud Logging.
