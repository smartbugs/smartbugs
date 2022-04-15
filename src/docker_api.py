#!/usr/bin/env python3

import docker
import os
import sys
import tarfile
import tempfile
import shutil
import time
import json
import requests

import src.solidity as solidity
import src.config as config
import src.logging as log
import src.colors as col

client = docker.from_env()

def pull_image(image):
    if client.images.list(image):
        return
    try:
        log.message(f"Pulling image {image}, this may take a while ...")
        client.images.pull(image)
        log.message(f"Image {image} pulled")
    except Exception as err:
        log.message(col.error(f"Error pulling image {image}.\n{err}"))
        sys.exit(1)


def volume_binding(dir_path):
    try:
        return {os.path.abspath(dir_path): {'bind': '/data', 'mode': 'rw'}}
    except Exception as err:
        log.message(col.error(f"Error constructing volume binding for {dir_path}.\n{err}"))
        sys.exit(1)


def stop_container(container):
    try:
        if container is not None:
            container.stop(timeout=0)
    except Exception as err:
        log.message(col.error(f"Error stopping container.\n{err}"))
        sys.exit(1)


def remove_container(container):
    try:
        if container is not None:
            container.remove()
    except Exception as err:
        log.message(col.error(f"Error removing container.\n{err}"))
        sys.exit(1)


def run(file, tool, results_folder):
    working_dir = tempfile.mkdtemp()
    working_bin_dir = os.path.join(working_dir, "bin")
    shutil.copy(file, working_dir)
    shutil.copytree(os.path.join(config.TOOLS_CFG_PATH,tool["name"]), working_bin_dir)
    solc_compiler = solidity.get_solc(file)
    shutil.copyfile(solc_compiler, os.path.join(working_bin_dir, "solc"))
    volumes = volume_binding(working_dir)

    exit_code = None
    result_log = None
    result_tar = None
    start_time = time.time()
    try:
        container = client.containers.run(tool["docker_image"],
                                          entrypoint = f"/data/bin/run_solidity /data/{os.path.basename(file)}",
                                          detach=True,
                                          user = 0,
                                          # cpu_quota=150000,
                                          volumes=volumes
                                          )
        try:
            result = container.wait(timeout=(30 * 60))
            exit_code = result['StatusCode']
        except (requests.exceptions.ReadTimeout, requests.exceptions.ConnectionError):
            # according to the docs, timeout gives ReadTimeout, but sometimes it is ConnectionError
            pass

        output = container.logs().decode('utf8').strip()
        if output is None:
            output = ''
        try:
            result_log = os.path.join(results_folder, "result.log")
            with open(result_log, 'w', encoding='utf-8') as f:
                f.write(output)
        except Exception as err:
            log.message(col.error(f"{tool['name']}, {file}: Failing to write output of container to {result_log}.\n{err}"))
            result_log = None

        if "output_in_files" in tool and "folder" in tool["output_in_files"]:
            try:
                output_folder = tool["output_in_files"]["folder"]
                output_tar, _ = container.get_archive(output_folder)
                result_tar = os.path.join(results_folder, "result.tar")
                with open(result_tar, 'wb') as f:
                    for chunk in output_tar:
                        f.write(chunk)
            except Exception as err:
                log.message(col.error(f"{tool['name']}, {file}: Failing to copy {output_folder} from container to {result_tar}.\n{err}"))
                result_tar = None

    except Exception as err:
        log.message(col.error(f"{tool['name']}, {file}: docker run failed.\n{err}"))
    finally:
        stop_container(container)
        remove_container(container)
        shutil.rmtree(working_dir)
    end_time = time.time()

    results = {
        "contract": file,
        "tool": tool["name"],
        "start": start_time,
        "end": end_time,
        "duration": end_time-start_time,
        "exit_code": exit_code
    }
    
    try:
        smartbugs_json = os.path.join(results_folder, "smartbugs.json")
        with open(smartbugs_json, 'w') as f:
            json.dump(results, f, indent=2)
    except Exception as err:
        log.message(col.error(f"{tool['name']}, {file}: Failing to write {smartbugs_json}.\n{err}"))

    return results, result_log, result_tar

