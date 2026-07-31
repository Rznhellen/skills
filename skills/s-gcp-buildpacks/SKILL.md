---
name: s-gcp-buildpacks
description: >-
  Use when setting up a deployable surface, writing Procfiles, configuring
  Buildpacks, or deciding between Buildpacks and Dockerfiles.
---

# GCP Buildpacks — No-Dockerfile Technique

## The pattern

Every deployable ships exactly two build-relevant files and no Dockerfile:

1. **Procfile** — declares the start command (e.g. `web: python3 main.py`)
2. **Dependency manifest** — `requirements.txt` for Python, `package.json` for Node, etc.

Buildpacks detects the language from the manifest and builds the image automatically.

## Decision: Buildpacks vs. Dockerfile

| Situation | Use |
|---|---|
| Standard runtime (Python, Node, Go, Java) with pip/npm deps | Buildpacks |
| Stdlib-only Python service | Buildpacks (empty requirements.txt with comment) |
| Non-Buildpacks-supported runtime | Dockerfile (fallback) |
| Native deps Buildpacks cannot compile | Dockerfile (fallback) |
| Frontend SPA served by thin backend | Frontend sub-technique (below) |

## Deploy paths by resource type

### Services (most surfaces)

```bash
gcloud run deploy <name> \
  --source=<context-dir> \
  --build-service-account=<build-sa>
```

The `--source` flag runs Buildpacks through a Cloud Run-managed inner Cloud Build. No explicit image build step needed.

### Jobs (cannot source-deploy with custom build SA)

Run Buildpacks explicitly, then deploy the image:

```bash
# In Cloud Build YAML:
pack build <image-url> --builder=gcr.io/buildpacks/builder --publish
gcloud run jobs deploy <name> --image=<image-url>
```

See `reference/Procfile` for an example.

## Frontend sub-technique

A browser SPA served by a thin backend breaks naive Buildpacks (mixed-language context). Split it:

1. **Build JS in a Cloud Build step** — `node:20` image running `npm ci && npm run build`
2. **Copy compiled output** (`dist/`) into the runtime service's `static/` directory
3. **Deploy only the runtime directory** — a minimal server (Python stdlib `wsgiref`, thin framework) that serves `static/` and proxies `/api/*` to the backend with an OIDC ID token
4. **Cache strategy** — `max-age=31536000, immutable` for hashed assets; `no-store` for HTML shell

Buildpacks only ever sees the trivial static-file server, not the frontend toolchain.

## Staged context rules

Minimal Buildpacks contexts change runtime layout: the service runs from a shallow `/workspace` app, not the source monorepo.

### Do not

- Hard-code paths like `Path(__file__).resolve().parents[2]`
- Assume monorepo directory structure at runtime

### Do

Use parent discovery for shared packages:

```python
from pathlib import Path

def _add_local_common_package_path() -> None:
    for parent in Path(__file__).resolve().parents:
        package_path = parent / "packages" / "python"
        if package_path.exists():
            sys.path.insert(0, str(package_path))
            return
```

### Staged-layout import check (run before first live build)

```bash
tmp="$(mktemp -d)"
mkdir -p "$tmp/<surface>/packages"
cp -R apps/<surface>/. "$tmp/<surface>/"
cp -R packages/python/<shared_pkg> "$tmp/<surface>/packages/"
cd "$tmp/<surface>"
PYTHONPATH="$tmp/<surface>/packages:$tmp/<surface>" python3 -c 'import main'
```

## Python version pinning

If the regional Buildpacks builder has dropped your target Python version, pin it explicitly in the staged build context:

```bash
echo "3.13" > "$CONTEXT_DIR/.python-version"
```

Don't commit `.python-version` to source if local dev floats across versions — write it at build time.

## Stdlib-only services

For Python services with no third-party dependencies, the `requirements.txt` still exists (so Buildpacks detects Python) but contains only a comment. See `reference/requirements-stdlib-only.txt`.
