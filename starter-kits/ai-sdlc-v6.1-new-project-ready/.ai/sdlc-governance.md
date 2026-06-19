# AI SDLC Governance

## Purpose
This document defines lifecycle gates for AI-assisted software delivery.

## Lifecycle Gates

| Stage | Required Artifact | Gate Question | Approval Required |
|---|---|---|---|
| Define | `.ai/artifacts/define/*.md` | Do we understand the problem? | R2+ |
| Plan | `.ai/artifacts/plan/*.md` | Is the plan safe, small, testable? | R2+ |
| Build | `.ai/artifacts/build/*.md` | Are changes incremental and scoped? | R3+ |
| Verify | `.ai/artifacts/verify/*.md` | Is there evidence it works? | All |
| Review | `.ai/artifacts/review/*.md` | Would a senior engineer approve? | All |
| Ship | `.ai/artifacts/ship/*.md` | Is release/rollback ready? | R2+ |
| Operate | `.ai/artifacts/operate/*.md` | Did production behavior match expectations? | R3+ |

## Non-negotiable Rules
- No code before spec/plan for R2+.
- No merge without CI evidence.
- No production deploy without explicit human approval.
- No security-sensitive change without `security-and-hardening`.
- No browser UI change without accessibility and runtime verification.
- No migration without rollback plan.
