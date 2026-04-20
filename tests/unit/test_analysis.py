import os
from types import SimpleNamespace

import pytest

import sb.analysis


class DummyLock:
    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc, tb):
        return False


class DummyValue:
    def __init__(self, value):
        self.value = value

    def get_lock(self):
        return DummyLock()


class DummyQueue:
    def __init__(self, items=None):
        self.items = list(items or [])
        self.put_calls = []

    def get(self):
        return self.items.pop(0)

    def put(self, item):
        self.put_calls.append(item)
        self.items.append(item)


class FakeProcess:
    def __init__(self, target, args):
        self.target = target
        self.args = args
        self.started = False
        self.joined = False

    def start(self):
        self.started = True

    def join(self):
        self.joined = True


class FakeMPContext:
    def __init__(self):
        self.created_queues = []
        self.created_values = []
        self.created_processes = []

    def Queue(self):  # noqa: N802
        q = DummyQueue()
        self.created_queues.append(q)
        return q

    def Value(self, _typecode, value):  # noqa: N802
        v = DummyValue(value)
        self.created_values.append(v)
        return v

    def Process(self, target, args):  # noqa: N802
        p = FakeProcess(target, args)
        self.created_processes.append(p)
        return p


def make_task(tmp_path, **overrides):
    settings = SimpleNamespace(
        runid="run-1",
        overwrite=False,
        json=False,
        sarif=False,
        quiet=False,
        processes=2,
        timeout=None,
        log="smartbugs.log",
    )
    settings.__dict__.update(overrides.pop("settings", {}))

    tool = SimpleNamespace(
        id="mytool",
        mode="default",
        dict=lambda: {"id": "mytool", "mode": "default"},
    )
    tool.__dict__.update(overrides.pop("tool", {}))

    task = SimpleNamespace(
        relfn="contracts/Test.sol",
        absfn="/abs/contracts/Test.sol",
        rdir=str(tmp_path / "result"),
        settings=settings,
        solc_version="0.8.20",
        tool=tool,
    )
    task.__dict__.update(overrides)
    return task


@pytest.fixture
def cfg(monkeypatch):
    monkeypatch.setattr(sb.analysis.sb.cfg, "TOOL_LOG", "tool.log")
    monkeypatch.setattr(sb.analysis.sb.cfg, "TOOL_OUTPUT", "tool.out")
    monkeypatch.setattr(sb.analysis.sb.cfg, "TASK_LOG", "task.json")
    monkeypatch.setattr(sb.analysis.sb.cfg, "PARSER_OUTPUT", "parsed.json")
    monkeypatch.setattr(sb.analysis.sb.cfg, "SARIF_OUTPUT", "result.sarif")
    monkeypatch.setattr(sb.analysis.sb.cfg, "PLATFORM", "test-platform")


def test_task_log_dict_includes_expected_fields(cfg, tmp_path):
    task = make_task(tmp_path)
    result = sb.analysis.task_log_dict(
        task=task,
        start_time=10.0,
        duration=2.5,
        exit_code=0,
        log=["line1"],
        output=b"bytes",
        sb_bin_log=["debug"],
        docker_args={"image": "x"},
    )

    assert result == {
        "filename": "contracts/Test.sol",
        "runid": "run-1",
        "result": {
            "start": 10.0,
            "duration": 2.5,
            "exit_code": 0,
            "logs": "tool.log",
            "output": "tool.out",
        },
        "debug": {"sb_bin_log": ["debug"]},
        "solc": "0.8.20",
        "tool": {"id": "mytool", "mode": "default"},
        "docker": {"image": "x"},
        "platform": "test-platform",
    }


def test_task_log_dict_omits_log_and_output_when_empty(cfg, tmp_path):
    task = make_task(tmp_path, solc_version=None)
    result = sb.analysis.task_log_dict(
        task=task,
        start_time=1.0,
        duration=0.1,
        exit_code=None,
        log=[],
        output=None,
        sb_bin_log=[],
        docker_args={},
    )

    assert result["result"]["logs"] is None
    assert result["result"]["output"] is None
    assert result["solc"] is None


