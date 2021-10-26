#!/usr/bin/env python3

import docker
import os
import sys
import yaml
import tempfile
from shutil import copyfile, rmtree

from src.execution.execution_task import Execution_Task
from src.logger import logs
from src.utils import get_solc_version

client = docker.from_env()

def pull_image(image: str):
    """
    pull images
    """
    try:
        logs.print('pulling ' + image + ' image, this may take a while...')
        image = client.images.pull(image)
        logs.print('image pulled')

    except docker.errors.APIError as err:
        logs.print(err)

def mount_volumes(dir_path: str):
    """
    mount volumes
    """
    try:
        volume_bindings = {os.path.abspath(dir_path): {'bind': '/data', 'mode': 'rw'}}
        return volume_bindings
    except os.error as err:
        logs.print(err)


def stop_container(container):
    """
    stop container
    """
    try:
        if container is not None:
            container.stop(timeout=0)
    except (docker.errors.APIError) as err:
        logs.print(err)


def remove_container(container):
    """
    remove container
    """
    try:
        if container is not None:
            container.remove()
    except (docker.errors.APIError) as err:
        logs.print(err)



def analyse_files(task: 'Execution_Task'):
    """
    analyse solidity files
    """
    try:
        cfg_path = os.path.join(os.path.dirname(__file__), '..', '..', 'config', 'tools', task.tool + '.yaml')
        with open(cfg_path, 'r', encoding='utf-8') as ymlfile:
            try:
                cfg = yaml.safe_load(ymlfile)
            except yaml.YAMLError as exc:
                logs.print(exc)

        # create result folder with time
        results_folder = task.result_output_path()
        if not os.path.exists(results_folder):
            os.makedirs(results_folder)
        # os.makedirs(os.path.dirname(results_folder), exist_ok=True)

        # check if config file as all required fields
        if task.execution_configuration.is_bytecode:
            cmd_key = 'cmd_bytecode'
        else:
            cmd_key = 'cmd'

        if 'default' not in cfg['docker_image'] or cfg['docker_image'] == None:
            logs.print(task.tool + ': default docker image not provided. please check you config file.')
            sys.exit(task.tool + ': default docker image not provided. please check you config file.')
        elif cmd_key not in cfg or cfg[cmd_key] == None:
            logs.print(task.tool + ': commands not provided. please check you config file.')
            sys.exit(task.tool + ': commands not provided. please check you config file.')

        file_name = os.path.basename(task.file)
        file_name = os.path.splitext(file_name)[0]

        working_dir = tempfile.mkdtemp()
        copyfile(task.file, os.path.join(working_dir, os.path.basename(task.file)))
        file = os.path.join(working_dir, os.path.basename(task.file))

        # bind directory path instead of file path to allow imports in the same directory
        volume_bindings = mount_volumes(working_dir)

        if not task.execution_configuration.is_bytecode:
            (solc_version, _) = get_solc_version(file)

            if isinstance(solc_version, int) and solc_version < 5 and 'solc<5' in cfg['docker_image']:
                image = cfg['docker_image']['solc<5']
            # if there's no version or version >5, choose default
            else:
                image = cfg['docker_image']['default']
        else:
            image = cfg['docker_image']['default']

        if not client.images.list(image):
            pull_image(image)

        cmd = cfg[cmd_key]

        if '{contract}' in cmd:
            cmd = cmd.replace('{contract}', '/data/' + os.path.basename(file))
        else:
            cmd += ' /data/' + os.path.basename(file)
        container = None
        try:
            container = client.containers.run(image,
                                              cmd,
                                              detach=True,
                                              cpu_quota=task.execution_configuration.cpu_quota,
                                              mem_limit=task.execution_configuration.mem_limit,
                                              volumes=volume_bindings)
            try:
                result = container.wait(timeout=task.execution_configuration.timeout)
                task.exit_code = result['StatusCode']
            except Exception as e:
                print(e)
                pass
            output = container.logs().decode('utf8').strip()
            if (output.count('Solc experienced a fatal error') >= 1 or output.count('compilation failed') >= 1):
                logs.print('\x1b[1;31m' + 'ERROR: Solc experienced a fatal error. Check the results file for more info' + '\x1b[0m', 'ERROR: Solc experienced a fatal error. Check the results file for more info')

            if 'output_in_files' in cfg:
                try:
                    with open(os.path.join(task.result_output_path(), 'result.tar'), 'wb') as f:
                        output_in_file = cfg['output_in_files']['folder']
                        bits, _ = container.get_archive(output_in_file)
                        for chunk in bits:
                            f.write(chunk)
                except Exception as e:
                    logs.print('\x1b[1;31m' + 'ERROR: could not get file from container. file not analysed.' + '\x1b[0m', 'ERROR: could not get file from container. file not analysed.\n')
            return output
        finally:
            rmtree(working_dir)
            stop_container(container)
            remove_container(container)

    except (docker.errors.APIError, docker.errors.ContainerError, docker.errors.ImageNotFound) as err:
        logs.print(err)
