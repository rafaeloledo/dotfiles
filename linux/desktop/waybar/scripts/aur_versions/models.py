from dataclasses import dataclass


# One package: PKGBUILD vs upstream vs pacman. status is current|updates|error.
@dataclass
class Check:
    name: str
    local: str
    upstream: str
    installed: str
    status: str
    detail: str
