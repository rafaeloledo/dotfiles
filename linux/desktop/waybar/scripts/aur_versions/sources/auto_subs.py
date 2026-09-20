from ..http import fetch_json
from ..models import Check
from ..pacman import pacman_version
from ..pkgbuild import pkgbuild_value
from ..version import cmp_versions

AUR_RPC = "https://aur.archlinux.org/rpc/v5/info?arg[]=auto-subs-bin"
GITHUB_LATEST = "https://api.github.com/repos/tmoroney/auto-subs/releases/latest"


# "v3.10.1" → "3.10.1"; leave other tags alone.
def strip_tag(raw: str) -> str:
    if len(raw) > 1 and raw[0] in "vV" and raw[1].isdigit():
        return raw[1:]
    return raw


# AUR Version "3.9.0-1" → pkgver "3.9.0".
def strip_pkgrel(raw: str) -> str:
    return raw.rsplit("-", 1)[0] if "-" in raw else raw


# auto-subs-bin PKGBUILD vs AUR RPC vs GitHub latest release.
def check_auto_subs(repo: dict) -> Check:
    pkgbuild, name = repo["dir"] / "PKGBUILD", repo["name"]
    installed = pacman_version(name)
    if not pkgbuild.is_file():
        return Check(name, "?", "?", installed, "error", f"missing PKGBUILD in {repo['dir']}")

    local_ver = pkgbuild_value(pkgbuild, "pkgver")
    aur = fetch_json(AUR_RPC)
    results = aur.get("results") or []
    aur_ver = strip_pkgrel(str(results[0].get("Version") or "")) if results else ""
    release = fetch_json(GITHUB_LATEST)
    upstream_ver = strip_tag(str(release.get("tag_name") or ""))
    if not upstream_ver:
        return Check(name, local_ver, "?", installed, "error", "github release had no tag")

    cmp_local = cmp_versions(local_ver, upstream_ver) if local_ver else -1
    cmp_aur = cmp_versions(aur_ver, upstream_ver) if aur_ver else 0
    if cmp_local < 0:
        detail = f"{local_ver} → {upstream_ver}"
        if cmp_aur < 0 and aur_ver and aur_ver != local_ver:
            detail += f"\nAUR {aur_ver}"
        return Check(name, local_ver, upstream_ver, installed, "updates", detail)
    if cmp_aur < 0:
        return Check(name, local_ver, upstream_ver, installed, "updates",
                     f"AUR {aur_ver} → {upstream_ver}")
    if cmp_local > 0:
        return Check(name, local_ver, upstream_ver, installed, "current",
                     f"PKGBUILD {local_ver} is ahead of github {upstream_ver}")
    return Check(name, local_ver, upstream_ver, installed, "current", local_ver)
