import os
import json
import sys
import operator
import re
import csv
from datetime import timedelta

class colors:
    INFO = '\033[94m'
    OK = '\033[92m'
    FAIL = '\033[91m'
    END = '\033[0m'

tools = ['mythril-0.23.5','slither','osiris','oyente','smartcheck','manticore-0.3.7','maian','securify','honeybadger','solhint','conkas','ccc','confuzzius']
#tools = ['mythril-0.23.5','slither','osiris','oyente','smartcheck','manticore-0.3.7','maian','securify','honeybadger','solhint','conkas','ccc','confuzzius','ethainter','ethor','madmax','pakala','teether','vandal']

output_name = 'curated'

vulnerability_stat = {
}
tool_stat = {}
duration_stat = {}
total_duration = 0
count = {}
output = {}
contract_vulnerabilities = {}

oracle = {}

precisions = {}
contract_precisions = {}
count_vulnerabilities = {}

false_positives = {}
false_negatives = {}
expected_vunerability_lines = {}
detected_vunerability_lines = {}

ROOT = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))

with open(os.path.join(ROOT, 'dataset/vulnerabilities.json')) as fd:
    data = json.load(fd)
    for file in data:
        oracle[file['name'].replace('.sol', '')] = file

nb_tagged_vulnerabilities = 0
for contract in oracle:
    for vuln in oracle[contract]['vulnerabilities']:
        if 'denial_of_service' == vuln['category']:
            vuln['category'] = 'denial_service'
        elif 'unchecked_low_level_calls' == vuln['category']:
            vuln['category'] = 'unchecked_low_calls'
        elif 'other' == vuln['category']:
            vuln['category'] = 'Other'
        if vuln['category'] not in count_vulnerabilities:
            count_vulnerabilities[vuln['category']] = 0
        count_vulnerabilities[vuln['category']] += 1
        nb_tagged_vulnerabilities += 1

vulnerability_mapping = {}
with open(os.path.join(ROOT, 'dataset/vulnerabilities_mapping.csv')) as fd:
    header = fd.readline().strip().split(',')
    line = fd.readline()
    while line:
        v = line.strip().split(',')
        index = -1
        if 'TRUE' in v:
            index = v.index('TRUE')
        elif 'MAYBE' in v:
            index = v.index('MAYBE')
        if index > -1:
            vulnerability_mapping[v[1]] = header[index]
        line = fd.readline()
categories = sorted(list(set(vulnerability_mapping.values())))
categories.remove('Ignore')
categories.remove('Other')
categories.append('Other')

for category in categories:
    precisions[category] = {}

