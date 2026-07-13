#!/usr/bin/env bash
# delete-branches — delete all local git branches except main.
#
# Skips the currently checked-out branch (git refuses to delete it anyway)
# and main/master. Uses -D (force delete) since the point is a clean slate;
# pass --dry-run first if unsure what will be removed.
#
# Usage: delete-branches [--dry-run]
set -euo pipefail

DRY_RUN=0
[[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]] && DRY_RUN=1

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "error: not inside a git repository" >&2
  exit 1
fi

current_branch="$(git branch --show-current)"

while IFS= read -r branch; do
  if [[ "$branch" == "main" || "$branch" == "master" || "$branch" == "$current_branch" ]]; then
    continue
  fi

  if (( DRY_RUN )); then
    echo "[dry-run] would delete branch $branch"
    continue
  fi

  echo "==> deleting branch $branch"
  git branch -D "$branch"
done < <(git branch --format='%(refname:short)')
