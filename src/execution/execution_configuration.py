from typing import List


class Execution_Configuration:

    def __init__(self, output_folder: str, execution_name: str, is_bytecode: bool, skip_existing: bool, sarif_output: bool,  processes: int, aggregate_sarif: bool, unique_sarif_output: bool, timeout: int, cpu_quota: int, mem_quota: str, tools: List[str], files: List[str], datasets: List[str]):
        self.output_folder = output_folder
        self.execution_name = execution_name
        self.is_bytecode = is_bytecode
        self.sarif_output = sarif_output
        self.skip_existing = skip_existing
        self.processes = processes
        self.aggregate_sarif = aggregate_sarif
        self.unique_sarif_output = unique_sarif_output
        self.timeout = timeout
        self.cpu_quota = cpu_quota
        self.mem_limit = mem_quota
        self.files = files

        from src.interface.cli import DATASET_CHOICES, TOOLS_CHOICES

        if tools == ['all']:
            self.tools = TOOLS_CHOICES.copy()
            self.tools.remove('all')
        else:
            self.tools = tools

        if datasets == ['all']:
            self.datasets = DATASET_CHOICES.copy()
            self.datasets.remove('all')
        else:
            self.datasets = datasets
