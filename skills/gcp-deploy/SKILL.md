---
name: gcp-deploy
description: >-
  Use when doing a first deploy, creating a deploy.sh wrapper, setting up
  credentials, bootstrapping a new environment, or managing secrets.
---

# GCP Deploy — First Deploy & Bootstrap

## Operating contract

First deploy is a recoverable state machine, not a linear happy path. Reruns converge without deleting durable resources. Never ask the operator to delete a Terraform state bucket after a failed apply.

## Deploy phases

```
1. Preflight creds       → verify gcloud + ADC are active
2. State bucket          → create if missing, reuse on reruns
3. APIs + base infra     → enable project APIs, create stable resources
4. GitHub connection     → Cloud Build v2 connection (browser auth, one-time)
5. First terraform       → skip IAM/IAP bindings if services don't exist yet
6. Secrets               → create containers, set initial versions
7. Services in order     → deploy surfaces in dependency order
8. Second terraform      → IAM/IAP bindings that require deployed services
9. Smoke tests           → verify auth boundaries, print URLs + log hints
```

Each phase is idempotent. The deploy script should check before creating and skip what already exists.

## Credential stores (distinct, don't confuse them)

| Credential | Command | Used by |
|---|---|---|
| Operator identity | `gcloud auth login` | Direct `gcloud` commands |
| Application Default Credentials | `gcloud auth application-default login` | Terraform, local client libraries |
| Runtime metadata credentials | (automatic on Cloud Run) | Deployed services — never ADC |

ADC is never baked into images or used by deployed services.

## Preflight checks

```bash
# Verify active credentials
gcloud auth list --filter=status:ACTIVE --format='value(account)'
gcloud auth application-default print-access-token >/dev/null
gcloud auth application-default set-quota-project "$PROJECT_ID"
```

If Terraform fails with `invalid_grant` / `invalid_rapt`, reauthenticate ADC:

```bash
gcloud auth application-default login --project="$PROJECT_ID"
gcloud auth application-default set-quota-project "$PROJECT_ID"
```

## Secret handling

- First deploy creates required secret versions
- Normal reruns verify that an enabled version exists
- New versions require explicit operator intent (`ROTATE_SECRETS=1` or `ADD_SECRET_VERSION=1`)
- Real values never appear in shell history, chat, screenshots, or logs
- If a secret appears in any of those places, rotate it

Prefer hidden input for ad hoc first setup:

```bash
read -r -s -p "Client secret: " CLIENT_SECRET
printf '\n'
export CLIENT_SECRET
```

## Scaffolding checklist

1. Confirm CLI + ADC credentials and ADC quota project
2. Enable APIs: `run cloudbuild artifactregistry iamcredentials iap storage firestore secretmanager logging monitoring`
3. Ensure Terraform state bucket (create if missing)
4. Create GCS buckets (`uniform-bucket-level-access`) + Firestore database
5. Pre-create Artifact Registry repo (`cloud-run-source-deploy`, docker format)
6. Pre-create `gcloud run deploy --source` staging bucket
7. Create build SA + one runtime SA per surface
8. Grant build SA: `cloudbuild.builds.builder`, `run.builder`, `run.sourceDeveloper`, `run.admin`, `artifactregistry.writer`, `logging.logWriter`, `iam.serviceAccountUser` on each runtime SA
9. Grant each runtime SA only what it needs (bucket-level access, datastore roles)
10. Deploy surfaces in dependency order
11. Enable IAP on human-facing surfaces after they exist
12. Wire `roles/run.invoker` for every caller-to-callee edge
13. Connect GitHub repo, create path-scoped triggers
14. Run post-deploy auth assertions

## Deploy script

See `reference/deploy-sh-template.sh` for an idempotent deploy wrapper supporting:

- `./deploy.sh` — full deploy (terraform + all surfaces)
- `./deploy.sh --plan` — terraform plan only
- `./deploy.sh --surface=api` — deploy one surface
- `./deploy.sh --skip-terraform` — skip infra, just redeploy services

## Post-deploy verification

```bash
# Private service should reject unauthenticated requests
curl -s -o /dev/null -w "%{http_code}" "$PRIVATE_API_URL/healthz"  # expect 403

# Public service should respond (app-level auth may still reject)
curl -s -o /dev/null -w "%{http_code}" "$PUBLIC_SERVICE_URL/healthz"  # expect 200
```
