#!/usr/bin/env bash
# Template trigger-creation script. Copy into deploy/scripts/create-triggers.sh,
# add one `gcloud builds triggers create github` block per deployable surface,
# and run once the Cloud Build GitHub App is installed on the repo (browser,
# one-time — see SKILL.md).
set -euo pipefail

: "${PROJECT_ID:?Set PROJECT_ID}"
: "${REPO_OWNER:?Set REPO_OWNER}"
: "${REPO_NAME:?Set REPO_NAME}"
: "${REGION:=us-central1}"
: "${BUILD_SA:=my-build@${PROJECT_ID}.iam.gserviceaccount.com}"

BRANCH_PATTERN="${BRANCH_PATTERN:-^main$}"
BUILD_SA_RESOURCE="projects/${PROJECT_ID}/serviceAccounts/${BUILD_SA}"

gcloud config set project "${PROJECT_ID}"

# One block per surface. --included-files scopes the trigger so a push that
# only touches an unrelated surface's tree does not rebuild this one.
gcloud builds triggers create github \
  --name="deploy-my-service" \
  --region="${REGION}" \
  --repo-owner="${REPO_OWNER}" \
  --repo-name="${REPO_NAME}" \
  --branch-pattern="${BRANCH_PATTERN}" \
  --build-config="deploy/cloudbuild.my-service.yaml" \
  --service-account="${BUILD_SA_RESOURCE}" \
  --included-files="apps/my-service/**,packages/shared_core/**,deploy/cloudbuild.my-service.yaml"

# gcloud builds triggers create github \
#   --name="deploy-my-job" \
#   --region="${REGION}" \
#   --repo-owner="${REPO_OWNER}" \
#   --repo-name="${REPO_NAME}" \
#   --branch-pattern="${BRANCH_PATTERN}" \
#   --build-config="deploy/cloudbuild.my-job.yaml" \
#   --service-account="${BUILD_SA_RESOURCE}" \
#   --included-files="apps/my-job/**,packages/shared_core/**,deploy/cloudbuild.my-job.yaml"
