from pathlib import Path

CACHE_PATH = Path.home() / ".cache" / "waybar" / "aur-versions.json"
CACHE_DEBOUNCE_S = 15  # skip a second fetch when --notify signals Waybar
WAYBAR_SIGNAL = "11"  # must match custom/aur "signal" in config.jsonc
ICON = ""

# Local AUR clones. `source` selects a handler in sources.SOURCES.
REPOS = [
    {
        "name": "grok-bot-bin",
        "dir": Path.home() / "repos" / "aur" / "grok-bot-bin",
        "source": "grok-bot",
    },
    {
        "name": "auto-subs-bin",
        "dir": Path.home() / "repos" / "aur" / "auto-subs-bin",
        "source": "auto-subs",
    },
]
