import io, tarfile, yaml
import sb.parse_utils

VERSION = "2022/11/17"

FINDINGS = set()

def parse_file(lines):
    findings = []
    snippet = False
    for line in lines:
        if snippet:
            snippet = False
            l = line.split()
            finding["line"] = int(l[0])
            finding["code"] = c
        elif line.startwith("  Solidity snippet:"):
            snippet = True
        elif line[0] == "-":
            finding = {
                "name": line[1:-2].strip()
            }
            findings.append(finding)
            continue
    return findings


def parse(exit_code, log, output):
    findings, infos = [], set()
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
                    fn = fn.replace("/global.findings","/manticore.yml")
                    cmd = yaml.safe_load(tar.extractfile(fn).read())
                except Exception as e:
                    infos.add(f"manticore.yml not found")

                filename, contract = None, None
                if isinstance(cmd,dict):
                    cli = cmd.get("cli")
                    if isinstance(cli,dict):
                        contract = cli.get("contract")
                        argv = cli.get("argv")
                        if isinstance(argv,list) and len(argv) > 0:
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
