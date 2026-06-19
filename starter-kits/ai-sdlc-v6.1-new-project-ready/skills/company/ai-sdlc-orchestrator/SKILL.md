---
name: ai-sdlc-orchestrator
description: Guides Claude Code through the repository's skill-driven SDLC pipeline. Use when starting any task, especially new projects, feature work, architectural changes, verification, review, or shipping.
---

# AI SDLC Orchestrator

## Overview

This skill coordinates the repository lifecycle. It does not replace external skills. It selects the correct lifecycle phase, chooses mapped skills, enforces required artifacts, applies risk gates, and prevents Claude Code from jumping directly to implementation.

## When to Use

Use this skill for every non-trivial repository task, including:

- starting a new project
- defining requirements
- choosing architecture
- bootstrapping a repository
- implementing a feature
- fixing a bug
- writing tests
- reviewing a diff
- preparing a PR or release
- operating or migrating a system

## Process

1. Classify the project context:
   - New project: no application structure or user asks to create a new product.
   - Existing project: codebase already exists and task modifies it.
2. Select lifecycle path from `pipeline/lifecycle.yml`:
   - New project: `inception → define → architecture → bootstrap → plan → build → verify → review → ship → operate`.
   - Existing project: `define → plan → build → verify → review → ship → operate`.
3. Identify the current phase and allowed next phase.
4. Read mapped skills from `pipeline/skill-map.yml`.
5. Load and follow each applicable `SKILL.md`.
6. Produce required artifact fields from `pipeline/artifact-schema.yml`.
7. Assign risk class from `pipeline/approval-matrix.yml`.
8. Stop before any action that requires human approval.
9. Complete the phase only when exit criteria and evidence requirements are satisfied.
10. End with the SDLC Phase Result block.

## Rationalizations

| Excuse | Rebuttal |
|---|---|
| "This is a new project, so I can scaffold immediately." | No. New projects must pass Inception, Define, and Architecture before Bootstrap. |
| "The task is simple, so no artifact is needed." | Use the lightweight path, but still record phase, skills, risk, and evidence. |
| "I know the best stack." | Architecture choices require tradeoff analysis and approval. |
| "Tests are not needed yet." | Bootstrap requires at least a smoke test or explicit justification. Feature work requires tests or documented reason. |
| "I can fix CI later." | CI is a lifecycle gate, not a cleanup task. |
| "I can touch auth/payment/db because the change is small." | R3/R4 gates apply regardless of size. |

## Red Flags

- Code is written before inception/define artifacts for a new project.
- Architecture is chosen without options and tradeoffs.
- Bootstrap includes broad business features.
- `git diff` includes unrelated files.
- No risk class is stated.
- No selected skills are listed.
- Tests are claimed but commands are missing.
- PR text lacks rollback plan.
- R3/R4 work proceeds without explicit approval.

## Verification

Before completing the phase, verify:

- Current phase is present in `pipeline/lifecycle.yml`.
- Selected skills are mapped in `pipeline/skill-map.yml`.
- Required artifact fields are present in `pipeline/artifact-schema.yml`.
- Risk class and approval status match `pipeline/approval-matrix.yml`.
- Commands and evidence are reported honestly.
- Next phase is allowed by the lifecycle path.
