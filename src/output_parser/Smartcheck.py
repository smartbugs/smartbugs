import re
from src.output_parser.Parser import Parser

class Smartcheck(Parser):
    def __init__(self):
        pass
    
    def extract_result_line(self, line):
        index_split = line.index(":")
        key = line[:index_split]
        value = line[index_split + 1:].strip()
        if value.isdigit():
            value = int(value)
        return (key, value)

    def parse(self, str_output):
        output = []
        current_error = None
        lines = str_output.splitlines()
        for line in lines:
            if "ruleId: " in line:
                if current_error is not None:
                    output.append(current_error)
                current_error = {
                    'name': line[line.index("ruleId: ") + 8:] 
                }
            elif current_error is not None and ':' in line and ' :' not in line:
                (key, value) = self.extract_result_line(line)
                current_error[key] = value

        if current_error is not None:
            output.append(current_error)
        return output