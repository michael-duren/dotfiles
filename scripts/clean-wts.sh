#!/usr/bin/env bash
# clean-wts — remove worktrees whose branch has been merged (or deleted) on GitHub.
#
# For each worktree registered in the .bare repo:
#   - asks gh whether the branch has a merged PR, or no longer exists on origin
#   - skips the worktree if it has uncommitted local changes
#   - otherwise removes the worktree directory and deletes the local branch
#
# Usage: clean-wts [--dry-run]
set -euo pipefail

DRY_RUN=0
[[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]] && DRY_RUN=1

# The script lives in the worktree container dir, next to .bare
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ ! -d "$ROOT/.bare" ]]; then
  echo "error: no .bare repository found in $ROOT" >&2
  exit 1
fi

g() { git -C "$ROOT" "$@"; }
# gh has no -C flag; run it from ROOT so it resolves owner/repo from origin
ghr() { (cd "$ROOT" && gh "$@"); }

DEFAULT_BRANCH="$(g symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"

echo "==> fetching origin (with prune) and pruning stale worktree entries"
g fetch --prune --quiet origin
g worktree prune

# Collect path/branch pairs from the porcelain listing; bare and detached
# entries never emit a "branch" line, so they are skipped automatically.
paths=() branches=()
current_path=""
while IFS= read -r line; do
  case "$line" in
    "worktree "*) current_path="${line#worktree }" ;;
    "branch refs/heads/"*)
      paths+=("$current_path")
      branches+=("${line#branch refs/heads/}")
      ;;
  esac
done < <(g worktree list --porcelain)

for i in "${!paths[@]}"; do
  wt="${paths[$i]}"
  branch="${branches[$i]}"

  if [[ "$branch" == "$DEFAULT_BRANCH" ]]; then
    continue
  fi

  # Determine remote state: merged PR, or branch deleted on origin
  merged_prs="$(ghr pr list --state merged --head "$branch" --json number --jq 'length')"
  if ghr api "repos/{owner}/{repo}/branches/$branch" --silent >/dev/null 2>&1; then
    remote_exists=1
  else
    remote_exists=0
  fi

  if (( merged_prs > 0 )); then
    reason="PR merged"
  elif (( ! remote_exists )); then
    # Deleted on origin with no merged PR — make sure we aren't about to
    # throw away commits that never landed anywhere
    if g merge-base --is-ancestor "$branch" "origin/$DEFAULT_BRANCH" 2>/dev/null; then
      reason="branch deleted on origin"
    else
      echo "$branch deleted on origin but has commits not on $DEFAULT_BRANCH, skipping deletion"
      continue
    fi
  else
    echo "$branch still open on origin, keeping"
    continue
  fi

  if [[ -n "$(git -C "$wt" status --porcelain)" ]]; then
    echo "$branch has local changes skipping deletion"
    continue
  fi

  if (( DRY_RUN )); then
    echo "[dry-run] would remove worktree $wt and branch $branch ($reason)"
    continue
  fi

  echo "==> removing $wt and branch $branch ($reason)"
  g worktree remove "$wt"
  g branch -D "$branch"
done
