import json
import urllib.request


# GET url and parse JSON (12s timeout).
def fetch_json(url: str) -> dict:
    req = urllib.request.Request(url, headers={"User-Agent": "waybar-aur-versions"})
    with urllib.request.urlopen(req, timeout=12) as resp:
        return json.load(resp)
