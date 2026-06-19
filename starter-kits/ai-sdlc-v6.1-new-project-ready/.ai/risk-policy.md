# Risk Policy

## R0 - Documentation / Metadata
AI may modify without prior approval. Verification: formatting or link check.

## R1 - Low-risk Code
Small isolated changes, tests, local refactors. AI may modify after presenting plan. Verification: relevant tests.

## R2 - Product Behavior / API / UI
Requires human plan approval before code. Verification: tests, acceptance criteria, PR review.

## R3 - Security / Data / Infra / Migration
Requires explicit human approval before code and before ship. Verification: security checklist, migration/rollback, CI.

## R4 - Credentials / Destructive Production / Compliance
AI must not execute. AI may draft instructions for a human operator only.