def test_execute_returns_zero_when_same_task_exists_and_no_overwrite(cfg, tmp_path, monkeypatch):
    task = make_task(tmp_path)

    os.makedirs(task.rdir, exist_ok=True)
    task_log_path = os.path.join(task.rdir, sb.analysis.sb.cfg.TASK_LOG)
    with open(task_log_path, "w", encoding="utf-8") as f:
        f.write("{}")

    monkeypatch.setattr(
        sb.analysis.sb.io,
        "read_json",
        lambda fn: {
            "filename": task.relfn,
            "tool": {"id": task.tool.id, "mode": task.tool.mode},
        },
    )

    called = {"docker": False}
    monkeypatch.setattr(
        sb.analysis.sb.docker,
        "execute",
        lambda _task: called.__setitem__("docker", True),
    )

    duration = sb.analysis.execute(task)

    assert duration == 0.0
    assert called["docker"] is False


def test_execute_raises_if_result_dir_belongs_to_other_task(cfg, tmp_path, monkeypatch):
    task = make_task(tmp_path)

    os.makedirs(task.rdir, exist_ok=True)
    task_log_path = os.path.join(task.rdir, sb.analysis.sb.cfg.TASK_LOG)
    with open(task_log_path, "w", encoding="utf-8") as f:
        f.write("{}")

    monkeypatch.setattr(
        sb.analysis.sb.io,
        "read_json",
        lambda fn: {
            "filename": "other.sol",
            "tool": {"id": "other-tool", "mode": "other-mode"},
        },
    )

    with pytest.raises(sb.analysis.sb.errors.SmartBugsError, match="occupied by another task"):
        sb.analysis.execute(task)


def test_execute_raises_if_result_dir_cannot_be_created(cfg, tmp_path, monkeypatch):
    task = make_task(tmp_path)

    open(task.rdir, "a").close()

    with pytest.raises(
        sb.analysis.sb.errors.SmartBugsError, match=f"Cannot create result directory {task.rdir}"
    ):
        sb.analysis.execute(task)


def test_execute_raises_if_old_results_cannot_be_removed(cfg, tmp_path, monkeypatch):
    task = make_task(tmp_path)
    task.settings.overwrite = True
    os.makedirs(task.rdir, exist_ok=True)

    old_files = [
        os.path.join(task.rdir, sb.analysis.sb.cfg.TASK_LOG),
        os.path.join(task.rdir, sb.analysis.sb.cfg.TOOL_LOG),
        os.path.join(task.rdir, sb.analysis.sb.cfg.TOOL_OUTPUT),
        os.path.join(task.rdir, sb.analysis.sb.cfg.PARSER_OUTPUT),
        os.path.join(task.rdir, sb.analysis.sb.cfg.SARIF_OUTPUT),
    ]
    for fn in old_files:
        with open(fn, "wb") as f:
            f.write(b"old")

    monkeypatch.setattr(
        sb.analysis.sb.io,
        "read_json",
        lambda fn: {
            "filename": task.relfn,
            "tool": {"id": task.tool.id, "mode": task.tool.mode},
        },
    )

    monkeypatch.setattr(
        sb.analysis.os,
        "remove",
        lambda fn: None,
    )

    with pytest.raises(
        sb.analysis.sb.errors.SmartBugsError,
        match=f"Cannot clear old output {os.path.join(task.rdir, sb.analysis.sb.cfg.TASK_LOG)}",
    ):
        sb.analysis.execute(task)


