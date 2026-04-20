from types import SimpleNamespace

import pytest
import requests

import sb.docker as mut


class DummyContainer:
    def __init__(
        self,
        *,
        wait_result=None,
        wait_exc=None,
        logs_bytes=b"",
        archive=([], {}),
        archive_exc=None,
        stop_exc=None,
        kill_exc=None,
        remove_exc=None,
    ):
        self.wait_result = wait_result if wait_result is not None else {"StatusCode": 0}
        self.wait_exc = wait_exc
        self.logs_bytes = logs_bytes
        self.archive = archive
        self.archive_exc = archive_exc
        self.stop_exc = stop_exc
        self.kill_exc = kill_exc
        self.remove_exc = remove_exc

        self.wait_calls = []
        self.stop_calls = []
        self.kill_called = 0
        self.remove_called = 0
        self.logs_called = 0
        self.get_archive_calls = []

    def wait(self, timeout=None):
        self.wait_calls.append(timeout)
        if self.wait_exc:
            raise self.wait_exc
        return self.wait_result

    def stop(self, timeout=None):
        self.stop_calls.append(timeout)
        if self.stop_exc:
            raise self.stop_exc

    def logs(self):
        self.logs_called += 1
        return self.logs_bytes

    def get_archive(self, path):
        self.get_archive_calls.append(path)
        if self.archive_exc:
            raise self.archive_exc
        return self.archive

    def kill(self):
        self.kill_called += 1
        if self.kill_exc:
            raise self.kill_exc

    def remove(self):
        self.remove_called += 1
        if self.remove_exc:
            raise self.remove_exc


class DummyClient:
    def __init__(self, *, info_exc=None, images_list=None, images_list_exc=None, pull_exc=None):
        self.info_exc = info_exc
        self.info_called = 0
        self.run_calls = []

        self._images_list = images_list if images_list is not None else []
        self._images_list_exc = images_list_exc
        self._pull_exc = pull_exc

        self.images = SimpleNamespace(list=self.images_list, pull=self.images_pull)
        self.containers = SimpleNamespace(run=self.run)

        self.container_to_return = None

    def info(self):
        self.info_called += 1
        if self.info_exc:
            raise self.info_exc
        return {"ok": True}

    def images_list(self, image):
        if self._images_list_exc:
            raise self._images_list_exc
        return self._images_list

    def images_pull(self, image):
        if self._pull_exc:
            raise self._pull_exc
        return image

    def run(self, **kwargs):
        self.run_calls.append(kwargs)
        return self.container_to_return


@pytest.fixture(autouse=True)
def reset_globals():
    mut._client = None
    mut.images_loaded.clear()
    yield
    mut._client = None
    mut.images_loaded.clear()


def make_task(**overrides):
    tool = SimpleNamespace(
        mode="solidity",
        bin=False,
        absbin="/tool/bin",
        image="img:latest",
        cpu_quota=111,
        mem_limit="128m",
        network=None,
        output="/tmp/output.tar",
        command=lambda filename, timeout, bindir, main: [
            "cmd",
            filename,
            str(timeout),
            bindir,
            main,
        ],
        entrypoint=lambda filename, timeout, bindir, main: [
            "entry",
            filename,
            str(timeout),
            bindir,
            main,
        ],
    )
    settings = SimpleNamespace(
        timeout=30,
        cpu_quota=222,
        mem_limit="256m",
        main=True,
    )
    task = SimpleNamespace(
        absfn="/contracts/Test.sol",
        tool=tool,
        settings=settings,
        solc_path=None,
    )

    for k, v in overrides.items():
        if k == "tool":
            for tk, tv in v.items():
                setattr(tool, tk, tv)
        elif k == "settings":
            for sk, sv in v.items():
                setattr(settings, sk, sv)
        else:
            setattr(task, k, v)
    return task


def test_client_returns_cached_client(monkeypatch):
    dummy = DummyClient()
    monkeypatch.setattr(mut.docker, "from_env", lambda: dummy)

    result1 = mut.client()
    result2 = mut.client()

    assert result1 is dummy
    assert result2 is dummy
    assert dummy.info_called == 1


def test_client_raises_smartbugs_error_and_logs_traceback(monkeypatch):
    logs = []
    monkeypatch.setattr(mut.sb.debug, "log", lambda msg: logs.append(msg))
    monkeypatch.setattr(mut.docker, "from_env", lambda: (_ for _ in ()).throw(RuntimeError("boom")))

    with pytest.raises(mut.sb.errors.SmartBugsError, match="Docker: Cannot connect to service"):
        mut.client()

    assert logs


