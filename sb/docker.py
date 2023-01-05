#!/usr/bin/env python3

import docker, os, shutil, tempfile, requests
import sb.io, io
from sb.exceptions import SmartBugsError
import docker.errors

_client = None

def client():
    global _client
    if not _client:
        try:    
            _client = docker.from_env()
            _client.info()
        except:
            raise SmartBugsError("Docker: Cannot connect to service. Is it installed and running?")
    return _client

images_loaded = set()

def is_loaded(image):
    try:
        return image in images_loaded or client().images.list(image)
    except Exception as e:
        raise SmartBugsError(f"Docker: checking for image {image} failed.\n{e}")

def load(image):
    try:
        client().images.pull(image)
        images_loaded.add(image)
    except Exception as e:
        raise SmartBugsError(f"Docker: Loading image {image} failed.\n{e}")

def __docker_volume(task):
    sbdir = tempfile.mkdtemp()
    sbdir_bin = os.path.join(sbdir, "bin")
    if task.tool.mode in ("bytecode","runtime"):
        # sanitize hex code
        code = sb.io.read_lines(task.absfn)
        code = code[0].strip() if code else ""
        if code.startswith("0x"):
            code = code[2:]
        _,filename = os.path.split(task.absfn)
        sb.io.write_txt(os.path.join(sbdir,filename), code)
    else:
        shutil.copy(task.absfn, sbdir)
    if task.tool.bin:
        shutil.copytree(task.tool.absbin, sbdir_bin)
    else:
        os.mkdir(sbdir_bin)
    if task.solc_path:
        sbdir_bin_solc = os.path.join(sbdir_bin, "solc")
        shutil.copyfile(task.solc_path, sbdir_bin_solc)
    return sbdir

def __docker_args(task, sbdir):
    args = {
        "volumes": {sbdir: {"bind": "/sb", "mode": "rw"}},
        "detach": True,
        "user": 0
    }
    for k in ("image","cpu_quota","mem_limit"):
        v = getattr(task.tool, k, None)
        if v is not None:
            args[k] = v
    for k in ("cpu_quota","mem_limit"):
        v = getattr(task.settings, k, None)
        if v is not None:
            args[k] = v
    _,filename = os.path.split(task.absfn)
    filename = f"/sb/{filename}" # path in Linux Docker image
    timeout = task.settings.timeout or "0"
    args['command'] = task.tool.command(filename, timeout, "/sb/bin")
    args['entrypoint'] = task.tool.entrypoint(filename, timeout, "/sb/bin")
    return args

def execute(task):
    sbdir = __docker_volume(task)
    args = __docker_args(task, sbdir)
    exit_code,logs,output,container = None,[],None,None
    try:
        container = client().containers.run(**args)
        try:
            result = container.wait(timeout=task.settings.timeout)
            exit_code = result["StatusCode"]
        except (requests.exceptions.ReadTimeout, requests.exceptions.ConnectionError):
            # The docs say that timeout raises ReadTimeout, but sometimes it is ConnectionError
            container.stop(timeout=0)
        logs = container.logs().decode("utf8").splitlines()
        if task.tool.output:
            try:
                output,_ = container.get_archive(task.tool.output)
                output = b''.join(output)
            except docker.errors.NotFound:
                pass
    finally:
        if container:
            container.stop(timeout=0)
            container.remove()
        shutil.rmtree(sbdir)
    return exit_code, logs, output, args
