#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXT="$ROOT/skills/external"
mkdir -p "$EXT"

clone_or_update() {
  local name="$1"
  local url="$2"
  local dir="$EXT/$name"
  if [ -d "$dir/.git" ]; then
    echo "Updating $name"
    git -C "$dir" pull --ff-only
  else
    if [ -d "$dir" ]; then
      non_placeholder_count="$(find "$dir" -mindepth 1 -maxdepth 1 ! -name .gitkeep | wc -l | tr -d ' ')"
      if [ "$non_placeholder_count" != "0" ]; then
        echo "ERROR: $dir exists and is not a git repo or placeholder-only directory" >&2
        exit 1
      fi
      rm -rf "$dir"
    fi
    echo "Cloning $name"
    git clone "$url" "$dir"
  fi
  git -C "$dir" rev-parse HEAD
}

clone_or_update "addyosmani-agent-skills" "https://github.com/addyosmani/agent-skills.git" > "$EXT/addyosmani-agent-skills.lock"
clone_or_update "obra-superpowers" "https://github.com/obra/superpowers.git" > "$EXT/obra-superpowers.lock"
clone_or_update "heilcheng-awesome-agent-skills" "https://github.com/heilcheng/awesome-agent-skills.git" > "$EXT/heilcheng-awesome-agent-skills.lock"

echo "External skills bootstrapped under $EXT"
