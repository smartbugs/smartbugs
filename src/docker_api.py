#!/usr/bin/env python3

import docker
import json
import os
import re
import sys
import tarfile
import yaml
import tempfile
import shutil

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

from time import time

from src.get_solc import get_solc

client = docker.from_env()

"""
pull images
"""
def pull_image(image, logs):
    try:
        print('pulling ' + image + ' image, this may take a while...')
        logs.write('pulling ' + image + ' image, this may take a while...\n')
        image = client.images.pull(image)
        print('image pulled')
        logs.write('image pulled\n')

    except docker.errors.APIError as err:
        print(err)
        logs.write(err + '\n')


"""
mount volumes
"""
def mount_volumes(dir_path, logs):
    try:
        volume_bindings = {os.path.abspath(dir_path): {'bind': '/data', 'mode': 'rw'}}
        return volume_bindings
    except os.error as err:
        print(err)
        logs.write(err + '\n')


"""
stop container
"""
def stop_container(container, logs):
    try:
        if container is not None:
            container.stop(timeout=0)
    except (docker.errors.APIError) as err:
        print(err)
        logs.write(str(err) + '\n')


"""
remove container
"""
def remove_container(container, logs):
    try:
        if container is not None:
            container.remove()
    except (docker.errors.APIError) as err:
        print(err)
        logs.write(err + '\n')


"""
write output
"""
def parse_results(output, tool, file_name, container, cfg, logs, results_folder, start, end, sarif_outputs,
                  file_path_in_repo, output_version):
    output_folder = os.path.join(results_folder, file_name)

    results = {
        'contract': file_name,
        'tool': tool,
        'start': start,
        'end': end,
        'duration': end - start,
        'analysis': None
    }
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    with open(os.path.join(output_folder, 'result.log'), 'w', encoding='utf-8') as f:
        f.write(output)

    if 'output_in_files' in cfg:
        try:
            with open(os.path.join(output_folder, 'result.tar'), 'wb') as f:
                output_in_file = cfg['output_in_files']['folder']
                bits, stat = container.get_archive(output_in_file)
                for chunk in bits:
                    f.write(chunk)
        except Exception as e:
            print(output)
            print(e)
            print('\x1b[1;31m' + 'ERROR: could not get file from container. file not analysed.' + '\x1b[0m')
            logs.write('ERROR: could not get file from container. file not analysed.\n')

    try:
        sarif_holder = sarif_outputs[file_name]
        if tool == 'oyente':
            results['analysis'] = Oyente().parse(output)
            # Sarif Conversion
            sarif_holder.addRun(Oyente().parseSarif(results, file_path_in_repo))
        elif tool == 'osiris':
            results['analysis'] = Osiris().parse(output)
            sarif_holder.addRun(Osiris().parseSarif(results, file_path_in_repo))
        elif tool == 'honeybadger':
            results['analysis'] = HoneyBadger().parse(output)
            sarif_holder.addRun(HoneyBadger().parseSarif(results, file_path_in_repo))
        elif tool == 'smartcheck':
            results['analysis'] = Smartcheck().parse(output)
            sarif_holder.addRun(Smartcheck().parseSarif(results, file_path_in_repo))
        elif tool == 'solhint':
            results['analysis'] = Solhint().parse(output)
            sarif_holder.addRun(Solhint().parseSarif(results, file_path_in_repo))
        elif tool == 'maian':
            results['analysis'] = Maian().parse(output)
            sarif_holder.addRun(Maian().parseSarif(results, file_path_in_repo))
        elif tool == 'mythril':
            results['analysis'] = json.loads(output)
            sarif_holder.addRun(Mythril().parseSarif(results, file_path_in_repo))
        elif tool == 'securify':
            if len(output) > 0 and output[0] == '{':
                results['analysis'] = json.loads(output)
            elif os.path.exists(os.path.join(output_folder, 'result.tar')):
                tar = tarfile.open(os.path.join(output_folder, 'result.tar'))
                try:
                    output_file = tar.extractfile('results/results.json')
                    results['analysis'] = json.loads(output_file.read())
                    sarif_holder.addRun(Securify().parseSarif(results, file_path_in_repo))
                except Exception as e:
                    print('pas terrible')
                    output_file = tar.extractfile('results/live.json')
                    results['analysis'] = {
                        file_name: {
                            'results': json.loads(output_file.read())["patternResults"]
                        }
                    }
                    sarif_holder.addRun(Securify().parseSarifFromLiveJson(results, file_path_in_repo))
        elif tool == 'slither':
            if os.path.exists(os.path.join(output_folder, 'result.tar')):
                tar = tarfile.open(os.path.join(output_folder, 'result.tar'))
                output_file = tar.extractfile('output.json')
                results['analysis'] = json.loads(output_file.read())
                sarif_holder.addRun(Slither().parseSarif(results, file_path_in_repo))
        elif tool == 'manticore':
            if os.path.exists(os.path.join(output_folder, 'result.tar')):
                tar = tarfile.open(os.path.join(output_folder, 'result.tar'))
                m = re.findall('Results in /(mcore_.+)', output)
                results['analysis'] = []
                for fout in m:
                    output_file = tar.extractfile('results/' + fout + '/global.findings')
                    results['analysis'].append(Manticore().parse(output_file.read().decode('utf8')))
                sarif_holder.addRun(Manticore().parseSarif(results, file_path_in_repo))
        elif tool == 'conkas':
            results['analysis'] = Conkas().parse(output)
            sarif_holder.addRun(Conkas().parseSarif(results, file_path_in_repo))

        sarif_outputs[file_name] = sarif_holder

    except Exception as e:
        print(output)
        print(e)
        # ignore
        pass

    if output_version == 'v1' or output_version == 'all':
        with open(os.path.join(output_folder, 'result.json'), 'w') as f:
            json.dump(results, f, indent=2)

    if output_version == 'v2' or output_version == 'all':
        with open(os.path.join(output_folder, 'result.sarif'), 'w') as sarifFile:
            json.dump(sarif_outputs[file_name].printToolRun(tool=tool), sarifFile, indent=2)



