import sb.parse_utils

VERSION = "2022/11/11"

FINDINGS = { "Ether leak" }


def parse(exit_code, log, output):
    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    errors.discard("EXIT_CODE_1") # there will be an exception in fails anyway
    for f in list(fails):         # make a copy of fails, so we can modify it
        if f.startswith("exception (teether.evm.exceptions."): # reported as error below
            fails.remove(f)
        elif f.startswith('exception (z3.z3types.Z3Exception: b"Argument '):
            fails.remove(f)
            fails.add("exception (z3.z3types.Z3Exception: Argument does not match function declaration")

    exploit = []
    analysis_completed = False
    for line in log:
        if line.startswith("INFO:root:Could not exploit any RETURN+CALL"):
            infos.add("Could not exploit any RETURN+CALL")
            analysis_completed = True
        elif line.startswith("WARNING:root:No state-dependent critical path found, aborting"):
            infos.add("No state-dependent critical path found")
            analysis_completed = True
        elif line.startswith("eth.sendTransaction"):
            exploit.append(line)
            analysis_completed = True
        elif line.startswith("ERROR:root:"):
            error = line[11:]

            if error.startswith("Failed path due to "):
                e = error[19:]

                # Skip errors already reported as an exception
                if e.startswith("b'Argument ") or any(e in f for f in fails):
                    continue

                if e.startswith("Symbolic code index"):
                    error = "Failed path due to Symbolic code index"
                elif e.startswith("balance of symbolic address"):
                    error = "Failed path due to balance of symbolic address"

            errors.add(error)

    if log and not analysis_completed:
        infos.add("analysis incomplete")
        if not fails and not errors:
            fails.add("execution failed")

    if exploit:
        findings = [ { "name": "Ether leak", "exploit": exploit } ]

    return findings, infos, errors, fails