def add_vul(contract, tool, vulnerability, lines):
    original_vulnerability = vulnerability
    vulnerability = vulnerability.strip().lower().title().replace('_', ' ').replace('.', '').replace('Solidity ', '').replace('Potentially ', '')
    vulnerability = re.sub(r' At Instruction .*', '', vulnerability)

    if tool not in tool_stat:
        tool_stat[tool] = {}

    if tool not in contract_precisions:
        contract_precisions[tool] = []

    category = 'unknown'
    if original_vulnerability in vulnerability_mapping:
        category = vulnerability_mapping[original_vulnerability]
    else:
        print(colors.FAIL+"Error: Vulnerability is not part of vulnerability_mapping:", "'"+original_vulnerability+"'", "Tool:", tool, colors.END)
    if category == 'Ignore' or category == 'unknown':
        return

    if tool not in precisions[category]:
        precisions[category][tool] = []
    if category not in vulnerability_stat:
        vulnerability_stat[category] = 0
    if category not in tool_stat[tool]:
        tool_stat[tool][category] = 0

    if not tool in false_positives:
        false_positives[tool] = {}
    if not category in false_positives[tool]:
        false_positives[tool][category] = {}
    if not contract in false_positives[tool][category]:
        false_positives[tool][category][contract] = set()

    if not tool in false_negatives:
        false_negatives[tool] = {}
    if not category in false_negatives[tool]:
        false_negatives[tool][category] = {}
    if not contract in false_negatives[tool][category]:
        false_negatives[tool][category][contract] = set()

    if contract in oracle:
        expected = oracle[contract]
        expected_vunerability_categories = set([vuln['category'] for vuln in expected['vulnerabilities']])
        if lines is not None:
            for line in lines:
                vulnerability_found = None
                for vuln in expected['vulnerabilities']:
                    if line in vuln['lines'] and category == vuln['category']:
                        vuln = {
                            'contract': contract,
                            'category': vuln['category'],
                            'lines': vuln['lines']
                        }
                        vulnerability_found = vuln
                        break
                if vulnerability_found != None:
                    detected_vunerability_lines[tool][category][contract].add(line)
                    if vulnerability_found not in precisions[category][tool]:
                        precisions[category][tool].append(vulnerability_found)
                    if contract not in contract_precisions[tool]:
                        contract_precisions[tool].append(contract)
                else:
                    if category in expected_vunerability_categories:
                        false_positives[tool][category][contract].add(line)

    if contract not in contract_vulnerabilities:
        contract_vulnerabilities[contract] = []

    if category not in contract_vulnerabilities[contract]:
        contract_vulnerabilities[contract].append(category)

    tool_stat[tool][category] += 1
    if category not in output[contract]['tools'][tool]['categories']:
        output[contract]['tools'][tool]['categories'][category] = 0
        vulnerability_stat[category] += 1
    output[contract]['tools'][tool]['categories'][category] += 1

    if original_vulnerability not in output[contract]['tools'][tool]['vulnerabilities']:
        output[contract]['tools'][tool]['vulnerabilities'][original_vulnerability] = 0
    output[contract]['tools'][tool]['vulnerabilities'][original_vulnerability] += 1

def add_expected_vul(tool, category, contract):
    if not tool in detected_vunerability_lines:
        detected_vunerability_lines[tool] = {}
    if not category in detected_vunerability_lines[tool]:
        detected_vunerability_lines[tool][category] = {}
    if not contract in detected_vunerability_lines[tool][category]:
        detected_vunerability_lines[tool][category][contract] = set()

    if not tool in expected_vunerability_lines:
        expected_vunerability_lines[tool] = {}
    if not category in expected_vunerability_lines[tool]:
        expected_vunerability_lines[tool][category] = {}
    if not contract in expected_vunerability_lines[tool][category]:
        expected_vunerability_lines[tool][category][contract] = list()

    if contract in oracle:
        for vuln in oracle[contract]['vulnerabilities']:
            if vuln['category'] == category:
                expected_vunerability_lines[tool][category][contract].append(vuln['lines'])

