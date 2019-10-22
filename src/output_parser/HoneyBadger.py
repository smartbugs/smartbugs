import re
from src.output_parser.Parser import Parser

class HoneyBadger(Parser):
    def __init__(self):
        pass
    
    def extract_result_line(self, line):
        line = line.replace("INFO:symExec:	 ", '')
        index_split = line.index(":")
        key = line[:index_split].lower().replace(' ', '_').replace('(', '').replace(')', '').strip()
        value = line[index_split + 1:].strip()
        if "True" == value:
            value = True
        elif "False" == value:
            value = False
        return (key, value)
    def parse(self, str_output):
        output = []
        current_contract = None
        lines = str_output.splitlines()
        for line in lines:
            if "INFO:root:Contract " in line:
                if current_contract is not None:
                    output.append(current_contract)
                current_contract = {
                    'errors': []
                }
                (file, contract_name, _) = line.replace("INFO:root:Contract ", '').split(':')
                current_contract['file'] = file
                current_contract['name'] = contract_name
            elif "INFO:symExec:	 " in line and '---' not in line and '======' not in line:
                current_error = None
                (key, value) = self.extract_result_line(line)
                if value:
                    current_error = key
            elif current_contract is not None and current_contract['file'] in line and line.index(current_contract['file']) == 0:
                (file, classname, line, column) = line.split(':')
                current_contract['errors'].append({
                    'line': int(line),
                    'column': int(column),
                    'message': current_error
                })
        if current_contract is not None:
            output.append(current_contract)
        return output