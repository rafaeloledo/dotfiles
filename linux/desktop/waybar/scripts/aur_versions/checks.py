import json
import urllib.error

from .config import REPOS
from .models import Check
from .pacman import pacman_version
from .sources import SOURCES


# Run each REPOS handler. Unknown source / fetch errors become status=error.
def run_checks() -> list[Check]:
    results = []
    for repo in REPOS:
        handler = SOURCES.get(repo["source"])
        try:
            if handler is None:
                raise ValueError(f"unknown source {repo['source']}")
            results.append(handler(repo))
        except (OSError, ValueError, urllib.error.URLError, json.JSONDecodeError, TimeoutError) as exc:
            results.append(Check(repo["name"], "?", "?", pacman_version(repo["name"]), "error", str(exc)))
    return results
