# dotfiles

Cross-platform dotfiles for Linux (Arch + Hyprland) and Windows.

## Layout

- `shared/` — configs used on both Linux and Windows (nvim, fish, tmux, yazi, lazygit, alacritty, etc.).
- `linux/` — Linux-only: Hyprland, quickshell, wofi, rofi, dunst, GTK, system scripts, Firefox.
- `windows/` — Windows-only: PowerShell profile, kanata, komorebi, autohotkey, Windows Terminal, setup script.

## Symlinking

- Linux: `just archlinux-link` (see `justfile`).
- Windows: `windows\setup.ps1` (must run as admin — uses real symlinks, not junctions).

## Terminals

- **Linux:** Ghostty primary; Alacritty / WezTerm / Zellij configs also present.
- **Windows:** **Alacritty** is the terminal. The `shared/terminal/wezterm/` config is legacy on Windows — do not propose wezterm-based workflows (external windows, font-zoom wrappers, etc.) for Windows tasks. Prefer running TUIs inline in the current terminal.

## Yazi (Windows notes)

- Config lives in `shared/terminal/yazi/yazi.toml` and is symlinked to `%APPDATA%\yazi\config\` by `setup.ps1`.
- Windows has no `file(1)`, so MIME detection uses the `mime-ext` plugin (configured in `yazi.toml`). Install once: `ya pkg add yazi-rs/plugins:mime-ext`.
