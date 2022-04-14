import csv
import sys
import os

initial_directory = "./dataset"
master_csv = open("./dataset/vulnerabilities.csv", 'w')
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
      bug = [filename, line_counter+1, '/'.join([category_string])]
      csv_writer.writerow(bug)
      master_csv_writter.writerow(bug)
    line_counter += 1

  contract_file.close()
  csv_file.close()

# Search all datasets
for filename1 in os.listdir(initial_directory):
  second_dir = os.path.join(initial_directory, filename1)
  # For each dataset
  if os.path.isdir(second_dir):
    # SolidiFi has a different folder structure
    if filename1 == "solidiFI":
      print ("solifiFi TODO")
    # For other datasets
    else:
      for filename2 in os.listdir(second_dir):
        file = os.path.join(second_dir, filename2)
        # If file is a .sol contract
        if os.path.isfile(file) and '.sol' in file:
          makeCSV(file)

