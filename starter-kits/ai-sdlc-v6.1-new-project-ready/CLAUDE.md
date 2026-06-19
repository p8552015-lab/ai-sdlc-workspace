# CLAUDE.md - Skill-Driven AI SDLC Operating Contract

This repository uses a skill-driven SDLC pipeline for Claude Code. Claude Code must act as a lifecycle agent, not a one-shot coding assistant. It must select skills, produce lifecycle artifacts, respect approval gates, verify evidence, and keep changes small.

---

## 1. Instruction Priority

When instructions conflict, use this order:

1. Safety, security, and explicit human instructions.
2. This `CLAUDE.md` file.
3. `.ai/sdlc-governance.md` and `.ai/risk-policy.md`.
4. `pipeline/lifecycle.yml`.
5. `pipeline/skill-map.yml`.
6. `pipeline/artifact-schema.yml`.
7. `pipeline/approval-matrix.yml`.
8. Selected `SKILL.md` files.
9. Existing repository conventions.
10. General model knowledge.

Do not skip lifecycle gates because a task looks simple. Small changes may use the lightweight path, but must still record selected skills, risk level, verification, and diff summary.

---

## 2. New Project Rule

If this repository has no existing application structure, or the user asks to start a new product/project, do not begin by coding features.

Use the New Project Pipeline first:

1. `inception` - clarify product purpose, users, MVP, non-goals, risks.
2. `define` - turn ideas into verifiable specifications.
3. `architecture` - decide the technical foundation and document ADRs.
4. `bootstrap` - create only the working project skeleton, CI, tests, README, and environment template.
5. `plan` - break MVP into small deliverable issues.
6. `build` - implement approved slices.
7. `verify` - prove the result with tests/evidence.
8. `review` - review quality, security, simplicity, and maintainability.
9. `ship` - prepare PR/release/rollback.
10. `operate` - monitor, learn, and feed back follow-up tasks.

Before `bootstrap`, application feature code is forbidden unless the user explicitly approves a disposable prototype.

Before `build`, both MVP scope and architecture must be approved.

---

## 3. Required Repository Data Structure

Claude Code must expect and maintain this structure:

```text
repo/
├── CLAUDE.md
├── .ai/
│   ├── sdlc-governance.md
│   ├── risk-policy.md
│   ├── new-project-policy.md
│   ├── artifacts/
│   │   ├── inception/
│   │   ├── define/
│   │   ├── architecture/
│   │   ├── bootstrap/
│   │   ├── plan/
│   │   ├── build/
│   │   ├── verify/
│   │   ├── review/
│   │   ├── ship/
│   │   └── operate/
│   └── decisions/
├── docs/
│   ├── project-brief.md
│   ├── product-requirements.md
│   ├── mvp-scope.md
│   ├── architecture.md
│   ├── roadmap.md
│   └── adrs/
├── pipeline/
│   ├── lifecycle.yml
│   ├── skill-map.yml
│   ├── artifact-schema.yml
│   └── approval-matrix.yml
├── skills/
│   ├── external/
│   │   ├── addyosmani-agent-skills/
│   │   ├── obra-superpowers/
│   │   └── heilcheng-awesome-agent-skills/
│   └── company/
│       └── ai-sdlc-orchestrator/SKILL.md
├── .claude/commands/
│   ├── sdlc-inception.md
│   ├── sdlc-define.md
│   ├── sdlc-architecture.md
│   ├── sdlc-bootstrap.md
│   ├── sdlc-plan.md
│   ├── sdlc-build.md
│   ├── sdlc-verify.md
│   ├── sdlc-review.md
│   └── sdlc-ship.md
├── .cursor/rules/ai-sdlc.mdc
├── .github/
│   ├── ISSUE_TEMPLATE/feature.yml
│   ├── pull_request_template.md
│   └── workflows/
│       ├── ci.yml
│       ├── ai-policy-gate.yml
│       └── skill-audit.yml
├── scripts/
│   ├── bootstrap_external_skills.sh
│   ├── audit_skills.py
│   ├── validate_pipeline.py
│   ├── check_environment.sh
│   └── graduate_sdlc.sh
└── optional/                 # opt-in only (LangGraph/CrewAI); safe to delete
    ├── langgraph/sdlc_graph.py
    └── crewai/{agents,tasks}.yaml
```

---

## 4. Canonical Skill Anatomy

Every runtime skill should follow this structure:

```text
SKILL.md
├── Frontmatter
│   ├── name: lowercase-hyphen-name
│   └── description: Guides agents through [task]. Use when...
├── Overview
├── When to Use
├── Process
├── Rationalizations
├── Red Flags
└── Verification
```

Prefer actual `SKILL.md` files from:

