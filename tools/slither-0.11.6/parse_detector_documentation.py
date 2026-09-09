#!/usr/bin/env python3

import re
import subprocess
from pathlib import Path

import yaml


SOURCE = Path("upload/Detector-Documentation.md")
OUTPUT = Path("Detector-Documentation.yaml")


def markdown_to_plain(text: str) -> str:
    """Convert a Markdown fragment to compact plain text."""
    result = subprocess.run(
        ["pandoc", "--from=gfm", "--to=plain", "--wrap=none"],
        input=text,
        text=True,
        capture_output=True,
        check=True,
    ).stdout
    return re.sub(r"\s+", " ", result).strip()


def section_text(body: str, heading: str) -> str:
    match = re.search(
        rf"^### {re.escape(heading)}\s*$\n(.*?)(?=^### |^## |\Z)",
        body,
        flags=re.MULTILINE | re.DOTALL,
    )
    if not match:
        raise ValueError(f"Missing section: {heading}")
    return markdown_to_plain(match.group(1))


def configuration_value(body: str, name: str) -> str:
    match = re.search(
        rf"^\* {re.escape(name)}:\s*(.+?)\s*$", body, flags=re.MULTILINE
    )
    if not match:
        raise ValueError(f"Missing configuration value: {name}")
    return markdown_to_plain(match.group(1))


def parse_document(source: str) -> dict[str, dict[str, str]]:
    findings: dict[str, dict[str, str]] = {}
    matches = list(re.finditer(r"^## (.+?)\s*$", source, flags=re.MULTILINE))

    for index, match in enumerate(matches):
        heading = markdown_to_plain(match.group(1))
        end = matches[index + 1].start() if index + 1 < len(matches) else len(source)
        body = source[match.end() : end]

        identifier = configuration_value(body, "Check")
        if identifier in findings:
            raise ValueError(f"Duplicate identifier: {identifier}")

        description = section_text(body, "Description")
        recommendation = section_text(body, "Recommendation")
        if not description.endswith("."):
            description += "."

        findings[identifier] = {
            "descr_short": heading,
            "descr_long": f"{description} Recommendation: {recommendation}",
            "severity": configuration_value(body, "Severity").lower(),
            "confidence": configuration_value(body, "Confidence").lower(),
        }

    return dict(sorted(findings.items()))


def dump_findings(findings: dict[str, dict[str, str]]) -> str:
    """Serialize findings with a blank line between top-level entries."""
    entries = [
        yaml.safe_dump(
            {identifier: values},
            sort_keys=False,
            allow_unicode=True,
            width=10_000,
        ).rstrip()
        for identifier, values in findings.items()
    ]
    return "\n\n".join(entries) + "\n"


def main() -> None:
    findings = parse_document(SOURCE.read_text(encoding="utf-8"))
    OUTPUT.write_text(dump_findings(findings), encoding="utf-8")
    print(f"Wrote {len(findings)} findings to {OUTPUT}")


if __name__ == "__main__":
    main()
