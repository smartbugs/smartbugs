import re
from src.output_parser.Parser import Parser

class Oyente(Parser):
    def __init__(self):
        pass
    
    def extract_result_line(self, line):
        line = line.replace("INFO:symExec:	  ", '')
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
            if "INFO:root:contract" in line:
                if current_contract is not None:
                    output.append(current_contract)
                current_contract = {
                    'errors': []
                }
                (file, contract_name, _) = line.replace("INFO:root:contract ", '').split(':')
                current_contract['file'] = file
                current_contract['name'] = contract_name
            elif "INFO:symExec:	  " in line:
                (key, value) = self.extract_result_line(line)
                current_contract[key] = value
            elif current_contract is not None and "INFO:symExec:" + current_contract['file'] in line:
                (line, column, level, message) = line.replace("INFO:symExec:%s:" % (current_contract['file']), '').split(':')
                current_contract['errors'].append({
                    'line': int(line),
                    'column': int(column),
                    'level': level.strip(),
                    'message': message.strip()
                })
        if current_contract is not None:
            output.append(current_contract)
        return output