- `skills/external/addyosmani-agent-skills/skills/`
- `skills/external/obra-superpowers/`
- `skills/company/`

Do not invent a workflow when a mapped skill exists.

---

## 5. External Skill Sources

### 5.1 addyosmani/agent-skills

Primary engineering lifecycle skill pack. Use its skills for concrete lifecycle execution:

- Define: `interview-me`, `idea-refine`, `spec-driven-development`
- Plan: `planning-and-task-breakdown`
- Build: `incremental-implementation`, `context-engineering`, `source-driven-development`, `doubt-driven-development`, `frontend-ui-engineering`, `test-driven-development`, `api-and-interface-design`
- Verify: `browser-testing-with-devtools`, `debugging-and-error-recovery`
- Review: `code-review-and-quality`, `code-simplification`, `security-and-hardening`, `performance-optimization`
- Ship: `git-workflow-and-versioning`, `ci-cd-and-automation`, `deprecation-and-migration`, `documentation-and-adrs`, `shipping-and-launch`
- Meta: `using-agent-skills`

### 5.2 obra/superpowers

Use as the methodology layer for disciplined agentic development:

- discovery before implementation
- design and plan approval
- test-first behavior
- worktree-based isolation
- review before merge
- disciplined subagent use

### 5.3 heilcheng/awesome-agent-skills

Use as a discovery index. Do not treat it as a runtime skill unless a linked project contains a usable `SKILL.md`, command, agent, checklist, or workflow document.

---

## 6. Lifecycle State Machine

Classify each task into exactly one current phase, with allowed transitions defined in `pipeline/lifecycle.yml`.

```text
New project path:
inception → define → architecture → bootstrap → plan → build → verify → review → ship → operate

Existing project path:
define → plan → build → verify → review → ship → operate
```

At each phase:

1. Read `pipeline/lifecycle.yml` for gates and required outputs.
2. Read `pipeline/skill-map.yml` to select skills.
3. Read selected `SKILL.md` files.
4. Produce artifacts listed in `pipeline/artifact-schema.yml`.
5. Apply `pipeline/approval-matrix.yml` before high-risk actions.
6. Stop if required evidence or approval is missing.

---

## 7. Risk Classes

Use these risk classes on every task:

- `R0`: docs, comments, formatting, no behavior change.
- `R1`: tests, type fixes, small local bug fixes.
- `R2`: feature work, public behavior changes, API changes.
- `R3`: auth, payment, security-sensitive code, database migration, infrastructure, data model changes.
- `R4`: production deployment, irreversible migration, data deletion, secret/policy changes, permission boundary changes.

Rules:

- `R0-R1`: Claude Code may implement after lightweight plan.
- `R2`: Claude Code may implement after plan; PR review required before merge.
- `R3`: Claude Code must request approval before implementation.
- `R4`: Claude Code must not execute; only produce plan and risk analysis unless explicitly authorized by a human owner.

---

## 8. Required Phase Output Format

At the end of each phase, output this block:

```markdown
## SDLC Phase Result

- Phase:
- Selected skills:
- Risk class:
- Artifacts produced:
- Commands run:
- Evidence:
- Open questions:
- Approval needed:
- Next recommended phase:
```

If any required artifact is missing, do not claim the phase is complete.

---

## 9. Implementation Discipline

During `build`:

- Work in small slices.
- Prefer one concern per commit.
- Do not modify unrelated files.
- Do not introduce new dependencies without plan and justification.
- Add or update tests with behavior changes.
- Check `git diff` before summarizing.
- Run the smallest meaningful verification command first, then broader CI-equivalent checks.

During `verify`:

- Provide exact commands and results.
- Include failures honestly.
- Do not say tests passed unless they were run.

During `ship`:

- Prepare PR title/body.
- Include risk class.
- Include verification evidence.
- Include rollback plan.
- Mention unresolved risks.

---

## 10. New Project Bootstrap Boundaries

The `bootstrap` phase may create:

- framework scaffold
- package manager setup
- lint/format/test/build configuration
- CI workflow
- README
- `.env.example`
- health check endpoint or equivalent smoke test
- basic folder/module structure
- starter test

The `bootstrap` phase must not create:

- full product workflows
- real production credentials
- broad business features
- irreversible database migrations
- deployment to production

---

## 11. Human Approval Gates

Always stop and request approval before:

- selecting or changing the primary tech stack
- changing architecture after approval
- adding paid or vendor-locking services
- touching auth/payment/security-sensitive code
- changing database schema or migrations
- deploying to production
- deleting data
- changing CI/CD secrets or permissions

---

## 12. First Command for New Projects

When the user describes a new product idea, start with:

```text
/sdlc-inception
```

Do not use `/sdlc-build` until inception, define, architecture, and bootstrap gates have passed.
