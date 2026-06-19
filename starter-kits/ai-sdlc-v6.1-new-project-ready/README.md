# AI SDLC Starter Kit v6.1 - New Project Ready

This starter kit turns Claude Code into a skill-driven SDLC agent for both existing repositories and brand-new projects.

## Core design

- `CLAUDE.md` is the operating contract for Claude Code.
- `pipeline/lifecycle.yml` defines the lifecycle state machine.
- `pipeline/skill-map.yml` maps phases to external skills.
- `pipeline/artifact-schema.yml` defines required evidence per phase.
- `pipeline/approval-matrix.yml` defines R0-R4 risk gates.
- `skills/company/ai-sdlc-orchestrator/SKILL.md` coordinates the whole process.

## New project path

```text
inception → define → architecture → bootstrap → plan → build → verify → review → ship → operate
```

## Existing project path

```text
define → plan → build → verify → review → ship → operate
```

## First setup

```bash
bash scripts/bootstrap_external_skills.sh
python scripts/validate_pipeline.py
python scripts/audit_skills.py
```

## First command for a new project

```text
/sdlc-inception
```

Do not start with `/sdlc-build` for a new project.

## Scaffolding vs product (graduation)

This kit ships SDLC scaffolding alongside your product. Optional scaffolds live in `optional/` (delete if unused). When you ship, strip the dev-only scaffolding:

```bash
bash scripts/graduate_sdlc.sh          # tier-1 (any shipped project)
bash scripts/graduate_sdlc.sh --full   # also governance (no longer kit-developed)
```

Product code, `docs/`, and `.ai/artifacts/` are always kept. See `docs/SDLC-SCAFFOLDING.md`.
