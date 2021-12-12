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
        l = []
        sep = False
        for c in s:
            if c.isalnum():
                if sep:
                    l.append('_')
                l.append(c)
                sep = False
            else:
                sep = True
        return ''.join(l)
