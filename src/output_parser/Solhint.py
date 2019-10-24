import re
from src.output_parser.Parser import Parser

class Solhint(Parser):
    def __init__(self):
        pass

    def parse(self, str_output):
        output = []
        lines = str_output.splitlines()
        for line in lines:
            if ":" in line:
                s_result = line.split(':')
                if len(s_result) != 4:
                    continue
                (file, line, column, end_error) = s_result
                if ']' not in end_error:
                    continue
                message = end_error[1:end_error.index('[') - 1]
                level = end_error[end_error.index('[') + 1: end_error.index('/')]
                type = end_error[end_error.index('/') + 1: len(end_error) - 1]
                output.append({
                    'file': file,
                    'line': line,
                    'column': column,
                    'message': message,
                    'level': level,
                    'type': type
                })

        return output