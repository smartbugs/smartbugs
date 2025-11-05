from typing import Any, Optional, Union

import sb.tools
import sb.utils


def sarify(tool: dict[str, Any], findings: list[dict[str, Any]]) -> dict[str, Any]:
    return {
        "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
        "version": "2.1.0",
        "runs": [run_info(tool, findings)],
    }


def run_info(tool: dict[str, Any], findings: list[dict[str, Any]]) -> dict[str, Any]:
    fnames = {finding["name"] for finding in findings}
    return {
        "tool": tool_info(tool, fnames),
        "results": [result_info(tool["id"], finding) for finding in findings],
    }


def tool_info(tool: dict[str, Any], fnames: set[str]) -> dict[str, Any]:
    driver = {
        "name": tool.get("name", tool["id"]),  # tool["id"] always exists
        "rules": [rule_info(tool["id"], fname) for fname in fnames],
    }

    v = tool.get("version")
    if v:
        driver["version"] = v

    v = tool.get("origin")
    if v:
        driver["informationUri"] = v

    return {"driver": driver}


def rule_info(tool_id: str, fname: str) -> dict[str, Any]:
    info_finding = sb.tools.info_finding(tool_id, fname)

    rule_dict: dict[str, Any] = {"name": fname, "id": rule_id(tool_id, fname)}

    short_desc = rule_short_description(info_finding)
    if short_desc:
        rule_dict["shortDescription"] = {"text": short_desc}

    full_desc = rule_full_description(info_finding)
    if full_desc:
        rule_dict["fullDescription"] = {"text": full_desc}

    help_text = rule_help(info_finding)
    if help_text:
        rule_dict["help"] = {"text": help_text}

    sec_sev = rule_security_severity(info_finding)
    if sec_sev:
        rule_dict["properties"] = {"security-severity": sec_sev}

    prob_sev = rule_problem_severity(info_finding)
    if prob_sev:
        rule_dict["properties"] = {"problem": {"severity": prob_sev}}

    return rule_dict


def result_info(tool_id: str, finding: dict[str, Any]) -> dict[str, Any]:
    fname = finding["name"]
    info_finding = sb.tools.info_finding(tool_id, fname)

    result_dict: dict[str, Any] = {
        "ruleId": rule_id(tool_id, fname),
        "locations": [{"physicalLocation": {"artifactLocation": {"uri": finding["filename"]}}}],
    }

    msg = result_message(finding, info_finding)
    if msg:
        result_dict["message"] = {"text": msg}

    level = result_level(finding)
    if level:
        result_dict["level"] = level

    region = result_region(finding)
    if region is not None:
        result_dict["locations"][0]["physicalLocation"]["region"] = region

    loc_msg = result_location_message(finding)
    if loc_msg:
        result_dict["locations"][0]["message"] = {"text": loc_msg}

    return result_dict


def rule_id(tool_id: str, fname: str) -> str:
    return f"{sb.utils.str2label(tool_id)}_{sb.utils.str2label(fname)}"


def rule_short_description(info_finding: dict[str, Any]) -> Optional[str]:
    return info_finding.get("descr_short")


def rule_full_description(info_finding: dict[str, Any]) -> str:
    descr_short = info_finding.get("descr_short")
    descr_long = info_finding.get("descr_long")
    classification = info_finding.get("classification")
    method = info_finding.get("method")
    description = []
    if descr_short:
        description.append(descr_short)
    if descr_long:
        description.append(descr_long)
    if classification:
        description.append(f"Classification: {classification}.")
    if method:
        description.append(f"Detection method: {method}")
    return " ".join(description)


def rule_help(info_finding: dict[str, Any]) -> str:
    descr_short = info_finding.get("descr_short")
    descr_long = info_finding.get("descr_long")
    return descr_long if descr_long else descr_short if descr_short else ""


def rule_problem_severity(info_finding: dict[str, Any]) -> str:
    return info_finding.get("level", "").strip().lower()


def rule_security_severity(info_finding: dict[str, Any]) -> Union[float, str]:
    severity = info_finding.get("severity", "").strip().lower()
    try:
        return float(severity)
    except Exception:
        return (
            "2.0"
            if severity == "low"
            else "5.5" if severity == "medium" else "8.0" if severity == "high" else ""
        )


def result_message(finding: dict[str, Any], info_finding: dict[str, Any]) -> str:
    message = finding.get("message") or info_finding.get("descr_short") or finding["name"]
    severity = finding.get("severity")
    return (
        f"{message}\nSeverity: {severity}"
        if message and severity
        else message if message else f"Severity: {severity}" if severity else ""
    )


def result_level(finding: dict[str, Any]) -> Optional[str]:
    level = finding.get("level", "").strip().lower()
    return level if level in ("none", "note", "warning", "error") else None


def result_location_message(finding: dict[str, Any]) -> str:
    contract = finding.get("contract")
    function = finding.get("function")
    return (
        f"contract {contract}, function {function}"
        if contract and function
        else f"contract {contract}" if contract else f"function {function}" if function else ""
    )


def result_region(finding: dict[str, Any]) -> Optional[dict[str, int]]:
    region_dict: dict[str, int] = {}

    # source code
    for f, r in (
        ("line", "startLine"),
        ("column", "startColumn"),
        ("line_end", "endLine"),
        ("column_end", "endColumn"),
    ):
        if f in finding:
            region_dict[r] = int(finding[f])

    if region_dict:
        return region_dict

    # hex code
    for addr, line_key, col_key in (
        ("address", "startLine", "startColumn"),
        ("address_end", "endLine", "endColumn"),
    ):
        if addr in finding:
            region_dict[line_key] = 1
            region_dict[col_key] = 1 + 2 * int(finding[addr])
    return region_dict if region_dict else None