for tool in tools:
    path_tool = os.path.abspath(os.path.join(ROOT, 'results', tool))
    path_tool_result = os.path.join(path_tool, output_name)

    if not os.path.exists(path_tool_result):
        continue
    for contract in os.listdir(path_tool_result):
        path_contract = os.path.join(path_tool_result, contract)
        path_result = os.path.join(path_contract, 'result.json')
        path_smartbugs = os.path.join(path_contract, 'smartbugs.json')

        if not os.path.isdir(path_contract):
            continue
        if not os.path.exists(path_result):
            print(colors.FAIL+"Error "+path_result+" does not exist!"+colors.END)
            continue
        if not os.path.exists(path_smartbugs):
            print(colors.FAIL+"Error "+path_smartbugs+" does not exist!"+colors.END)
            continue
        with open(path_result, 'r', encoding='utf-8') as fd:
            data = None
            try:
                data = json.load(fd)
            except Exception as a:
                continue
            if tool not in duration_stat:
                duration_stat[tool] = 0
            if tool not in count:
                count[tool] = 0
            count[tool] += 1

            smartbugs_data = None
            try:
                with open(path_smartbugs, 'r', encoding='utf-8') as fd2:
                    smartbugs_data = json.load(fd2)
            except Exception as a:
                continue

            duration_stat[tool] += smartbugs_data['result']['duration']
            total_duration += smartbugs_data['result']['duration']

            if contract not in output:
                output[contract] = {
                    'tools': {},
                    'lines': [],
                    'nb_vulnerabilities': 0
                }
            output[contract]['tools'][tool] = {
                'vulnerabilities': {},
                'categories': {}
            }

            vulnerabilities = set([vuln for vuln in vulnerability_mapping.values()])
            for vuln in vulnerabilities:
                add_expected_vul(tool, vuln, contract)

            """if tool == 'mythril':
                analysis = data['analysis']
                if analysis['issues'] is not None:
                    for result in analysis['issues']:
                        vulnerability = result['title'].strip()
                        add_vul(contract, tool, vulnerability, [result['lineno']])
            elif tool == 'oyente' or tool == 'osiris' or tool == 'honeybadger':
                for analysis in data['analysis']:
                    if analysis['errors'] is not None:
                        for result in analysis['errors']:
                            vulnerability = result['message'].strip()
                            add_vul(contract, tool, vulnerability, [result['line']])
            elif tool == 'manticore':
                for analysis in data['analysis']:
                    for result in analysis:
                        vulnerability = result['name'].strip()
                        add_vul(contract, tool, vulnerability, [result['line']])
            elif tool == 'maian':
                for vulnerability in data['analysis']:
                    if data['analysis'][vulnerability]:
                        add_vul(contract, tool, vulnerability, None)
            elif tool == 'securify':
                for f in data['analysis']:
                    analysis = data['analysis'][f]['results']
                    for vulnerability in analysis:
                        for line in analysis[vulnerability]['violations']:
                            add_vul(contract, tool, vulnerability, [line + 1])
            elif tool == 'slither':
                analysis = data['analysis']
                for result in analysis:
                    vulnerability = result['check'].strip()
                    line = None
                    if 'source_mapping' in result['elements'][0] and len(result['elements'][0]['source_mapping']['lines']) > 0:
                        line = result['elements'][0]['source_mapping']['lines']
                    add_vul(contract, tool, vulnerability, line)
            elif tool == 'smartcheck':
                analysis = data['analysis']
                for result in analysis:
                    vulnerability = result['name'].strip()
                    add_vul(contract, tool, vulnerability, [result['line']])
            elif tool == 'solhint':
                analysis = data['analysis']
                for result in analysis:
                    vulnerability = result['type'].strip()
                    add_vul(contract, tool, vulnerability, [int(result['line'])])"""
            if tool == 'ccc':
                for finding in data['findings']:
                    if 'name' in finding and 'line' in finding:
                        add_vul(contract, tool, finding['name'], list(set([int(finding['line']), int(finding['line_end'])])))
            elif tool in ['mythril-0.23.5','slither','osiris','oyente','smartcheck','manticore-0.3.7','maian','securify','honeybadger','solhint','conkas','confuzzius']:
                for finding in data['findings']:
                    if 'name' in finding and 'line' in finding:
                        add_vul(contract, tool, finding['name'], [int(finding['line'])])
            #else:
            #    print("Unknown tool:", tool)


with open(os.path.join(ROOT, 'dataset/results_curated.json'), 'w') as fd:
    json.dump(output, fd)
#### Generate table ####
print("# Execution Time Stat\n")

index_duration = 1
print("|  #  | Tool            | Avg. Execution Time | Total Execution Time |")
print("| --- | --------------- | ------------------- | -------------------- |")
for tool in sorted(duration_stat):
    value = str(timedelta(seconds=round(duration_stat[tool]/count[tool])))
    line = "| {:3} | {:15} | {:19} | {:20} |".format(index_duration, tool.title(), value, str(timedelta(seconds=round(duration_stat[tool]))))
    index_duration += 1
    print(line)

