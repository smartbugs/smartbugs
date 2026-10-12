"""SmartBugs result parser for GPTScan.

Converts GPTScan's JSON report (utils.convert_output) into SmartBugs findings.
The finding ``name`` equals GPTScan's ``output.title`` (e.g. "MWE-200: ..."),
which is the key used in this tool's ``findings.yaml`` to attach the SWC/DASP
classification, severity and descriptions.

Reporting errors and fails
--------------------------
SmartBugs separates *errors* (a problem the tool noticed and handled) from
*fails* (an exception the tool did not catch, or an outside event that aborted
the run); see ``sb/parse_utils.py::errors_fails``. GPTScan makes that split
unusually hard, and getting it wrong has a nasty consequence --- contracts that
never compiled become indistinguishable from clean ones:

* GPTScan logs through ``rich``, which hard-wraps every record and right-aligns
  a ``source.py:LINE`` marker on its first line. ``errors_fails`` looks for a
  line *ending* in ``"Traceback (most recent call last):"`` followed by an
  unindented line --- neither holds for a ``rich``-rendered traceback, so it
  sees nothing.
* GPTScan catches a failed compilation, logs it, and carries on with a degraded
  pipeline: without a Falcon IR the static confirmation stage is skipped
  entirely. It then exits **0** and writes ``{"success": true, "results": []}``.

:func:`_log_records` undoes the wrapping so those messages can be read, and the
rendering itself supplies the errors/fails discriminator:

===========================  =================  ==========================
Traceback in the log         Reported as        Rationale
===========================  =================  ==========================
``rich``-rendered            ``error``          GPTScan's own logger emitted
(timestamp / source marker)                     it, so GPTScan caught it
raw on stderr                ``fail``           escaped the process; left to
                                                ``errors_fails`` upstream
===========================  =================  ==========================

Messages are passed through verbatim (only length-truncated). Nothing is
rewritten or suppressed --- including misleading ones such as the ``TypeError``
that is merely a knock-on effect of a failed compilation. Cause and effect are
labelled in ``infos`` instead, never by dropping a message.

Deliberately *not* an error: ``vul_before_static > vul_after_static``. That is
GPTScan's static confirmation stage discarding LLM candidates, i.e. its
intended false-positive filter, and it fires on many real-world
contracts. It is surfaced as an info so it cannot be mistaken for a defect.
"""

import io
import json
import os
import re
import tarfile
from typing import Optional

import sb.parse_utils

# Date of the last change to the parsing logic. SmartBugs writes the value
# into every result.json under parser.version, so a stale date hides which
# parser produced a file; bump it with every behavioural change.
VERSION = "2026/08/17"

# All finding names GPTScan can emit (the rule output titles). `findings`
# returned by parse() is a subset of this set.
FINDINGS = {
    "MWE-200: Insecure LP Token Value Calculation",
    "MWE-201: Insecure Vote Calculation",
    "MWE-202: Insecure Token Buying Behavior",
    "MWE-203: Approval Not Revoked",
    "MWE-204: Unsafe First Deposit",
    "MWE-205: Front Running",
    "MWE-206: No Slippage Limit Check",
    "MWE-207: Unauthorized Transfer",
    "MWE-208: Wrong Order for Checkpoint",
    "MWE-209: Wrong Order for Interest or ExchangeRate",
}

# --------------------------------------------------------------------------- #
# rich console log handling
# --------------------------------------------------------------------------- #

# ``rich`` right-aligns the emitting source location on a record's first line.
# Only the tail of a line is searched: an unanchored scan is quadratic, and a
# single log line can be very long.
_RICH_SRC = re.compile(r"\s+[\w.\-/]{1,80}\.(?:py|pyx):\d{1,7}\s*$")
_RICH_SRC_TAIL = 160
# ... prefixed by a timestamp, e.g. "[07:13:58] " or "[07/01/26 07:13:58] ".
_RICH_TS = re.compile(r"^\[[\d/:. ]+\]\s")

