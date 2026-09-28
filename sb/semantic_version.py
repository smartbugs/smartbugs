import re
from typing import Optional

import semantic_version

import sb.debug


# Solidity accepts spaces between an operator and its version, and around dots.
# NpmSpec expects the operator and the version to be adjacent.
OPERATOR_SPACE = re.compile(r"(<=|>=|<|>|=|\^|~)\s+(?=\d|[xX*])")
VERSION_CORE = re.compile(r"(?<![\w.+-])\d+(?:\.\d+){0,2}(?![\w.-])")
UNBOUNDED_ZERO_LOWER = re.compile(r"(?<!\S)>=0\.\d+\.\d+(?![\w.+-])")


def _normalize(spec: str) -> str:
    spec = re.sub(r"\s*\.\s*", ".", spec.strip())
    spec = re.sub(r"\s+", " ", spec)
    spec = OPERATOR_SPACE.sub(r"\1", spec)

    # Normalize only the numeric core, not prerelease or build identifiers.
    def strip_zeroes(match: re.Match[str]) -> str:
        return ".".join(str(int(part)) for part in match.group().split("."))

    spec = VERSION_CORE.sub(strip_zeroes, spec)

    # Treat an unbounded >=0.x.y as the likely intended compatibility range.
    # Check each OR branch independently: a bound in another branch is irrelevant.
    branches = []
    for branch in spec.split("||"):
        if "<" not in branch:
            branch = UNBOUNDED_ZERO_LOWER.sub(
                lambda match: "^" + match.group()[2:], branch
            )
        branches.append(branch)
    return "||".join(branches)


def match(versions: list[str], available: set[str]) -> Optional[str]:
    sb.debug.log(f"semantic_version.match:\n   {versions=}\n   {available=}")

    # Separate pragmas constrain the same compiler version (AND). NpmSpec
    # implements npm's AND within each expression and OR between || branches.
    try:
        specs = [semantic_version.NpmSpec(_normalize(v)) for v in versions]
    except ValueError as exc:
        sb.debug.log(f"   Cannot parse Solidity version requirement: {exc}")
        return None

    if not specs:
        return None

    candidates = [semantic_version.Version(v) for v in available]
    compatible = [v for v in candidates if all(spec.match(v) for spec in specs)]

    # Select the newest compatible release. A pragma establishes compatibility,
    # not that every matching compiler can actually compile the source.
    selected = max(compatible, default=None)
    sb.debug.log(f"   {selected=}")
    return str(selected) if selected else None
