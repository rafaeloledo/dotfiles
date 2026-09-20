import json
import subprocess
import time
from dataclasses import asdict

from .config import ICON, WAYBAR_SIGNAL
from .models import Check


# Cache + Waybar fields. class is updates > error > current. Tooltip lists each check.
def payload_from(checks: list[Check]) -> dict:
    statuses = {c.status for c in checks}
    css = "updates" if "updates" in statuses else "error" if "error" in statuses else "current"
    lines = []
    for c in checks:
        lines.append(f"{c.name}  {c.detail}")
        if c.installed:
            lines.append(f"installed  {c.installed}")
    return {
        "text": ICON, "class": css, "alt": css,
        "tooltip": "\n".join(lines) or "no repositories configured",
        "checks": [asdict(c) for c in checks],
        "checked_at": int(time.time()),
    }


# Waybar JSON line (drops cache-only fields checks / checked_at).
def waybar_line(payload: dict) -> str:
    return json.dumps({
        "text": payload.get("text", ICON),
        "class": payload.get("class", "error"),
        "alt": payload.get("alt", "error"),
        "tooltip": payload.get("tooltip", ""),
    }, ensure_ascii=False)


# pkill -RTMIN+N waybar so custom/aur re-runs. Harmless if Waybar is down.
def signal_waybar() -> None:
    subprocess.run(["pkill", f"-RTMIN+{WAYBAR_SIGNAL}", "waybar"], check=False)
