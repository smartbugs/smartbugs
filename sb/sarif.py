#from sb.exceptions import SmartBugsError
from functools import reduce
import collections.abc


def empty_sarif():
    return {
            "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
            "version": "2.1.0",
            "runs": [],
        }
    
    
def tool_info(info, issues):
    info_tool = info["tool"]
    tool = {
        "driver": {
            "name":           info_tool["name"]    if info_tool.get("name")    else info_tool["id"],
            "version":        info_tool["version"] if info_tool.get("version") else "unavailable",
            "informationUri": info_tool["origin"]  if info_tool.get("origin")  else "unavailable" }
    }
    
    rule_dict = {}
    for issue in issues:
        rule_id = issue.get("id")
        rule_dict[rule_id] = {
            "id" : rule_id,
            "name" : issue["title"].replace(" ", "").replace("-",""),
            "help" : {
                "text" : issue["description"]
            }
        }
        
    
    tool_rules = []
    for rule in rule_dict:
        tool_rules.append(rule_dict[rule])
        
    tool["driver"]["rules"] = tool_rules
    
    return tool


def issue_sarif(issue):
    return {
        "ruleId": issue.get("id"),
        "message": {
            "text": issue.get("title") },
        "locations": [
            {   "physicalLocation": {
                    "artifactLocation": {
                        "uri": issue.get("filename") },
                    "region": {
                        "startLine":   issue.get("lineno",1),
                        "startColumn": issue.get("column",1),
                        "endLine":     issue.get("lineno_end", issue.get("lineno",1)),
                        "endColumn":   issue.get("column_end", issue.get("column",1)) } }
            }
        ]
    }



def tool_results(issues):
    return [ issue_sarif(issue) for issue in issues ]
    

def create_sarif(info, parsed_result):
    issues = parsed_result("findings")
    
    result = empty_sarif()
    
    # Tool info
    runs_dict = { "tool" : tool_info(info, issues) }
    
    # Results info
    results_dict = { "results" : tool_results(issues) }
    
    # Merge dictionaries
    runs_dict.update(results_dict)
    
    # Add result to "runs"
    result["runs"].append(runs_dict)
    
    return dict(result)
