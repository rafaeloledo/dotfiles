# aur-versions

Waybar module that compares local AUR package trees against upstream.

The bar shows an Arch Linux icon. Hover lists each package; click re-checks and
sends a mako notification. Gold means something is behind, red means the check
failed.

## Packages

Configured in `REPOS` inside `aur_versions/config.py`. Each entry is a local
clone plus a named upstream source:

| Field | Meaning |
|-------|---------|
| `name` | Pacman / AUR package name (`pacman -Q`) |
| `dir` | Path to the package tree (must contain a `PKGBUILD`) |
| `source` | Key in `SOURCES` — how to query latest |

Currently wired:

| Package | Tree | Upstream |
|---------|------|----------|
| `grok-bot-bin` | `~/repos/aur/grok-bot-bin` | Cursor linux-x64 `sand` update feed |
| `auto-subs-bin` | `~/repos/aur/auto-subs-bin` | AUR RPC + GitHub latest release |

`grok-bot` compares `pkgver` / `_commit` in the PKGBUILD to the feed at
`https://api2.cursor.sh/updates/api/update/linux-x64/sand/.../stable`. An older
version, or the same version with a different commit, counts as behind.

`auto-subs` compares PKGBUILD `pkgver` to the latest GitHub release tag of
`tmoroney/auto-subs`, and also to the Version published on
[auto-subs-bin](https://aur.archlinux.org/packages/auto-subs-bin). Either side
lagging GitHub counts as behind.

To watch another package, append a `REPOS` entry in `config.py` and (if needed)
a checker under `aur_versions/sources/` registered in `SOURCES`.

## Layout

`aur-versions` is the Waybar entry point. Logic lives in `aur_versions/`:

| Module | Responsibility |
|--------|----------------|
| `config.py` | cache path, icon, signal, `REPOS` |
| `models.py` | `Check` dataclass |
| `pkgbuild.py` | read `key=` from a PKGBUILD |
| `pacman.py` | installed version (`pacman -Q`) |
| `version.py` | version compare (`0.9 < 0.10`) |
| `http.py` | GET + JSON |
| `sources/` | upstream adapters (`SOURCES` registry) |
| `checks.py` | run every `REPOS` entry |
| `waybar.py` | payload, JSON line, `RTMIN+11` |
| `cache.py` | `~/.cache/waybar/aur-versions.json` |
| `notify.py` | notify-send |
| `cli.py` | `--refresh` / `--notify` |

## Implementations

| File | Language | Waybar |
|------|----------|--------|
| `aur-versions` | Python 3 (stdlib only) | default (`config.jsonc`) |
| `aur-versions.lua` | Lua 5 (`curl` + `jq`) | drop-in |
| `aur-versions.sh` | Bash (`curl` + `jq`) | drop-in |

Same flags, cache (`~/.cache/waybar/aur-versions.json`), and the same package checks.
Swap the `exec` / `on-click` paths in `config.jsonc` to use another copy.

## CLI

```bash
~/.config/waybar/scripts/aur-versions            # JSON for Waybar (uses 15s cache)
~/.config/waybar/scripts/aur-versions --refresh  # ignore cache, print JSON
~/.config/waybar/scripts/aur-versions --notify   # refresh, notify-send, poke Waybar
```

`--notify` implies a refresh. Results are written to
`~/.cache/waybar/aur-versions.json`.

## Waybar

```jsonc
"custom/aur": {
    "exec": "$HOME/.config/waybar/scripts/aur-versions",
    "return-type": "json",
    "interval": 1800,
    "signal": 11,
    "exec-on-event": false,
    "format": "{text}",
    "on-click": "$HOME/.config/waybar/scripts/aur-versions --notify",
    "tooltip": true
}
```

| Action | Effect |
|--------|--------|
| Show | Arch icon (``); color from last check |
| Hover | Per-package local → upstream, plus installed version |
| Click | Live check + notification; module refreshes via `RTMIN+11` |
| Interval | Recheck every 30 minutes |

Icon color is set by the JSON `class` (`current`, `updates`, `error`) in
`style.css` (`#custom-aur.*`).