def test_execute_runs_analysis_and_writes_outputs(cfg, tmp_path, monkeypatch):
    task = make_task(tmp_path)
    task.settings.overwrite = True
    os.makedirs(task.rdir, exist_ok=True)

    old_files = [
        os.path.join(task.rdir, sb.analysis.sb.cfg.TASK_LOG),
        os.path.join(task.rdir, sb.analysis.sb.cfg.TOOL_LOG),
        os.path.join(task.rdir, sb.analysis.sb.cfg.TOOL_OUTPUT),
        os.path.join(task.rdir, sb.analysis.sb.cfg.PARSER_OUTPUT),
        os.path.join(task.rdir, sb.analysis.sb.cfg.SARIF_OUTPUT),
    ]
    for fn in old_files:
        with open(fn, "wb") as f:
            f.write(b"old")

    monkeypatch.setattr(
        sb.analysis.sb.io,
        "read_json",
        lambda fn: {
            "filename": task.relfn,
            "tool": {"id": task.tool.id, "mode": task.tool.mode},
        },
    )

    times = iter([100.0, 104.25])
    monkeypatch.setattr(sb.analysis.time, "time", lambda: next(times))

    docker_called = {"count": 0}

    def fake_docker_execute(_task):
        docker_called["count"] += 1
        return 0, ["tool-log"], b"tool-output", ["sb-log"], {"image": "img"}

    monkeypatch.setattr(sb.analysis.sb.docker, "execute", fake_docker_execute)

    writes = {"text": [], "bin": [], "json": []}
    monkeypatch.setattr(
        sb.analysis.sb.io, "write_text", lambda fn, data: writes["text"].append((fn, data))
    )
    monkeypatch.setattr(
        sb.analysis.sb.io, "write_bin", lambda fn, data: writes["bin"].append((fn, data))
    )
    monkeypatch.setattr(
        sb.analysis.sb.io, "write_json", lambda fn, data: writes["json"].append((fn, data))
    )

    duration = sb.analysis.execute(task)

    assert duration == 4.25
    assert docker_called["count"] == 1
    assert writes["text"] == [(os.path.join(task.rdir, "tool.log"), ["tool-log"])]
    assert writes["bin"] == [(os.path.join(task.rdir, "tool.out"), b"tool-output")]
    assert writes["json"][0][0] == os.path.join(task.rdir, "task.json")
    task_log = writes["json"][0][1]
    assert task_log["result"]["start"] == 100.0
    assert task_log["result"]["duration"] == 4.25
    assert task_log["docker"] == {"image": "img"}


def test_execute_parses_and_writes_json(cfg, tmp_path, monkeypatch):
    task = make_task(tmp_path, settings={"json": True, "sarif": False})

    monkeypatch.setattr(sb.analysis.time, "time", lambda: 10.0)
    monkeypatch.setattr(
        sb.analysis.sb.docker,
        "execute",
        lambda _task: (0, ["log"], b"out", ["sb"], {"arg": "x"}),
    )

    parsed = {"findings": [{"id": "F1"}]}
    sarif = {"version": "2.1.0"}

    monkeypatch.setattr(sb.analysis.sb.parsing, "parse", lambda *args: parsed)
    monkeypatch.setattr(sb.analysis.sb.sarif, "sarify", lambda tool, findings: sarif)

    writes = []
    monkeypatch.setattr(sb.analysis.sb.io, "write_text", lambda *args: None)
    monkeypatch.setattr(sb.analysis.sb.io, "write_bin", lambda *args: None)
    monkeypatch.setattr(sb.analysis.sb.io, "write_json", lambda fn, data: writes.append((fn, data)))

    sb.analysis.execute(task)

    assert writes[0][0].endswith("task.json")
    assert writes[1] == (os.path.join(task.rdir, "parsed.json"), parsed)
    assert len(writes) == 2


def test_execute_parses_and_writes_json_sarif(cfg, tmp_path, monkeypatch):
    task = make_task(tmp_path, settings={"json": True, "sarif": True})

    monkeypatch.setattr(sb.analysis.time, "time", lambda: 10.0)
    monkeypatch.setattr(
        sb.analysis.sb.docker,
        "execute",
        lambda _task: (0, ["log"], b"out", ["sb"], {"arg": "x"}),
    )

    parsed = {"findings": [{"id": "F1"}]}
    sarif = {"version": "2.1.0"}

    monkeypatch.setattr(sb.analysis.sb.parsing, "parse", lambda *args: parsed)
    monkeypatch.setattr(sb.analysis.sb.sarif, "sarify", lambda tool, findings: sarif)

    writes = []
    monkeypatch.setattr(sb.analysis.sb.io, "write_text", lambda *args: None)
    monkeypatch.setattr(sb.analysis.sb.io, "write_bin", lambda *args: None)
    monkeypatch.setattr(sb.analysis.sb.io, "write_json", lambda fn, data: writes.append((fn, data)))

    sb.analysis.execute(task)

    assert writes[0][0].endswith("task.json")
    assert writes[1] == (os.path.join(task.rdir, "parsed.json"), parsed)
    assert writes[2] == (os.path.join(task.rdir, "result.sarif"), sarif)
    assert len(writes) == 3


