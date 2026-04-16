import itertools
import re
import semantic_version
from typing import Optional

import sb.debug

COMPARATOR = re.compile(r"(([<>]?=?|~|\^)\s*\d+\.\d+\.\d+)")


def match(versions: list[str], available: set[str]) -> Optional[str]:
    sb.debug.log(f"semantic_version.match:\n   {versions=}\n   {available=}")

    # semantic_version is picky compared to solc when parsing versions
    # we try to fix some issues
    sanitized_versions = []
    for version in versions:
        # remove leading zeros
        version = re.sub(r"(?:^|(?<=\D))0+(\d)", r"\1", version)
        # replace >=0.y.z by ^0.y.z if there is no upper bound
        if "<" not in version:
            version = re.sub(r">=\s*0\.", r"^0.", version)
        # replace x.y by x.y.0 if not preceded by operator
        version = re.sub(r"(?:^|(?<=[^0-9.>=<~]))\s*(\d+\.\d+)(?=[^0-9.]|$)", r"^\1.0", version)
        # replace ranges
        version = re.sub(r"(\d+\.\d+\.\d+)\s*-\s*(\d+\.\d+\.\d+)", r">=\1 <=\2", version)
        alternatives = []
        for comparator_set in version.split("||"):
            comparators = [m[0] for m in COMPARATOR.findall(comparator_set)]
            if comparators:
                alternatives.append(",".join(c.replace(" ", "") for c in comparators))
        if alternatives:
            sanitized_versions.append(alternatives)

    sb.debug.log(f"   {sanitized_versions=}")
    if not sanitized_versions:
        return None

    available = [semantic_version.Version(v) for v in available]

    # We select the maximal version compatible with the spec,
    # since people tend to specify ^0.x.0 when they actually used ^0.x.y
    # for some y > 0, and solc-0.x.0 may fail on the contract.
    # Beware: 0.4.10 introduced breaking changes, so choosing 0.4.26 for
    # something like ^0.4.0 is not always a good choice either.
    # In this case, you have to specify the version in the pragma
    # more precisely.
    solc_version = None
    for p in itertools.product(*sanitized_versions):
        spec = semantic_version.SimpleSpec(",".join(p))
        selected = spec.select(available)
        if selected and (not solc_version or solc_version < selected):
            solc_version = selected

    sb.debug.log(f"   {solc_version=}")
    return str(solc_version) if solc_version else None
