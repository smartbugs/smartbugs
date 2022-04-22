#!/usr/bin/env python3

import json
import os
import re
import tarfile

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
import src.logging as log
import src.colors as col
import src.output_parser.SarifHolder as SarifHolder


def parse_results(logqueue, results, result_log, result_tar, import_path):
    toolname = results["tool"]
    file = results["contract"]
    if import_path == "FILE":
        file_path_in_repo = file
    else:
        file_path_in_repo = file.replace(import_path, '')  # file path relative to project's root directory
    sarif = None

    if not result_log:
        log.message(logqueue, col.error(f"Output of {results['tool']} for {results['contract']} not found."))
        return results, sarif
    with open(result_log) as f:
        output = f.read()

    if output.count('Solc experienced a fatal error') >= 1 or output.count('compilation failed') >= 1:
        log.message(logqueue, col.error(f"Solc experienced a fatal error. Check the results file for more info\n{toolname}, {file}"))
    if toolname == 'oyente':
        results['analysis'] = Oyente().parse(output)
        sarif = Oyente().parseSarif(results, file_path_in_repo)
    elif toolname == 'osiris':
        results['analysis'] = Osiris().parse(output)
        sarif = Osiris().parseSarif(results, file_path_in_repo)
    elif toolname == 'honeybadger':
        results['analysis'] = HoneyBadger().parse(output)
        sarif = HoneyBadger().parseSarif(results, file_path_in_repo)
    elif toolname == 'smartcheck':
        results['analysis'] = Smartcheck().parse(output)
        sarif = Smartcheck().parseSarif(results, file_path_in_repo)
    elif toolname == 'solhint':
        results['analysis'] = Solhint().parse(output)
        sarif = Solhint().parseSarif(results, file_path_in_repo)
    elif toolname == 'maian':
        results['analysis'] = Maian().parse(output)
        sarif = Maian().parseSarif(results, file_path_in_repo)
    elif toolname == 'mythril':
        results['analysis'] = json.loads(output)
        sarif = Mythril().parseSarif(results, file_path_in_repo)
    elif toolname == 'securify':
        if len(output) > 0 and output[0] == '{':
            results['analysis'] = json.loads(output)
        elif result_tar:
            tar = tarfile.open(result_tar)
            try:
                output_file = tar.extractfile('results/results.json')
                results['analysis'] = json.loads(output_file.read())
                sarif = Securify().parseSarif(results, file_path_in_repo)
            except Exception as e:
                output_file = tar.extractfile('results/live.json')
                results['analysis'] = {
                    os.path.basename(file): {
                        'results': json.loads(output_file.read())["patternResults"]
                    }
                }
                sarif = Securify().parseSarifFromLiveJson(results, file_path_in_repo)
    elif toolname == 'slither':
        if result_tar:
            tar = tarfile.open(result_tar)
            output_file = tar.extractfile('output.json')
            results['analysis'] = json.loads(output_file.read())
            sarif = Slither().parseSarif(results, file_path_in_repo)
    elif toolname == 'manticore':
        if result_tar:
            tar = tarfile.open(result_tar)
            m = re.findall('Results in /(mcore_.+)', output)
            results['analysis'] = []
            for fout in m:
                output_file = tar.extractfile(f"results/{fout}/global.findings")
                results['analysis'].append(Manticore().parse(output_file.read().decode('utf8')))
            sarif = Manticore().parseSarif(results, file_path_in_repo)
    elif toolname == 'conkas':
        results['analysis'] = Conkas().parse(output)
        sarif = Conkas().parseSarif(results, file_path_in_repo)
    else:
        results["analysis"] = None
        sarif = None
        log.message(logqueue, col.error(f"No parser for {toolname} available, skipping {file}"))
    return results, sarif

