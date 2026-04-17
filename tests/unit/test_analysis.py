import pytest
from unittest.mock import MagicMock, patch

import sb.errors
import sb.analysis


# ---------------- helpers ----------------

class DummyTool:
    def dict(self):
        return {"id": "t1", "mode": "solidity"}


class DummySettings:
    def __init__(self):
        self.runid = "r1"
        self.overwrite = True
        self.json = False
        self.sarif = False
        self.quiet = False
        self.processes = 1
        self.timeout = None
        self.log = "log"


class DummyTask:
    def __init__(self):
        self.relfn = "file.sol"
        self.absfn = "/tmp/file.sol"
        self.rdir = "/tmp/r"
        self.settings = DummySettings()
        self.solc_version = None
        self.tool = DummyTool()


# ---------------- task_log_dict ----------------

def test_task_log_dict_basic():
    task = DummyTask()

    res = sb.analysis.task_log_dict(
        task,
        start_time=1.0,
        duration=2.0,
        exit_code=0,
        log=["a"],
        output=b"x",
        sb_bin_log=["dbg"],
        docker_args={"k": 1},
    )

    assert res["filename"] == "file.sol"
    assert res["result"]["logs"] is not None
    assert res["result"]["output"] is not None
    assert res["tool"] == {"id": "t1", "mode": "solidity"}


# ---------------- execute ----------------

@patch("sb.analysis.time.sleep", return_value=None)
@patch("sb.analysis.time.time", side_effect=[0.0, 1.0])
@patch("sb.analysis.sb.docker.execute")
@patch("sb.io.write_json")
@patch("sb.io.write_bin")
@patch("sb.io.write_text")
@patch("sb.analysis.os.makedirs")
@patch("sb.analysis.os.path.isdir", return_value=True)
@patch("sb.analysis.os.path.exists", return_value=False)
def test_execute_success(
    mock_exists,
    mock_isdir,
    mock_makedirs,
    mock_wtext,
    mock_wbin,    
    mock_wjson,
    mock_exec,
    mock_time,
    mock_sleep,
):
    task = DummyTask()

    mock_exec.return_value = (0, ["log"], b"out", ["bin"], {"img": 1})

    duration = sb.analysis.execute(task)

    assert duration == 1.0
    assert mock_exec.call_count == 1
    mock_wjson.assert_called_once()


@patch("sb.analysis.time.sleep", return_value=None)
@patch("sb.analysis.time.time", side_effect=[0.0, 1.0, 2.0, 3.0])
@patch("sb.analysis.sb.docker.execute")
@patch("sb.io.write_json")
@patch("sb.io.write_bin")
@patch("sb.io.write_text")
@patch("sb.analysis.os.makedirs")
@patch("sb.analysis.os.path.isdir", return_value=True)
@patch("sb.analysis.os.path.exists", return_value=False)
def test_execute_retry_success_after_failures(
    mock_exists,
    mock_isdir,
    mock_makedirs,
    mock_wtext,
    mock_wbin,    
    mock_wjson,
    mock_exec,
    mock_time,
    mock_sleep,
):
    task = DummyTask()

    mock_exec.side_effect = [
        sb.errors.SmartBugsError("fail1"),
        sb.errors.SmartBugsError("fail2"),
        (0, ["log"], b"out", ["bin"], {"img": 1}),
    ]

    duration = sb.analysis.execute(task)

    assert duration == 1.0
    assert mock_exec.call_count == 3
    assert mock_sleep.call_count == 2


@patch("sb.analysis.os.path.isdir", return_value=False)
@patch("sb.analysis.os.makedirs")
def test_execute_invalid_dir(mock_makedirs, mock_isdir):
    task = DummyTask()
    with pytest.raises(sb.errors.SmartBugsError):
        sb.analysis.execute(task)


# ---------------- analyser ----------------

def test_analyser_exit_on_none():
    logq = MagicMock()
    taskq = MagicMock()
    taskq.get.side_effect = [None]

    started = MagicMock()
    started.get_lock.return_value.__enter__ = lambda *a: None
    started.get_lock.return_value.__exit__ = lambda *a, **k: None
    started.value = 0

    completed = MagicMock()
    completed.get_lock.return_value.__enter__ = lambda *a: None
    completed.get_lock.return_value.__exit__ = lambda *a, **k: None
    completed.value = 0

    time_completed = MagicMock()
    time_completed.get_lock.return_value.__enter__ = lambda *a: None
    time_completed.get_lock.return_value.__exit__ = lambda *a, **k: None
    time_completed.value = 0.0

    sb.analysis.analyser(logq, taskq, 1, started, completed, time_completed)


# ---------------- run ----------------

@patch("sb.analysis.sb.logging.stop")
@patch("sb.analysis.sb.logging.start")
@patch("sb.analysis.multiprocessing.get_context")
@patch("sb.analysis.time.time", side_effect=[0.0, 2.0])
def test_run_basic(mock_time, mock_ctx, mock_start, mock_stop):
    ctx = MagicMock()
    ctx.Queue.return_value = MagicMock()
    ctx.Value.return_value = MagicMock()
    ctx.Process.return_value = MagicMock()

    mock_ctx.return_value = ctx

    task = DummyTask()
    settings = DummySettings()
    settings.processes = 1

    sb.analysis.run([task], settings)

    mock_start.assert_called_once()
    mock_stop.assert_called_once()
