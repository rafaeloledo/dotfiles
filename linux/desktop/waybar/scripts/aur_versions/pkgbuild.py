from pathlib import Path


# First `key=value` in a PKGBUILD (quotes stripped), or "".
def pkgbuild_value(pkgbuild: Path, key: str) -> str:
    prefix = f"{key}="
    for line in pkgbuild.read_text(encoding="utf-8", errors="replace").splitlines():
        if line.startswith(prefix):
            return line.split("=", 1)[1].strip().strip("'\"")
    return ""