def test_execute_retries_on_smartbugs_error_and_sleeps(cfg, tmp_path, monkeypatch):
    task = make_task(tmp_path)

    monkeypatch.setattr(sb.analysis.time, "time", lambda: 50.0)

    attempts = {"count": 0}

    def fake_execute(_task):
        attempts["count"] += 1
        if attempts["count"] < 3:
            raise sb.analysis.sb.errors.SmartBugsError("docker error")
        return 0, [], None, [], {}

    monkeypatch.setattr(sb.analysis.sb.docker, "execute", fake_execute)
    monkeypatch.setattr(sb.analysis.random, "randint", lambda a, b: 3)

    sleeps = []
    monkeypatch.setattr(sb.analysis.time, "sleep", lambda seconds: sleeps.append(seconds))

    monkeypatch.setattr(sb.analysis.sb.io, "write_text", lambda *args: None)
    monkeypatch.setattr(sb.analysis.sb.io, "write_bin", lambda *args: None)
    monkeypatch.setattr(sb.analysis.sb.io, "write_json", lambda *args: None)

    duration = sb.analysis.execute(task)

    assert duration == 0.0
    assert attempts["count"] == 3
    assert sleeps == [180, 180]


def test_execute_raises_after_third_retry(cfg, tmp_path, monkeypatch):
    task = make_task(tmp_path)

    monkeypatch.setattr(
        sb.analysis.sb.docker,
        "execute",
        lambda _task: (_ for _ in ()).throw(sb.analysis.sb.errors.SmartBugsError("still failing")),
    )
    monkeypatch.setattr(sb.analysis.random, "randint", lambda a, b: 3)
    monkeypatch.setattr(sb.analysis.time, "sleep", lambda seconds: None)

    with pytest.raises(sb.analysis.sb.errors.SmartBugsError, match="still failing"):
        sb.analysis.execute(task)


def test_analyser_processes_task_and_logs_progress(cfg, tmp_path, monkeypatch):
    task = make_task(tmp_path, settings={"processes": 4, "timeout": None})
    logqueue = DummyQueue()
    taskqueue = DummyQueue([task, None])

    tasks_started = DummyValue(0)
    tasks_completed = DummyValue(0)
    time_completed = DummyValue(0.0)

    monkeypatch.setattr(sb.analysis.sb.colors, "tool", lambda x: f"<tool:{x}>")
    monkeypatch.setattr(sb.analysis.sb.colors, "file", lambda x: f"<file:{x}>")

    messages = []
    monkeypatch.setattr(
        sb.analysis.sb.logging,
        "message",
        lambda *args: messages.append(args),
    )
    monkeypatch.setattr(sb.analysis, "execute", lambda _task: 5.0)

    sb.analysis.analyser(
        logqueue=logqueue,
        taskqueue=taskqueue,
        tasks_total=3,
        tasks_started=tasks_started,
        tasks_completed=tasks_completed,
        time_completed=time_completed,
    )

    assert sb.analysis.sb.logging.quiet is False
    assert tasks_started.value == 1
    assert tasks_completed.value == 1
    assert time_completed.value == 5.0
    assert messages[0][0] == "Starting task 1/3: <tool:mytool> and <file:contracts/Test.sol>"
    assert messages[1][0] == "1/3 completed, ETC 0:00:02"