print("\nTotal: %s" % timedelta(seconds=(round(total_duration))))

print("\n# Accuracy\n")

total_precision = []
index_vulnerability = 1
line = '|  Category           |'
for tool in sorted(tools):
    line += ' {:^11} |'.format(tool.title().split("-")[0])
line += ' {:^11} |'.format('Total')
print(line)

line = "| ------------------- |"
for tool in tools:
    line += ' {:-<11} |'.format('-')
line += ' {:-<11} |'.format('')
print(line)

total_tools = {}
for category in categories:
    line = "| {:19} |".format(category.title().replace('_', ' '))
    total_detection_tool = 0
    total_category_precision = []
    for tool in sorted(tools):
        found = 0
        if tool not in total_tools:
            total_tools[tool] = 0
        if tool in precisions[category]:
            found = len(precisions[category][tool])
            for vuln in precisions[category][tool]:
                if vuln not in total_precision:
                    total_precision.append(vuln)
                if vuln not in total_category_precision:
                    total_category_precision.append(vuln)
        total_tools[tool] += found
        expected = count_vulnerabilities[category]
        total_identified = 0
        if tool in tool_stat and category in tool_stat[tool]:
            total_identified = tool_stat[tool][category]
        total_detection_tool += total_identified
        line += "  {:>5} {:3}% |".format("{:}/{:}".format(found, expected), round(found*100/expected))
    line += "  {:2}/{:2} {:3}% |".format(len(total_category_precision), count_vulnerabilities[category], round(len(total_category_precision)*100/count_vulnerabilities[category]))
    print(line)
    index_vulnerability += 1
line = "| {:19} |".format('Total')
for tool in sorted(tools):
    found = total_tools[tool]
    expected = nb_tagged_vulnerabilities
    line += " {:2}/{:2} {:3}% |".format(found, expected, round(found*100/expected))
line += " {:2}/{:2} {:3}% |".format(len(total_precision), nb_tagged_vulnerabilities, round(len(total_precision)*100/nb_tagged_vulnerabilities))
print(line)

print("\n# False Positives/False Negatives\n")
line = '| Category            |'
for tool in sorted(tools):
    line += ' {:^11} |'.format(tool.title().split("-")[0])
line += ' {:^11} |'.format('Total')
print(line)
line = "| ------------------- |"
for tool in tools:
    line += ' {:-<11} |'.format('-')
line += ' {:-<11} |'.format('')
print(line)
csv_fp_file = open("false_positives.csv", "w")
writer_fp = csv.writer(csv_fp_file)
writer_fp.writerow(["Tool","Category","Contract","Line Numbers"])
csv_fn_file = open("false_negatives.csv", "w")
writer_fn = csv.writer(csv_fn_file)
writer_fn.writerow(["Tool","Category","Contract","Line Numbers"])
total_tools = {}
difference = {}
for category in categories:
    line = "| {:19} |".format(category.title().replace('_', ' '))
    total_category_fp = set()
    total_category_fn = set()
    for tool in sorted(tools):
        if tool not in difference:
            difference[tool] = {}
        if category not in difference[tool]:
            difference[tool][category] = []
        if tool not in total_tools:
            total_tools[tool] = {"fp": 0, "fn": 0}
        false_positives_identified, false_negatives_identified = set(), 0
        if tool in false_positives and category in false_positives[tool]:
            for contract in false_positives[tool][category]:
                if tool == "ccc" and len(set(false_positives[tool][category][contract])) > 0:
                    writer_fp.writerow([tool, category, contract, list(set(false_positives[tool][category][contract]))])
                total_category_fp.update(false_positives[tool][category][contract])
                false_positives_identified.update(set(false_positives[tool][category][contract]))
        if tool in expected_vunerability_lines:
            for contract in expected_vunerability_lines[tool][category]:
                for vulnerable_lines in expected_vunerability_lines[tool][category][contract]:
                    vulnerable_line_found = False
                    for vuln in detected_vunerability_lines[tool][category][contract]:
                        if vuln in vulnerable_lines:
                            vulnerable_line_found = True
                    if vulnerable_line_found == False:
                        difference[tool][category].append(vulnerable_lines)
                        if tool == "ccc":
                            writer_fn.writerow([tool, category, contract, vulnerable_lines])
                false_negatives_identified = len(difference[tool][category])
        line += " {:5} {:5} |".format(len(false_positives_identified), false_negatives_identified)
        total_tools[tool]["fp"] += len(false_positives_identified)
        total_tools[tool]["fn"] += len(total_category_fn)
    line += " {:5} {:5} |".format(len(total_category_fp), len(total_category_fn))
    print(line)
