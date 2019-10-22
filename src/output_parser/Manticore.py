import re
from src.output_parser.Parser import Parser

class Manticore(Parser):
    def __init__(self):
        pass
    
    def parse(self, str_output):
        output = []
        lines = str_output.splitlines()

        current_vul = None
        for line in lines:
            if len(line) == 0:
                continue
            if line[0] == '-':
                if current_vul is not None:
                    output.append(current_vul)
                current_vul = {
                    'name': line[1:-2].strip(),
                    'line': -1,
                    'code': None
                }
            elif current_vul is not None and line[:4] == '    ':
                index = line[4:].rindex('  ') + 4
                current_vul['line'] = int(line[4:index])
                current_vul['code'] = line[index:].strip()
                
        if current_vul is not None:
            output.append(current_vul)
        return output