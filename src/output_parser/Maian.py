import re
from src.output_parser.Parser import Parser

class Maian(Parser):
    def __init__(self):
        pass
    
    def parse(self, str_output):
        output = {
            'is_lock_vulnerable': False,
            'is_prodigal_vulnerable': False,
            'is_suicidal_vulnerable': False,
        }
        lines = str_output.splitlines()
        for line in lines:
            if 'Locking vulnerability found!' in line:
                output['is_lock_vulnerable'] = True
            if 'The contract is prodigal' in line:
                output['is_prodigal_vulnerable'] = True
            if 'Confirmed ! The contract is suicidal' in line:
                output['is_suicidal_vulnerable'] = True
        return output