csv_fp_file.close()
csv_fn_file.close()
line = "| {:19} |".format('Total')
total_fp, total_fn = 0, 0
for tool in sorted(tools):
    total_fp += total_tools[tool]["fp"]
    total_fn += total_tools[tool]["fn"]
    line += " {:5} {:5} |".format(total_tools[tool]["fp"], total_tools[tool]["fn"])
line += " {:5} {:5} |".format(total_fp, total_fn)
print(line)

print("\n# Nb Detected Vulnerabilities\n")
line = '| Category            |'
for tool in sorted(tools):
    line += ' {:^11} |'.format(tool.title().split("-")[0])
line += ' {:^11} |'.format('Total')
print(line)

line = "| ------------------- |"
for tool in tools:
    line += ' {:-<11} |'.format('-')
line += ' {:-<11} |'.format('')
print(line)

total_tools = {}
for category in categories:
    line = "| {:19} |".format(category.title().replace('_', ' '))
    total_detection_tool = 0
    for tool in sorted(tools):
        if tool not in total_tools:
            total_tools[tool] = 0

        total_identified = 0
        if tool in tool_stat and category in tool_stat[tool]:
            total_identified = tool_stat[tool][category]
        total_detection_tool += total_identified
        total_tools[tool] += total_identified
        line += " {:11} |".format(total_identified)
    line += " {:11} |".format(total_detection_tool)
    print(line)
    index_vulnerability += 1
line = "| {:19} |".format('Total')
total = 0
for tool in sorted(tools):
    total += total_tools[tool]
    line += " {:11} |".format(total_tools[tool])
line += " {:11} |".format(total)
print(line)


print("\n# Combine Tools\n")

tool_ability = {}
for category in categories:
    for tool in precisions[category]:
        if tool not in tool_ability:
            tool_ability[tool] = []
        vulns = precisions[category][tool]
        for vuln in vulns:
            tool_ability[tool].append(vuln)

line = '| {:11} |'.format('')
for tool_a in sorted(tools):
    line += ' {:^11} |'.format(tool_a.title().split("-")[0])
print(line)
line = '| {:-<11} |'.format('-')
for tool_a in sorted(tools):
    line += ' {:-<11} |'.format('-')
print(line)

for tool_a in sorted(tools):
    line = '| {:11} |'.format(tool_a.title().split("-")[0])

    if tool_a not in tool_ability:
        continue
    ability_a = tool_ability[tool_a]
    stop_number = True
    for tool_b in sorted(tools):
        if tool_a == tool_b or stop_number:
            line += ' {:11} |'.format('')
            if tool_a == tool_b:
                stop_number = False
            continue
        if tool_b in tool_ability:
            ability_b = [*tool_ability[tool_b]]
        else:
            ability_b = []
        for vuln in ability_a:
            if vuln not in ability_b:
                ability_b.append(vuln)
        line += ' {:7} {:2}% |'.format("%d/%d" %(len(ability_b), nb_tagged_vulnerabilities),round(len(ability_b)*100/nb_tagged_vulnerabilities))
    print(line)
