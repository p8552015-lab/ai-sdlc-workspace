#!/usr/bin/env bash
# Self-test for graduate_sdlc.sh: run --full on a throwaway copy of this kit and
# assert a clean, deliverable result — no scaffolding/junk left, product and the
# .ai/artifacts decision record kept. No network or python needed.
set -euo pipefail
KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT

cp -R "$KIT/." "$T/"
# Simulate a used, shippable project on top of the kit.
mkdir -p "$T/src"
printf 'x = 1\n' > "$T/src/app_stub.py"
printf '# Brief\n> Generated during `/sdlc-inception`\nbody\n' > "$T/docs/project-brief.md"
printf 'report body\n' > "$T/.ai/artifacts/inception/inception.md"
: > "$T/.DS_Store"
: > "$T/docs/.DS_Store"

bash "$T/scripts/graduate_sdlc.sh" --full >/dev/null 2>&1 || true

fail=0
ok() { echo "  ok   $1"; }
no() { echo "  FAIL $1"; fail=1; }
assert() { if eval "$1"; then ok "$2"; else no "$2"; fi; }

assert '[ ! -e "$T/docs/SDLC-SCAFFOLDING.md" ]'                              "scaffolding guide removed"
assert '[ ! -e "$T/.github/pull_request_template.md" ]'                     "PR template removed"
assert '[ ! -e "$T/.github/ISSUE_TEMPLATE" ]'                               "issue template removed"
assert '[ ! -e "$T/CLAUDE.md" ] && [ ! -e "$T/pipeline" ]'                  "governance removed"
assert '[ -z "$(find "$T/.ai" -name .gitkeep 2>/dev/null)" ]'              "no .gitkeep under .ai"
assert '[ -z "$(find "$T" -name .DS_Store 2>/dev/null)" ]'                 "no .DS_Store"
assert '[ -z "$(grep -rl "Generated during" "$T/docs" 2>/dev/null)" ]'      "no process headers in docs"
assert '[ -f "$T/src/app_stub.py" ] && [ -f "$T/.github/workflows/ci.yml" ]' "product kept"
assert '[ -f "$T/.ai/artifacts/inception/inception.md" ]'                   "decision record kept"

if [ "$fail" -eq 0 ]; then
  echo "graduate self-test: PASS"
else
  echo "graduate self-test: FAIL"
  exit 1
fi
