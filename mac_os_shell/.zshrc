# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
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
    brew
    macos
    extract
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-vi-mode
    z
  )

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"


# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

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
alias gacm="git add -A && git commit -m"
alias nr="npm run dev"
alias vim="nvim"
source ~/powerlevel10k/powerlevel10k.zsh-theme


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

# dotnet debugger
export PATH="/Users/michaelduren/.local/bin/netcoredbg:$PATH"

alias mnv="XDG_DATA_HOME=$HOME/.config/modern-neovim/share XDG_CACHE_HOME=$HOME/.config/modern-neovim XDG_CONFIG_HOME=$HOME/.config/modern-neovim nvim"

alias vimlog="cd /Users/michaelduren/.cache/nvim && vim ."
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# go path
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

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

# add python3 scripts to path
export PATH="$HOME/.local/scripts:$PATH"

alias gs="git status"

# Added by Antigravity
export PATH="/Users/michaelduren/.antigravity/antigravity/bin:$PATH"
