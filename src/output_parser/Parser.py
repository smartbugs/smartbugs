from typing import List
from src.execution.execution_task import Execution_Task


class Parser:

    def __init__(self, task: 'Execution_Task', str_output: str):
        self.task = task
        self.str_output = str_output
        self.success = False
        self.labels = None
        self.output = None

    def is_success(self) -> bool:
        return self.success

    def findings(self) -> List[str]:
        return self.labels

    def parse(self):
        return self.output

    def parseSarif(self, str, file_path_in_repo):
        pass

    @staticmethod
    def str2label(s):
        # Convert string to label satisfying:
        # - letters and digits remain unaffected
        # - leading or trailing punctuation and spaces are removed
        # - sequences of punctuation and spaces are replaced by a single underscore
        l = []
        sep = False
        ch = False
        for c in s: # or in s.lower() (convert to lowercase)?
            if c.isalnum(): # "or c in '-'", to allow for - and maybe other characters?
                if sep:
                    l.append('_')
                    sep = False
                l.append(c)
                ch = True
            else:
                sep = ch
        return ''.join(l)
