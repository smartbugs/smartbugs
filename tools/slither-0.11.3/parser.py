import io, tarfile, json, re
import sb.parse_utils

VERSION = "2024/04/30"

FINDINGS = {
    "abiencoderv2-array",
    "arbitrary-send-erc20",
    "arbitrary-send-erc20-permit",
    "arbitrary-send-eth",
    "array-by-reference",
    "assembly",
    "assert-state-change",
    "boolean-cst",
    "boolean-equal",
    "cache-array-length",
    "calls-loop",
    "chainlink-feed-registry",
    "chronicle-unchecked-price",
    "codex",
    "constable-states",
    "constant-function-asm",
    "constant-function-state",
    "controlled-array-length",
    "controlled-delegatecall",
    "costly-loop",
    "cyclomatic-complexity",
    "dead-code",
    "delegatecall-loop",
    "deprecated-standards",
    "divide-before-multiply",
    "domain-separator-collision",
    "encode-packed-collision",
    "enum-conversion",
    "erc20-indexed",
    "erc20-interface",
    "erc721-interface",
    "events-access",
    "events-maths",
    "external-function",
    "function-init-state",
    "gelato-unprotected-randomness",
    "immutable-states",
    "incorrect-equality",
    "incorrect-exp",
    "incorrect-modifier",
    "incorrect-return",
    "incorrect-shift",
    "incorrect-unary",
    "incorrect-using-for",
    "locked-ether",
    "low-level-calls",
    "mapping-deletion",
    "missing-inheritance",
    "missing-zero-check",
    "msg-value-loop",
    "multiple-constructors",
    "name-reused",
    "naming-convention",
    "optimism-deprecation",
    "out-of-order-retryable",
    "pragma",
    "protected-vars",
    "public-mappings-nested",
    "pyth-deprecated-functions",
    "pyth-unchecked-confidence",
    "pyth-unchecked-publishtime",
    "redundant-statements",
    "reentrancy-benign",
    "reentrancy-eth",
    "reentrancy-events",
    "reentrancy-no-eth",
    "reentrancy-unlimited-gas",
    "return-bomb",
    "return-leave",
    "reused-constructor",
    "rtlo",
    "shadowing-abstract",
    "shadowing-builtin",
    "shadowing-local",
    "shadowing-state",
    "solc-version",
    "storage-array",
    "suicidal",
    "tautological-compare",
    "tautology",
    "timestamp",
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
    "var-read-using-this",
    "variable-scope",
    "void-cst",
    "weak-prng",
    "write-after-write",
}

LOCATION = re.compile("/sb/(.*?)#([0-9-]*)")

def parse(exit_code, log, output):
    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    errors.discard('EXIT_CODE_255') # this code seems to be returned in any case

    try:
        with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
            output_json = tar.extractfile("output.json").read()
            output_dict = json.loads(output_json)
    except Exception as e:
        fails.add(f"error parsing results: {e}")
        output_dict = {}

    if not output_dict.get("success", False):
        fails.add("analysis unsuccessful, check output.json")

    if output_dict.get("error", None):
        errors.add("analysis reports errors, check output.json")

    results = output_dict.get("results", {})
    issues = results.get("detectors", [])

    for issue in issues:
        finding = {}
        for i,f in (("check", "name"), ("impact", "impact" ),
            ("confidence", "confidence"), ("description", "message")):
            finding[f] = issue[i]
        elements = issue.get("elements",[])
        m = LOCATION.search(finding["message"])
        finding["message"] = finding["message"].replace("../../sb/","")
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
            finding["filename"] = source_mapping["filename_absolute"].replace("/sb/","")
        for element in elements:
            if element.get("type") == "function":
                finding["function"] = element["name"]
                type_specific_fields = element.get("type_specific_fields", {})
                parent = type_specific_fields.get("parent", {})
                if parent.get("type", None) == "contract":
                    finding["contract"] = parent.get("name", "")
                break
        findings.append(finding)

    return findings, infos, errors, fails
