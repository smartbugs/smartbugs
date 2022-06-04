import json
import csv
import numpy as np
from lib2to3.pgen2 import driver

def bugID(file, line):
    return str(file) + ":" + str(line)

# Parse file
with open('./prioritization/parsers/data/results_solidifi.sarif') as json_file:
    sarif = json.load(json_file)

# Results file
csv_file = open('./prioritization/parsers/data/result_solidifi.csv', 'w')
csv_writer = csv.writer(csv_file)

headers = ["bug_id"]

# Headers
for run in sarif["runs"]:
    headers.append(str(run["tool"]["driver"]["name"]) + "_rule_id")
    headers.append(str(run["tool"]["driver"]["name"]) + "_level")

csv_writer.writerow(headers)

# Calculate Data
data = {}
tool_id = 0
bug_id = ""
for run in sarif["runs"]:
    for res in run["results"]:
        for location in res["locations"]:
            try:
                bug_id = bugID(location["physicalLocation"]["artifactLocation"]["uri"], location["physicalLocation"]["region"]["startLine"])

                # If is first time seeing this error
                if (bug_id in data):
                    old_bug = data[bug_id]
                    old_bug[tool_id*2+1] = res["ruleId"]
                    old_bug[tool_id*2+2] = res["level"]
                    data[bug_id] = old_bug
                    #print(old_bug)
                    #print()
                else:
                    new_bug = [0] * len(headers)
                    new_bug[0] = bug_id
                    new_bug[tool_id*2+1] = res["ruleId"]
                    new_bug[tool_id*2+2] = res["level"]
                    data[bug_id] = new_bug
                    #print(new_bug)
                    #print()
            except:
                som = 0


    tool_id += 1

# Write Data
for d in data:
    #print(data[d])
    #print("\n")
    csv_writer.writerow(data[d])

csv_file.close()