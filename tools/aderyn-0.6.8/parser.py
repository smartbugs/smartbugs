import io
import json
import re
import tarfile
from typing import Optional

import sb.parse_utils


VERSION = "2026/07/28"

# Aderyn 0.6.8 detector registry (the `detectors_used` list emitted in the report).
FINDINGS = {
    "abi-encode-packed-hash-collision",
    "arbitrary-transfer-from",
    "assert-state-change",
    "block-timestamp-deadline",
    "boolean-equality",
    "builtin-symbol-shadowing",
    "centralization-risk",
    "constant-function-changes-state",
    "constant-function-contains-assembly",
    "contract-locks-ether",
    "costly-loop",
    "dangerous-unary-operator",
    "dead-code",
    "delegate-call-unchecked-address",
    "delegatecall-in-loop",
    "delete-nested-mapping",
    "deprecated-oz-function",
    "division-before-multiplication",
    "dynamic-array-length-assignment",
    "ecrecover",
    "empty-block",
    "empty-require-revert",
    "enumerable-loop-removal",
    "eth-send-unchecked-address",
    "experimental-encoder",
    "function-initializing-state",
    "function-pointer-in-constructor",
    "function-selector-collision",
    "inconsistent-type-names",
    "incorrect-caret-operator",
    "incorrect-erc20-interface",
    "incorrect-erc721-interface",
    "incorrect-shift-order",
    "incorrect-use-of-modifier",
    "internal-function-used-once",
    "large-numeric-literal",
    "literal-instead-of-constant",
    "local-variable-shadowing",
    "missing-inheritance",
    "misused-boolean",
    "modifier-used-only-once",
    "msg-value-in-loop",
    "multiple-constructors",
    "multiple-placeholders",
    "nested-struct-in-mapping",
    "non-reentrant-not-first",
    "out-of-order-retryable",
    "pre-declared-local-variable-usage",
    "push-zero-opcode",
    "redundant-statement",
    "reentrancy-state-change",
    "require-revert-in-loop",
    "return-bomb",
    "reused-contract-name",
    "rtlo",
    "selfdestruct",
    "signed-integer-storage-array",
    "solmate-safe-transfer-lib",
    "state-change-without-event",
    "state-no-address-check",
    "state-variable-could-be-constant",
    "state-variable-could-be-immutable",
    "state-variable-init-order",
    "state-variable-read-external",
    "state-variable-shadowing",
    "storage-array-length-not-cached",
    "storage-array-memory-edit",
    "strict-equality-contract-balance",
    "tautological-compare",
    "tautology-or-contradiction",
    "todo",
    "tx-origin-used-for-auth",
    "unchecked-low-level-call",
    "unchecked-return",
    "unchecked-send",
    "uninitialized-local-variable",
    "unprotected-initializer",
    "unsafe-casting",
    "unsafe-erc20-operation",
    "unsafe-oz-erc721-mint",
    "unspecific-solidity-pragma",
    "unused-error",
    "unused-import",
    "unused-public-function",
    "unused-state-variable",
    "void-constructor",
    "weak-randomness",
    "yul-return",
}