def test_is_loaded_returns_true_from_cache():
    mut.images_loaded.add("img:1")
    assert mut.is_loaded("img:1") is True


def test_is_loaded_checks_client_and_caches_image(monkeypatch):
    dummy = DummyClient(images_list=["img"])
    monkeypatch.setattr(mut, "client", lambda: dummy)

    assert mut.is_loaded("img:1") is True
    assert "img:1" in mut.images_loaded


def test_is_loaded_returns_false_when_not_present(monkeypatch):
    dummy = DummyClient(images_list=[])
    monkeypatch.setattr(mut, "client", lambda: dummy)

    assert mut.is_loaded("img:1") is False
    assert "img:1" not in mut.images_loaded


def test_is_loaded_wraps_client_errors(monkeypatch):
    dummy = DummyClient(images_list_exc=RuntimeError("list failed"))
    monkeypatch.setattr(mut, "client", lambda: dummy)

    with pytest.raises(mut.sb.errors.SmartBugsError, match="checking for image img:1 failed"):
        mut.is_loaded("img:1")


def test_load_pulls_and_caches_image(monkeypatch):
    dummy = DummyClient()
    monkeypatch.setattr(mut, "client", lambda: dummy)

    mut.load("img:2")

    assert "img:2" in mut.images_loaded


def test_load_wraps_pull_errors(monkeypatch):
    dummy = DummyClient(pull_exc=RuntimeError("pull failed"))
    monkeypatch.setattr(mut, "client", lambda: dummy)

    with pytest.raises(mut.sb.errors.SmartBugsError, match="Loading image img:2 failed"):
        mut.load("img:2")


def test_docker_volume_copies_source_file_for_non_bytecode(monkeypatch, tmp_path):
    copied = []
    made_dirs = []

    monkeypatch.setattr(mut.tempfile, "mkdtemp", lambda: str(tmp_path / "sbdir"))
    monkeypatch.setattr(mut.shutil, "copy", lambda src, dst: copied.append((src, dst)))
    monkeypatch.setattr(mut.os, "mkdir", lambda path: made_dirs.append(path))

    task = make_task(
        absfn="/contracts/Test.sol", tool={"mode": "solidity", "bin": False}, solc_path=None
    )

    result = mut.__docker_volume(task)

    assert result == str(tmp_path / "sbdir")
    assert copied == [("/contracts/Test.sol", str(tmp_path / "sbdir"))]
    assert made_dirs == [str(tmp_path / "sbdir" / "bin")]


def test_docker_volume_sanitizes_bytecode_and_writes_text(monkeypatch, tmp_path):
    writes = []
    monkeypatch.setattr(mut.tempfile, "mkdtemp", lambda: str(tmp_path / "sbdir"))
    monkeypatch.setattr(mut.sb.io, "read_lines", lambda path: ["0xabc123\n"])
    monkeypatch.setattr(mut.sb.io, "write_text", lambda path, text: writes.append((path, text)))
    monkeypatch.setattr(mut.os, "mkdir", lambda path: None)

    task = make_task(
        absfn="/contracts/code.hex", tool={"mode": "bytecode", "bin": False}, solc_path=None
    )

    result = mut.__docker_volume(task)

    assert result == str(tmp_path / "sbdir")
    assert writes == [(str(tmp_path / "sbdir" / "code.hex"), "abc123")]


def test_docker_volume_keeps_bytecode_without_0x_prefix(monkeypatch, tmp_path):
    writes = []
    monkeypatch.setattr(mut.tempfile, "mkdtemp", lambda: str(tmp_path / "sbdir"))
    monkeypatch.setattr(mut.sb.io, "read_lines", lambda path: ["deadbeef\n"])
    monkeypatch.setattr(mut.sb.io, "write_text", lambda path, text: writes.append((path, text)))
    monkeypatch.setattr(mut.os, "mkdir", lambda path: None)

    task = make_task(
        absfn="/contracts/code.hex", tool={"mode": "runtime", "bin": False}, solc_path=None
    )

    mut.__docker_volume(task)

    assert writes == [(str(tmp_path / "sbdir" / "code.hex"), "deadbeef")]


