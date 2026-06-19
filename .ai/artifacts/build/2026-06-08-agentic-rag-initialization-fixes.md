# Agentic RAG Initialization Fixes

## SDLC Metadata

- Phase: Build
- Date: 2026-06-08
- Branch: `chore/reorganize-project-structure`
- Task: Fix init starter kit based on `agentic_RAG` initialization test
- Risk class: R1
- Selected skills:
  - `debugging-and-error-recovery`
  - `incremental-implementation`
- Author: Codex
- Status: Completed

## Context

Testing the organized starter kit against `/Users/tunghsing/Desktop/agentic_RAG` exposed two starter kit issues:

1. `scripts/bootstrap_external_skills.sh` failed when external skill placeholder directories already existed with only `.gitkeep`.
2. `scripts/audit_skills.py` read the old `stages` shape and did not audit the current `pipeline/skill-map.yml` `phases` shape.

## Changes Made

- Updated `starter-kits/ai-sdlc-v6.1-new-project-ready/scripts/bootstrap_external_skills.sh`.
  - Placeholder-only external skill directories are now removed before `git clone`.
  - Non-placeholder existing directories still fail loudly to avoid accidental deletion.
- Updated `starter-kits/ai-sdlc-v6.1-new-project-ready/scripts/audit_skills.py`.
  - Reads `phases` from `pipeline/skill-map.yml`.
  - Audits mapped `SKILL.md` paths.
  - Applies strict section checks to company-owned skills.
  - Checks external skills for existence and YAML frontmatter.
- Added `starter-kits/ai-sdlc-v6.1-new-project-ready/.gitignore`.
  - Ignores `.DS_Store`, local Claude settings, and external cloned git repos.
- Removed local `.DS_Store` from the starter kit source.

## Verification

Verified through the `agentic_RAG` initialization test:

```bash
bash scripts/bootstrap_external_skills.sh
python3 scripts/validate_pipeline.py
python3 scripts/audit_skills.py
```

All commands passed in `/Users/tunghsing/Desktop/agentic_RAG`.
