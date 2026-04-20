import sys

import pytest

import sb.reparse as mut


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
        self.queues = []
        self.processes = []

    def Queue(self):  # noqa: N802
        q = DummyQueue()
        self.queues.append(q)
        return q

    def Process(self, target, args):  # noqa: N802
        p = FakeProcess(target, args)
        self.processes.append(p)
        return p


@pytest.fixture
def patched_cfg(monkeypatch):
    monkeypatch.setattr(mut.sb.cfg, "TASK_LOG", "task.json")
    monkeypatch.setattr(mut.sb.cfg, "TOOL_LOG", "tool.log")
    monkeypatch.setattr(mut.sb.cfg, "TOOL_OUTPUT", "tool.out")
    monkeypatch.setattr(mut.sb.cfg, "PARSER_OUTPUT", "parsed.json")
    monkeypatch.setattr(mut.sb.cfg, "SARIF_OUTPUT", "result.sarif")


def test_reparser_skips_when_task_log_missing_verbose(patched_cfg, monkeypatch, capsys):
    queue = DummyQueue(["/results/task1", None])

    monkeypatch.setattr(
        mut.os.path,
        "exists",
        lambda path: False,
    )

    mut.reparser(queue, sarif=False, verbose=True)

    captured = capsys.readouterr()
    assert "/results/task1: task.json not found, skipping" in captured.out


def test_reparser_skips_when_task_log_missing_non_verbose(patched_cfg, monkeypatch, capsys):
    queue = DummyQueue(["/results/task1", None])

    monkeypatch.setattr(mut.os.path, "exists", lambda path: False)

    mut.reparser(queue, sarif=False, verbose=False)

    captured = capsys.readouterr()
    assert captured.out == ""


def test_reparser_skips_when_old_parse_output_cannot_be_cleared(patched_cfg, monkeypatch, capsys):
    queue = DummyQueue(["/results/task1", None])

    monkeypatch.setattr(mut.os, "remove", lambda path: (_ for _ in ()).throw(PermissionError))
    monkeypatch.setattr(mut.os.path, "exists", lambda path: True)

    mut.reparser(queue, sarif=False, verbose=False)

    captured = capsys.readouterr()
    assert "/results/task1: Cannot clear old parse output, skipping" in captured.out


def test_reparser_reads_files_parses_and_writes_json(patched_cfg, monkeypatch, capsys):
    queue = DummyQueue(["/results/task1", None])

    def fake_exists(path):
        return path in {
            "/results/task1/task.json",
            "/results/task1/tool.log",
            "/results/task1/tool.out",
        }

    monkeypatch.setattr(mut.os.path, "exists", fake_exists)

    removed = []
    monkeypatch.setattr(mut.os, "remove", lambda path: removed.append(path))

    sbj = {"tool": {"id": "slither", "mode": "default"}}
    parsed = {"findings": [{"name": "x"}]}

    monkeypatch.setattr(mut.sb.io, "read_json", lambda path: sbj)
    monkeypatch.setattr(mut.sb.io, "read_lines", lambda path: ["line1", "line2"])
    monkeypatch.setattr(mut.sb.io, "read_bin", lambda path: b"binary")
    monkeypatch.setattr(mut.sb.parsing, "parse", lambda a, b, c: parsed)

    writes = []
    monkeypatch.setattr(mut.sb.io, "write_json", lambda path, data: writes.append((path, data)))

    mut.reparser(queue, sarif=False, verbose=True)

    captured = capsys.readouterr()
    assert "/results/task1" in captured.out
    assert removed == ["/results/task1/parsed.json", "/results/task1/result.sarif"]
    assert writes == [("/results/task1/parsed.json", parsed)]


