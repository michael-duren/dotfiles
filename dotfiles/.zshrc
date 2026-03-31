# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [ -z "$TMUX" ]; then
#   exec tmux
# fi
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# source local api keys to not store in git
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    dotnet
    extract
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    z
    kubectl
    zsh-vi-mode
  )

# macOS specific plugins
if [[ "$OSTYPE" == "darwin"* ]]; then
    plugins+=(brew macos)
fi

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"


# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

export LESS="-R"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias D="docker"
alias gacm="git add -A && git commit -m"
alias nr="npm run dev"
alias vim="nvim"
alias gs="git status"
alias l="ls -la"
alias m="make"
alias t="trash"

source ~/powerlevel10k/powerlevel10k.zsh-theme

# go path
export GOPATH=$HOME/go
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# add python3 scripts to path
export PATH="$HOME/.local/scripts:$PATH"

# macOS specific configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
    # bun completions
    [ -s "/Users/michaelduren/.bun/_bun" ] && source "/Users/michaelduren/.bun/_bun"

    # bun
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"

    # android studio
    export ANDROID_HOME=$HOME/Library/Android/sdk
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/platform-tools
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home

    # java
    export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
    export JAVA_HOME="/opt/homebrew/opt/openjdk@21"

    # ruby
    eval "$(rbenv init - zsh)"

    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"

    # omnisharp
    export PATH="/opt/homebrew/Cellar/omnisharp/1.35.3/bin:$PATH"

    # pico SDK
    export PICO_SDK_PATH=~/pico/pico-sdk/

    # dotnet debugger
    export PATH="/Users/michaelduren/.local/bin/netcoredbg:$PATH"

    alias mnv="XDG_DATA_HOME=$HOME/.config/modern-neovim/share XDG_CACHE_HOME=$HOME/.config/modern-neovim XDG_CONFIG_HOME=$HOME/.config/modern-neovim nvim"

    alias vimlog="cd /Users/michaelduren/.cache/nvim && vim ."
    export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

    # Mac setup for pomo
    alias work="timer 60m && terminal-notifier -message 'Pomodoro'\
            -title 'Work Timer is up! Take a Break 😊'\
            -appIcon '~/Pictures/pumpkin.jpg'\
            -sound Crystal"

    alias rest="timer 10m && terminal-notifier -message 'Pomodoro'\
            -title 'Break is over! Get back to work 😬'\
            -appIcon '~/Pictures/pumpkin.jpg'\
            -sound Crystal"

    w() {
        timer "${1}m" && terminal-notifier -message 'Pomodoro'\
            -title 'Work Timer is up! Take a Break 😊'\
            -appIcon '~/Pictures/pumpkin.jpg'\
            -sound Crystal
    }

    r() {
        timer "${1}m" && terminal-notifier -message 'Pomodoro'\
            -title 'Break is over! Get back to work 😬'\
            -appIcon '~/Pictures/pumpkin.jpg'\
            -sound Crystal
    }

    # Added by Antigravity
    export PATH="/Users/michaelduren/.antigravity/antigravity/bin:$PATH"
fi

# ── Git Worktree Functions ──────────────────────────────────────────────

