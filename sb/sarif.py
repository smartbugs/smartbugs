#from sb.exceptions import SmartBugsError
from functools import reduce
import collections.abc


def empty_sarif():
    return {
            "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
            "version": "2.1.0",
            "runs": [],
        }
    
    
def tool_info(info, parsed_result):
    tool = {}
    tool["driver"] = {}
    tool["driver"]["name"] = info["tool"]["id"]
    tool["driver"]["version"] = info["tool"]["version"]
    tool["driver"]["informationUri"] = info["tool"]["origin"]
    
    rule_dict = {}
    for issue in parsed_result["analysis"]["issues"]:
        rule_id = issue["title"].replace(" ", "_")
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


def issue_sarif(filename, issue):
    return { "ruleId": issue["title"].replace(" ", "_"),
             "message": { "text": issue["title"] },
             "locations": [
                            {
                                "physicalLocation" : {
                                    "artifactLocation" : {
                                        "uri" : filename
                                    },
                                "region" : {
                                    "startLine" : issue["lineno"],
                                    "startColumn" : 1,
                                    "endLine" : issue["lineno"],
                                    "endColumn" : 1,
                                        }
                                }
                            }
                    ]
            }


def tool_results(info, parsed_result):
    results = []
    
    for issue in parsed_result["analysis"]["issues"]:
        results.append(issue_sarif(info["contract"]["filename"], issue))
    
    return results
    

def create_sarif(info, parsed_result):
    
    result = empty_sarif()
    
    # Tool info
    runs_dict = { "tool" : tool_info(info, parsed_result)}
    
    # Results info
    results_dict = { "results" : tool_results(info, parsed_result)}
    
    # Merge dictionaries
    runs_dict.update(results_dict)
    
    # Add result to "runs"
    result["runs"].append(runs_dict)
    
    return dict(result)