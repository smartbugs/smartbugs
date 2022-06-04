import csv
import os
import string

# IMPORTANT: run from main folder
initial_directory = "dataset"
master_csv = open("./prioritization/parsers/data/vulnerabilities_solidifi.csv", 'w')
master_csv_writter = csv.writer(master_csv)

headers = ["Contract", "Lines", "Categories"]
master_csv_writter.writerow(headers)

def makeCSV(filename):
  # Contract file
  contract_file = open(filename, 'r')

  # Results file
  contract_path = filename.split(".sol")
  csv_file = open(contract_path[0] + ".csv", 'w')
  csv_writer = csv.writer(csv_file)

  # Headers
  csv_writer.writerow(headers)

  line_counter = 1

  for line in contract_file:
    bug = []
    category = line.split("// <yes> <report> ")
    if len(category) == 2:
      category_string = category[1].replace("\n", "")
      # TODO: Try different line acceptances
      bug = [filename, line_counter+1, '/'.join([category_string])]
      csv_writer.writerow(bug)
      master_csv_writter.writerow(bug)
    line_counter += 1

  contract_file.close()
  csv_file.close()

def solifiCSV(filename, folder):
  # Open file
  file = open(filename)
  split = filename.split("/BugLog")
  split_1 = filename.split(".csv")
  split_2 = split_1[0].split("Log")
  filename = split[0] + "/buggy" + split_2[1] + ".sol"
  csv_reader = csv.reader(file)

  header = True

  for row in csv_reader:
    # Ignore headers
    if header == True:
      header = False
      continue
    
    first_line = row[0]
    last_line = int(row[0]) + int(row[1])
    line = str(first_line) + "-" + str(last_line)
    category = "UNKOWN"
    # Map SolidiFi vulnerabilities to Smartbugs Vulnerabilities
    if (folder == "Overflow-Underflow"):
      category = "arithmetic"
    elif (folder == "Re-entrancy"):
      category = "reentrancy"
    elif (folder == "Timestamp-Dependency"):
      category = "time_manipulation"
    elif (folder == "TOD"):
      category = "front_running"
    elif (folder == "tx.origin"):
      category = "access_control"
    elif (folder == "Unchecked-Send"):
      category = "unchecked_low_level_calls"
    elif (folder == "Unhandled-Exceptions"):
      category = "unchecked_low_level_calls"
    else:
      print(row)

    bug = [filename, line, category]
    master_csv_writter.writerow(bug)
    


# Search all datasets
for filename1 in os.listdir(initial_directory):
  second_dir = os.path.join(initial_directory, filename1)
  # For each dataset
  if os.path.isdir(second_dir):
    # SolidiFi has a different folder structure
    if filename1 == "solidiFI":
      third_dir = os.path.join(second_dir, "buggy_contracts")
      for solidifi_category in os.listdir(third_dir):
        forth_dir = os.path.join(third_dir, solidifi_category)
        for solidifi_file in os.listdir(forth_dir):
          solidifi_file_path = os.path.join(forth_dir, solidifi_file)
          if os.path.isfile(solidifi_file_path) and '.csv' in solidifi_file_path:
            solifiCSV(solidifi_file_path, solidifi_category)

    # For other datasets
    else:
      for filename2 in os.listdir(second_dir):
        file = os.path.join(second_dir, filename2)
        # If file is a .sol contract
        if os.path.isfile(file) and '.sol' in file:
          makeCSV(file)

