import re

from ..http import fetch_json
from ..models import Check
from ..pacman import pacman_version
from ..pkgbuild import pkgbuild_value
from ..version import cmp_versions

GROK_BOT_FEED = (
    "https://api2.cursor.sh/updates/api/update/linux-x64/sand/0.0.0/"
    "00000000-0000-0000-0000-000000000000/stable"
)


# 40-char commit from a Cursor /stable/<sha>/ CDN URL, or "".
def commit_from_url(url: str) -> str:
    match = re.search(r"/stable/([0-9a-f]{40})/", url)
    return match.group(1) if match else ""


# grok-bot-bin PKGBUILD vs Cursor linux-x64 sand feed (newer ver or same ver, new commit).
def check_grok_bot(repo: dict) -> Check:
    pkgbuild, name = repo["dir"] / "PKGBUILD", repo["name"]
    installed = pacman_version(name)
    if not pkgbuild.is_file():
        return Check(name, "?", "?", installed, "error", f"missing PKGBUILD in {repo['dir']}")

    local_ver = pkgbuild_value(pkgbuild, "pkgver")
    local_commit = pkgbuild_value(pkgbuild, "_commit")
    feed = fetch_json(GROK_BOT_FEED)
    upstream_ver = str(feed.get("version") or feed.get("name") or "")
    upstream_commit = commit_from_url(str(feed.get("url") or ""))
    if not upstream_ver:
        return Check(name, local_ver, "?", installed, "error", "update feed had no version")

    cmp = cmp_versions(local_ver, upstream_ver)
    drift = bool(local_commit and upstream_commit and local_commit != upstream_commit)
    if cmp < 0 or (cmp == 0 and drift):
        detail = f"{local_ver} → {upstream_ver}"
        if drift:
            detail += f"\ncommit {local_commit[:8]} → {upstream_commit[:8]}"
        return Check(name, local_ver, upstream_ver, installed, "updates", detail)
    if cmp > 0:
        return Check(name, local_ver, upstream_ver, installed, "current",
                     f"PKGBUILD {local_ver} is ahead of feed {upstream_ver}")
    return Check(name, local_ver, upstream_ver, installed, "current", local_ver)
