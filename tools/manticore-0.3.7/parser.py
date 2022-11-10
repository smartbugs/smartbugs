import sb.parse_utils
import io, tarfile

VERSION = "2022/08/05"

FINDINGS = set()


def parse_file(contents):
    analysis = []
    current_vul = None
    for line in contents.splitlines():
        if not line:
            continue
        if line[0] == "-":
            if current_vul is not None:
                analysis.append(current_vul)
            current_vul = {
                "name": line[1:-2].strip(),
                "line": -1,
                "code": None
            }
        elif current_vul is not None and line[:4] == "    ":
            index = line[4:].rindex("  ") + 4
            current_vul["line"] = int(line[4:index])
            current_vul["code"] = line[index:].strip()
    if current_vul is not None:
        analysis.append(current_vul)
    return analysis


def parse(exit_code, log, output, task):
    findings, infos, analysis = set(), set(), []
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    if any("Invalid solc compilation" in line for line in log):
        errors.add("solc error")

    try:
        with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
            for f in tar.getmembers():
                if not f.name.endswith("/global.findings"):
                    continue
                try:
                    contents = tar.extractfile(f).read()
                except Exception as e:
                    fails.add(f"problem extracting {f.name} from output archive")
                    continue
                analysis.append(parse_file(contents))
    except Exception as e:
        fails.add(f"error parsing results: {e}")

    findings = { vul["name"] for vuls in analysis for vul in vuls }

    return findings, infos, errors, fails, analysis
