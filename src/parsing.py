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


def parse_results(results, result_log, result_tar, results_folder, sarif_outputs, id, import_path, output_version):
    toolname = results["tool"]
    file = results["contract"]
    if import_path == "FILE":
        file_path_in_repo = file
    else:
        file_path_in_repo = file.replace(import_path, '')  # file path relative to project's root directory

    sarif_holder = sarif_outputs[id]
    try:
        with open(result_log) as f:
            output = f.read()
        if output.count('Solc experienced a fatal error') >= 1 or output.count('compilation failed') >= 1:
            log.message(col.error(f"Solc experienced a fatal error. Check the results file for more info\n{toolname}, {file}"))
        if toolname == 'oyente':
            results['analysis'] = Oyente().parse(output)
            sarif_holder.addRun(Oyente().parseSarif(results, file_path_in_repo))
        elif toolname == 'osiris':
            results['analysis'] = Osiris().parse(output)
            sarif_holder.addRun(Osiris().parseSarif(results, file_path_in_repo))
        elif toolname == 'honeybadger':
            results['analysis'] = HoneyBadger().parse(output)
            sarif_holder.addRun(HoneyBadger().parseSarif(results, file_path_in_repo))
        elif toolname == 'smartcheck':
            results['analysis'] = Smartcheck().parse(output)
            sarif_holder.addRun(Smartcheck().parseSarif(results, file_path_in_repo))
        elif toolname == 'solhint':
            results['analysis'] = Solhint().parse(output)
            sarif_holder.addRun(Solhint().parseSarif(results, file_path_in_repo))
        elif toolname == 'maian':
            results['analysis'] = Maian().parse(output)
            sarif_holder.addRun(Maian().parseSarif(results, file_path_in_repo))
        elif toolname == 'mythril':
            results['analysis'] = json.loads(output)
            sarif_holder.addRun(Mythril().parseSarif(results, file_path_in_repo))
        elif toolname == 'securify':
            if len(output) > 0 and output[0] == '{':
                results['analysis'] = json.loads(output)
            elif result_tar:
                tar = tarfile.open(result_tar)
                try:
                    output_file = tar.extractfile('results/results.json')
                    results['analysis'] = json.loads(output_file.read())
                    sarif_holder.addRun(Securify().parseSarif(results, file_path_in_repo))
                except Exception as e:
                    output_file = tar.extractfile('results/live.json')
                    results['analysis'] = {
                        os.path.basename(file): {
                            'results': json.loads(output_file.read())["patternResults"]
                        }
                    }
                    sarif_holder.addRun(Securify().parseSarifFromLiveJson(results, file_path_in_repo))
        elif toolname == 'slither':
            if result_tar:
                tar = tarfile.open(result_tar)
                output_file = tar.extractfile('output.json')
                results['analysis'] = json.loads(output_file.read())
                sarif_holder.addRun(Slither().parseSarif(results, file_path_in_repo))
        elif toolname == 'manticore':
            if result_tar:
                tar = tarfile.open(result_tar)
                m = re.findall('Results in /(mcore_.+)', output)
                results['analysis'] = []
                for fout in m:
                    output_file = tar.extractfile(f"results/{fout}/global.findings")
                    results['analysis'].append(Manticore().parse(output_file.read().decode('utf8')))
                sarif_holder.addRun(Manticore().parseSarif(results, file_path_in_repo))
        elif toolname == 'conkas':
            results['analysis'] = Conkas().parse(output)
            sarif_holder.addRun(Conkas().parseSarif(results, file_path_in_repo))
    except Exception as err:
        log.message(col.error(f"Error parsing output of {toolname} for file {file}\n{err}"))
    sarif_outputs[id] = sarif_holder

    if output_version == 'v1' or output_version == 'all':
        with open(os.path.join(results_folder, 'result.json'), 'w') as f:
            json.dump(results, f, indent=2, sort_keys=True)

    if output_version == 'v2' or output_version == 'all':
        with open(os.path.join(results_folder, 'result.sarif'), 'w') as f:
            json.dump(sarif_holder.printToolRun(tool=toolname), f, indent=2, sort_keys=True)
