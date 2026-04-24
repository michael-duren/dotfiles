#!/usr/bin/env bash

set -e

# ─────────────────────────────────────────────────────────────
# Global Variables
# ─────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"

# ─────────────────────────────────────────────────────────────
# Detect OS
# ─────────────────────────────────────────────────────────────
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unsupported"
        echo "exiting setup script"
        exit 1
    fi
}

# ─────────────────────────────────────────────────────────────
# Package Manager Functions
# ─────────────────────────────────────────────────────────────
install_package() {
    local pkg_manager=$1
    local package=$2
    local display_name=${3:-$package}

    if command -v "$package" &>/dev/null; then
        echo "✅ $display_name already installed"
        return 0
    fi

    echo "📦 Installing $display_name..."
    case $pkg_manager in
    brew)
        brew install "$package"
        ;;
    apt)
        sudo apt-get install -y "$package"
        ;;
    dnf)
        sudo dnf install -y "$package"
        ;;
    pacman)
        sudo pacman -S --noconfirm "$package"
        ;;
    *)
        echo "❌ Unsupported package manager: $pkg_manager"
        return 1
        ;;
    esac
    echo "✅ $display_name installed"
}

install_aur_package() {
    local package=$1
    local display_name=${2:-$package}

    if command -v "$package" &>/dev/null; then
        echo "✅ $display_name already installed"
        return 0
    fi

    if ! command -v yay &>/dev/null; then
        echo "📦 Installing yay (AUR helper)..."
        sudo pacman -S --needed --noconfirm base-devel git debugedit fakeroot
        local tmpdir
        tmpdir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
        (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
        rm -rf "$tmpdir"
        echo "✅ yay installed"
    fi

    echo "📦 Installing $display_name from AUR..."
    yay -S --noconfirm "$package"
    echo "✅ $display_name installed"
}

install_packages() {
    local pkg_manager=$1
    shift
    local packages=("$@")

    for package in "${packages[@]}"; do
        install_package "$pkg_manager" "$package"
    done
}

# ─────────────────────────────────────────────────────────────
# Package Manager Setup
# ─────────────────────────────────────────────────────────────
setup_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        echo "✅ Homebrew already installed"
    fi
}

setup_linux_package_manager() {
    if command -v pacman &>/dev/null; then
        sudo pacman -Sy
        echo "pacman"
    elif command -v apt-get &>/dev/null; then
        echo "📦 Updating apt package list..."
        sudo apt-get update
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    else
        echo "❌ No supported package manager found"
        exit 1
    fi
}

# ─────────────────────────────────────────────────────────────
# Core Development Tools
# ─────────────────────────────────────────────────────────────
install_stow() {
    local pkg_manager=$1

    if command -v stow &>/dev/null; then
        echo "✅ GNU Stow already installed"
        return 0
    fi

    echo "📦 Installing GNU Stow..."
    install_package "$pkg_manager" "stow" "GNU Stow"
}

install_git() {
    local pkg_manager=$1

    if command -v git &>/dev/null; then
        echo "✅ Git already installed"
        return 0
    fi

    echo "📦 Installing Git..."
    install_package "$pkg_manager" "git" "Git"
}

install_neovim() {
    local pkg_manager=$1

    if command -v nvim &>/dev/null; then
        echo "✅ Neovim already installed"
        return 0
    fi

    echo "📦 Installing Neovim..."
    case $pkg_manager in
    brew)
        brew install neovim
        ;;
    apt)
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt-get update
        sudo apt-get install -y neovim
        ;;
    dnf)
        sudo dnf install -y neovim
        ;;
    pacman)
        sudo pacman -S --noconfirm neovim
        ;;
    esac
    echo "✅ Neovim installed"
}

install_tmux() {
    local pkg_manager=$1

    if command -v tmux &>/dev/null; then
        echo "✅ Tmux already installed"
        return 0
    fi

    echo "📦 Installing Tmux..."
    install_package "$pkg_manager" "tmux" "Tmux"
}

install_fzf() {
    local pkg_manager=$1

    if command -v fzf &>/dev/null; then
        echo "✅ fzf already installed"
        return 0
    fi

    echo "📦 Installing fzf..."
    install_package "$pkg_manager" "fzf" "fzf"
}

install_ripgrep() {
    local pkg_manager=$1

    if command -v rg &>/dev/null; then
        echo "✅ ripgrep already installed"
        return 0
    fi

    echo "📦 Installing ripgrep..."
    install_package "$pkg_manager" "ripgrep" "ripgrep"
}

install_lazygit() {
    local pkg_manager=$1

    if command -v lazygit &>/dev/null; then
        echo "✅ lazygit already installed"
        return 0
    fi

    echo "📦 Installing lazygit..."
    case $pkg_manager in
    brew)
        brew install lazygit
        ;;
    apt)
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
        ;;
    pacman)
        install_aur_package "lazygit" "lazygit"
        ;;
    *)
        install_package "$pkg_manager" "lazygit" "lazygit"
        ;;
    esac
    echo "✅ lazygit installed"
}

install_fd() {
    local pkg_manager=$1

    if command -v fd &>/dev/null; then
        echo "✅ fd already installed"
        return 0
    fi

    echo "📦 Installing fd..."
    case $pkg_manager in
    apt)
        install_package "$pkg_manager" "fd-find" "fd"
        ;;
    *)
        install_package "$pkg_manager" "fd" "fd"
        ;;
    esac
}

install_bat() {
    local pkg_manager=$1

    if command -v bat &>/dev/null || command -v batcat &>/dev/null; then
        echo "✅ bat already installed"
        return 0
    fi

    echo "📦 Installing bat..."
    install_package "$pkg_manager" "bat" "bat"
}

