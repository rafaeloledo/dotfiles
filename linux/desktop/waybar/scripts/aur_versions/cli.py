import sys

from .cache import load_payload
from .checks import run_checks
from .notify import notify
from .waybar import payload_from, signal_waybar, waybar_line


# --notify implies refresh + notify-send + Waybar signal. Always prints JSON, exits 0.
def main() -> int:
    notify_user = "--notify" in sys.argv
    payload = load_payload(
        force=notify_user or "--refresh" in sys.argv,
        build=lambda: payload_from(run_checks()),
    )
    if notify_user:
        notify(payload)
        signal_waybar()
    print(waybar_line(payload), flush=True)
    return 0