def test_docker_volume_copies_tool_bin_and_solc(monkeypatch, tmp_path):
    copy_calls = []
    copytree_calls = []

    monkeypatch.setattr(mut.tempfile, "mkdtemp", lambda: str(tmp_path / "sbdir"))
    monkeypatch.setattr(mut.shutil, "copy", lambda src, dst: copy_calls.append((src, dst)))
    monkeypatch.setattr(mut.shutil, "copytree", lambda src, dst: copytree_calls.append((src, dst)))
    monkeypatch.setattr(mut.shutil, "copyfile", lambda src, dst: copy_calls.append((src, dst)))

    task = make_task(
        absfn="/contracts/Test.sol",
        tool={"mode": "solidity", "bin": True, "absbin": "/tool/bin"},
        solc_path="/usr/bin/solc",
    )

    mut.__docker_volume(task)

    assert ("/contracts/Test.sol", str(tmp_path / "sbdir")) in copy_calls
    assert copytree_calls == [("/tool/bin", str(tmp_path / "sbdir" / "bin"))]
    assert ("/usr/bin/solc", str(tmp_path / "sbdir" / "bin" / "solc")) in copy_calls


def test_docker_args_uses_tool_values_then_overrides_with_settings():
    task = make_task(
        absfn="/contracts/Test.sol",
        tool={"network": None, "cpu_quota": 100, "mem_limit": "64m", "image": "myimg"},
        settings={"cpu_quota": 200, "mem_limit": "512m", "timeout": 45, "main": True},
    )

    args = mut.__docker_args(task, "/tmp/sbdir")

    assert args["volumes"] == {"/tmp/sbdir": {"bind": "/sb", "mode": "rw"}}
    assert args["detach"] is True
    assert args["user"] == 0
    assert args["image"] == "myimg"
    assert args["cpu_quota"] == 200
    assert args["mem_limit"] == "512m"
    assert args["network"] == "none"
    assert args["command"] == ["cmd", "/sb/Test.sol", "45", "/sb/bin", "1"]
    assert args["entrypoint"] == ["entry", "/sb/Test.sol", "45", "/sb/bin", "1"]


def test_docker_args_preserves_tool_network_and_handles_falsey_timeout_and_main():
    task = make_task(
        absfn="/contracts/Test.sol",
        tool={"network": "bridge"},
        settings={"timeout": None, "main": False, "cpu_quota": None, "mem_limit": None},
    )

    args = mut.__docker_args(task, "/tmp/sbdir")

    assert args["network"] == "bridge"
    assert args["command"] == ["cmd", "/sb/Test.sol", "0", "/sb/bin", "0"]
    assert args["entrypoint"] == ["entry", "/sb/Test.sol", "0", "/sb/bin", "0"]


def test_execute_runs_container_and_collects_outputs(monkeypatch):
    container = DummyContainer(
        wait_result={"StatusCode": 7},
        logs_bytes=b"line1\nline2\n",
        archive=([b"a", b"b"], {}),
    )
    dummy_client = DummyClient()
    dummy_client.container_to_return = container

    monkeypatch.setattr(mut, "__docker_volume", lambda task: "/tmp/sbdir")
    monkeypatch.setattr(mut, "__docker_args", lambda task, sbdir: {"image": "img"})
    monkeypatch.setattr(mut, "client", lambda: dummy_client)
    monkeypatch.setattr(mut.sb.io, "read_lines", lambda path: ["sb-bin-log"])
    removed = []
    monkeypatch.setattr(mut.shutil, "rmtree", lambda path: removed.append(path))

    task = make_task(tool={"output": "/tmp/output.tar"}, settings={"timeout": 12})

    exit_code, logs, output, sb_bin_log, args = mut.execute(task)

    assert exit_code == 7
    assert logs == ["line1", "line2"]
    assert output == b"ab"
    assert sb_bin_log == ["sb-bin-log"]
    assert args == {"image": "img"}
    assert dummy_client.run_calls == [{"image": "img"}]
    assert container.wait_calls == [12]
    assert container.logs_called == 1
    assert container.get_archive_calls == ["/tmp/output.tar"]
    assert container.kill_called == 1
    assert container.remove_called == 1
    assert removed == ["/tmp/sbdir"]


def test_execute_handles_timeout_and_stops_container(monkeypatch):
    container = DummyContainer(
        wait_exc=requests.exceptions.ReadTimeout("timeout"),
        logs_bytes=b"log1\n",
    )
    dummy_client = DummyClient()
    dummy_client.container_to_return = container

    monkeypatch.setattr(mut, "__docker_volume", lambda task: "/tmp/sbdir")
    monkeypatch.setattr(mut, "__docker_args", lambda task, sbdir: {"image": "img"})
    monkeypatch.setattr(mut, "client", lambda: dummy_client)
    monkeypatch.setattr(mut.sb.io, "read_lines", lambda path: [])
    monkeypatch.setattr(mut.shutil, "rmtree", lambda path: None)

    task = make_task(tool={"output": None}, settings={"timeout": 9})

    exit_code, logs, output, sb_bin_log, args = mut.execute(task)

    assert exit_code is None
    assert logs == ["log1"]
    assert output is None
    assert sb_bin_log == []
    assert container.stop_calls == [10]
    assert container.kill_called == 1
    assert container.remove_called == 1


