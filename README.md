# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

This repository uses GNU Stow to manage symlinks. All dotfiles are in the `dotfiles/` package directory:

- `dotfiles/.config/nvim/` - Neovim configuration
- `dotfiles/.config/tmux/` - Tmux configuration
- `dotfiles/.config/ghostty/` - Ghostty terminal configuration
- `dotfiles/.config/hive/` - Hive configuration
- `dotfiles/.config/zls.json` - Zig Language Server configuration
- `dotfiles/.local/bin/` - Custom scripts
- `dotfiles/.zshrc` - Zsh configuration (merged macOS/Linux with OS detection)
- `dotfiles/.wezterm.lua` - WezTerm terminal configuration
- `dotfiles/.ideavimrc` - IntelliJ IDEA Vim plugin configuration
- `dotfiles/.vsvimrc` - Visual Studio Vim configuration

## Prerequisites

### Install GNU Stow

**macOS:**
```bash
brew install stow
```

**Linux (Debian/Ubuntu):**
```bash
sudo apt install stow
```

**Linux (Arch):**
```bash
sudo pacman -S stow
```

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/Code/dotfiles
   cd ~/Code/dotfiles
   ```

2. **(Optional) Install Zsh dependencies:**
   ```bash
   ./install-zsh-deps.sh
   ```
   This installs Oh My Zsh, Powerlevel10k, and required zsh plugins.

3. **Remove existing configs that conflict:**
   ```bash
   # Backup your current configs if needed
   mv ~/.zshrc ~/.zshrc.backup
   rm ~/.config/nvim  # if it's a symlink
   # etc.
   ```

4. **Install dotfiles using GNU Stow:**

   ```bash
   stow dotfiles
   ```

   This will symlink all dotfiles from the `dotfiles/` directory to your home directory.

5. **Reload your shell:**
   ```bash
   source ~/.zshrc
   ```

## How GNU Stow Works

GNU Stow creates symlinks from the dotfiles repo to your home directory. For example:

```
~/Code/dotfiles/.config/nvim/init.lua  →  ~/.config/nvim/init.lua
~/Code/dotfiles/.zshrc                 →  ~/.zshrc
~/Code/dotfiles/.config/tmux/tmux.conf →  ~/.config/tmux/tmux.conf
```

## Usage

### Installing dotfiles
```bash
cd ~/Code/dotfiles
stow dotfiles
```

### Removing dotfiles
```bash
cd ~/Code/dotfiles
stow -D dotfiles
```

### Restowing (useful after updates)
```bash
cd ~/Code/dotfiles
stow -R dotfiles
```

### Dry run (see what would happen)
```bash
stow -n dotfiles
```

### Verbose output
```bash
stow -v dotfiles
```

## Platform-Specific Notes

### Zsh Configuration
The `.zshrc` file includes OS detection via `$OSTYPE`:
- macOS-specific configs (Homebrew, Bun, Android Studio, etc.) only load on macOS
- Shared configs (aliases, Go, vim, etc.) work on both platforms
- Linux-specific configs can be added in the `else` branch

### Local Overrides
Create `~/.zshrc.local` for machine-specific configurations (API keys, local paths, etc.). This file is gitignored and sourced automatically.

## Troubleshooting

### Conflicts
If stow reports conflicts (files already exist), you have a few options:

1. **Backup and remove existing files:**
   ```bash
   mv ~/.zshrc ~/.zshrc.backup
   stow zsh
   ```

2. **Adopt existing files into stow:**
   ```bash
   stow --adopt zsh
   ```
   Note: This will move existing files into your dotfiles repo. Review changes before committing.

### Cleaning broken symlinks
```bash
find ~ -maxdepth 1 -type l ! -exec test -e {} \; -delete
```

## Maintenance

### Adding new dotfiles
1. Mirror your home directory structure in the `dotfiles/` package
2. Move your dotfile into the package
3. Restow

Example for adding a new config:
```bash
cd ~/Code/dotfiles
mkdir -p dotfiles/.config/myapp
mv ~/.config/myapp/config dotfiles/.config/myapp/config
stow -R dotfiles
```

### Updating dotfiles
1. Edit files in the `dotfiles/` package (they're symlinked, so edits apply immediately)
2. Commit and push changes
3. On other machines: `git pull && stow -R dotfiles`

## Additional Resources

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Managing Dotfiles with GNU Stow](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
