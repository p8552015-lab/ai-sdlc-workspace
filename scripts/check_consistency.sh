#!/usr/bin/env bash
# Workspace consistency guard. Fails if any single-source-of-truth invariant from
# SOURCE-OF-TRUTH.md is violated. Safe to run locally or in CI.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KIT="$ROOT/starter-kits/ai-sdlc-v6.1-new-project-ready"
BOOT="$KIT/scripts/bootstrap_external_skills.sh"
fail=0
note() { echo "FAIL: $*" >&2; fail=1; }

# 1. Source-of-truth doc must exist.
[ -f "$ROOT/SOURCE-OF-TRUTH.md" ] || note "SOURCE-OF-TRUTH.md is missing at the workspace root."

# 2. No redundant editable copy of external skills (thin-curator model).
[ -d "$ROOT/skill-packs" ] && note "skill-packs/ reappeared. External skills must come from bootstrap, not a vendored copy (see SOURCE-OF-TRUTH.md)."

# 3. Bootstrap must emit a single skills.lock, and no per-repo *.lock files.
if [ -f "$BOOT" ]; then
  grep -q 'skills\.lock' "$BOOT" || note "bootstrap_external_skills.sh no longer emits skills.lock."
  for bad in addyosmani-agent-skills.lock obra-superpowers.lock heilcheng-awesome-agent-skills.lock; do
    grep -q "$bad" "$BOOT" && note "bootstrap_external_skills.sh emits per-repo lock '$bad'; use a single skills.lock instead."
  done
else
  note "bootstrap script not found at $BOOT"
fi

# 4. The kit's own pipeline structure must validate.
if [ -f "$KIT/scripts/validate_pipeline.py" ]; then
  python3 "$KIT/scripts/validate_pipeline.py" >/dev/null 2>&1 || note "validate_pipeline.py failed (kit pipeline structure is incomplete)."
fi

if [ "$fail" -eq 0 ]; then
  echo "workspace consistency OK"
fi
exit "$fail"
