#!/usr/bin/env python3

import docker, os, shutil, tempfile, requests
from sb.exceptions import SmartBugsError

try:    
    client = docker.from_env()
    client.info()
except:
    raise SmartBugsError("Docker: Cannot connect to service. Is it installed and running?")

images_loaded = set()

def is_loaded(image):
    try:
        return image in images_loaded or client.images.list(image)
    except BaseException as e:
        raise SmartBugsError(f"Docker: checking for image {image} failed.\n{e}")

def load(image):
    try:
        client.images.pull(image)
        images_loaded.add(image)
    except BaseException as e:
        raise SmartBugsError(f"Docker: Loading image {image} failed.\n{e}")

def __run_volume(task):
    sbdir = tempfile.mkdtemp()
    sbdir_bin = os.path.join(sbdir, "bin")
    shutil.copy(task.absfn, sbdir)
    os.mkdir(sbdir_bin)
    if task.tool.bin:
        shutil.copytree(task.tool.bin, sbdir_bin, dirs_exist_ok=True)
    if task.solc_path:
        sbdir_bin_solc = os.path.join(sbdir_bin, "solc")
        shutil.copyfile(task.solc_path, sbdir_bin_solc)
    return sbdir

def __run_args(task, sbdir):
    args = {
        "volumes": {sbdir: {"bind": "/sb", "mode": "rw"}},
        "detach": True
    }
    for k in ("image","user","cpu_quota","mem_limit"):
        if (v := getattr(task.tool, k, None)) is not None:
            args[k] = v
    for k in ("cpu_quota","mem_limit"):
        if (v := getattr(task.settings, k, None)) is not None:
            args[k] = v
    _,filename = os.path.split(task.absfn)
    filename = f"/sb/{filename}" # path in Linux Docker image
    timeout = task.settings.timeout or "0"
    args['command'] = task.tool.command(filename, timeout, "/sb/bin")
    args['entrypoint'] = task.tool.entrypoint(filename, timeout, "/sb/bin")
    return args

def execute(task):
    sbdir = __run_volume(task)
    args = __run_args(task, sbdir)
    exit_code = None
    logs = None
    output = None
    container = None
    try:
        container = client.containers.run(**args)
        try:
            result = container.wait(timeout=task.settings.timeout)
            exit_code = result["StatusCode"]
        except (requests.exceptions.ReadTimeout, requests.exceptions.ConnectionError):
            # The docs say that timeout raises ReadTimeout, but sometimes it is ConnectionError
            container.stop(timeout=0)
        logs = container.logs().decode('utf8').strip()
        if task.tool.output:
            output,_ = container.get_archive(task.tool.output)
    finally:
        if container:
            container.stop(timeout=0)
            container.remove()
        shutil.rmtree(sbdir)
    return args, exit_code, logs, output
