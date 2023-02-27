import io, os, tarfile
import sb.parse_utils

VERSION = "2023/02/27"

FINDINGS = (
    "CheckedCallStateUpdate",
    "Destroyable",
    "OriginUsed",
    "ReentrantCall",
    "UnsecuredValueSend",
    "UncheckedCall"
)

MAP_FINDINGS = {
    "checkedCallStateUpdate.csv": "CheckedCallStateUpdate",
    "destroyable.csv": "Destroyable",
    "originUsed.csv":  "OriginUsed",
    "reentrantCall.csv": "ReentrantCall",
    "unsecuredValueSend.csv": "UnsecuredValueSend",
    "uncheckedCall.csv": "UncheckedCall"
}

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
                    indicator = os.path.basename(fn)
                    try:
                        contents = tar.extractfile(fn).read()
                    except Exception as e:
                        fails.add(f"problem extracting {fn} from output archive: {e}")
                        continue
                    for line in contents.splitlines():
                        finding = {
                            "name": MAP_FINDINGS[indicator],
                            "address": int(line.strip(),16)
                        }
                        findings.append(finding)
        except Exception as e:
            fails.add(f"error parsing results: {e}")
    else:
        # parsing result of old Smartbugs
        for line in log:
            for indicator in MAP_FINDINGS:
                if indicator in line:
                    findings.append({"name": MAP_FINDINGS[indicator]})
                    break

    return findings, infos, errors, fails

