# Local secrets
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"

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
alias l='ls -la'
alias m='make'
alias t='trash'
alias vless='nvim -R'
alias kctx='kubectx'
alias vim='nvim'

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
fi

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
