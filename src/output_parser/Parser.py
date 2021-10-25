from src.execution.execution_task import Execution_Task


class Parser:
    def __init__(self, task: Execution_Task, str_output: str):
        self.task = task
        self.str_output = str_output
        pass

    def is_success(self) -> bool:
        pass

    def parse(self):
        pass

    def parseSarif(self, str, file_path_in_repo):
        pass