# Final line of a Python traceback: "pkg.mod.SomeError: message". The dotted
# prefix is atomic; without that, a record full of Solidity member chains sends
# the engine into exponential backtracking.
_FINAL_EXC = re.compile(
    r"(?>(?:[A-Za-z_]\w*\.)*)[A-Za-z_]\w*" r"(?:Error|Exception|Interrupt|Exit|Timeout|Failure):\s"
)

# GPTScan's own logger records, e.g. "ERROR    tasks: Static analysis failed".
_LOG_LEVEL = re.compile(r"^(ERROR|CRITICAL)\s+[\w.]+:")
# The static stage announces its own unavailability at WARNING level.
_FALCON_DEAD = "Falcon is not initialized"
# crytic-compile echoes solc's own diagnostics; this is the only place the
# actual reason a contract did not compile appears in full.
_COMPILE_REC = re.compile(r"CryticCompile: Compilation warnings/errors on ([^:]+):\s*(.*)$")
# rich table titles that bleed into the record that follows them
_TRAILING_NOISE = re.compile(r"\s+(?:Scan Results|Summary)\s*$")


def _log_records(log: list) -> list:
    """Reassemble ``rich``-wrapped console output into ``(text, rich)`` records.

    ``rich`` is True when the record carried a timestamp or a source marker,
    i.e. when GPTScan's logger produced it. Plain stderr output keeps
    ``rich=False`` and is left to :func:`sb.parse_utils.errors_fails`.

    Continuation lines are joined with a single space.

    Reflowing cannot be exact, and no heuristic fixes it: ``rich`` pads every
    rendered line to the block width, so a line that ends at that width may
    have been broken at a space (which was consumed) or in the middle of a
    token (which was not) --- both look identical afterwards. A space-join is
    therefore right for prose and occasionally inserts a space into a long
    unbroken token, e.g. ``crytic_compile/ platform/solc.py`` or
    ``SomeContract.so l``.

    The consequence is cosmetic and confined to long paths: exception classes,
    messages and the wording of GPTScan's own log records are prose and reflow
    correctly. Nothing is lost either way --- the affected text is still in
    ``result.log``, which this parser never modifies.
    """
    records: list = []
    parts: list = []
    is_rich = False
    for raw in log:
        line = raw.rstrip()
        if not line:
            continue
        tail = line[-_RICH_SRC_TAIL:]
        m = _RICH_SRC.search(tail)
        if m:
            line = line[: len(line) - len(tail) + m.start()]
        timestamped = bool(_RICH_TS.match(line))
        body = _RICH_TS.sub("", line).strip()
        if not body:
            continue
        starts_record = bool(m) or timestamped or not line.startswith(" ")
        if starts_record:
            if parts:
                records.append((" ".join(parts), is_rich))
            parts = []
            is_rich = bool(m) or timestamped
        parts.append(body)
    if parts:
        records.append((" ".join(parts), is_rich))
    return records


def _final_exception(record: str) -> Optional[str]:
    """The outermost ``Module.Error: message`` of a de-wrapped traceback.

    Chained tracebacks ("During handling of the above exception, another
    exception occurred") land in one record; the *last* match is the one that
    actually escaped --- the same choice ``sb.parse_utils.exceptions`` makes.
    """
    matches = list(_FINAL_EXC.finditer(record))
    if not matches:
        return None
    return _TRAILING_NOISE.sub("", record[matches[-1].start() :]).strip()