"""
analyse solidity files
"""
def analyse_files(tool, file, logs, now, sarif_outputs, output_version, import_path):
    try:
        cfg_path = os.path.abspath(f'config/tools/{tool}.yaml')
        with open(cfg_path, 'r', encoding='utf-8') as ymlfile:
            try:
                cfg = yaml.safe_load(ymlfile)
            except yaml.YAMLError as exc:
                print(exc)
                logs.write(exc)

        # create result folder with time
        results_folder = 'results/' + tool + '/' + now
        if not os.path.exists(results_folder):
            os.makedirs(results_folder)
        # os.makedirs(os.path.dirname(results_folder), exist_ok=True)

        # check if config file as all required fields
        if 'docker_image' not in cfg or cfg['docker_image'] == None:
            logs.write(tool + ': docker image not provided. please check you config file.\n')
            sys.exit(tool + ': docker image not provided. please check you config file.')

        if import_path == "FILE":
            import_path = file
            file_path_in_repo = file
        else:
            file_path_in_repo = file.replace(import_path, '')  # file path relative to project's root directory

        solc_compiler = get_solc(file)

        filename = os.path.basename(file)
        scripts  = os.path.abspath(f'config/tools/{tool}')
        working_dir = tempfile.mkdtemp()
        shutil.copy(file, working_dir)
        working_bin_dir = f'{working_dir}/bin'
        shutil.copytree(scripts, working_bin_dir)
        shutil.copyfile(solc_compiler, f'{working_bin_dir}/solc')

        # bind directory path instead of file path to allow imports in the same directory
        volume_bindings = mount_volumes(working_dir, logs)

        start = time()

        image = cfg['docker_image']

        if not client.images.list(image):
            pull_image(image, logs)

        container = None
        try:
            container = client.containers.run(image,
                                              entrypoint = f"/data/bin/run_solidity /data/{filename}",
                                              detach=True,
                                              user = 0,
                                              # cpu_quota=150000,
                                              volumes=volume_bindings)
            try:
                container.wait(timeout=(30 * 60))
            except Exception as e:
                pass
            output = container.logs().decode('utf8').strip()
            if (output.count('Solc experienced a fatal error') >= 1 or output.count('compilation failed') >= 1):
                print(
                    '\x1b[1;31m' + 'ERROR: Solc experienced a fatal error. Check the results file for more info' + '\x1b[0m')
                logs.write('ERROR: Solc experienced a fatal error. Check the results file for more info\n')

            end = time()

            parse_results(output, tool, os.path.splitext(filename)[0], container, cfg, logs, results_folder,
                start, end, sarif_outputs, file_path_in_repo, output_version)
        finally:
            stop_container(container, logs)
            remove_container(container, logs)
            shutil.rmtree(working_dir)

    except (docker.errors.APIError, docker.errors.ContainerError, docker.errors.ImageNotFound) as err:
        print(err)
        logs.write(err + '\n')
