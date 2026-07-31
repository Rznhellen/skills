# Feedback Entry Format

## Entry Structure

Each feedback entry is a markdown file or section in `docs/harness-feedback/`. One entry per friction point.

```markdown
## YYYY-MM-DD | [skill-or-area]

**Friction:** One-sentence description of what went wrong or was missing.

**Context:** What you were trying to accomplish when you hit this.

**Impact:** blocker | slowdown | paper-cut

**Suggested fix:** Your idea for what would have prevented this.
```

## Placement

- Directory: `docs/harness-feedback/`
- File naming: `YYYY-MM-DD-brief-slug.md` for individual entries, or append to a rolling `YYYY-MM.md` monthly file
- Either approach works — pick one per repo and stay consistent

## Examples

### Good friction report

```markdown
## 2026-07-15 | s-gcp-deploy

**Friction:** Skill says to use `gcloud run deploy --source .` but project uses Buildpacks via Cloud Build. Followed the wrong path for 10 minutes before discovering the actual deploy trigger.

**Context:** Deploying a hotfix to the staging Cloud Run service.

**Impact:** slowdown

**Suggested fix:** Add a decision branch in s-gcp-deploy SKILL.md: "If project has cloudbuild.yaml, deploy via trigger, not gcloud run deploy --source."
```

### Good friction report (missing context)

```markdown
## 2026-07-20 | s-codebase-setup

**Friction:** No mention of which Node version is required. Used 20, but lockfile was generated with 18 and install failed with peer dep conflicts.

**Context:** Setting up the project for the first time to fix a bug.

**Impact:** blocker

**Suggested fix:** Add .node-version or engines field to package.json, and mention in CLAUDE.md prerequisites.
```

### Noise (don't log these)

- "The API was slow today" — not a harness issue
- "I wasn't sure how to write a regex" — agent knowledge gap, not missing harness
- "The test took 30 seconds to run" — infrastructure issue, not guidance issue
- "I had to read 3 files to understand the data model" — normal complexity

## Processing

Entries in `docs/harness-feedback/` are consumed by the harness-evolution consolidation process. After fixes are applied, entries are moved to `docs/harness-feedback/archived/` with a note referencing the fix commit or PR.
