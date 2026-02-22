#!/usr/bin/env bash

set -e

echo "🚀 Installing Zsh dependencies..."
echo

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    echo "📱 Detected: macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    echo "🐧 Detected: Linux"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

echo

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh installed"
else
    echo "✅ Oh My Zsh already installed"
fi

echo

# Install Powerlevel10k if not present
if [ ! -d "$HOME/powerlevel10k" ]; then
    echo "📦 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo "✅ Powerlevel10k installed"
else
    echo "✅ Powerlevel10k already installed"
fi

echo

# Install Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "📦 Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions
    echo "✅ zsh-autosuggestions installed"
else
    echo "✅ zsh-autosuggestions already installed"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "📦 Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting
    echo "✅ zsh-syntax-highlighting installed"
else
    echo "✅ zsh-syntax-highlighting already installed"
fi

# zsh-vi-mode
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]; then
    echo "📦 Installing zsh-vi-mode..."
    git clone https://github.com/jeffreytse/zsh-vi-mode "${ZSH_CUSTOM}"/plugins/zsh-vi-mode
    echo "✅ zsh-vi-mode installed"
else
    echo "✅ zsh-vi-mode already installed"
fi

echo

# macOS specific dependencies
if [ "$OS" = "macos" ]; then
    echo "📦 Checking macOS-specific dependencies..."

    # Check if Homebrew is installed
    if ! command -v brew &>/dev/null; then
        echo "⚠️  Homebrew not found. Install from: https://brew.sh"
    else
        echo "✅ Homebrew installed"

        # Optional: Check for common tools
        TOOLS=("rbenv" "terminal-notifier")
        for tool in "${TOOLS[@]}"; do
            if command -v "$tool" &>/dev/null; then
                echo "✅ $tool installed"
            else
                echo "⚠️  $tool not found (optional, install with: brew install $tool)"
            fi
        done
    fi
fi

echo

# Check for mise (universal version manager)
if ! command -v mise &>/dev/null; then
    echo "⚠️  mise not found. Install from: https://mise.jdx.dev"
    echo "   Quick install: curl https://mise.run | sh"
else
    echo "✅ mise installed"
fi

echo
echo "🎉 Zsh dependency installation complete!"
echo
echo "Next steps:"
echo "1. Stow the zsh config: cd ~/dotfiles && stow zsh"
echo "2. Restart your terminal or run: source ~/.zshrc"
echo "3. Configure Powerlevel10k: p10k configure (if first time)"
echo
echo "Optional: Create ~/.zshrc.local for machine-specific configs (API keys, etc.)"
