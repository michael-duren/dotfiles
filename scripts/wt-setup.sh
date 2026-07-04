#!/usr/bin/env bash

set -eou pipefail

usage() {
    cat <<EOF
Usage:  wt-setup [remote-url] 

An easy way to quickly setup worktrees with a bare clone

Example:
  wt-setup git@github.com:michael-duren/rubber-duck.git         Creates a '.bare' directory and 'main' worktree directory
EOF
}

check_for_git() {
    if [[ -e .git ]] || [[ -e .bare ]]; then
        echo "warning: this folder already has git information"
        echo "cleanup the directory and run again"
        exit 1
    fi

    if [[ $# == 1 ]]; then
        if [[ -e $1 ]]; then
            echo "warning: this folder already has git information"
            echo "cleanup the directory and run again"
            exit 1
        fi
    fi
}

if [[ $# -ne 1 ]]; then
    usage
    exit 1
fi

check_for_git

repo_url=$1

read -rp "create new directory (Y/n)? " new_dir
if [[ "$new_dir" =~ ^[Yy]?$ ]]; then
    read -rp "directory name, leave blank for repo name " dir_name
    if [[ -z "$dir_name" ]]; then
        dir_name=$(basename -s .git "$repo_url")
    fi
    check_for_git "$dir_name"
    mkdir -p "$dir_name" && cd "$dir_name"
fi

git clone --bare "$repo_url" .bare
echo "gitdir: ./.bare" >.git
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch origin

read -rp "if your default branch is NOT main enter it here: " branch

if [[ -z "$branch" ]]; then
    branch="main"
fi

git worktree add "$branch" "$branch"