def _scan_log(log: list, errors: set, infos: set) -> bool:
    """Record every diagnostic GPTScan logged. Returns True if compilation failed.

    Everything collected here goes into ``errors``: GPTScan logged it and kept
    running, which is exactly SmartBugs' definition of an error as opposed to a
    fail.
    """
    compile_failed = False
    solc_diagnostics: list = []
    for text, rich in _log_records(log):
        if not rich:
            continue  # raw stderr output -- errors_fails() owns it

        exc = _final_exception(text)
        if exc and "Traceback (most recent call last)" in text:
            errors.add(sb.parse_utils.truncate_message(exc))
            if "InvalidCompilation" in exc or "Invalid compilation" in exc:
                compile_failed = True

        if _LOG_LEVEL.match(text):
            errors.add(sb.parse_utils.truncate_message(_TRAILING_NOISE.sub("", text)))

        if _FALCON_DEAD in text:
            errors.add(sb.parse_utils.truncate_message(_TRAILING_NOISE.sub("", text)))
            compile_failed = True

        # Collected regardless of severity wording, but only reported when the
        # compilation actually failed. The wording cannot decide that: with
        # ``--combined-json`` an old solc prints warnings onto stdout, which
        # corrupts the JSON and makes crytic-compile bail out -- so a contract
        # can die on a record whose only diagnostic reads "Warning: SPDX
        # license identifier not provided".
        m = _COMPILE_REC.search(text)
        if m:
            solc_diagnostics.append(
                f"solc rejected {os.path.basename(m.group(1))}:" f" {m.group(2)}"
            )

    if compile_failed:
        # As its own entry, not merely buried inside the truncated middle of
        # the FalconError message: this is the one line that says *why*.
        for diag in solc_diagnostics:
            errors.add(sb.parse_utils.truncate_message(diag))
        infos.add(
            "GPTScan analysis degraded: the contract did not compile, so the static"
            " confirmation stage never ran. Any 'no findings' result for this"
            " contract is inconclusive, not clean."
        )
    return compile_failed


def _read_output_json(output: Optional[bytes], fails: set) -> Optional[dict]:
    """Extract GPTScan's /output.json from the tar archive SmartBugs collected.

    Each way of failing is reported on its own instead of collapsing into a
    single "no output" message, so the reason stays visible in the CSV.
    """
    if not output:
        fails.add("no tar archive collected from the container")
        return None
    try:
        with tarfile.open(fileobj=io.BytesIO(output)) as tar:
            for m in tar.getmembers():
                if not m.isfile():
                    continue
                # the results file, not the .metadata.json sidecar
                if m.name.endswith("output.json") or m.name.rsplit("/", 1)[-1] == "output.json":
                    fh = tar.extractfile(m)
                    if fh is None:
                        continue
                    raw = fh.read().decode("utf-8", errors="replace")
                    try:
                        return json.loads(raw)
                    except ValueError as e:
                        fails.add(f"output.json is not valid JSON: {e}")
                        return None
    except tarfile.TarError as e:
        fails.add(f"tar archive from the container is unreadable: {e}")
        return None
    fails.add("tar archive contains no output.json")
    return None


def _meta(log: list) -> Optional[dict]:
    """The entrypoint's ``GPTSCAN_META {json}`` line, or None if never printed."""
    for line in log:
        if line.startswith("GPTSCAN_META "):
            try:
                return json.loads(line[len("GPTSCAN_META ") :].strip())
            except ValueError:
                return {}
    return None


def _meta_info(meta: dict) -> Optional[str]:
    """Condense the run metadata (backend, LLM calls, cost) into one info."""
    parts = []
    provider, model = meta.get("provider"), meta.get("model")
    if provider or model:
        parts.append(f"backend={provider}/{model}")
    if meta.get("llm_calls") is not None:
        parts.append(f"llm_calls={meta['llm_calls']}")
    if meta.get("estimated_cost") is not None:
        try:
            parts.append(f"est_cost_usd={float(meta['estimated_cost']):.4f}")
        except (TypeError, ValueError):
            pass
    return "GPTScan run: " + ", ".join(parts) if parts else None