install_mise() {
    if command -v mise &>/dev/null; then
        echo "✅ mise already installed"
        return 0
    fi

    echo "📦 Installing mise..."
    curl https://mise.run | sh
    echo "✅ mise installed"
}

# ─────────────────────────────────────────────────────────────
# Zsh Setup
# ─────────────────────────────────────────────────────────────
install_zsh() {
    local pkg_manager=$1

    if command -v zsh &>/dev/null; then
        echo "✅ Zsh already installed"
        return 0
    fi

    echo "📦 Installing Zsh..."
    install_package "$pkg_manager" "zsh" "Zsh"
}

install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "✅ Oh My Zsh already installed"
        return 0
    fi

    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh installed"
}

install_powerlevel10k() {
    if [ -d "$HOME/powerlevel10k" ]; then
        echo "✅ Powerlevel10k already installed"
        return 0
    fi

    echo "📦 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo "✅ Powerlevel10k installed"
}

install_zsh_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        echo "📦 Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        echo "✅ zsh-autosuggestions installed"
    else
        echo "✅ zsh-autosuggestions already installed"
    fi

    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        echo "📦 Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        echo "✅ zsh-syntax-highlighting installed"
    else
        echo "✅ zsh-syntax-highlighting already installed"
    fi

    # zsh-vi-mode
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]; then
        echo "📦 Installing zsh-vi-mode..."
        git clone https://github.com/jeffreytse/zsh-vi-mode "$ZSH_CUSTOM/plugins/zsh-vi-mode"
        echo "✅ zsh-vi-mode installed"
    else
        echo "✅ zsh-vi-mode already installed"
    fi
}

# ─────────────────────────────────────────────────────────────
# Tmux Plugin Manager
# ─────────────────────────────────────────────────────────────
install_tpm() {
    if [ -d "$HOME/.config/tmux/plugins/tpm" ]; then
        echo "✅ TPM (Tmux Plugin Manager) already installed"
        return 0
    fi

    echo "📦 Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
    echo "✅ TPM installed"
}

# ─────────────────────────────────────────────────────────────
# Optional Tools
# ─────────────────────────────────────────────────────────────
install_optional_tools() {
    local pkg_manager=$1
    local os=$2

    echo ""
    echo "📦 Installing optional development tools..."

    # Terminal notifier (macOS only)
    if [ "$os" = "macos" ]; then
        if ! command -v terminal-notifier &>/dev/null; then
            echo "📦 Installing terminal-notifier..."
            brew install terminal-notifier
        else
            echo "✅ terminal-notifier already installed"
        fi
    fi

    # Node (via mise, but we can check)
    if ! command -v node &>/dev/null; then
        echo "⚠️  Node.js not found (will be managed by mise)"
    else
        echo "✅ Node.js already installed"
    fi
}

# ─────────────────────────────────────────────────────────────
# Stow Dotfiles
# ─────────────────────────────────────────────────────────────
stow_dotfiles() {
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo "⚠️  Dotfiles directory not found at: $DOTFILES_DIR"
        echo "   Skipping stow..."
        return 1
    fi

    echo ""
    echo "📦 Stowing dotfiles..."
    cd "$SCRIPT_DIR"

    # Stow all configurations
    if stow -v -R -t "$HOME" dotfiles 2>&1; then
        echo "✅ Dotfiles stowed successfully"
    else
        echo "⚠️  Some dotfiles may have conflicts. Review manually."
    fi
}

# ─────────────────────────────────────────────────────────────
# Main Installation
# ─────────────────────────────────────────────────────────────
main() {
    echo "🚀 Installing development environment..."
    echo ""

    # Detect OS
    OS=$(detect_os)
    if [ "$OS" = "unsupported" ]; then
        echo "❌ Unsupported OS: $OSTYPE"
        exit 1
    fi

    if [ "$OS" = "macos" ]; then
        echo "📱 Detected: macOS"
        setup_homebrew
        PKG_MANAGER="brew"
    else
        echo "🐧 Detected: Linux"
        PKG_MANAGER=$(setup_linux_package_manager)
    fi

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Installing Core Tools"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    install_git "$PKG_MANAGER"
    install_stow "$PKG_MANAGER"
    install_zsh "$PKG_MANAGER"
    install_neovim "$PKG_MANAGER"
    install_tmux "$PKG_MANAGER"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Installing CLI Tools"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    install_fzf "$PKG_MANAGER"
    install_ripgrep "$PKG_MANAGER"
    install_fd "$PKG_MANAGER"
    install_bat "$PKG_MANAGER"
    install_lazygit "$PKG_MANAGER"
    install_mise

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Installing Zsh Configuration"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    install_oh_my_zsh
    install_powerlevel10k
    install_zsh_plugins

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Installing Tmux Configuration"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    install_tpm

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Installing Optional Tools"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    install_optional_tools "$PKG_MANAGER" "$OS"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Stowing Dotfiles"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    stow_dotfiles

    echo ""
    echo "🎉 Development environment installation complete!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Next Steps"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "1. Restart your terminal or run: source ~/.zshrc"
    echo "2. Configure Powerlevel10k (first time): p10k configure"
    echo "3. Install Tmux plugins: Open tmux and press 'prefix + I'"
    echo "4. Install mise tools: mise install"
    echo "5. Set Zsh as default shell: chsh -s \$(which zsh)"
    echo ""
    echo "Optional:"
    echo "  - Create ~/.zshrc.local for machine-specific configs"
    echo "  - Install Neovim plugins: nvim +Lazy"
    echo ""
}

# Run main installation
main