def test_execute_ignores_stop_api_error_after_connection_error(monkeypatch):
    api_error = mut.docker.errors.APIError("api")
    container = DummyContainer(
        wait_exc=requests.exceptions.ConnectionError("conn"),
        logs_bytes=b"",
        stop_exc=api_error,
    )
    dummy_client = DummyClient()
    dummy_client.container_to_return = container

    monkeypatch.setattr(mut, "__docker_volume", lambda task: "/tmp/sbdir")
    monkeypatch.setattr(mut, "__docker_args", lambda task, sbdir: {"image": "img"})
    monkeypatch.setattr(mut, "client", lambda: dummy_client)
    monkeypatch.setattr(mut.sb.io, "read_lines", lambda path: [])
    monkeypatch.setattr(mut.shutil, "rmtree", lambda path: None)

    task = make_task(tool={"output": None})

    exit_code, logs, output, sb_bin_log, args = mut.execute(task)

    assert exit_code is None
    assert logs == []
    assert output is None
    assert sb_bin_log == []


def test_execute_ignores_missing_output_archive(monkeypatch):
    not_found = mut.docker.errors.NotFound("missing")
    container = DummyContainer(
        wait_result={"StatusCode": 0},
        logs_bytes=b"",
        archive_exc=not_found,
    )
    dummy_client = DummyClient()
    dummy_client.container_to_return = container

    monkeypatch.setattr(mut, "__docker_volume", lambda task: "/tmp/sbdir")
    monkeypatch.setattr(mut, "__docker_args", lambda task, sbdir: {"image": "img"})
    monkeypatch.setattr(mut, "client", lambda: dummy_client)
    monkeypatch.setattr(mut.sb.io, "read_lines", lambda path: [])
    monkeypatch.setattr(mut.shutil, "rmtree", lambda path: None)

    task = make_task(tool={"output": "/tmp/missing"})

    exit_code, logs, output, sb_bin_log, args = mut.execute(task)

    assert exit_code == 0
    assert output is None
    assert container.get_archive_calls == ["/tmp/missing"]


def test_execute_wraps_run_errors_and_still_cleans_up(monkeypatch):
    dummy_client = DummyClient()

    def boom(**kwargs):
        raise RuntimeError("run failed")

    dummy_client.containers = SimpleNamespace(run=boom)

    monkeypatch.setattr(mut, "__docker_volume", lambda task: "/tmp/sbdir")
    monkeypatch.setattr(mut, "__docker_args", lambda task, sbdir: {"image": "img"})
    monkeypatch.setattr(mut, "client", lambda: dummy_client)

    read_lines_calls = []
    monkeypatch.setattr(
        mut.sb.io, "read_lines", lambda path: read_lines_calls.append(path) or ["binlog"]
    )
    removed = []
    monkeypatch.setattr(mut.shutil, "rmtree", lambda path: removed.append(path))

    task = make_task()

    with pytest.raises(
        mut.sb.errors.SmartBugsError, match=r"Problem running Docker container: run failed\)"
    ):
        mut.execute(task)

    assert read_lines_calls == ["/tmp/sbdir/bin/log"]
    assert removed == ["/tmp/sbdir"]


def test_execute_ignores_cleanup_errors(monkeypatch):
    container = DummyContainer(
        wait_result={"StatusCode": 0},
        logs_bytes=b"",
        kill_exc=RuntimeError("kill"),
        remove_exc=RuntimeError("remove"),
    )
    dummy_client = DummyClient()
    dummy_client.container_to_return = container

    monkeypatch.setattr(mut, "__docker_volume", lambda task: "/tmp/sbdir")
    monkeypatch.setattr(mut, "__docker_args", lambda task, sbdir: {"image": "img"})
    monkeypatch.setattr(mut, "client", lambda: dummy_client)
    monkeypatch.setattr(
        mut.sb.io,
        "read_lines",
        lambda path: (_ for _ in ()).throw(RuntimeError("no bin log")),
    )
    monkeypatch.setattr(mut.shutil, "rmtree", lambda path: None)

    task = make_task(tool={"output": None})

    exit_code, logs, output, sb_bin_log, args = mut.execute(task)

    assert exit_code == 0
    assert logs == []
    assert output is None
    assert sb_bin_log == []
