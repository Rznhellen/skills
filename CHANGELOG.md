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
