# Local secrets
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"

# before zsh-vi-mode is loaded
export ZVM_INIT_MODE=sourcing

plugins=(
  git
  extract
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  kubectl
  zsh-vi-mode
)

[[ "$OSTYPE" == darwin* ]] && plugins+=(brew macos)

source "$ZSH/oh-my-zsh.sh"

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
alias l='ls -la'
alias m='make'
alias t='trash'
alias vless='nvim -R'
alias kctx='kubectx'
alias vim='nvim'

ts() {
    if [[ $# != 2 ]]; then
        echo "Usage: ts <name> <path>"
    fi
    tmux new-session -d -s "$1" -n "cli" -c "$1"
}

# ollama
#  Local LLMs (ramalama, Vulkan on Radeon 890M)
alias qcode='ollama run qwen3-coder:30b'         # default coding — Qwen3-Coder 30B-A3B (MoE)
alias qcoder='ollama run qwen2.5-coder:32b'      # heavy / C / asm — Qwen2.5-Coder 32B (dense)
alias qask='ollama run qwen3.5:27b'              # general / Linux / Hyprland — Qwen3.5 27B
alias qserve='ollama serve qwen3-coder:30b'      # OpenAI-compatible API on :8080

# macOS-only
if [[ "$OSTYPE" == darwin* ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"

  export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
  export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

  export PICO_SDK_PATH="$HOME/pico/pico-sdk"
  alias vimlog="cd ~/.cache/nvim && vim ."

  # work work work
  alias ghec-login="ghec-migrate auth login"
  alias ghec-add="ghec-migrate tap roles add"
  alias ghec-rm="ghec-migrate tap roles remove"
  alias ghec-howto="ghec-migrate tap roles remove|add <ZID> <team-name>"
fi

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

source <(fzf --zsh)

# nnn
# -H: show hidden/dot files at startup (needed to see .config, .zshrc, etc. in dotfiles)
# -e: open text files in $VISUAL/$EDITOR (nvim)
# -d: start in detail view (long listing)
export NNN_OPTS="Hed"
export NNN_PLUG='f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:imgview'

# Trash instead of permanent delete (uses trash-cli if installed)
export NNN_TRASH=1
# Use fzf/$EDITOR for the in-app open prompts
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'

# nnn cd-on-quit: launch with `f`, quit with `q`, and your shell follows nnn
# into the last dir you were browsing. Must be a function, not an alias —
# an alias can't run the post-exit `cd`.
f() {
    # Don't nest nnn inside an nnn-spawned shell
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    nnn "$@"
    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE"
    }
}