def test_reparser_writes_sarif_when_requested(patched_cfg, monkeypatch):
    queue = DummyQueue(["/results/task1", None])

    def fake_exists(path):
        return path in {
            "/results/task1/task.json",
            "/results/task1/tool.log",
            "/results/task1/tool.out",
        }

    monkeypatch.setattr(mut.os.path, "exists", fake_exists)
    monkeypatch.setattr(mut.os, "remove", lambda path: None)

    sbj = {"tool": {"id": "mytool", "mode": "m"}}
    parsed = {"findings": [{"name": "f1"}]}
    sarif_result = {"version": "2.1.0"}

    monkeypatch.setattr(mut.sb.io, "read_json", lambda path: sbj)
    monkeypatch.setattr(mut.sb.io, "read_lines", lambda path: ["log"])
    monkeypatch.setattr(mut.sb.io, "read_bin", lambda path: b"out")
    monkeypatch.setattr(mut.sb.parsing, "parse", lambda a, b, c: parsed)
    monkeypatch.setattr(mut.sb.sarif, "sarify", lambda tool, findings: sarif_result)

    writes = []
    monkeypatch.setattr(mut.sb.io, "write_json", lambda path, data: writes.append((path, data)))

    mut.reparser(queue, sarif=True, verbose=False)

    assert writes == [
        ("/results/task1/parsed.json", parsed),
        ("/results/task1/result.sarif", sarif_result),
    ]


def test_reparser_uses_empty_log_and_none_output_when_missing(patched_cfg, monkeypatch):
    queue = DummyQueue(["/results/task1", None])

    def fake_exists(path):
        return path == "/results/task1/task.json"

    monkeypatch.setattr(mut.os.path, "exists", fake_exists)
    monkeypatch.setattr(mut.os, "remove", lambda path: None)

    monkeypatch.setattr(mut.sb.io, "read_json", lambda path: {"tool": {"id": "t", "mode": "m"}})

    parse_calls = []

    def fake_parse(sbj, log, tar):
        parse_calls.append((sbj, log, tar))
        return {"findings": []}

    monkeypatch.setattr(mut.sb.parsing, "parse", fake_parse)
    monkeypatch.setattr(mut.sb.io, "write_json", lambda path, data: None)

    mut.reparser(queue, sarif=False, verbose=False)

    assert parse_calls == [({"tool": {"id": "t", "mode": "m"}}, [], None)]


def test_reparser_prints_parse_error_and_continues(patched_cfg, monkeypatch, capsys):
    queue = DummyQueue(["/results/task1", None])

    def fake_exists(path):
        return path == "/results/task1/task.json"

    monkeypatch.setattr(mut.os.path, "exists", fake_exists)
    monkeypatch.setattr(mut.os, "remove", lambda path: None)
    monkeypatch.setattr(mut.sb.io, "read_json", lambda path: {"tool": {"id": "t", "mode": "m"}})
    monkeypatch.setattr(
        mut.sb.parsing,
        "parse",
        lambda a, b, c: (_ for _ in ()).throw(mut.sb.errors.SmartBugsError("parse failed")),
    )

    writes = []
    monkeypatch.setattr(mut.sb.io, "write_json", lambda path, data: writes.append((path, data)))

    mut.reparser(queue, sarif=True, verbose=False)

    captured = capsys.readouterr()
    assert "parse failed" in captured.out
    assert writes == []


def test_reparser_processes_multiple_directories_until_sentinel(patched_cfg, monkeypatch):
    queue = DummyQueue(["/results/task1", "/results/task2", None])

    def fake_exists(path):
        if path.endswith("task.json"):
            return True
        return False

    monkeypatch.setattr(mut.os.path, "exists", fake_exists)
    monkeypatch.setattr(mut.os, "remove", lambda path: None)

    read_json_calls = []

    def fake_read_json(path):
        read_json_calls.append(path)
        return {"tool": {"id": "t", "mode": "m"}}

    monkeypatch.setattr(mut.sb.io, "read_json", fake_read_json)
    monkeypatch.setattr(mut.sb.parsing, "parse", lambda a, b, c: {"findings": []})
    monkeypatch.setattr(mut.sb.io, "write_json", lambda path, data: None)

    mut.reparser(queue, sarif=False, verbose=False)

    assert read_json_calls == [
        "/results/task1/task.json",
        "/results/task2/task.json",
    ]


