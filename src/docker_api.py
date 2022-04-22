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

try:
    client = docker.from_env()
    client.info()
except:
    print(col.error("Please make sure that docker is installed and running."))
    sys.exit(1)

def pull_image(logqueue, image):
    if client.images.list(image):
        return
    try:
        log.message(logqueue, f"Pulling image {image}, this may take a while ...")
        client.images.pull(image)
        log.message(logqueue, f"Image {image} pulled")
    except Exception as err:
        log.message(logqueue, col.error(f"Error pulling image {image}.\n{err}"))
        sys.exit(1)


def volume_binding(logqueue, dir_path):
    try:
        return {os.path.abspath(dir_path): {'bind': '/data', 'mode': 'rw'}}
    except Exception as err:
        log.message(logqueue, col.error(f"Error constructing volume binding for {dir_path}.\n{err}"))
        sys.exit(1)


def stop_container(logqueue, container):
    try:
        if container is not None:
            container.stop(timeout=0)
    except Exception as err:
        log.message(logqueue, col.error(f"Error stopping container.\n{err}"))
        sys.exit(1)


def remove_container(logqueue, container):
    try:
        if container is not None:
            container.remove()
    except Exception as err:
        log.message(logqueue, col.error(f"Error removing container.\n{err}"))
        sys.exit(1)


def run(logqueue, file, tool, results_folder):
    start_time = time.time()
    results = {
        "contract": file,
        "tool": tool["name"],
        "start": start_time,
        "end": start_time,
        "duration": 0,
        "exit_code": None
    }
    result_log = None
    result_tar = None
    
    working_dir = tempfile.mkdtemp()
    working_bin_dir = os.path.join(working_dir, "bin")
    shutil.copy(file, working_dir)
    shutil.copytree(os.path.join(config.TOOLS_CFG_PATH,tool["name"]), working_bin_dir)
    solc_compiler = solidity.get_solc(file)
    if not solc_compiler:
        log.message(logqueue, col.error(f"No compiler found for file '{file}'. Does it contain a version pragma?"))
        return results, result_log, result_tar
    shutil.copyfile(solc_compiler, os.path.join(working_bin_dir, "solc"))
    volumes = volume_binding(logqueue, working_dir)

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
            results["exit_code"] = result["StatusCode"]
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
            log.message(logqueue, col.error(f"{tool['name']}, {file}: Failing to write output of container to {result_log}.\n{err}"))
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
                log.message(logqueue, col.error(f"{tool['name']}, {file}: Failing to copy {output_folder} from container to {result_tar}.\n{err}"))
                result_tar = None

    except Exception as err:
        log.message(logqueue, col.error(f"{tool['name']}, {file}: docker run failed.\n{err}"))
    finally:
        stop_container(logqueue, container)
        remove_container(logqueue, container)
        shutil.rmtree(working_dir)
    results["end"] = time.time()
    results["duration"] = results["end"] - results["start"]

    try:
        smartbugs_json = os.path.join(results_folder, "smartbugs.json")
        with open(smartbugs_json, 'w') as f:
            json.dump(results, f, indent=2)
    except Exception as err:
        log.message(logqueue, col.error(f"{tool['name']}, {file}: Failing to write {smartbugs_json}.\n{err}"))

    return results, result_log, result_tar

