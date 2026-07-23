# Changelog

## 2026-07-08 15:01:29 - COMPLETED
- Plan: none
- Files modified: .gitignore, .DS_Store
- Summary: Added a repository ignore rule for macOS .DS_Store files and removed the existing .DS_Store from Git tracking while preserving it locally.
- Verification: git check-ignore -v .DS_Store; git ls-files -- .DS_Store; git status --short
- Additional verification: git check-ignore -v skills/harness-protocol/.DS_Store; git check-ignore -v skills/gcp-project-scaffold/reference/.DS_Store; git ls-files -- '*.DS_Store'

## 2026-07-08 15:03:26 - COMPLETED_WITH_WARNINGS
- Plan: none
- Files modified: README.md, skills/harness-protocol/SKILL.md, skills/harness-protocol/README.md, skills/gcp-project-scaffold/README.md
- Summary: Removed per-skill README files, moved human-facing package context into the root README, and preserved the harness source note in the skill file.
- Verification: find skills -name README.md; rg stale README references; git diff --check; quick_validate.py attempted but blocked by missing yaml module; Ruby YAML frontmatter checks passed for both SKILL.md files.

## 2026-07-08 15:03:39 - COMPLETED
- Plan: none
- Files modified: .gitignore
- Summary: Made the .DS_Store ignore rule explicit for all directory depths.
- Verification: git check-ignore -v .DS_Store; git check-ignore -v skills/harness-protocol/.DS_Store; git check-ignore -v skills/gcp-project-scaffold/reference/.DS_Store; git ls-files -- '*.DS_Store'; rg -n '!.*DS_Store|DS_Store' -uu -g '.gitignore' -g 'exclude' . .git/info

## 2026-07-08 15:12:20 - COMPLETED_WITH_WARNINGS
- Plan: none
- Files modified: skills/gcp-project-scaffold/SKILL.md, skills/gcp-project-scaffold/reference/cloudbuild-service.yaml, skills/gcp-project-scaffold/reference/cloudbuild-job.yaml, skills/gcp-project-scaffold/reference/create-triggers.sh
- Summary: Added first-deploy Cloud Run lessons from the retrospective to the GCP project scaffold and aligned Cloud Build templates with v2 GitHub connections, pinned build identities, staged-context checks, rerun guidance, auth assertions, and secret handling.
- Verification: bash -n skills/gcp-project-scaffold/reference/create-triggers.sh; Ruby YAML parse for Cloud Build templates; Ruby frontmatter validation for SKILL.md; git diff --check; gcloud help checked Cloud Build v2 trigger/repository/connection flags.
- Warning: skill-creator quick_validate.py was attempted but could not run because the active Python environment is missing the yaml module.

## 2026-07-08 16:23:51 - COMPLETED
- Plan: none
- Files modified: README.md, skills/change-vscode-color/SKILL.md
- Summary: Added the change-vscode-color skill to the repository README and updated its default inactive chrome colors so inactive backgrounds and borders match active colors while inactive text remains darker.
- Verification: python3 JSON parse of the SKILL.md default key set; rg reference check for change-vscode-color and inactive color keys.

## 2026-07-08 16:29:11 - COMPLETED
- Plan: none
- Files modified: .vscode/settings.json
- Summary: Added workspace-local VS Code royal blue window chrome colors scoped to title bar, status bar, and window border keys, with inactive backgrounds and borders matching active colors.
- Verification: python3 -m json.tool .vscode/settings.json; rg final key list confirmed no Activity Bar, Side Bar, panel, editor, or Peacock keys.

## 2026-07-22 23:43:48 - COMPLETED
- Plan: none
- Files modified: skills/harness-protocol/SKILL.md
- Summary: Added a bounded, macro-level technical-debt protocol to the repository skill and restored the installed harness-protocol skill to its prior repository-HEAD content.
- Verification: Ruby YAML frontmatter parse; required-section assertions; installed-skill comparison against repository HEAD; git diff --check.

## 2026-07-22 23:49:39 - COMPLETED
- Plan: none
- Files modified: skills/harness-protocol/SKILL.md
- Summary: Condensed the technical-debt protocol while preserving its audit cadence, macro review criteria, tracker requirements, and remediation thresholds.
- Verification: Ruby YAML frontmatter parse; required-content assertions; installed-skill comparison against repository HEAD; git diff --check.

## 2026-07-22 23:58:08 - COMPLETED
- Plan: none
- Files modified: skills/harness-protocol/SKILL.md
- Summary: Consolidated the debt audit categories and made the tracker an active-only register whose resolved entries are removed after verified remediation.
- Verification: Ruby YAML frontmatter parse; active-only tracker assertions; installed-skill comparison against repository HEAD; git diff --check.