def test_main_prints_help_and_exits_when_no_args(patched_cfg, monkeypatch, capsys):
    monkeypatch.setattr(sys, "argv", ["reparse"])

    with pytest.raises(SystemExit) as excinfo:
        mut.main()

    assert excinfo.value.code == 1
    captured = capsys.readouterr()
    assert "Parse the tool output (tool.log, tool.out) into parsed.json." in captured.err


def test_main_discovers_results_builds_queue_and_starts_processes(patched_cfg, monkeypatch):
    fake_mp = FakeMPContext()
    monkeypatch.setattr(mut.multiprocessing, "get_context", lambda mode: fake_mp)

    walked = [
        ("/root", [], []),
        ("/root/a", [], ["task.json"]),
        ("/root/b", [], []),
        ("/root/c", [], ["task.json"]),
    ]
    monkeypatch.setattr(mut.os, "walk", lambda root: iter(walked))
    monkeypatch.setattr(
        sys,
        "argv",
        ["reparse", "--processes", "2", "--sarif", "-v", "/root"],
    )

    mut.main()

    queue = fake_mp.queues[0]
    assert queue.put_calls == ["/root/a", "/root/c", None, None]

    assert len(fake_mp.processes) == 2
    for proc in fake_mp.processes:
        assert proc.target is mut.reparser
        assert proc.args == (queue, True, True)
        assert proc.started is True
        assert proc.joined is True


def test_main_deduplicates_results_from_multiple_roots(patched_cfg, monkeypatch):
    fake_mp = FakeMPContext()
    monkeypatch.setattr(mut.multiprocessing, "get_context", lambda mode: fake_mp)

    def fake_walk(root):
        if root == "/root1":
            return iter([("/shared/task", [], ["task.json"])])
        if root == "/root2":
            return iter([("/shared/task", [], ["task.json"])])
        return iter([])

    monkeypatch.setattr(mut.os, "walk", fake_walk)
    monkeypatch.setattr(sys, "argv", ["reparse", "/root1", "/root2"])

    mut.main()

    queue = fake_mp.queues[0]
    assert queue.put_calls == ["/shared/task", None]


def test_main_sorts_results_before_queueing(patched_cfg, monkeypatch):
    fake_mp = FakeMPContext()
    monkeypatch.setattr(mut.multiprocessing, "get_context", lambda mode: fake_mp)

    monkeypatch.setattr(
        mut.os,
        "walk",
        lambda root: iter(
            [
                ("/root/z", [], ["task.json"]),
                ("/root/a", [], ["task.json"]),
                ("/root/m", [], ["task.json"]),
            ]
        ),
    )
    monkeypatch.setattr(sys, "argv", ["reparse", "/root"])

    mut.main()

    queue = fake_mp.queues[0]
    assert queue.put_calls == ["/root/a", "/root/m", "/root/z", None]


def test_main_uses_default_process_count_of_one(patched_cfg, monkeypatch):
    fake_mp = FakeMPContext()
    monkeypatch.setattr(mut.multiprocessing, "get_context", lambda mode: fake_mp)
    monkeypatch.setattr(mut.os, "walk", lambda root: iter([]))
    monkeypatch.setattr(sys, "argv", ["reparse", "/root"])

    mut.main()

    assert len(fake_mp.processes) == 1
    assert fake_mp.queues[0].put_calls == [None]


def test_main_process_args_reflect_non_sarif_and_non_verbose(patched_cfg, monkeypatch):
    fake_mp = FakeMPContext()
    monkeypatch.setattr(mut.multiprocessing, "get_context", lambda mode: fake_mp)
    monkeypatch.setattr(
        mut.os,
        "walk",
        lambda root: iter([("/root/task", [], ["task.json"])]),
    )
    monkeypatch.setattr(sys, "argv", ["reparse", "--processes", "3", "/root"])

    mut.main()

    queue = fake_mp.queues[0]
    assert len(fake_mp.processes) == 3
    for proc in fake_mp.processes:
        assert proc.args == (queue, False, False)
