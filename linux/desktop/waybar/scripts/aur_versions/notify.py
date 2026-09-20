import subprocess


# notify-send from payload: behind=normal, error=critical, current=low.
def notify(payload: dict) -> None:
    titles = {
        "updates": ("AUR packages behind", "normal"),
        "error": ("AUR version check failed", "critical"),
    }
    title, urgency = titles.get(payload.get("class"), ("AUR packages current", "low"))
    body = payload.get("tooltip") or "no repositories configured"
    subprocess.run(["notify-send", "-a", "AUR", "-u", urgency, title, body], check=False)
