import sb.tools, sb.utils

def sarify(tool, findings):
    return {
        "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
        "version": "2.1.0",
        "runs": [ run_info(tool, findings) ]
    }


def run_info(tool, findings):
    fnames = { finding["name"] for finding in findings }
    return {
        "tool":    tool_info(tool, fnames),
        "results": [ result_info(tool["id"],finding) for finding in findings ]
    }


def tool_info(tool, fnames):
    driver = {
        "name":  tool.get("name", tool["id"]), # tool["id"] always exists
        "rules": [ rule_info(tool["id"], fname) for fname in fnames ]
    }

    v = tool.get("version")
    if v: driver["version"] = v

    v = tool.get("origin")
    if v: driver["informationUri"] = v

    return { "driver": driver }


def rule_info(tool_id, fname):
    info_finding = sb.tools.info_finding(tool_id, fname)

    rule_dict = {
        "name": fname,
        "id": rule_id(tool_id, fname)
    }

    v = rule_shortDescription(info_finding)
    if v: rule_dict["shortDescription"] = { "text": v }

    v = rule_fullDescription(info_finding)
    if v: rule_dict["fullDescription"] = { "text": v }

    v = rule_help(info_finding)
    if v: rule_dict["help"] = { "text": v }

    v = rule_security_severity(info_finding)
    if v: rule_dict["properties"] = { "security-severity": v }

    v = rule_problem_severity(info_finding)
    if v: rule_dict["properties"] = { "problem": { "severity": v }}

    return rule_dict


def result_info(tool_id, finding):
    fname = finding["name"]
    info_finding = sb.tools.info_finding(tool_id, fname)

    result_dict = {
        "ruleId": rule_id(tool_id, fname),
        "locations": [ { 
            "physicalLocation": {
                "artifactLocation": {
                    "uri": finding["filename"]
    } } } ] }

    v = result_message(finding, info_finding)
    if v: result_dict["message"] = { "text": v }

    v = result_level(finding)
    if v: result_dict["level"] = v

    v = result_region(finding)
    if v: result_dict["locations"][0]["physicalLocation"]["region"] = v

    v = result_location_message(finding)
    if v: result_dict["locations"][0]["message"] = { "text": v }

    return result_dict


def rule_id(tool_id, fname):
    return f"{sb.utils.str2label(tool_id)}_{sb.utils.str2label(fname)}"


def rule_shortDescription(info_finding):
    return info_finding.get("descr_short")


def rule_fullDescription(info_finding):
    descr_short = info_finding.get("descr_short")
    descr_long = info_finding.get("descr_long")
    classification = info_finding.get("classification")
    method = info_finding.get("method")
    description = []
    if descr_short: description.append(descr_short)
    if descr_long: description.append(descr_long)
    if classification: description.append(f"Classification: {classification}.")
    if method: description.append(f"Detection method: {method}")
    return " ".join(description)


def rule_help(info_finding):
    descr_short = info_finding.get("descr_short")
    descr_long = info_finding.get("descr_long")
    return (descr_long if descr_long else
            descr_short if descr_short else
            "")


def rule_problem_severity(info_finding):
    return info_finding.get("level", "").strip().lower()


def rule_security_severity(info_finding):
    severity = info_finding.get("severity", "").strip().lower()
    try:
        return float(severity)
    except:
        return ("2.0" if severity == "low" else
                "5.5" if severity == "medium" else
                "8.0" if severity == "high" else
                "")


def result_message(finding, info_finding):
    message = (
        finding.get("message")
        or info_finding.get("descr_short")
        or finding["name"])
    severity = finding.get("severity")
    return (f"{message}\nSeverity: {severity}" if message and severity else
            message if message else
            f"Severity: {severity}" if severity else
            "")


def result_level(finding):
    level = finding.get("level","").strip().lower()
    return level if level in ("none", "note", "warning", "error") else None


def result_location_message(finding):
    contract = finding.get("contract")
    function = finding.get("function")
    return (f"contract {contract}, function {function}" if contract and function else
            f"contract {contract}" if contract else
            f"function {function}" if function else
            "")


def result_region(finding):
    region_dict = {}

    # source code
    for f,r in (("line","startLine"), ("column","startColumn"), ("line_end","endLine"), ("column_end","endColumn")):
        if f in finding:
            region_dict[r] = int(finding[f])

    if region_dict:
        return region_dict
    
    # hex code
    for a,l,c in (("address","startLine","startColumn"), ("address_end","endLine","endColumn")):
        if a in finding:
            region_dict[l] = 1
            region_dict[c] = 1 + 2*int(finding[a])
    return region_dict

