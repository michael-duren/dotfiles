#!/usr/bin/env bash

if ! command -v tmux >/dev/null 2>&1; then
    echo "first install tmux"
    exit 1
fi

if [[ "$WORK" == "true" ]]; then
    sessions=(scratch pc dotfiles notes)

    for session in "${sessions[@]}"; do
        case "$session" in
        scratch) path="$HOME/Code" ;;
        pc) path="$HOME/Code/cia/digital-web-platform-commander" ;;
        dotfiles) path="$HOME/Code/dotfiles/dotfiles" ;;
        notes) path="$HOME/Code/learning" ;;
        esac

        if tmux has-session -t "$session" 2>/dev/null; then
            continue
        fi

        tmux new-session -d -s "$session" -n "cli" -c "$path"
        tmux new-window -t "$session" -n "nvim" -c "$path" nvim
        tmux select-window -t "$session:1"
    done

    exec tmux attach -t scratch
else
    sessions=(career dotfiles boxes lc duck)

    for session in "${sessions[@]}"; do
        case "$session" in
        career) path="$HOME/Code/career-strategy" ;;
        dotfiles) path="$HOME/Code/dotfiles" ;;
        boxes) path="$HOME/Code/boxes" ;;
        lc) path="$HOME/Code/leet-code-practice/c" ;;
        duck) path"$HOME/Code/rd-wt/main" ;;
        esac

        if tmux has-session -t "$session" 2>/dev/null; then
            continue
        fi

        tmux new-session -d -s "$session" -n "cli" -c "$path"
        tmux new-window -t "$session" -n "nvim" -c "$path" nvim
        tmux select-window -t "$session:1"
    done

    exec tmux attach -t career
fi
