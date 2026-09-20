from __future__ import annotations

import json
import time
from collections.abc import Callable

from .config import CACHE_DEBOUNCE_S, CACHE_PATH


# Last payload from CACHE_PATH, or None if missing / invalid.
def read_cache() -> dict | None:
    try:
        data = json.loads(CACHE_PATH.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return None
    return data if isinstance(data, dict) and "text" in data else None


# Write payload to CACHE_PATH (creates ~/.cache/waybar if needed).
def write_cache(payload: dict) -> None:
    CACHE_PATH.parent.mkdir(parents=True, exist_ok=True)
    CACHE_PATH.write_text(json.dumps(payload), encoding="utf-8")


# Reuse cache if younger than CACHE_DEBOUNCE_S unless force (avoids double fetch on --notify).
def load_payload(force: bool, build: Callable[[], dict]) -> dict:
    cached = read_cache()
    age = time.time() - int(cached.get("checked_at", 0)) if cached else 1e9
    if cached and not force and age < CACHE_DEBOUNCE_S:
        return cached
    payload = build()
    write_cache(payload)
    return payload
