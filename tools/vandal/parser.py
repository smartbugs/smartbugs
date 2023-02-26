import io, os, tarfile
import sb.parse_utils

VERSION = "2023/02/26"

FINDINGS = (
    "checkedCallStateUpdate",
    "destroyable",
    "originUsed",
    "reentrantCall",
    "unsecuredValueSend",
    "uncheckedCall"
)

ANALYSIS_COMPLETE = (
    "+ /vandal/bin/decompile",
    "+ souffle -F facts-tmp",
    "+ rm -rf facts-tmp"
)

DEPRECATED = "Warning: Deprecated type declaration"
CANNOT_OPEN_FACT_FILE = "Cannot open fact file"

def parse(exit_code, log, output):
    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    errors.discard("EXIT_CODE_1") # = no findings; EXIT_CODE_0 = findings

    analysis_complete = set()
    for line in log:
        if DEPRECATED in line:
            infos.add(DEPRECATED)
            continue
        if CANNOT_OPEN_FACT_FILE in line:
            fails.add(CANNOT_OPEN_FACT_FILE)
            continue
        for indicator in ANALYSIS_COMPLETE:
            if indicator in line:
                analysis_complete.add(indicator)
                break

    if log and (len(analysis_complete) < 3 or CANNOT_OPEN_FACT_FILE in fails):
        infos.add("analysis incomplete")
        if not fails and not errors:
            fails.add("execution failed")
    if CANNOT_OPEN_FACT_FILE in fails and len(fails) > 1:
        fails.remove(CANNOT_OPEN_FACT_FILE)

    if output:
        try:
            with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
                for fn in tar.getnames():
                    if not fn.endswith(".csv"):
                        continue
                    name = os.path.basename(fn)[:-4]
                    try:
                        contents = tar.extractfile(fn).read()
                    except Exception as e:
                        fails.add(f"problem extracting {fn} from output archive: {e}")
                        continue
                    for line in contents.splitlines():
                        finding = { "name": name, "address": int(line.strip(),16) }
                        findings.append(finding)
        except Exception as e:
            fails.add(f"error parsing results: {e}")
    else:
        # parsing result of old Smartbugs
        for line in log:
            for finding in FINDINGS:
                if f"{finding}.csv" in line:
                    findings.append({"name": finding})
                    break

    return findings, infos, errors, fails

