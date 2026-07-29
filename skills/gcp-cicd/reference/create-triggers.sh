#!/usr/bin/env bash
# Template Cloud Build v2 GitHub connection / repository / trigger script.
# Copy into deploy/scripts/create-triggers.sh, fill in one trigger block per
# deployable surface, and run during first deploy. This script is rerunnable:
# it creates missing resources and skips ones that already exist.
set -euo pipefail

: "${PROJECT_ID:?Set PROJECT_ID}"
: "${REPO_OWNER:?Set REPO_OWNER}"
: "${REPO_NAME:?Set REPO_NAME}"
: "${REGION:=us-central1}"
: "${CONNECTION_NAME:=github-main}"
: "${REPOSITORY_NAME:=${REPO_NAME}}"
: "${BUILD_SA_NAME:=my-build}"
: "${PAUSE_FOR_CICD_CONNECTION:=1}"
: "${OPEN_CICD_CONNECT_URL:=1}"
: "${SKIP_CICD_TRIGGERS:=0}"

BRANCH_PATTERN="${BRANCH_PATTERN:-^main$}"
BUILD_SA_RESOURCE="projects/${PROJECT_ID}/serviceAccounts/${BUILD_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
REPOSITORY_RESOURCE="projects/${PROJECT_ID}/locations/${REGION}/connections/${CONNECTION_NAME}/repositories/${REPOSITORY_NAME}"

gcloud config set project "${PROJECT_ID}"

connection_stage() {
  gcloud builds connections describe "${CONNECTION_NAME}" \
    --region="${REGION}" \
    --format="value(installationState.stage)" 2>/dev/null || true
}

if [[ -z "$(connection_stage)" ]]; then
  echo "Creating Cloud Build GitHub connection ${CONNECTION_NAME}."
  echo "Follow the authorization URL printed by gcloud."
  gcloud builds connections create github "${CONNECTION_NAME}" \
    --region="${REGION}"
fi

if [[ "$(connection_stage)" != "COMPLETE" ]]; then
  ACTION_URL="$(gcloud builds connections describe "${CONNECTION_NAME}" \
    --region="${REGION}" \
    --format="value(installationState.actionUri)" 2>/dev/null || true)"
  if [[ -n "${ACTION_URL}" ]]; then
    echo "Cloud Build GitHub connection authorization URL: ${ACTION_URL}"
    if [[ "${OPEN_CICD_CONNECT_URL}" == "1" ]] && command -v open >/dev/null 2>&1; then
      open "${ACTION_URL}" || true
    fi
  fi

  if [[ "${PAUSE_FOR_CICD_CONNECTION}" == "1" && -t 0 ]]; then
    read -r -p "Authorize the GitHub connection, then press Enter to recheck."
  fi
fi

if [[ "$(connection_stage)" != "COMPLETE" ]]; then
  if [[ "${SKIP_CICD_TRIGGERS}" == "1" || ! -t 0 ]]; then
    echo "Cloud Build GitHub connection is incomplete; continuing without triggers."
    exit 0
  fi
  echo "ERROR: Cloud Build GitHub connection ${CONNECTION_NAME} is not COMPLETE." >&2
  exit 1
fi

if ! gcloud builds repositories describe "${REPOSITORY_NAME}" \
  --connection="${CONNECTION_NAME}" \
  --region="${REGION}" >/dev/null 2>&1; then
  gcloud builds repositories create "${REPOSITORY_NAME}" \
    --connection="${CONNECTION_NAME}" \
    --region="${REGION}" \
    --remote-uri="https://github.com/${REPO_OWNER}/${REPO_NAME}.git"
fi

create_trigger_if_missing() {
  local trigger_name="$1"
  local build_config="$2"
  local included_files="$3"

  if gcloud builds triggers describe "${trigger_name}" \
    --region="${REGION}" >/dev/null 2>&1; then
    echo "Trigger ${trigger_name} already exists."
    return
  fi

  gcloud builds triggers create github \
    --name="${trigger_name}" \
    --region="${REGION}" \
    --repository="${REPOSITORY_RESOURCE}" \
    --branch-pattern="${BRANCH_PATTERN}" \
    --build-config="${build_config}" \
    --service-account="${BUILD_SA_RESOURCE}" \
    --included-files="${included_files}" \
    --include-logs-with-status
}

# One call per surface. --included-files scopes the trigger so a push that
# only touches an unrelated surface's tree does not rebuild this one.
create_trigger_if_missing \
  "deploy-my-service" \
  "deploy/cloudbuild.my-service.yaml" \
  "apps/my-service/**,packages/shared_core/**,deploy/cloudbuild.my-service.yaml"

# create_trigger_if_missing \
#   "deploy-my-job" \
#   "deploy/cloudbuild.my-job.yaml" \
#   "apps/my-job/**,packages/shared_core/**,deploy/cloudbuild.my-job.yaml"
