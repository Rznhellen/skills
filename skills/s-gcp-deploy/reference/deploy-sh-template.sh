#!/usr/bin/env bash
# Idempotent deploy wrapper for GCP Cloud Run projects.
# Copy to deploy/deploy.sh, fill in PROJECT_ID and surface names.
#
# Usage:
#   ./deploy.sh                    — full deploy (terraform + all surfaces)
#   ./deploy.sh --plan             — terraform plan only
#   ./deploy.sh --surface=api      — deploy one surface
#   ./deploy.sh --skip-terraform   — skip infra, just redeploy services
#   ./deploy.sh --help             — show usage
set -euo pipefail

# === Configuration ===
: "${PROJECT_ID:?Set PROJECT_ID}"
: "${REGION:=us-central1}"
: "${BUILD_SA_NAME:=my-build}"
: "${TF_STATE_BUCKET:=${PROJECT_ID}-terraform-state}"
: "${TF_DIR:=infra/terraform/envs/dev}"

# Surfaces in dependency order (deploy left-to-right)
SURFACES=(api frontend worker)

# === Argument parsing ===
PLAN_ONLY=false
SKIP_TERRAFORM=false
TARGET_SURFACE=""

for arg in "$@"; do
  case "$arg" in
    --plan)           PLAN_ONLY=true ;;
    --skip-terraform) SKIP_TERRAFORM=true ;;
    --surface=*)      TARGET_SURFACE="${arg#*=}" ;;
    --help|-h)
      sed -n '2,8p' "$0" | sed 's/^# //'
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

# === Helper functions ===
info()  { printf '\033[1;34m▶ %s\033[0m\n' "$*"; }
ok()    { printf '\033[1;32m✓ %s\033[0m\n' "$*"; }
fail()  { printf '\033[1;31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

# === Phase 1: Preflight ===
info "Checking credentials..."

ACTIVE_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format='value(account)' 2>/dev/null | head -1)
[[ -n "$ACTIVE_ACCOUNT" ]] || fail "No active gcloud account. Run: gcloud auth login"

gcloud auth application-default print-access-token >/dev/null 2>&1 \
  || fail "ADC not configured. Run: gcloud auth application-default login --project=$PROJECT_ID"

gcloud config set project "$PROJECT_ID" --quiet
ok "Credentials verified (operator: $ACTIVE_ACCOUNT)"

# === Phase 2: State bucket ===
if [[ "$SKIP_TERRAFORM" == "false" ]]; then
  info "Ensuring Terraform state bucket..."
  if ! gsutil ls "gs://$TF_STATE_BUCKET" >/dev/null 2>&1; then
    gsutil mb -p "$PROJECT_ID" -l "$REGION" -b on "gs://$TF_STATE_BUCKET"
    ok "Created state bucket: $TF_STATE_BUCKET"
  else
    ok "State bucket exists: $TF_STATE_BUCKET"
  fi
fi

# === Phase 3: Terraform ===
if [[ "$SKIP_TERRAFORM" == "false" ]]; then
  info "Running Terraform..."
  terraform -chdir="$TF_DIR" init -input=false
  terraform -chdir="$TF_DIR" fmt -check -recursive || fail "Terraform fmt check failed"
  terraform -chdir="$TF_DIR" validate -no-color || fail "Terraform validation failed"

  if [[ "$PLAN_ONLY" == "true" ]]; then
    terraform -chdir="$TF_DIR" plan -no-color
    ok "Plan complete. Exiting (--plan mode)."
    exit 0
  fi

  terraform -chdir="$TF_DIR" apply -auto-approve -no-color
  ok "Terraform apply complete"
fi

# === Phase 4: Deploy surfaces ===
deploy_surface() {
  local surface="$1"
  local config="deploy/cloudbuild.${surface}.yaml"

  if [[ ! -f "$config" ]]; then
    fail "Build config not found: $config"
  fi

  info "Deploying surface: $surface"
  gcloud builds submit . \
    --project="$PROJECT_ID" \
    --region="$REGION" \
    --config="$config" \
    --service-account="projects/${PROJECT_ID}/serviceAccounts/${BUILD_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --suppress-logs

  ok "Deployed: $surface"
}

if [[ -n "$TARGET_SURFACE" ]]; then
  deploy_surface "$TARGET_SURFACE"
else
  for surface in "${SURFACES[@]}"; do
    deploy_surface "$surface"
  done
fi

# === Phase 5: Post-deploy verification ===
info "Running smoke tests..."

for surface in "${SURFACES[@]}"; do
  URL=$(gcloud run services describe "$surface" \
    --region="$REGION" \
    --format="value(status.url)" 2>/dev/null || true)
  if [[ -n "$URL" ]]; then
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL/healthz" 2>/dev/null || echo "000")
    echo "  $surface: $URL → HTTP $STATUS"
  fi
done

ok "Deploy complete"
echo ""
echo "Log retrieval:"
echo "  gcloud builds log <BUILD_ID> --project=$PROJECT_ID --region=$REGION"
echo "  gcloud logging read 'resource.type=\"cloud_run_revision\"' --project=$PROJECT_ID --limit=50"
