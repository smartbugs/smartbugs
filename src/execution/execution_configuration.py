from multiprocessing import Manager


class Execution_Configuration:

    def __init__(self, output_folder: str, execution_name: str, is_bytecode: bool, skip_existing: bool, output_version: str,  processes: int, aggregate_sarif: bool, unique_sarif_output: bool):
        self.output_folder = output_folder
        self.execution_name = execution_name
        self.is_bytecode = is_bytecode
        self.output_version = output_version
        self.skip_existing = skip_existing
        self.processes = processes
        self.aggregate_sarif = aggregate_sarif
        self.unique_sarif_output = unique_sarif_output
        self.timeout = 30 * 60
        self.cpu_quota = None  # 150000
        self.mem_limit = None  # "512m"
        self.serif_cache = Manager().dict()
