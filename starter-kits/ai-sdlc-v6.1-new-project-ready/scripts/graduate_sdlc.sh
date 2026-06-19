#!/usr/bin/env bash
# Graduate a project off the AI SDLC scaffolding once it has real product code.
#
#   bash scripts/graduate_sdlc.sh           # --light (default)
#   bash scripts/graduate_sdlc.sh --full
#
# --light : remove tier-1 dead weight that no shipped project needs — the opt-in
#           scaffolds (optional/), the kit adoption guide (INSTALL.md), and the
#           SDLC-governance CI workflows that would otherwise run on every PR.
# --full  : ALSO remove the SDLC governance layer (CLAUDE.md, pipeline/, skills/,
#           commands, .ai governance, validators). Use only when you stop
#           developing this repo with the kit.
#
# ALWAYS kept: your product code, docs/, and .ai/artifacts/ (the decision record).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:---light}"

TIER1=(
  optional
  INSTALL.md
  .github/workflows/ai-policy-gate.yml
  .github/workflows/skill-audit.yml
)
TIER2=(
  CLAUDE.md
  pipeline
  .ai/sdlc-governance.md
  .ai/risk-policy.md
  .ai/new-project-policy.md
  .claude/commands
  .cursor/rules/ai-sdlc.mdc
  scripts/audit_skills.py
  scripts/bootstrap_external_skills.sh
  scripts/check_environment.sh
  scripts/validate_pipeline.py
  skills
)

_remove() {
  local target="$ROOT/$1"
  if [ -e "$target" ]; then
    rm -rf "$target"
    echo "  removed  $1"
  fi
}

echo "Graduating AI SDLC scaffolding (mode: $MODE)."
echo "Kept: product code, docs/, .ai/artifacts/ (decision record)."
echo "Tier-1 (always removable):"
for p in "${TIER1[@]}"; do _remove "$p"; done

if [ "$MODE" = "--full" ]; then
  echo "Tier-2 (SDLC governance):"
  for p in "${TIER2[@]}"; do _remove "$p"; done
  rm -f "$ROOT/scripts/graduate_sdlc.sh" && echo "  removed  scripts/graduate_sdlc.sh"
  rmdir "$ROOT/scripts" 2>/dev/null || true
  echo "Full graduation complete — this is now a plain product repo."
else
  echo "Light graduation complete. Re-run with --full when you stop developing with the kit."
fi
