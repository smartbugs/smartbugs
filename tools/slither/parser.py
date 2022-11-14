import io, tarfile, json, re
import sb.parse_utils

VERSION = "2022/11/14"

FINDINGS = {
    "abiencoderv2-array",
    "arbitrary-send",
    "arbitrary-send-erc20",
    "arbitrary-send-erc20-permit",
    "arbitrary-send-eth",
    "array-by-reference",
    "assembly",
    "assert-state-change",
    "backdoor",
    "boolean-cst",
    "boolean-equal",
    "calls-loop",
    "complex-function",
    "constable-states",
    "constant-function",
    "constant-function-asm",
    "constant-function-state",
    "controlled-array-length",
    "controlled-delegatecall",
    "costly-loop",
    "dead-code",
    "delegatecall-loop",
    "deprecated-standards",
    "divide-before-multiply",
    "domain-separator-collision",
    "enum-conversion",
    "erc20-indexed",
    "erc20-interface",
    "erc721-interface",
    "events-access",
    "events-maths",
    "external-function",
    "function-init-state",
    "incorrect-equality",
    "incorrect-modifier",
    "incorrect-shift",
    "incorrect-unary",
    "locked-ether",
    "low-level-calls",
    "mapping-deletion",
    "missing-inheritance",
    "missing-zero-check",
    "msg-value-loop",
    "multiple-constructors",
    "name-reused",
    "naming-convention",
    "pragma",
    "protected-vars",
    "public-mappings-nested",
    "redundant-statements",
    "reentrancy-benign",
    "reentrancy-eth",
    "reentrancy-events",
    "reentrancy-no-eth",
    "reentrancy-unlimited-gas",
    "reused-constructor",
    "rtlo",
    "shadowing-abstract",
    "shadowing-builtin",
    "shadowing-local",
    "shadowing-state",
    "similar-names",
    "solc-version",
    "storage-array",
    "suicidal",
    "tautology",
    "timestamp",
    "token-reentrancy",
    "too-many-digits",
    "tx-origin",
    "unchecked-lowlevel",
    "unchecked-send",
    "unchecked-transfer",
    "unimplemented-functions",
    "uninitialized-fptr-cst",
    "uninitialized-local",
    "uninitialized-state",
    "uninitialized-storage",
    "unprotected-upgrade",
    "unused-return",
    "unused-state",
    "variable-scope",
    "void-cst",
    "weak-prng",
    "write-after-write",
}

LOCATION = re.compile("/sb/(.*?)#([0-9-]*)")

def parse(exit_code, log, output):
    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    #for line in log:
    #    pass

    try:
        with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
            output_json = tar.extractfile("output.json").read()
            issues = json.loads(output_json)
    except Exception as e:
        fails.add(f"error parsing results: {e}")
        issues = {}

    for issue in issues:
        finding = {}
        for i,f in ( ("check", "name"), ("impact", "impact" ),
            ("confidence", "confidence"), ("description", "message")):
            finding[f] = issue[i]
        elements = issue.get("elements",[])
        m = LOCATION.search(finding["message"])
        finding["message"] = finding["message"].replace("/sb/","")
        if m:
            finding["filename"] = m[1]
            if "-" in m[2]:
                start,end = m[2].split("-")
                finding["line"] = int(start)
                finding["line_end"] = int(end)
            else:
                finding["line"] = int(m[2])
        elif len(elements) > 0 and "source_mapping" in elements[0]:
            source_mapping = elements[0]["source_mapping"]
            lines = sorted(source_mapping["lines"])
            if len(lines) > 0:
                finding["line"] = lines[0]
                if len(lines) > 1:
                    finding["line_end"] = lines[-1]
            finding["filename"] = source_mapping["filename"]
        for element in elements:
            if element.get("type") == "function":
                finding["function"] = element["name"]
                finding["contract"] = element["contract"]["name"]
                break
        findings.append(finding)

    return findings, infos, errors, fails