# gclone: Clone a repo as a bare repository with worktrees
# Usage: gclone git@github.com:you/my-app.git
#        gclone https://github.com/you/my-app.git
gclone() {
    local repo_url="$1"

    if [[ -z "$repo_url" ]]; then
        echo "Usage: gclone <repo-url>"
        echo "Example: gclone git@github.com:you/my-app.git"
        return 1
    fi

    # Extract repo name from URL
    local repo_name
    repo_name=$(basename "$repo_url" .git)
    repo_name=$(basename "$repo_name") # handle trailing slashes

    if [[ -z "$repo_name" ]]; then
        echo "Error: Could not extract repo name from URL"
        return 1
    fi

    local project_dir="$(pwd)/$repo_name"

    if [[ -d "$project_dir" ]]; then
        echo "Error: Directory '$project_dir' already exists"
        return 1
    fi

    echo "Setting up worktree project: $project_dir"
    mkdir -p "$project_dir"

    # Clone as bare repo
    echo "Cloning bare repo..."
    git clone --bare "$repo_url" "$project_dir/bare"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to clone repository"
        rm -rf "$project_dir"
        return 1
    fi

    # Configure bare repo to fetch all remote branches
    git -C "$project_dir/bare" config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git -C "$project_dir/bare" fetch origin

    # Detect default branch (main or master)
    local default_branch
    default_branch=$(git -C "$project_dir/bare" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if [[ -z "$default_branch" ]]; then
        # Fallback: check if main or master exists
        if git -C "$project_dir/bare" show-ref --verify --quiet refs/remotes/origin/main 2>/dev/null; then
            default_branch="main"
        elif git -C "$project_dir/bare" show-ref --verify --quiet refs/remotes/origin/master 2>/dev/null; then
            default_branch="master"
        else
            echo "Error: Could not detect default branch"
            rm -rf "$project_dir"
            return 1
        fi
    fi

    # Create main worktree
    echo "Creating worktree for '$default_branch'..."
    git -C "$project_dir/bare" worktree add "$project_dir/$default_branch" "$default_branch"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to create worktree for '$default_branch'"
        rm -rf "$project_dir"
        return 1
    fi

    echo ""
    echo "Project ready:"
    echo "  $project_dir/bare/           (bare repo)"
    echo "  $project_dir/$default_branch/  (default branch worktree)"

    # Ask about feature branch
    echo ""
    read -q "create_feature?Create a feature branch? [y/N] "
    echo ""

    if [[ "$create_feature" == "y" ]]; then
        read -r "feature_name?Branch name: "
        if [[ -n "$feature_name" ]]; then
            git -C "$project_dir/bare" worktree add -b "$feature_name" "$project_dir/$feature_name" "$default_branch"
            if [[ $? -eq 0 ]]; then
                echo "  $project_dir/$feature_name/  (feature branch worktree)"
            else
                echo "Warning: Failed to create feature branch worktree"
            fi
        fi
    fi

    echo ""
    echo "Done! cd into a worktree to start working:"
    echo "  cd $project_dir/$default_branch"
}

# gwt: Manage git worktrees for a bare repo project
# Usage: gwt add <branch>        - Add worktree for existing remote branch
#        gwt new <branch> [base] - Create new branch worktree (default base: default branch)
#        gwt rm <branch>         - Remove worktree
#        gwt list                - List all worktrees
# Override oh-my-zsh git plugin aliases (gwt, gwta, gwtls, gwtrm, gwtmv)
unalias gwt gwta gwtls gwtrm gwtmv 2>/dev/null
gwt() {
    local subcmd="$1"
    shift 2>/dev/null

    # Find the bare repo directory
    local bare_dir
    bare_dir=$(_gwt_find_bare)
    if [[ -z "$bare_dir" ]]; then
        echo "Error: Not inside a git worktree project (no bare repo found)"
        echo "Hint: Run 'gclone <url>' first to set up a project"
        return 1
    fi

    local project_dir
    project_dir=$(dirname "$bare_dir")

    case "$subcmd" in
        add)
            local branch="$1"
            if [[ -z "$branch" ]]; then
                echo "Usage: gwt add <branch>"
                return 1
            fi
            echo "Fetching latest from remote..."
            git -C "$bare_dir" fetch origin
            git -C "$bare_dir" worktree add "$project_dir/$branch" "$branch"
            ;;
        new)
            local branch="$1"
            local base="${2:-}"
            if [[ -z "$branch" ]]; then
                echo "Usage: gwt new <branch> [base-branch]"
                return 1
            fi
            # Auto-detect default branch if base not specified
            if [[ -z "$base" ]]; then
                base=$(_gwt_default_branch "$bare_dir")
                if [[ -z "$base" ]]; then
                    echo "Error: Could not detect default branch. Specify base explicitly."
                    return 1
                fi
            fi
            git -C "$bare_dir" worktree add -b "$branch" "$project_dir/$branch" "$base"
            ;;
        rm|remove)
            local branch="$1"
            if [[ -z "$branch" ]]; then
                echo "Usage: gwt rm <branch>"
                return 1
            fi
            local wt_path="$project_dir/$branch"
            if [[ ! -d "$wt_path" ]]; then
                echo "Error: Worktree directory '$wt_path' does not exist"
                return 1
            fi
            # Warn if currently inside the worktree being removed
            if [[ "$(pwd)" == "$wt_path"* ]]; then
                echo "Warning: You are inside this worktree. Changing to project root."
                cd "$project_dir"
            fi
            git -C "$bare_dir" worktree remove "$wt_path"
            ;;
        list|ls)
            git -C "$bare_dir" worktree list
            ;;
        ""|help|-h|--help)
            echo "gwt - Git Worktree Manager"
            echo ""
            echo "Usage: gwt <command> [args]"
            echo ""
            echo "Commands:"
            echo "  add <branch>          Add worktree for existing remote branch"
            echo "  new <branch> [base]   Create new branch worktree (default base: main)"
            echo "  rm <branch>           Remove worktree"
            echo "  list                  List all worktrees"
            echo ""
            echo "Run from anywhere inside a worktree project."
            ;;
        *)
            echo "Unknown command: $subcmd"
            echo "Run 'gwt help' for usage"
            return 1
            ;;
    esac
}

# Helper: Find bare repo directory by walking up from cwd
_gwt_find_bare() {
    local dir="$(pwd)"

    # Check if we're directly in a bare repo
    if [[ -f "$dir/HEAD" && -d "$dir/objects" ]]; then
        echo "$dir"
        return
    fi

    # Check if current dir has a bare/ subdirectory
    if [[ -f "$dir/bare/HEAD" && -d "$dir/bare/objects" ]]; then
        echo "$dir/bare"
        return
    fi

    # Use git to find the common dir (works inside any worktree)
    local git_common
    git_common=$(git rev-parse --git-common-dir 2>/dev/null)
    if [[ -n "$git_common" && -d "$git_common" ]]; then
        # Resolve to absolute path
        git_common=$(cd "$git_common" && pwd)
        echo "$git_common"
        return
    fi

    # Walk up directory tree looking for bare/
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/bare/HEAD" && -d "$dir/bare/objects" ]]; then
            echo "$dir/bare"
            return
        fi
        dir=$(dirname "$dir")
    done
}

# Helper: Detect default branch for a bare repo
_gwt_default_branch() {
    local bare_dir="$1"
    local default_branch
    default_branch=$(git -C "$bare_dir" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if [[ -z "$default_branch" ]]; then
        if git -C "$bare_dir" show-ref --verify --quiet refs/remotes/origin/main 2>/dev/null; then
            default_branch="main"
        elif git -C "$bare_dir" show-ref --verify --quiet refs/remotes/origin/master 2>/dev/null; then
            default_branch="master"
        fi
    fi
    echo "$default_branch"
}

# ── End Git Worktree Functions ──────────────────────────────────────────

alias hv='tmux new-session -As hive hive'

# mise activation (works on both macOS and Linux)
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi
