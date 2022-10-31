import csv
from re import T
from traceback import print_tb

# Final file
final_file = open('./prioritization/notebooks/final_3_tools.csv', 'w')
final_writer = csv.writer(final_file)

# Results file
results_file = open('./prioritization/parsers/data/result_3_tools.csv', 'r')
results_reader = csv.reader(results_file)

# Vulnerabilities file
vulnerabilities_file = open('./prioritization/parsers/data/vulnerabilities_all_until_manual_huang.csv', 'r')
vulnerabilities_reader = csv.reader(vulnerabilities_file)

# Join the two CSV
# Make a list of the rows of found vulnerabilites
found_vulnerabilites = [0]

def isTruePositive(bugRow):
  bugId = bugRow[0]
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
        for i in range (int(line_range[0]), int(line_range[1])+1):
          lines.append(i)
      # If it is a single line
      else:
        lines.append(line_p)

    if (bug[0] == vul[0] and int(bug[1]) in lines and bug[2] == vul[2]):
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
    bugTruth = isTruePositive(result_row)
    
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
    split = vulnerability_row[1].split("-")
    if len(split) == 2:
      bug = [bugID(vulnerability_row[0], split[0])]
    else:
      bug = [bugID(vulnerability_row[0], vulnerability_row[1])]

    for i in range(1, len(headers)-1):
      bug.append("0")
    
    # Add the final value of true
    bug.append("True")

    final_writer.writerow(bug)

  row_counter += 1

