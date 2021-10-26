import os

from src.execution.execution_configuration import Execution_Configuration


class Execution_Task:

    def __init__(self, tool: str, file: str, execution_configuration: 'Execution_Configuration'):
        self.tool = tool
        self.file = file
        self.file_name = os.path.splitext(os.path.basename(self.file))[0]
        self.execution_configuration = execution_configuration
        self.end_time = None
        self.start_time = None
        self.exit_code = None

    def result_output_path(self):
        return os.path.join(self.execution_configuration.output_folder, self.tool, self.execution_configuration.execution_name, self.file_name)
