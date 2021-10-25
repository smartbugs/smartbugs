import os
import json
import traceback

from src.logger import logs
from src.output_parser.SarifHolder import SarifHolder
from src.output_parser.Parser import Parser
from src.execution.execution_task import Execution_Task
from src.output_parser.Vandal import Vandal
from src.output_parser.Pakala import Pakala
from src.output_parser.Conkas import Conkas
from src.output_parser.HoneyBadger import HoneyBadger
from src.output_parser.Maian import Maian
from src.output_parser.Manticore import Manticore
from src.output_parser.Mythril import Mythril
from src.output_parser.Osiris import Osiris
from src.output_parser.Oyente import Oyente
from src.output_parser.Securify import Securify
from src.output_parser.Slither import Slither
from src.output_parser.Smartcheck import Smartcheck
from src.output_parser.Solhint import Solhint


def log_parser(task: Execution_Task, log: str) -> Parser:
    if task.tool == 'oyente':
        return Oyente(task, log)
    if task.tool == 'osiris':
        return Osiris(task, log)
    if task.tool == 'honeybadger':
        return HoneyBadger(task, log)
    if task.tool == 'smartcheck':
        return Smartcheck(task, log)
    if task.tool == 'solhint':
        return Solhint(task, log)
    if task.tool == 'maian':
        return Maian(task, log)
    if task.tool == 'mythril':
        return Mythril(task, log)
    if task.tool == 'securify':
        return Securify(task, log)
    if task.tool == 'slither':
        return Slither(task, log)
    if task.tool == 'manticore':
        return Manticore(task, log)
    if task.tool == 'conkas':
        return Conkas(task, log)
    if task.tool == 'pakala':
        return Pakala(task, log)
    if task.tool == 'vandal':
        return Vandal(task, log)


def parse_results(task: Execution_Task, log_content: str):
    results = {
        'contract': task.file,
        'tool': task.tool,
        'start': task.start_time,
        'end': task.end_time,
        'exit_code': task.exit_code,
        'duration': task.end_time - task.start_time,
        'analysis': None,
        'success': False
    }
    output_folder = task.result_output_path()
    if not os.path.exists(task.result_output_path()):
        os.makedirs(task.result_output_path())

    with open(os.path.join(task.result_output_path(), 'result.log'), 'w', encoding='utf-8') as f:
        f.write(log_content)


    if task.file_name not in task.execution_configuration.serif_cache:
        task.execution_configuration.serif_cache[task.file_name] = SarifHolder()
    try:
        parser = log_parser(task, log_content)
        results['analysis'] = parser.parse()
        results['success'] = parser.is_success()

        task.execution_configuration.serif_cache[task.file_name].addRun(parser.parseSarif(results, task.file))
    except Exception as e:
        traceback.print_exc()
        logs.print("Log parser error: %s" % e)
        # ignore
        pass

    if task.execution_configuration.output_version == 'v1' or task.execution_configuration.output_version == 'all':
        with open(os.path.join(output_folder, 'result.json'), 'w') as f:
            json.dump(results, f, indent=2)

    if task.execution_configuration.output_version == 'v2' or task.execution_configuration.output_version == 'all':
        with open(os.path.join(output_folder, 'result.sarif'), 'w') as sarif_file:
            json.dump(task.execution_configuration.serif_cache[task.file_name].printToolRun(
                tool=task.tool), sarif_file, indent=2)
