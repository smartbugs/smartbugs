"""Tests for sb.docker._remove_tempdir() and its use in execute()."""

import sb.docker as mut
from tests.unit.test_docker import DummyClient, DummyContainer, make_task


def test_remove_tempdir_removes_the_directory(tmp_path):
    sbdir = tmp_path / "sbdir"
    sbdir.mkdir()
    (sbdir / "bin").mkdir()

    assert mut._remove_tempdir(str(sbdir)) is True
    assert not sbdir.exists()


def test_remove_tempdir_survives_a_transient_lock(monkeypatch):
    calls = []

    def rmtree(path):
        calls.append(path)
        if len(calls) < 3:
            raise PermissionError("still in use")

    monkeypatch.setattr(mut.shutil, "rmtree", rmtree)
    sleeps = []
    monkeypatch.setattr(mut.time, "sleep", lambda seconds: sleeps.append(seconds))

    assert mut._remove_tempdir("/tmp/sbdir", attempts=5, delay=0.1) is True
    assert calls == ["/tmp/sbdir"] * 3
    assert sleeps == [0.1, 0.1]


def test_remove_tempdir_logs_a_permanent_lock_instead_of_raising(monkeypatch):
    def rmtree(path):
        raise PermissionError("still in use")

    monkeypatch.setattr(mut.shutil, "rmtree", rmtree)
    monkeypatch.setattr(mut.time, "sleep", lambda seconds: None)
    logged = []
    monkeypatch.setattr(mut.sb.debug, "log", lambda message: logged.append(message))

    assert mut._remove_tempdir("/tmp/sbdir", attempts=3, delay=0) is False
    assert len(logged) == 1
    assert "/tmp/sbdir" in logged[0]


def test_execute_returns_the_result_even_if_the_tempdir_stays_locked(monkeypatch):
    container = DummyContainer(wait_result={"StatusCode": 3}, logs_bytes=b"done\n")
    dummy_client = DummyClient()
    dummy_client.container_to_return = container

    monkeypatch.setattr(mut, "__docker_volume", lambda task: "/tmp/sbdir")
    monkeypatch.setattr(mut, "__docker_args", lambda task, sbdir: {"image": "img"})
    monkeypatch.setattr(mut, "client", lambda: dummy_client)
    monkeypatch.setattr(mut.sb.io, "read_lines", lambda path: [])
    monkeypatch.setattr(mut.time, "sleep", lambda seconds: None)
    monkeypatch.setattr(mut.sb.debug, "log", lambda message: None)

    def rmtree(path):
        raise PermissionError("still in use")

    monkeypatch.setattr(mut.shutil, "rmtree", rmtree)

    exit_code, logs, *_ = mut.execute(make_task(tool={"output": None}))

    assert exit_code == 3
    assert logs == ["done"]
