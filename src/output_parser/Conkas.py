from src.output_parser.Parser import Parser


class Conkas(Parser):
    def __init__(self):
        pass

    @staticmethod
    def __parse_vuln_line(line):
        vuln_type = line.split('Vulnerability: ')[1].split('.')[0]
        maybe_in_function = line.split('Maybe in function: ')[1].split('.')[0]
        pc = line.split('PC: ')[1].split('.')[0]
        line_number = line.split('Line number: ')[1].split('.')[0]
        if vuln_type == 'Integer Overflow':
            vuln_type = 'Integer_Overflow'
        elif vuln_type == 'Integer Underflow':
            vuln_type = 'Integer_Underflow'
        return {
            'vuln_type': vuln_type,
            'maybe_in_function': maybe_in_function,
            'pc': pc,
            'line_number': line_number
        }

    def parse(self, str_output):
        output = []
        str_output = str_output.split('\n')
        for line in str_output:
            if 'Vulnerability' in line:
                try:
                    output.append(self.__parse_vuln_line(line))
                except:
                    continue
        return output
