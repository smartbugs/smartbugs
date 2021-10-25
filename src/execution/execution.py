from time import time
import sys
import json
import os

from datetime import timedelta
from multiprocessing import Pool, Manager

from src.parse_result import parse_results
from src.execution.execution_task import Execution_Task
from src.logger import logs
from src.execution.docker_api import analyse_files
from src.output_parser.SarifHolder import SarifHolder


class Execution:

    def __init__(self, tasks: list[Execution_Task]):
        manager = Manager()
        self.tasks = tasks
        self.conf = tasks[0].execution_configuration
        self.tasks_done = manager.list()
        self.total_execution = manager.Value("i", 0)

    @staticmethod
    def analyze(args):
        (self, task) = args
        try:
            self.analyze_start(task)
            task.start_time = time()
            output = analyse_files(task)
            task.end_time = time()
            parse_results(task, output)
            self.analyze_end(task)
        except Exception as e:
            logs.print(e)

    def analyze_start(self, task: Execution_Task):
        sys.stdout.write('\x1b[1;37m' + 'Analysing file [%d/%d]: ' %
                         (len(self.tasks_done), len(self.tasks)) + '\x1b[0m')
        sys.stdout.write('\x1b[1;34m' + task.file + '\x1b[0m')
        sys.stdout.write('\x1b[1;37m' + ' [' +
                         task.tool + ']' + '\x1b[0m' + '\n')

    def analyze_end(self, task: Execution_Task):
        self.tasks_done.append(task)

        duration = task.end_time - task.start_time
        self.total_execution.value += task.end_time - task.start_time

        task_sec = len(self.tasks_done) / duration
        remaining_time = str(timedelta(seconds=round(
            (len(self.tasks) - len(self.tasks_done)) / task_sec)))

        duration_str = str(timedelta(seconds=round(duration)))
        line = "\x1b[1;37mDone [%d/%d, %s]: \x1b[0m\x1b[1;34m%s\x1b[0m\x1b[1;37m [%s] in %s \x1b[0mwith exit code: %d" % (
            len(self.tasks_done), len(self.tasks), remaining_time, task.file, task.tool, duration_str, task.exit_code)
        logs.print(line, '[%d/%d] ' % (len(self.tasks_done), len(self.tasks)) +
                   task.file + ' [' + task.tool + '] in ' + duration_str)

    def exec(self):
        self.start_time = time()

        with Pool(processes=self.conf.processes) as pool:
            pool.map(Execution.analyze, [(self, task, )
                     for task in self.tasks])

        if self.conf.aggregate_sarif:
            for task in self.tasks:
                sarif_file_path = os.path.join(
                    self.conf.output_folder, self.conf.execution_name, task.file_name + '.sarif')
                with open(sarif_file_path, 'w') as sarif_file:
                    json.dump(
                        self.conf.serif_cache[task.file_name].print(), sarif_file, indent=2)

        if self.conf.unique_sarif_output:
            sarif_holder = SarifHolder()
            for sarif_output in self.conf.serif_cache.values():
                for run in sarif_output.sarif.runs:
                    sarif_holder.addRun(run)
            sarif_file_path = os.path.join(
                self.conf.output_folder, self.conf.execution_name + '.sarif')
            with open(sarif_file_path, 'w') as sarif_file:
                json.dump(sarif_holder.print(), sarif_file, indent=2)

        elapsed_time = round(time() - self.start_time)
        if elapsed_time > 60:
            elapsed_time_sec = round(elapsed_time % 60)
            elapsed_time = round(elapsed_time // 60)
            logs.print('Analysis completed. \nIt took %sm %ss to analyse all files.' % (
                elapsed_time, elapsed_time_sec))
        else:
            logs.print(
                'Analysis completed. \nIt took %ss to analyse all files.' % elapsed_time)
