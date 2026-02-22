# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

This repository uses GNU Stow to manage symlinks. Each directory represents a "package" that can be independently installed:

- `nvim/` - Neovim configuration
- `zsh/` - Zsh configuration (merged macOS/Linux with OS detection)
- `wezterm/` - WezTerm terminal configuration
- `ghostty-pkg/` - Ghostty terminal configuration
- `tmux/` - Tmux configuration
- `ideavim/` - IntelliJ IDEA Vim plugin configuration
- `vsvimrc/` - Visual Studio Vim configuration
- `zls/` - Zig Language Server configuration
- `hive/` - Hive configuration
- `scripts/` - Custom scripts (installed to `~/.local/bin`)

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

4. **Install packages using GNU Stow:**

   **Install all packages:**
   ```bash
   stow */
   ```

   **Install specific packages (recommended):**
   ```bash
   stow zsh nvim wezterm tmux scripts
   ```

   **Or install one at a time:**
   ```bash
   stow zsh
   stow nvim
   stow tmux
   ```

5. **Reload your shell:**
   ```bash
   source ~/.zshrc
   ```

## How GNU Stow Works

GNU Stow creates symlinks from the dotfiles repo to your home directory. For example:

```
~/dotfiles/nvim/.config/nvim/init.lua  →  ~/.config/nvim/init.lua
~/dotfiles/zsh/.zshrc                  →  ~/.zshrc
~/dotfiles/tmux/.config/tmux/tmux.conf →  ~/.config/tmux/tmux.conf
```

## Usage

### Installing a package
```bash
cd ~/dotfiles
stow <package-name>
```

### Removing a package
```bash
cd ~/dotfiles
stow -D <package-name>
```

### Restowing (useful after updates)
```bash
cd ~/dotfiles
stow -R <package-name>
```

### Dry run (see what would happen)
```bash
stow -n <package-name>
```

### Verbose output
```bash
stow -v <package-name>
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
1. Create a new package directory
2. Mirror your home directory structure within it
3. Move your dotfile into the package
4. Stow it

Example for adding a new config:
```bash
mkdir -p myapp/.config/myapp
mv ~/.config/myapp/config myapp/.config/myapp/config
stow myapp
```

### Updating dotfiles
1. Edit files in the stow packages (they're symlinked, so edits apply immediately)
2. Commit and push changes
3. On other machines: `git pull && stow -R <package-name>`

## Additional Resources

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Managing Dotfiles with GNU Stow](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
