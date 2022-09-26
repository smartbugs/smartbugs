import json
import csv
import sys
import numpy as np
from lib2to3.pgen2 import driver

# Vulnerabilities Mapping file
mapping_file = open('./prioritization/parsers/vulnerabilities_mapping.csv', 'r')
mapping_reader = csv.reader(mapping_file)

tools = ["SmartCheck", "Oyente", "Maian", "Conkas", "Manticore", "HoneyBadger", "Mythril", "Osiris", "Solhint", "Securify", "Slither"]

# Make mapping a dictionary of dictionaries, where first key is tool, second is vulnerability name and last item is category
mapping = {}
categories = []

def getCategoryIndex(row):
  counter = 0
  for column in row:
    if (column == "TRUE"):
      return counter - 2
    counter += 1


# Set up mapping
first_row = True
row_counter = 0
for row in mapping_reader:
  # Prepare headers
  if (first_row):
    counter = 0
    for header in row:
      # Ignore first two headers
      if counter >= 2:
        categories.append(header)
      counter += 1
    first_row = False
    
  else:
    index = getCategoryIndex(row)
    if (row[0] in mapping):
      mapping[row[0]][row[1]] = categories[index]
    # If tool is not yet on mapping
    else:
      mapping[row[0]] = {row[1]:categories[index]}


def getCategory(toolId, ruleId):
  # Special case
  temp_rule = ruleId[0:55]
  if (temp_rule == "Potentially reading uninitialized memory at instruction"):
    return "Other"

  tool = tools[toolId].lower()
  category = mapping[tool][ruleId]
  return category


def bugID(file, line, category):
  return str(file) + ":" + str(line) + ":" + str(category)

# Parse file
with open('./prioritization/parsers/data/results_all.sarif') as json_file:
  sarif = json.load(json_file)

# Results file
csv_file = open('./prioritization/parsers/data/result_all.csv', 'w')
csv_writer = csv.writer(csv_file)

headers = ["bug_id"]

# Headers
for run in sarif["runs"]:
  headers.append(str(run["tool"]["driver"]["name"]) + "_rule_id")
  headers.append(str(run["tool"]["driver"]["name"]) + "_level")

csv_writer.writerow(headers)

bug_count = [0,0,0,0,0,0,0,0,0,0,0]

missing_categories = []

# Calculate Data
data = {}
tool_id = 0
bug_id = ""
for run in sarif["runs"]:
    for res in run["results"]:
        for location in res["locations"]:
            try:
                category = getCategory(tool_id, res["message"]["text"])
                local_file = location["physicalLocation"]["artifactLocation"]["uri"]
                start_line = location["physicalLocation"]["region"]["startLine"]

                bug_id = bugID(local_file, start_line, category)
                bug_count[tool_id] += 1

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
              missing_cat = tools[tool_id] + " - " + res["message"]["text"]
              if (missing_cat not in missing_categories):
                missing_categories.append(missing_cat)
              #print(missing_cat)
              #print(res)
              #print("")
              som = 0


    tool_id += 1

# Write Data
for d in data:
    #print(data[d])
    #print("\n")
    csv_writer.writerow(data[d])

csv_file.close()

print(mapping)
print("----------")
for cat in missing_categories:
  print(cat)
#for count in bug_count:
#  print(count)