# Scaffolding vs Product, and Graduation

This kit is copied wholesale into a repo, so it intentionally ships development
scaffolding alongside (eventually) your product. To stop that scaffolding from
becoming permanent dead weight, every file falls into one of three buckets, and
there is a script to strip the scaffolding when you ship.

## Buckets

**Product (always keep)** — what actually runs / ships: your application code,
`docs/` (design docs / ADRs), `.github/workflows/ci.yml`, packaging / config.

**Decision record (keep)** — `.ai/artifacts/` — the per-phase trail of what was
decided and why. Keep it like you keep ADRs.

**SDLC scaffolding (remove when no longer needed)** — two tiers:

| Tier | Paths | Remove when |
|---|---|---|
| 1 — always removable | `optional/`, `INSTALL.md`, `.github/workflows/{ai-policy-gate,skill-audit}.yml` | you have real product code (optional / unused / adoption-only, plus dev-governance CI that should not run on product PRs) |
| 2 — governance | `CLAUDE.md`, `pipeline/`, `.ai/{sdlc-governance,risk-policy,new-project-policy}.md`, `.claude/commands/`, `.cursor/rules/`, `scripts/` (validators / bootstrap), `skills/` | you stop developing this repo with the kit |

## Graduation

```bash
bash scripts/graduate_sdlc.sh          # remove tier-1 (safe for any shipped project)
bash scripts/graduate_sdlc.sh --full   # also remove tier-2 (no longer kit-developed)
```

Product code, `docs/`, and `.ai/artifacts/` are kept in both modes.

`--full` additionally removes the SDLC GitHub templates (`pull_request_template.md`,
`ISSUE_TEMPLATE/`) and this scaffolding guide, and strips `> Generated during
/sdlc-*` headers from `docs/*.md`. **Both** modes also run delivery hygiene: drop
placeholder `.gitkeep` / empty dirs, delete `.DS_Store`, warn about dangling
references to removed files, and warn about `.venv`/cache dirs that must not be
shipped.

`scripts/test_graduate.sh` is a self-test: it runs `--full` on a throwaway copy
and asserts the result is clean (no scaffolding/junk; product + `.ai/artifacts`
kept). Run it after changing the graduation logic.

## Why this exists

Without graduation, a copied kit leaves the majority of the repo as non-product
files forever, mixes SDLC-governance CI into the product's CI (e.g. `skill-audit`
cloning skill repos on every push — now also limited with `paths:` filters so it
only runs when SDLC files change), and keeps a stale `INSTALL.md`. Graduation
makes the scaffolding explicitly temporary instead of permanent.
