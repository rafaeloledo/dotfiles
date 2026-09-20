import subprocess


# Installed version-release from `pacman -Q`, or "" if missing.
def pacman_version(pkg: str) -> str:
    try:
        out = subprocess.check_output(["pacman", "-Q", pkg], stderr=subprocess.DEVNULL, text=True)
    except (OSError, subprocess.CalledProcessError):
        return ""
    parts = out.strip().split(None, 1)
    return parts[1] if len(parts) == 2 else out.strip()
