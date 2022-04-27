import csv
from re import T
from traceback import print_tb

# Make mapping a dictionary of dictionaries, where first key is tool, second is vulnerability name and last item is category
mapping = {}
categories = []

# Final file
final_file = open('./results/final.csv', 'w')
final_writer = csv.writer(final_file)

# Results file
results_file = open('./data/result1.csv', 'r')
results_reader = csv.reader(results_file)

# Vulnerabilities file
vulnerabilities_file = open('./data/vulnerabilities.csv', 'r')
vulnerabilities_reader = csv.reader(vulnerabilities_file)

# Vulnerabilities Mapping file
mapping_file = open('./vulnerabilities_mapping.csv', 'r')
mapping_reader = csv.reader(mapping_file)

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


# Join the two CSV
# Make a list of the rows of found vulnerabilites
found_vulnerabilites = [0]

def isTruePositive(bugId):
  bug = bugId.split(":")

  # Return to begging of file
  vulnerabilities_file.seek(0)

  # Check vulnerabilities file
  row_counter = 0
  for vul in vulnerabilities_reader:
    # Ignore headers
    if (row_counter == 0):
      row_counter += 1
      continue

    # Process vul[1] for the case it accpets more than one line
    lines = []
    line_parts = vul[1].split("/")
    for line_p in line_parts:
      line_range = line_p.split("-")
      # If its a line range
      if len(line_range) == 2:
        for i in range (line_range[0], line_range[1]+1):
          lines.append(i)
      
      # If it is a single line
      else:
        lines.append(line_p)

    if (bug[0] == vul[0] and bug[1] in lines):
      return row_counter
  
    row_counter += 1

  return 0


# Process true and false positives
first_row = True
headers = []
for result_row in results_reader:
  # Prepare headers
  if first_row:
    headers = result_row
    headers.append("Value")
    final_writer.writerow(headers)
    first_row = False
  else:
    #print(result_row[0])
    bugTruth = isTruePositive(result_row[0])
    
    # If is true positive
    if (bugTruth != 0):
      final_report = result_row
      final_report.append("True")
      final_writer.writerow(final_report)
      found_vulnerabilites.append(bugTruth)

    # If it is false positive
    else:
      final_report = result_row
      final_report.append("False")
      final_writer.writerow(final_report)
  

# Process true and false negatives
row_counter = 0

# Return to begging of file
vulnerabilities_file.seek(0)

def bugID(file, line):
  return str(file) + ":" + str(line)

for vulnerability_row in vulnerabilities_reader:
  # If vulnerability has not been accounted for
  if (row_counter not in found_vulnerabilites):
    
    # Put a row for a true bug that no tool has found
    bug = [bugID(vulnerability_row[0], vulnerability_row[1])]

    for i in range(1, len(headers)-1):
      bug.append("0")
    
    # Add the final value of true
    bug.append("True")

    final_writer.writerow(bug)

  row_counter += 1

