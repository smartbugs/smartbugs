import os
import shutil
import tempfile
import traceback
from typing import TYPE_CHECKING, Any, Optional

import docker
import docker.models.containers
import requests

import sb.cfg
import sb.errors
import sb.io


if TYPE_CHECKING:
    import sb.tasks


_client: Optional[docker.DockerClient] = None


def client() -> docker.DockerClient:
    global _client
    if not _client:
        try:
            _client = docker.from_env()
            _client.info()
        except Exception:
            details = f"\n{traceback.format_exc()}" if sb.cfg.DEBUG else ""
            raise sb.errors.SmartBugsError(
                f"Docker: Cannot connect to service. Is it installed and running?{details}"
            )
    return _client


images_loaded = set()


def is_loaded(image: str) -> bool:
    if image in images_loaded:
        return True
    try:
        image_list = client().images.list(image)
    except Exception as e:
        raise sb.errors.SmartBugsError(f"Docker: checking for image {image} failed.\n{e}")
    if image_list:
        images_loaded.add(image)
        return True
    return False


def load(image: str) -> None:
    try:
        client().images.pull(image)
    except Exception as e:
        raise sb.errors.SmartBugsError(f"Docker: Loading image {image} failed.\n{e}")
    images_loaded.add(image)


def __docker_volume(task: "sb.tasks.Task") -> str:
    sbdir = tempfile.mkdtemp()
    sbdir_bin = os.path.join(sbdir, "bin")
    if task.tool.mode in ("bytecode", "runtime"):
        # sanitize hex code
        code_lines = sb.io.read_lines(task.absfn)
        code = code_lines[0].strip() if code_lines else ""
        if code.startswith("0x"):
            code = code[2:]
        _, filename = os.path.split(task.absfn)
        sb.io.write_txt(os.path.join(sbdir, filename), code)
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


def __docker_args(task: "sb.tasks.Task", sbdir: str) -> dict[str, Any]:
    args = {"volumes": {sbdir: {"bind": "/sb", "mode": "rw"}}, "detach": True, "user": 0}
    for k in ("image", "cpu_quota", "mem_limit"):
        v = getattr(task.tool, k, None)
        if v is not None:
            args[k] = v
    for k in ("cpu_quota", "mem_limit"):
        v = getattr(task.settings, k, None)
        if v is not None:
            args[k] = v
    filename = f"/sb/{os.path.split(task.absfn)[1]}"  # path in Linux Docker image
    timeout = task.settings.timeout or 0
    main = "1" if task.settings.main else "0"
    args["command"] = task.tool.command(filename, timeout, "/sb/bin", main)
    args["entrypoint"] = task.tool.entrypoint(filename, timeout, "/sb/bin", main)
    return args


def execute(
    task: "sb.tasks.Task",
) -> tuple[Optional[int], list[str], Optional[bytes], dict[str, Any]]:
    sbdir = __docker_volume(task)
    args = __docker_args(task, sbdir)
    exit_code, logs, output, container = None, [], None, None
    try:
        container = client().containers.run(**args)
        try:
            result = container.wait(timeout=task.settings.timeout)
            exit_code = result["StatusCode"]
        except (requests.exceptions.ReadTimeout, requests.exceptions.ConnectionError):
            try:
                container.stop(timeout=10)
            except docker.errors.APIError:
                pass
        logs = container.logs().decode("utf8").splitlines()
        if task.tool.output:
            try:
                output, _ = container.get_archive(task.tool.output)
                output = b"".join(output)
            except docker.errors.NotFound:
                pass

    except Exception as e:
        raise sb.errors.SmartBugsError(f"Problem running Docker container: {e})")

    finally:
        try:
            container.kill()
        except Exception:
            pass
        try:
            container.remove()
        except Exception:
            pass
        shutil.rmtree(sbdir)

    return exit_code, logs, output, args