def parse(exit_code: Optional[int], log: list, output: Optional[bytes]) -> tuple:
    """Turn one GPTScan task into SmartBugs' ``(findings, infos, errors, fails)``.

    Called by ``sb/parsing.py``, both during a run and on every ``sb.reparse``
    of an existing result directory. The argument types are SmartBugs' stable
    parser contract and must not be changed: *log* is a list of lines, *output*
    is the raw tar SmartBugs pulled out of the container (or None).

    Order matters. ``errors_fails`` runs first so an uncaught exception is
    classified before anything else looks at the log; :func:`_scan_log` then
    adds what GPTScan caught and logged itself; the report is read last, since
    a task can fail long before one exists.
    """
    findings: list = []
    infos: set = set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    _scan_log(log, errors, infos)

    meta = _meta(log)
    if meta is None:
        # The entrypoint prints GPTSCAN_META unconditionally once GPTScan
        # returns, so its absence means the container died mid-analysis. On a
        # non-zero exit that is already reported; on exit 0 it would otherwise
        # go unnoticed.
        if exit_code == 0:
            errors.add(
                "GPTSCAN_META missing although the container exited 0:"
                " GPTScan did not run to completion"
            )
    else:
        meta_info = _meta_info(meta)
        if meta_info:
            infos.add(meta_info)
        # Make the intended false-positive filter visible, so that a drop in
        # candidates is never mistaken for a defect.
        before, after = meta.get("vul_before_static"), meta.get("vul_after_static")
        if isinstance(before, int) and isinstance(after, int) and before != after:
            infos.add(
                f"static confirmation filtered LLM candidates:"
                f" {before} before, {after} after (intended behaviour)"
            )
        if meta.get("budget_exceeded"):
            errors.add("GPTScan stopped early: per-contract cost cap reached")
        if (meta.get("llm_calls_skipped_budget") or 0) > 0:
            errors.add(
                f"{meta['llm_calls_skipped_budget']} LLM calls skipped:"
                " per-contract cost cap reached"
            )

    result = _read_output_json(output, fails)
    if result is None:
        return findings, infos, errors, fails

    if result.get("message"):
        infos.add(str(result["message"]))
    # A report that declares itself unsuccessful must not read as a clean run.
    if result.get("success") is False:
        errors.add(f"GPTScan reported success=false: {result.get('message')}")

    # Timeout marker. Two routes lead here: the brake writes it into the
    # metadata GPTScan produces itself (GPTSCAN_META), the net gets stamped onto
    # /output.json by the entrypoint. Either way it belongs in *errors* --
    # SmartBugs' category for a problem the run noticed and handled -- and never
    # in *fails*, which is reserved for a tool that was knocked out.
    sb_timeout = result.get("sb_timeout") or (meta or {}).get("sb_timeout")
    if isinstance(sb_timeout, dict) and sb_timeout.get("hit"):
        stage = str(sb_timeout.get("stage", "unknown"))
        detail = sb_timeout.get("detail") or ""
        errors.add(
            f"TIMEOUT_{stage.upper()}: run cut short ({stage})"
            + (f" -- {detail}" if detail else "")
        )

    for r in result.get("results", []) or []:
        finding = {"name": r.get("title", "GPTScan finding")}
        if r.get("severity"):
            finding["severity"] = str(r["severity"]).lower()

        affected = r.get("affectedFiles") or []
        msg_parts = []
        if r.get("description"):
            msg_parts.append(str(r["description"]))
        if r.get("recommendation"):
            msg_parts.append("Recommendation: " + str(r["recommendation"]))

        if affected:
            first = affected[0]
            fn = first.get("filePath")
            if fn:
                finding["filename"] = os.path.basename(fn)
            rng = first.get("range", {}) or {}
            start = (rng.get("start", {}) or {}).get("line")
            end = (rng.get("end", {}) or {}).get("line")
            if isinstance(start, int):
                finding["line"] = start
            if isinstance(end, int):
                finding["line_end"] = end
            if len(affected) > 1:
                extra = []
                for af in affected[1:]:
                    r2 = af.get("range", {}) or {}
                    s2 = (r2.get("start", {}) or {}).get("line")
                    e2 = (r2.get("end", {}) or {}).get("line")
                    extra.append(f"{os.path.basename(af.get('filePath', '?'))}:{s2}-{e2}")
                msg_parts.append("Also affects: " + ", ".join(extra))

        if r.get("code"):
            msg_parts.append(f"GPTScan code: {r['code']}")
        if msg_parts:
            finding["message"] = "\n".join(msg_parts)

        findings.append(finding)

    return findings, infos, errors, fails
