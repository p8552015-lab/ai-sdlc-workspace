#!/usr/bin/env bash
set -euo pipefail
for cmd in git gh node npm python3; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "OK: $cmd -> $(command -v $cmd)"
  else
    echo "MISSING: $cmd"
  fi
done
if command -v claude >/dev/null 2>&1; then
  echo "OK: claude -> $(command -v claude)"
else
  echo "WARN: Claude Code CLI not found. Install/configure Claude Code before using .claude/commands."
fi
