import os
import sb.config, sb.io, sb.tools


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

    v = rule_severity(info_finding)
    if v: rule_dict["properties"] = { "security-severity": v }

    return rule_dict


def result_info(tool_id, finding):
    result_dict = {
        "ruleId": rule_id(tool_id, finding["name"]),
        "locations": [ { 
            "physicalLocation": {
                "artifactLocation": {
                    "uri": finding["filename"]
    } } } ] }

    v = result_message(finding)
    if v: result_dict["message"] = { "text": v }

    v = result_level(finding)
    if v: result_dict["level"] = v

    v = result_region(finding)
    if v: result_dict["locations"][0]["physicalLocation"]["region"] = v

    return result_dict


def str2label(s):
    """Convert string to label.

    - leading non-letters are removed
    - trailing characters that are neither letters nor digits ("other chars") are removed
    - sequences of other chars within the string are replaced by a single underscore
    """
    l = ""
    separator = False
    has_started = False
    for c in s:
        if c.isalpha() or (has_started and c.isdigit()):
            has_started = True
            if separator:
                separator = False
                l += "_"
            l += c
        else:
            separator = has_started
    return l

def rule_id(tool_id, fname):
    return f"{str2label(tool_id)}_{str2label(fname)}"

def rule_shortDescription(info_finding):
    pass

def rule_fullDescription(info_finding):
    pass

def rule_help(info_finding):
    pass

def rule_severity(info_finding):
    pass

def result_message(finding):
    pass

def result_level(finding):
    pass

def result_region(finding):
    pass