# Aderyn has no error taxonomy: every failure path prints a message to stderr and
# calls process::exit(1), so the exit code carries no information. The patterns below
# map those messages to a readable cause and to SmartBugs' distinction between
# 'errors' (the tool detected and handled the situation) and 'fails' (it crashed).
# (regex, category, template): first match wins, so crashes are checked first
DIAGNOSES: tuple[tuple[re.Pattern[str], str, str], ...] = (
    # stack overflows abort the process directly, without running the panic hook
    (re.compile(r"^fatal runtime error: (.*)$", re.M), "fail", "aderyn crashed: {}"),
    # aderyn/src/panic.rs prints "Panic: <file>:<line>\n\t<message>"
    (re.compile(r"^Panic: ([^\n]+)\n\s+([^\n]+)", re.M), "fail", "aderyn crashed at {}: {}"),
    (re.compile(r"^Panic: (.+)$", re.M), "fail", "aderyn crashed: {}"),
    (re.compile(r"Fatal compiler bug"), "fail", "aderyn crashed (fatal compiler bug)"),
    (re.compile(r"thread '[^']*'[^\n]*panicked at:?\s*([^\n]*)"), "fail", "aderyn crashed: {}"),
    # compile.rs:115 -- solc's AST does not fit aderyn's Rust AST types (all of Solidity 0.4.x)
    (
        re.compile(r'Unable to serialize Source Unit from AST[\s\S]*?Error\("([^"]*)"'),
        "error",
        "unsupported AST: {}",
    ),
    # compile.rs:69 -- the contract itself does not compile
    (
        re.compile(r"^[^\s:]+\.sol:[0-9]+:[0-9]+: (\w*Error): (.*)$", re.M),
        "error",
        "solc compilation error ({}): {}",
    ),
    (re.compile(r"^Compilation Error: (.*)$", re.M), "error", "solc compilation error: {}"),
    # compile.rs:51 -- solc could not be driven at all
    (
        re.compile(r"Failed to Derive AST & EVM Info: unrecognised option '--allow-paths'"),
        "error",
        "solc too old for aderyn (does not support --allow-paths)",
    ),
    (
        re.compile(r"Failed to Derive AST & EVM Info: missing field `ast`"),
        "error",
        "solc produced no AST",
    ),
    # Aderyn resolves the pragma itself and fetches its own compiler via svm. When its
    # resolution disagrees with the version SmartBugs injected, it tries to download the
    # missing one which fails, because analysis containers run with network=none.
    # Seen on malformed pragmas ("pragma solidity 0.4 .24;").
    (
        re.compile(r"Failed to Derive AST & EVM Info: error sending request for url"),
        "error",
        "aderyn requested a solc version other than the injected one (container is offline)",
    ),
    (re.compile(r"Failed to Derive AST & EVM Info: (.*)"), "error", "could not derive AST: {}"),
    # compile.rs:135
    (
        re.compile(r"Error loading AST into WorkspaceContext"),
        "error",
        "AST could not be loaded into workspace context",
    ),
    # process.rs:151
    (re.compile(r"^(.*) does not exist!$", re.M), "fail", "aderyn could not find the source: {}"),
    # display.rs:31 -- ran fine, but the include filter matched nothing
    (
        re.compile(r"No files found for context \[solc : v([0-9.]+)\]"),
        "info",
        "no contract matched the include filter (solc {})",
    ),
)


def diagnose(log: list[str]) -> Optional[tuple[str, str]]:
    """Turn aderyn's stderr into (category, message), or None if nothing matched."""
    text = "\n".join(sb.parse_utils.discard_ansi(log))
    for pattern, category, template in DIAGNOSES:
        m = pattern.search(text)
        if not m:
            continue
        # keep the arity: a pattern's groups map 1:1 onto the template's placeholders
        message = template.format(*[(g or "").strip() for g in m.groups()])
        return category, sb.parse_utils.truncate_message(message, 160)
    return None


def parse(
    exit_code: Optional[int], log: list[str], output: Optional[bytes]
) -> tuple[list[dict], set[str], set[str], set[str]]:
    findings: list[dict] = []
    infos: set[str] = set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    try:
        with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
            report_json = tar.extractfile("output.json").read()
            report = json.loads(report_json)
    except Exception as e:
        # Aderyn writes no report when it errors out, so SmartBugs collects an empty
        # file. Prefer the reason aderyn printed; the tar message only describes the
        # symptom and would classify handled errors as crashes.
        diagnosis = diagnose(log)
        if diagnosis:
            category, message = diagnosis
            {"error": errors, "fail": fails, "info": infos}[category].add(message)
        else:
            fails.add(f"error parsing results: {e}")
        report = {}

    # Aderyn groups issues by severity; each issue has a detector_name and
    # one or more source instances (contract_path + line_no).
    for severity, key in (("High", "high_issues"), ("Low", "low_issues")):
        block = report.get(key) or {}
        for issue in block.get("issues", []):
            name = issue.get("detector_name", "")
            title = issue.get("title", "")
            instances = issue.get("instances", [])
            if not instances:
                findings.append({"name": name, "severity": severity, "message": title})
                continue
            for inst in instances:
                finding = {"name": name, "severity": severity, "message": title}
                if inst.get("contract_path"):
                    finding["filename"] = inst["contract_path"]
                if inst.get("line_no") is not None:
                    finding["line"] = inst["line_no"]
                findings.append(finding)

    return findings, infos, errors, fails
