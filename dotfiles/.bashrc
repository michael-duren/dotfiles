export PATH="$HOME/.local/bin:$PATH"

pcall() {
    if (($# < 1)); then
        echo "pcall error: need at least one arg"
        echo "usage: cmd args..."
        return 1
    fi

    local cmd=$1

    if ! command -v $cmd &>/dev/null; then
        echo "command: $cmd not installed"
        return 1
    fi

    "$@"
}

export EDITOR="${SSH_CONNECTION:+vim}"
export EDITOR="${EDITOR:-nvim}"
export LESS="-R"
export MANPAGER='nvim +Man!'

alias D='docker'
alias gacm='git add -A && git commit -m'
alias gs='git status'
alias gwt='git worktree'
alias gwa='git worktree add'
alias gwl='git worktree list'
alias gwr='git worktree remove'
alias gwrf='git worktree remove --force'
alias gwp='git worktree prune'
unalias gd
alias gd="git diff | pcall diffnav"
alias l='ls -la'
alias m='make'
alias t='trash'
alias vless='nvim -R'
alias kctx='kubectx'
alias vim='nvim'
