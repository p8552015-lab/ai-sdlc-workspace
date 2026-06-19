#!/usr/bin/env bash
# Graduate a project off the AI SDLC scaffolding and produce a CLEAN, deliverable repo.
#
#   bash scripts/graduate_sdlc.sh           # --light
#   bash scripts/graduate_sdlc.sh --full
#
# Both modes ALWAYS run hygiene: drop placeholder .gitkeep / empty dirs, delete
# .DS_Store, and warn about delivery junk (.venv, caches).
#
# --light : remove tier-1 — optional/, INSTALL.md, governance CI workflows.
# --full  : also remove the governance layer, the SDLC GitHub templates, this
#           kit's scaffolding guide, and strip "Generated during /sdlc-*" process
#           headers from docs/ — i.e. a plain, vendor-deliverable product repo.
#
# ALWAYS kept: product code, docs/ (design docs), .ai/artifacts/ (decision record).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:---light}"

TIER1=( optional INSTALL.md .github/workflows/ai-policy-gate.yml .github/workflows/skill-audit.yml )
TIER2=(
  CLAUDE.md pipeline
  .ai/sdlc-governance.md .ai/risk-policy.md .ai/new-project-policy.md
  .claude/commands .cursor/rules/ai-sdlc.mdc
  scripts/audit_skills.py scripts/bootstrap_external_skills.sh
  scripts/check_environment.sh scripts/validate_pipeline.py
  skills
  .github/pull_request_template.md .github/ISSUE_TEMPLATE
  docs/SDLC-SCAFFOLDING.md
)

_rm() { local t="$ROOT/$1"; if [ -e "$t" ]; then rm -rf "$t"; echo "  removed  $1"; fi; }

echo "== Graduating AI SDLC scaffolding (mode: $MODE) =="

echo "Tier-1 (always removable):"
for p in "${TIER1[@]}"; do _rm "$p"; done

if [ "$MODE" = "--full" ]; then
  echo "Tier-2 (governance + SDLC templates):"
  for p in "${TIER2[@]}"; do _rm "$p"; done
  if [ -d "$ROOT/docs" ]; then
    find "$ROOT/docs" -name '*.md' -exec sed -i.bak '/^> Generated during/d' {} +
    find "$ROOT/docs" -name '*.md.bak' -delete
    echo "  stripped '> Generated during /sdlc-*' headers from docs/*.md"
  fi
fi

echo "Hygiene:"
if [ -d "$ROOT/.ai" ]; then
  find "$ROOT/.ai" -name .gitkeep -delete
  find "$ROOT/.ai" -type d -empty -delete
  echo "  cleaned placeholder .gitkeep and empty dirs under .ai/"
fi
n="$(find "$ROOT" -name .DS_Store -not -path '*/.git/*' | wc -l | tr -d ' ')"
if [ "$n" != "0" ]; then
  find "$ROOT" -name .DS_Store -not -path '*/.git/*' -delete
  echo "  deleted $n .DS_Store file(s)"
fi

echo "Delivery checks:"
if [ "$MODE" = "--full" ]; then
  hits="$(grep -rlE 'CLAUDE\.md|pipeline/|/sdlc-|validate_pipeline|skill-map' \
    "$ROOT/README.md" "$ROOT/docs" 2>/dev/null || true)"
  if [ -n "$hits" ]; then
    echo "  WARNING: these still mention removed scaffolding — edit by hand:"
    echo "$hits" | sed "s|$ROOT/|     |"
  else
    echo "  ok: no dangling references to removed scaffolding"
  fi
fi
for d in .venv .pytest_cache .ruff_cache .mypy_cache node_modules; do
  [ -e "$ROOT/$d" ] && echo "  WARNING: $d/ is on disk — exclude it from any zip handoff (it is gitignored)"
done

if [ "$MODE" = "--full" ]; then
  _rm "scripts/graduate_sdlc.sh"
  rmdir "$ROOT/scripts" 2>/dev/null || true
  echo "== Full graduation complete — plain, deliverable product repo. =="
else
  echo "== Light graduation complete. Re-run with --full for a vendor-deliverable repo. =="
fi
