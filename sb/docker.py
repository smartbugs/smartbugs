import os
import shutil
import tempfile
import time
import traceback
from typing import TYPE_CHECKING, Any, Optional

import docker
import docker.models.containers
import requests

import sb.debug
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
            sb.debug.log(traceback.format_exc())
            raise sb.errors.SmartBugsError(
                "Docker: Cannot connect to service. Is it installed and running?"
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
        sb.io.write_text(os.path.join(sbdir, filename), code)
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
    for k in ("image", "cpu_quota", "mem_limit", "network"):
        v = getattr(task.tool, k, None)
        if v is not None:
            args[k] = v
    if "network" not in args:
        args["network"] = "none"
    for k in ("cpu_quota", "mem_limit"):
        v = getattr(task.settings, k, None)
        if v is not None:
            args[k] = v
    filename = f"/sb/{os.path.split(task.absfn)[1]}"  # path in Linux Docker image
    timeout = task.settings.timeout or 0
    main = "1" if task.settings.main else "0"
    args["command"] = task.tool.command(filename, timeout, "/sb/bin", main)
    args["entrypoint"] = task.tool.entrypoint(filename, timeout, "/sb/bin", main)
    # Forward the host variables the tool declares under "env:" in its config.yaml.
    # Only variables set on the host are forwarded, so an unset name never overrides
    # a default baked into the image; nothing else of the host environment leaks in.
    env_names = getattr(task.tool, "env", None)
    if env_names:
        names = env_names.replace(",", " ").split()
        environment = {name: os.environ[name] for name in names if name in os.environ}
        if environment:
            args["environment"] = environment
    return args


def _remove_tempdir(sbdir: str, attempts: int = 30, delay: float = 0.5) -> bool:
    """Remove a task's temporary directory, tolerating a transient file lock.

    On Windows, Docker Desktop can still hold a handle on the bind-mounted
    directory when container.remove() has just returned, and removing the
    directory fails with a PermissionError. Raised from the finally block of
    execute(), that exception is not a SmartBugsError, so the worker process
    died before the result files were written while SmartBugs still exited
    with status 0. The lock clears within seconds, so retrying is enough. A
    directory that still cannot be removed is logged and left behind: a
    leftover temporary directory must never cost a finished analysis.

    Returns True if the directory was removed.
    """
    error: Optional[OSError] = None
    for attempt in range(1, attempts + 1):
        try:
            shutil.rmtree(sbdir)
            return True
        except OSError as e:
            error = e
            if attempt < attempts:
                time.sleep(delay)
    sb.debug.log(f"Could not remove temporary directory {sbdir}: {error}")
    return False


def execute(
    task: "sb.tasks.Task",
) -> tuple[Optional[int], list[str], Optional[bytes], dict[str, Any]]:
    sbdir = __docker_volume(task)
    args = __docker_args(task, sbdir)
    exit_code, logs, output, sb_bin_log, container = None, [], None, [], None
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
        try:
            sb_bin_log_path = os.path.join(sbdir, "bin", "log")
            sb_bin_log = sb.io.read_lines(sb_bin_log_path)
        except Exception:
            pass
        _remove_tempdir(sbdir)

    # sb.analysis writes the returned arguments verbatim into smartbugs.json.
    # Forwarded environment values (API keys!) must not end up there; the
    # container has already received the real values.
    if "environment" in args:
        args["environment"] = {name: "<redacted>" for name in args["environment"]}

    return exit_code, logs, output, sb_bin_log, args
