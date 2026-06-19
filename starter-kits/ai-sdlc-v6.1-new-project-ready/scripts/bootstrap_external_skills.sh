#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXT="$ROOT/skills/external"
mkdir -p "$EXT"

# Clone or fast-forward a single external skill repo.
# Progress goes to stderr; only the resolved commit SHA is printed to stdout so
# the caller can aggregate clean lines into a single skills.lock.
clone_or_update() {
  local name="$1"
  local url="$2"
  local dir="$EXT/$name"
  if [ -d "$dir/.git" ]; then
    echo "Updating $name" >&2
    git -C "$dir" pull --ff-only >&2
  else
    if [ -d "$dir" ]; then
      non_placeholder_count="$(find "$dir" -mindepth 1 -maxdepth 1 ! -name .gitkeep | wc -l | tr -d ' ')"
      if [ "$non_placeholder_count" != "0" ]; then
        echo "ERROR: $dir exists and is not a git repo or placeholder-only directory" >&2
        exit 1
      fi
      rm -rf "$dir"
    fi
    echo "Cloning $name" >&2
    git clone "$url" "$dir" >&2
  fi
  git -C "$dir" rev-parse HEAD
}

# Repos vendored on demand: "<name> <url>".
repos=(
  "addyosmani-agent-skills https://github.com/addyosmani/agent-skills.git"
  "obra-superpowers https://github.com/obra/superpowers.git"
  "heilcheng-awesome-agent-skills https://github.com/heilcheng/awesome-agent-skills.git"
)

# A single lock file pins every repo to its resolved commit (matches the manuals).
lock="$EXT/skills.lock"
{
  echo "# AI SDLC external skills lock"
  echo "# format: <name> <url> <commit>"
} > "$lock"
for entry in "${repos[@]}"; do
  # shellcheck disable=SC2086
  set -- $entry
  sha="$(clone_or_update "$1" "$2")"
  echo "$1 $2 $sha" >> "$lock"
done

echo "External skills bootstrapped under $EXT (pinned in skills.lock)" >&2
