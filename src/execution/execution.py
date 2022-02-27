from time import time
import sys, json, os, importlib
import traceback
from typing import List, Tuple, Dict

from datetime import timedelta
from multiprocessing import Pool, Manager

from src import output_parser
from src.output_parser.Parser import Parser
from src.tools import TOOLS
from src.execution.execution_task import Execution_Task
from src.logger import logs, Logger
from src.execution.docker_api import analyse_files
from src.output_parser.SarifHolder import SarifHolder
from src.utils import COLINFO, COLSTATUS, COLRESET, COLSUCCESS, COLERR

class Execution:

    def __init__(self, tasks: List['Execution_Task']):
        manager = Manager()
        self.tasks = tasks
        self.conf = tasks[0].execution_configuration
        self.tasks_done = manager.list()
        self.total_execution = manager.Value("i", 0)
        self.sarif_cache: Dict[str, SarifHolder] = manager.dict()

    @staticmethod
    def analyze(args: Tuple['Execution', 'Execution_Task', "Logger"]):
        (self, task, logger) = args
        logs.file_path = logger.file_path
        try:
            self.analyze_start(task)
            task.start_time = time()
            output = analyse_files(task)
            task.end_time = time()
            result = self.parse_results(task, output)
            self.analyze_end(task, result)
        except Exception as e:
            traceback.print_exc()
            logs.print(e)

    def analyze_start(self, task: 'Execution_Task'):
        sys.stdout.write(
            f"{COLSTATUS}Analyzing file [{len(self.tasks_done)+1}/{len(self.tasks)}]: "
            f"{COLINFO}{task.file}"
            f"{COLSTATUS} [{task.tool}]{COLRESET}\n"
        )
        sys.stdout.flush()

    def analyze_end(self, task: 'Execution_Task', result):
        self.tasks_done.append(task)

        duration = task.end_time - task.start_time
        self.total_execution.value += duration

        avg_task_execution_time = (time() - self.start_time) / len(self.tasks_done)
        remaining_time = str(timedelta(seconds=round(
            (len(self.tasks) - len(self.tasks_done)) * avg_task_execution_time)))

        duration_str = str(timedelta(seconds=round(duration)))
        exit_code = task.exit_code if task.exit_code is not None else "timeout"
        line = (
            f"{COLSTATUS}Done [{len(self.tasks_done)}/{len(self.tasks)}, {remaining_time}]: "
            f"{COLINFO}{task.file}"
            f"{COLSTATUS} [{task.tool}] in {duration_str}"
            f"{COLRESET} with exit code: {exit_code} ({f'{COLSUCCESS}SUCCESS' if result['success'] else f'{COLERR}FAILED'}{COLRESET})"
            )
        logs.print(line, f"[{len(self.tasks_done)}/{len(self.tasks)}] {task.file} [{task.tool}] in {duration_str} with exit code: {exit_code} ({'SUCCESS' if result['success'] else 'FAILED'})")

    def exec(self):
        self.start_time = time()

        with Pool(processes=self.conf.processes) as pool:
            pool.map(Execution.analyze, [(self, task, logs, )
                     for task in self.tasks])

        if self.conf.aggregate_sarif:
            for task in self.tasks:
                sarif_file_path = os.path.join(
                    self.conf.output_folder, self.conf.execution_name, task.file_name + '.sarif')
                if not os.path.exists(os.path.dirname(sarif_file_path)):
                    os.makedirs(os.path.dirname(sarif_file_path))
                with open(sarif_file_path, 'w') as sarif_file:
                    json.dump(
                        self.sarif_cache[task.file_name].print(), sarif_file, indent=2)

        if self.conf.unique_sarif_output:
            sarif_holder = SarifHolder()
            for sarif_output in self.sarif_cache.values():
                for run in sarif_output.sarif.runs:
                    sarif_holder.addRun(run)

            sarif_file_path = os.path.join(
                self.conf.output_folder, self.conf.execution_name + '.sarif')

            if not os.path.exists(os.path.dirname(sarif_file_path)):
                os.makedirs(os.path.dirname(sarif_file_path))

            with open(sarif_file_path, 'w') as sarif_file:
                json.dump(sarif_holder.print(), sarif_file, indent=2)

        elapsed_time = round(time() - self.start_time)
        if elapsed_time > 60:
            elapsed_time_sec = round(elapsed_time % 60)
            elapsed_time = round(elapsed_time // 60)
            logs.print(f"Analysis completed. \nIt took {elapsed_time}m {elapsed_time_sec}s to analyse all files.")
        else:
            logs.print(f"Analysis completed. \nIt took {elapsed_time}s to analyse all files.")

    def parse_results(self, task: 'Execution_Task', log_content: str):
        results = {
            'contract': task.file,
            'tool': task.tool,
            'start': task.start_time,
            'end': task.end_time,
            'exit_code': task.exit_code,
            'duration': task.end_time - task.start_time,
            'success': False,
            'findings': None,
            'errors': None,
            'analysis': None
        }
        output_folder = task.result_output_path()
        if not os.path.exists(output_folder):
            os.makedirs(output_folder)

        try:
            if log_content is not None:
                with open(os.path.join(output_folder, 'result.log'), 'w', encoding='utf-8') as f:
                    f.write(log_content)
                parser = Execution.log_parser(task, log_content)
                results['findings'] = parser.findings()
                results['errors']   = parser.errors()
                results['analysis'] = parser.analysis()
                if task.exit_code is None:
                    # If you change this error message, change it also in src/Parser.py:main()
                    results['errors'].append('Docker container timed out')
                results['success'] = not results['errors']
        except Exception as e:
            traceback.print_exc()
            logs.print(f"Log parser error: {e}")
        
        with open(os.path.join(output_folder, 'result.json'), 'w') as f:
            json.dump(results, f, indent=2)

        try:
            if self.conf.sarif_output:
                if task.file_name not in self.sarif_cache:
                    sarif = SarifHolder()
                else:
                    sarif = self.sarif_cache[task.file_name]
                sarif.addRun(parser.parseSarif(results, task.file))
                self.sarif_cache[task.file_name] = sarif

                with open(os.path.join(output_folder, 'result.sarif'), 'w') as sarif_file:
                    json.dump(self.sarif_cache[task.file_name].printToolRun(
                        tool=task.tool), sarif_file, indent=2)
        except Exception as e:
            traceback.print_exc()
            logs.print(f"parse sarif error: {e}")
        return results
        

    @staticmethod
    def log_parser(task: 'Execution_Task', log: str) -> output_parser.Parser:
        parser_name = TOOLS[task.tool]['output_parser']
        module = importlib.import_module(f'src.output_parser.{parser_name}')
        parser = getattr(module, parser_name)
        return parser(task, log)
