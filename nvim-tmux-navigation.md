# nvim-tmux-navigation Cheat Sheet

Seamless navigation between Neovim splits and tmux panes using the same keys.
Plugin: [alexghergh/nvim-tmux-navigation](https://github.com/alexghergh/nvim-tmux-navigation)

---

## Pane / Split Navigation

These bindings work transparently — the same key moves between a Neovim split
or a tmux pane depending on what's adjacent.

| Key       | Action                     |
|-----------|----------------------------|
| `Ctrl+h`  | Move to the **left** pane/split  |
| `Ctrl+j`  | Move **down** to the next pane/split |
| `Ctrl+k`  | Move **up** to the next pane/split  |
| `Ctrl+l`  | Move to the **right** pane/split |

> Works in both normal mode (Neovim) and any tmux pane (including non-vim panes).
> Also active in tmux copy-mode (`C-h/j/k/l`).

---

## Neovim Commands

These Ex commands are also available inside Neovim:

| Command                    | Action           |
|----------------------------|------------------|
| `:NvimTmuxNavigateLeft`    | Move left        |
| `:NvimTmuxNavigateDown`    | Move down        |
| `:NvimTmuxNavigateUp`      | Move up          |
| `:NvimTmuxNavigateRight`   | Move right       |

---

## Other tmux Bindings (unchanged)

| Key              | Action                              |
|------------------|-------------------------------------|
| `C-a`            | tmux prefix                         |
| `prefix + \|`    | Split pane vertically               |
| `prefix + -`     | Split pane horizontally             |
| `prefix + H/J/K/L` | Resize pane (5 cells)             |
| `prefix + h/l`   | Previous / Next window              |
| `prefix + </>`   | Move window left / right            |
| `prefix + c`     | New window                          |
| `prefix + f`     | Session picker (fzf)                |
| `M-t`            | New window (Alt+t)                  |
| `M-Tab`          | Next window (Alt+Tab)               |
| `M-n`            | New pane (Alt+n)                    |
| `M-1` … `M-9`   | Switch to window 1–9                |
| `M-=`            | Zoom / unzoom current pane          |
| `M-g`            | Lazygit popup                       |
| `prefix + 1-9`   | Switch to Nth session               |

---

## Copy Mode (vi-style)

Enter copy mode with `prefix + [`

| Key        | Action                     |
|------------|----------------------------|
| `v`        | Begin selection            |
| `y`        | Copy selection to clipboard |
| `Escape`   | Cancel / exit copy mode    |
| `C-d`      | Half-page down             |
| `C-u`      | Half-page up               |
| `C-e`      | Scroll down (one line)     |
| `C-y`      | Scroll up (one line)       |
| `C-h/j/k/l` | Navigate panes in copy mode |

---

## Notes

- Navigation is **disabled when the current tmux pane is zoomed** (configured via `disable_when_zoomed = true` in the Neovim plugin).
- `Ctrl+l` clears the screen in many terminals — use `prefix + C-l` to send a clear-screen to the shell from within tmux.
