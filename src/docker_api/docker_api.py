#!/usr/bin/env python3

import docker
import yaml
import logging
import os
import sys
from solidity_parser import parser
from time import gmtime, strftime

client = docker.from_env()

"""
get solidity compiler version
"""
def get_solc_verion(file, logs):
    try:
        sourceUnit = parser.parse_file(file)
        solc_version = sourceUnit['children'][0]['value']
        solc_version = solc_version.strip('^')
        solc_version = solc_version.split('.')
        return(int(solc_version[1]))
    except:
        print('\x1b[1;33m' + 'WARNING: could not parse solidity file to get solc version' + '\x1b[0m')
        logs.write('WARNING: could not parse solidity file to get solc version \n')


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
def mount_volumes(file, logs):
    try:
        volume_bindings = {os.path.abspath(file): {'bind': '/' + file, 'mode': 'ro'}}
        return volume_bindings
    except os.error as err:
        print(err)
        logs.write(err + '\n')



"""
stop container
"""
def stop_container(container, logs):
    try:
        container.stop()
    except (docker.errors.APIError) as err:
        print(err)
        logs.write(err + '\n')


"""
remove container
"""
def remove_container(container, logs):
    try:
        container.remove()
    except (docker.errors.APIError) as err:
        print(err)
        logs.write(err + '\n')


"""
write output
"""
def parse_results(output, tool, file_name, container, cfg, logs, results_folder):

    if 'output_in_files' in cfg:
        try:
            with open(results_folder + '/' + file_name +'.tar', 'wb') as f:
                bits, stat = container.get_archive(cfg['output_in_files']['folder'])
                for chunk in bits:
                    f.write(chunk)
                f.close()
        except:
            print('\x1b[1;31m' + 'ERROR: could not get file from container. file not analised.' + '\x1b[0m')
            logs.write('ERROR: could not get file from container. file not analised.\n' )
    else:
        with open(results_folder + '/' + file_name  +'.txt', 'w') as f:
            for log in output:
                f.write(log)
            f.close()


"""
analyse solidity files
"""
def analyse_files(tool, file, logs, now):
    try:
        cfg_path = os.path.abspath('config/tools/'+tool+'.yaml')
        with open(cfg_path, 'r') as ymlfile:
            try:
                cfg = yaml.safe_load(ymlfile)
            except yaml.YAMLError as exc:
                print(exc)
                logs.write(exc)

        #create result folder with time
        results_folder = 'results/' + tool + '/' + now
        if not os.path.exists(results_folder):
            os.makedirs(results_folder)
        #os.makedirs(os.path.dirname(results_folder), exist_ok=True)

        #check if config file as all required fields
        if 'default' not in cfg['docker_image'] or cfg['docker_image'] == None:
            logs.write(tool + ': default docker image not provided. please check you config file.\n')
            sys.exit(tool + ': default docker image not provided. please check you config file.')
        elif 'cmd' not in cfg or cfg['cmd'] == None:
            logs.write(tool + ': commands not provided. please check you config file.\n')
            sys.exit(tool + ': commands not provided. please check you config file.')


        volume_bindings = mount_volumes(file, logs)

        file_name = os.path.basename(file)
        file_name = os.path.splitext(file_name)[0]

        sys.stdout.write('\x1b[1;37m' + 'Analysing file: ' + '\x1b[0m')
        sys.stdout.write('\x1b[1;34m' + file + '\x1b[0m')
        sys.stdout.write('\x1b[1;37m' + ' [' + tool + ']' + '\x1b[0m' + '\n')
        logs.write('Analysing file: ' + file + ' [' + tool + ']\n')

        solc_version = get_solc_verion(file, logs)

        if isinstance(solc_version, int) and solc_version < 5 and 'solc<5' in cfg['docker_image']:
            image = cfg['docker_image']['solc<5']
        #if there's no version or version >5, choose default
        else:
            image = cfg['docker_image']['default']


        if not client.images.list(image):
            pull_image(image, logs)

        cmd = cfg['cmd'] + ' /' + file
        container = client.containers.run(image,
                                            cmd,
                                            detach=True,
                                            #entrypoint='ls',
                                            volumes=volume_bindings)

        container.wait()
        output = container.logs().decode('utf8').strip()
        if (output.count('Solc experienced a fatal error') >= 1 or output.count('compilation failed') >= 1):
            print('\x1b[1;31m' + 'ERROR: Solc experienced a fatal error. Check the results file for more info' + '\x1b[0m')
            logs.write('ERROR: Solc experienced a fatal error. Check the results file for more info\n')

        parse_results(output, tool, file_name, container, cfg, logs, results_folder)

        stop_container(container, logs)
        remove_container(container, logs)

    except (docker.errors.APIError, docker.errors.ContainerError, docker.errors.ImageNotFound) as err:
        print(err)
        logs.write(err + '\n' )
