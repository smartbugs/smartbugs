import io
import tarfile

import yaml

import sb.parse_utils


VERSION = "2022/11/17"

FINDINGS: set[str] = set()


def parse_file(lines: list[bytes]) -> list[dict]:
    findings: list[dict] = []
    snippet = False
    finding: dict = {}
    for line in lines:
        if snippet:
            snippet = False
            parts = line.split()
            if finding and parts:
                finding["line"] = int(parts[0])
                finding["code"] = line
        elif line.startswith(b"  Solidity snippet:"):
            snippet = True
        elif line[0:1] == b"-":
            finding = {"name": line[1:-2].strip().decode("utf-8", errors="ignore")}
            findings.append(finding)
            continue
    return findings


def parse(
    exit_code: int, log: list[str], output: bytes
) -> tuple[list[dict], set[str], set[str], set[str]]:
    findings: list[dict] = []
    infos: set[str] = set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    if any("Invalid solc compilation" in line for line in log):
        errors.add("solc error")

    try:
        with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
            for fn in tar.getnames():
                if not fn.endswith("/global.findings"):
                    continue

                try:
                    contents = tar.extractfile(fn).read()
                    manticore_findings = parse_file(contents.splitlines())
                except Exception as e:
                    fails.add(f"problem extracting {fn} from output archive: {e}")
                    continue

                cmd = None
                try:
                    fn = fn.replace("/global.findings", "/manticore.yml")
                    cmd = yaml.safe_load(tar.extractfile(fn).read())
                except Exception:
                    infos.add("manticore.yml not found")

                filename, contract = None, None
                if isinstance(cmd, dict):
                    cli = cmd.get("cli")
                    if isinstance(cli, dict):
                        contract = cli.get("contract")
                        argv = cli.get("argv")
                        if isinstance(argv, list) and len(argv) > 0:
                            filename = argv[0]

                for mf in manticore_findings:
                    if filename:
                        mf["filename"] = filename
                    if contract:
                        mf["contract"] = contract
                    findings.append(mf)
    except Exception as e:
        fails.add(f"error parsing results: {e}")

    return findings, infos, errors, fails
