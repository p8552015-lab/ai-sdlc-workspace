# Source of Truth

This repository is a **curation + maintenance workspace** for an AI-assisted SDLC
methodology. It is not a runnable product. To avoid the "which copy do I edit?"
problem, every kind of content has exactly one authoritative home.

## Model: thin curator (not a vendored fork)

External skill packs (addyosmani/agent-skills, obra/superpowers,
heilcheng/awesome-agent-skills) are **not** authored or vendored here. They are
pulled on demand by the starter kit's bootstrap script and pinned by commit SHA.

| Content | Source of truth | Editable here? |
|---|---|---|
| Starter kit | `starter-kits/ai-sdlc-v6.1-new-project-ready/` | yes — this is what we maintain |
| Manuals | `docs/manuals/*.docx` | yes |
| Workspace docs | `README.md`, this file | yes |
| External skill packs | upstream GitHub repos, pinned in `skills/external/skills.lock` after bootstrap | no — never hand-edit; re-bootstrap to update |
| ZIP snapshots | `archives/source-zips/*.zip` | no — immutable cold storage (see below) |

## Why there is no `skill-packs/` directory

A root-level `skill-packs/` previously held editable copies of two upstream packs.
That was a redundant third copy (alongside the bootstrap target and the zip
snapshots) with no single owner, so it was removed. To read a pack locally:

- run `starter-kits/ai-sdlc-v6.1-new-project-ready/scripts/bootstrap_external_skills.sh`
  (clones upstream into `skills/external/`), or
- unzip the matching snapshot under `archives/source-zips/`.

## Role of `archives/source-zips/`

Immutable **disaster-recovery snapshots** of the upstream packs and the kit
release. They exist for the one case a commit SHA cannot cover: upstream
disappearing. They are never the working source and are never edited.

## Local tree is intentionally incomplete

A fresh checkout does **not** contain the external skills — `skills/external/*`
are placeholders until bootstrap runs. This is by design (thin curator). CI
bootstraps automatically before auditing skills; locally, run bootstrap first.
Do not claim "locally complete & runnable" without it.

## Invariants (enforced by `scripts/check_consistency.sh`)

1. No root `skill-packs/` directory (single source of truth for external skills).
2. `SOURCE-OF-TRUTH.md` exists.
3. The bootstrap script emits a single `skills.lock` (not per-repo `*.lock`),
   matching the manuals.
4. The kit's `validate_pipeline.py` passes.