def test_analyser_logs_error_and_uses_zero_duration(cfg, tmp_path, monkeypatch):
    task = make_task(tmp_path, settings={"processes": 2, "timeout": 10})
    logqueue = DummyQueue()
    taskqueue = DummyQueue([task, None])

    tasks_started = DummyValue(0)
    tasks_completed = DummyValue(0)
    time_completed = DummyValue(0.0)

    monkeypatch.setattr(sb.analysis.sb.colors, "tool", lambda x: x)
    monkeypatch.setattr(sb.analysis.sb.colors, "file", lambda x: x)
    monkeypatch.setattr(sb.analysis.sb.colors, "error", lambda x: f"ERR:{x}")
    monkeypatch.setattr(
        sb.analysis,
        "execute",
        lambda _task: (_ for _ in ()).throw(sb.analysis.sb.errors.SmartBugsError("boom")),
    )

    messages = []
    monkeypatch.setattr(sb.analysis.sb.logging, "message", lambda *args: messages.append(args))

    sb.analysis.analyser(
        logqueue=logqueue,
        taskqueue=taskqueue,
        tasks_total=5,
        tasks_started=tasks_started,
        tasks_completed=tasks_completed,
        time_completed=time_completed,
    )

    assert tasks_started.value == 1
    assert tasks_completed.value == 1
    assert time_completed.value == 0.0
    assert "While analyzing /abs/contracts/Test.sol with mytool:\nboom" in messages[1][0]
    assert messages[2][0] == "1/5 completed, ETC 0:00:13"


def test_run_initializes_logging_queues_processes_and_final_message(cfg, monkeypatch, tmp_path):
    tasks = [make_task(tmp_path, relfn="a.sol"), make_task(tmp_path, relfn="b.sol")]
    settings = SimpleNamespace(log="run.log", overwrite=True, processes=3)

    fake_mp = FakeMPContext()
    monkeypatch.setattr(sb.analysis.multiprocessing, "get_context", lambda mode: fake_mp)
    monkeypatch.setattr(sb.analysis.random, "shuffle", lambda items: None)

    lifecycle = {"start": None, "stop": None, "messages": []}
    monkeypatch.setattr(
        sb.analysis.sb.logging,
        "start",
        lambda log, overwrite, logqueue: lifecycle.__setitem__("start", (log, overwrite, logqueue)),
    )
    monkeypatch.setattr(
        sb.analysis.sb.logging, "stop", lambda logqueue: lifecycle.__setitem__("stop", logqueue)
    )
    monkeypatch.setattr(
        sb.analysis.sb.logging,
        "message",
        lambda *args: lifecycle["messages"].append(args),
    )

    times = iter([100.0, 107.0])
    monkeypatch.setattr(sb.analysis.time, "time", lambda: next(times))

    sb.analysis.run(tasks, settings)

    assert lifecycle["start"] == ("run.log", True, fake_mp.created_queues[0])
    assert lifecycle["stop"] is fake_mp.created_queues[0]

    taskqueue = fake_mp.created_queues[1]
    assert taskqueue.put_calls[:2] == tasks
    assert taskqueue.put_calls[2:] == [None, None, None]

    assert len(fake_mp.created_values) == 3
    assert [v.value for v in fake_mp.created_values] == [0, 0, 0.0]

    assert len(fake_mp.created_processes) == 3
    for proc in fake_mp.created_processes:
        assert proc.started is True
        assert proc.joined is True
        assert proc.target is sb.analysis.analyser

    assert lifecycle["messages"][-1][0] == "Analysis completed in 0:00:07."


def test_run_stops_logging_even_when_process_start_fails(cfg, monkeypatch, tmp_path):
    tasks = [make_task(tmp_path)]
    settings = SimpleNamespace(log="run.log", overwrite=False, processes=1)

    class FailingProcess(FakeProcess):
        def start(self):
            raise RuntimeError("cannot start")

    class FailingMP(FakeMPContext):
        def Process(self, target, args):  # noqa: N802
            p = FailingProcess(target, args)
            self.created_processes.append(p)
            return p

    fake_mp = FailingMP()
    monkeypatch.setattr(sb.analysis.multiprocessing, "get_context", lambda mode: fake_mp)
    monkeypatch.setattr(sb.analysis.random, "shuffle", lambda items: None)

    stopped = {"queue": None}
    monkeypatch.setattr(sb.analysis.sb.logging, "start", lambda *args: None)
    monkeypatch.setattr(sb.analysis.sb.logging, "stop", lambda q: stopped.__setitem__("queue", q))

    with pytest.raises(RuntimeError, match="cannot start"):
        sb.analysis.run(tasks, settings)

    assert stopped["queue"] is fake_mp.created_queues[0]
