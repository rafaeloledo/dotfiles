import re


# Split a version on . + _ - with digit segments as ints (0.9 < 0.10).
def version_tuple(raw: str) -> tuple[int | str, ...]:
    return tuple(int(p) if p.isdigit() else p for p in re.split(r"[.+_-]", raw) if p)


# -1 / 0 / 1. Falls back to string compare if mixed int/str parts.
def cmp_versions(a: str, b: str) -> int:
    try:
        ta, tb = version_tuple(a), version_tuple(b)
        return (ta > tb) - (ta < tb)
    except TypeError:
        return (a > b) - (a < b)
