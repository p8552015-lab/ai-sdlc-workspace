# New Project Policy

This policy applies when a repository has no existing application structure or when the user asks to start a new product/project.

## Mandatory sequence

1. Inception
2. Define
3. Architecture
4. Bootstrap
5. Plan
6. Build
7. Verify
8. Review
9. Ship
10. Operate

## Hard rules

- Do not create feature code before Inception and Define artifacts exist.
- Do not scaffold production architecture before Architecture is approved.
- Do not start business feature implementation before Bootstrap passes CI-equivalent checks.
- Do not introduce production secrets.
- Do not deploy to production from the initial Bootstrap stage.

## Required artifacts

- `docs/project-brief.md`
- `docs/product-requirements.md`
- `docs/mvp-scope.md`
- `docs/architecture.md`
- `docs/adrs/0001-tech-stack.md`
- `docs/roadmap.md`
- `.ai/artifacts/*/*.md`
