#  Startup 
# Commands to execute on startup (before the prompt is shown)
# Check if the interactive shell option is set
if [[ $- == *i* ]]; then
    # This is a good place to load graphic/ascii art, display system information, etc.
    if command -v pokego >/dev/null; then
        pokego --no-title -r 1,3,6
    elif command -v pokemon-colorscripts >/dev/null; then
        pokemon-colorscripts --no-title -r 1,3,6
    elif command -v fastfetch >/dev/null; then
        if do_render "image"; then
            fastfetch --logo-type kitty
        fi
    fi
fi

#   Overrides 
# HYDE_ZSH_NO_PLUGINS=1 # Set to 1 to disable loading of oh-my-zsh plugins, useful if you want to use your zsh plugins system
# unset HYDE_ZSH_PROMPT # Uncomment to unset/disable loading of prompts from HyDE and let you load your own prompts
# HYDE_ZSH_COMPINIT_CHECK=1 # Set 24 (hours) per compinit security check // lessens startup time
# HYDE_ZSH_OMZ_DEFER=1 # Set to 1 to defer loading of oh-my-zsh plugins ONLY if prompt is already loaded

if [[ ${HYDE_ZSH_NO_PLUGINS} != "1" ]]; then
    #  OMZ Plugins 
    # manually add your oh-my-zsh plugins here
    plugins=(
        "sudo"
        "z"
        "kubectl"
        "zsh-vi-mode"
    )
fi

#  Local LLMs (ramalama, Vulkan on Radeon 890M)
alias qcode='ramalama run qwen3-coder:30b'    # default coding — Qwen3-Coder 30B-A3B (MoE)
alias qcoder='ramalama run qwen2.5-coder:32b' # heavy / C / asm — Qwen2.5-Coder 32B (dense)
alias qask='ramalama run qwen3.5:27b'         # general / Linux / Hyprland — Qwen3.5 27B
alias qserve='ramalama serve qwen3-coder:30b' # OpenAI-compatible API on :8080
alias qls='ramalama list'                     # list cached models
alias gacm='git add -A && git commit -m'      # list cached models
alias help='run-help'

# mise — version manager for go/node/etc.
# Use shims (not `mise activate`) so PATH is set unconditionally at shell start;
# activate's precmd hook gets clobbered by HyDE's plugin loading order.
export PATH="$HOME/.local/share/mise/shims:$PATH"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="/home/mduren/.lmstudio/bin:$PATH"

# Read-only nvim as a pager — supports stdin: `cmd | vless`
alias vless="nvim -R"
# Use Neovim as the man pager (built-in :Man plugin)
export MANPAGER='nvim +Man!'
alias gs="git status"
alias awake="systemd-inhibit sleep infinity"
alias k="kubectl"
alias kctx="kubectx"

export EDITOR=nvim
export VISUAL=nvim

if [[ -e "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# nnn cd-on-quit: launch with `f`, quit with `q`, and your shell follows nnn
# into the last dir you were browsing. Must be a function, not an alias —
# an alias can't run the post-exit `cd`.
f() {
    # Don't nest nnn inside an nnn-spawned shell
    [ "${NNNLVL:-0}" -eq 0 ] || { echo "nnn is already running"; return; }

    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    nnn "$@"
    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE"
    }
}

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
