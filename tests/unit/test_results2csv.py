import csv
import io
import sys

import pytest

import sb.results2csv


def test_list2postgres_empty():
    assert sb.results2csv.list2postgres([]) == "{}"


def test_list2postgres_without_escaping():
    assert sb.results2csv.list2postgres(["a", "b", "c"]) == "{a,b,c}"


def test_list2postgres_with_escaping():
    assert (
        sb.results2csv.list2postgres(["plain", "a,b", 'a"b', "a\nb", "{x}", "}"])
        == '{plain,"a,b","a\\"b","a\nb","{x}","}"}'
    )


def test_list2excel_empty():
    assert sb.results2csv.list2excel([]) == ""


def test_list2excel_without_escaping():
    assert sb.results2csv.list2excel(["a", "b", "c"]) == "a,b,c"


def test_list2excel_with_escaping():
    assert sb.results2csv.list2excel(["plain", "a,b", 'a"b', "a\nb"]) == 'plain,"a,b","a""b","a\nb"'


def test_data2csv_excel_format(monkeypatch):
    monkeypatch.setattr(sb.results2csv.sb.utils, "str2label", lambda s: f"LABEL:{s}")

    task_log = {
        "filename": "contracts/Token.sol",
        "tool": {"id": "slither", "mode": "default"},
        "runid": "run-123",
        "result": {
            "start": 10.0,
            "duration": 2.5,
            "exit_code": 0,
        },
    }
    parser_output = {
        "parser": {"version": "1.2.3"},
        "findings": [{"name": "beta"}, {"name": "alpha"}, {"name": "beta"}],
        "infos": ["info1", "info,2"],
        "errors": ['err"1'],
        "fails": ["fail1"],
    }

    fields = [
        "filename",
        "basename",
        "toolid",
        "toolmode",
        "parser_version",
        "runid",
        "start",
        "duration",
        "exit_code",
        "findings",
        "infos",
        "errors",
        "fails",
    ]

    row = sb.results2csv.data2csv(task_log, parser_output, postgres=False, fields=fields)

    assert row == [
        "contracts/Token.sol",
        "Token.sol",
        "slither",
        "default",
        "1.2.3",
        "run-123",
        10.0,
        2.5,
        0,
        "LABEL:alpha,LABEL:beta",
        'info1,"info,2"',
        '"err""1"',
        "fail1",
    ]


def test_data2csv_postgres_format(monkeypatch):
    monkeypatch.setattr(sb.results2csv.sb.utils, "str2label", lambda s: s.upper())

    task_log = {
        "filename": "a/b/c.sol",
        "tool": {"id": "mytool", "mode": "fast"},
        "runid": "r1",
        "result": {
            "start": 1,
            "duration": 3,
            "exit_code": 7,
        },
    }
    parser_output = {
        "parser": {"version": "9.9"},
        "findings": [{"name": "x"}, {"name": "y"}],
        "infos": ["hello,world"],
        "errors": ['bad"value'],
        "fails": ["{oops}"],
    }

    fields = ["findings", "infos", "errors", "fails"]
    row = sb.results2csv.data2csv(task_log, parser_output, postgres=True, fields=fields)

    assert row == [
        "{X,Y}",
        '{"hello,world"}',
        '{"bad\\"value"}',
        '{"{oops}"}',
    ]


def test_main_prints_help_and_exits_when_no_args(monkeypatch, capsys):
    monkeypatch.setattr(sys, "argv", ["results2csv"])

    with pytest.raises(SystemExit) as excinfo:
        sb.results2csv.main()

    assert excinfo.value.code == 1
    captured = capsys.readouterr()
    assert "Write key information from runs to stdout, in csv format." in captured.err


def test_main_writes_csv_for_discovered_results(monkeypatch, capsys, tmp_path):
    monkeypatch.setattr(sb.results2csv.sb.cfg, "TASK_LOG", "task.json")
    monkeypatch.setattr(sb.results2csv.sb.cfg, "PARSER_OUTPUT", "parsed.json")

    run1 = tmp_path / "run1"
    result_a = run1 / "a"
    result_b = run1 / "nested" / "b"
    result_a.mkdir(parents=True)
    result_b.mkdir(parents=True)
    (result_a / "task.json").write_text("x", encoding="utf-8")
    (result_b / "task.json").write_text("x", encoding="utf-8")

    task_logs = {
        str(result_a / "task.json"): {
            "filename": "contracts/A.sol",
            "tool": {"id": "toolA", "mode": "m1"},
            "runid": "runA",
            "result": {"start": 1.0, "duration": 2.0, "exit_code": 0},
        },
        str(result_b / "task.json"): {
            "filename": "contracts/B.sol",
            "tool": {"id": "toolB", "mode": "m2"},
            "runid": "runB",
            "result": {"start": 3.0, "duration": 4.0, "exit_code": 1},
        },
    }
    parser_outputs = {
        str(result_a / "parsed.json"): {
            "parser": {"version": "v1"},
            "findings": [{"name": "zeta"}, {"name": "alpha"}],
            "infos": ["i1"],
            "errors": [],
            "fails": ["f1"],
        },
        str(result_b / "parsed.json"): {
            "parser": {"version": "v2"},
            "findings": [{"name": "beta"}],
            "infos": ["i2"],
            "errors": ["e2"],
            "fails": [],
        },
    }

    def fake_read_json(path):
        if path in task_logs:
            return task_logs[path]
        if path in parser_outputs:
            return parser_outputs[path]
        raise AssertionError(f"Unexpected path: {path}")

    monkeypatch.setattr(sb.results2csv.sb.io, "read_json", fake_read_json)
    monkeypatch.setattr(sb.results2csv.sb.utils, "str2label", lambda s: s.upper())
    monkeypatch.setattr(
        sys,
        "argv",
        ["results2csv", str(run1)],
    )

    sb.results2csv.main()

    captured = capsys.readouterr()
    rows = list(csv.reader(io.StringIO(captured.out)))

    assert rows == [
        list(sb.results2csv.FIELDS),
        [
            "contracts/A.sol",
            "A.sol",
            "toolA",
            "m1",
            "v1",
            "runA",
            "1.0",
            "2.0",
            "0",
            "ALPHA,ZETA",
            "i1",
            "",
            "f1",
        ],
        [
            "contracts/B.sol",
            "B.sol",
            "toolB",
            "m2",
            "v2",
            "runB",
            "3.0",
            "4.0",
            "1",
            "BETA",
            "i2",
            "e2",
            "",
        ],
    ]


def test_main_applies_include_exclude_verbose_and_postgres(monkeypatch, capsys, tmp_path):
    monkeypatch.setattr(sb.results2csv.sb.cfg, "TASK_LOG", "task.json")
    monkeypatch.setattr(sb.results2csv.sb.cfg, "PARSER_OUTPUT", "parsed.json")

    result_dir = tmp_path / "run" / "taskdir"
    result_dir.mkdir(parents=True)
    (result_dir / "task.json").write_text("x", encoding="utf-8")

    monkeypatch.setattr(
        sb.results2csv.sb.io,
        "read_json",
        lambda path: {
            str(result_dir / "task.json"): {
                "filename": "contracts/C.sol",
                "tool": {"id": "toolC", "mode": "m3"},
                "runid": "runC",
                "result": {"start": 5, "duration": 6, "exit_code": 0},
            },
            str(result_dir / "parsed.json"): {
                "parser": {"version": "v3"},
                "findings": [{"name": "name,1"}],
                "infos": ["info"],
                "errors": ["err"],
                "fails": ["fail"],
            },
        }[path],
    )
    monkeypatch.setattr(sb.results2csv.sb.utils, "str2label", lambda s: s)

    monkeypatch.setattr(
        sys,
        "argv",
        [
            "results2csv",
            "-p",
            "-v",
            "-f",
            "filename",
            "findings",
            "errors",
            "-x",
            "errors",
            "--",
            str(tmp_path / "run"),
        ],
    )

    sb.results2csv.main()

    captured = capsys.readouterr()
    assert str(result_dir) in captured.err

    rows = list(csv.reader(io.StringIO(captured.out)))
    assert rows == [
        ["filename", "findings"],
        ["contracts/C.sol", '{"name,1"}'],
    ]


def test_main_skips_task_when_task_log_cannot_be_read(monkeypatch, capsys, tmp_path):
    monkeypatch.setattr(sb.results2csv.sb.cfg, "TASK_LOG", "task.json")
    monkeypatch.setattr(sb.results2csv.sb.cfg, "PARSER_OUTPUT", "parsed.json")

    result_dir = tmp_path / "run" / "bad"
    result_dir.mkdir(parents=True)
    (result_dir / "task.json").write_text("x", encoding="utf-8")

    def fake_read_json(path):
        if path.endswith("task.json"):
            raise ValueError("broken task log")
        raise AssertionError("parser output should not be read")

    monkeypatch.setattr(sb.results2csv.sb.io, "read_json", fake_read_json)
    monkeypatch.setattr(sys, "argv", ["results2csv", str(tmp_path / "run")])

    sb.results2csv.main()

    captured = capsys.readouterr()
    assert "Cannot read task log: broken task log" in captured.err

    rows = list(csv.reader(io.StringIO(captured.out)))
    assert rows == [list(sb.results2csv.FIELDS)]


def test_main_skips_task_when_parser_output_cannot_be_read(monkeypatch, capsys, tmp_path):
    monkeypatch.setattr(sb.results2csv.sb.cfg, "TASK_LOG", "task.json")
    monkeypatch.setattr(sb.results2csv.sb.cfg, "PARSER_OUTPUT", "parsed.json")

    result_dir = tmp_path / "run" / "badparse"
    result_dir.mkdir(parents=True)
    (result_dir / "task.json").write_text("x", encoding="utf-8")

    task_log = {
        "filename": "contracts/D.sol",
        "tool": {"id": "toolD", "mode": "m4"},
        "runid": "runD",
        "result": {"start": 7, "duration": 8, "exit_code": 9},
    }

    def fake_read_json(path):
        if path == str(result_dir / "task.json"):
            return task_log
        if path == str(result_dir / "parsed.json"):
            raise ValueError("missing parser output")
        raise AssertionError(f"Unexpected path: {path}")

    monkeypatch.setattr(sb.results2csv.sb.io, "read_json", fake_read_json)
    monkeypatch.setattr(sys, "argv", ["results2csv", str(tmp_path / "run")])

    sb.results2csv.main()

    captured = capsys.readouterr()
    assert "Cannot read parsed output; use 'reparse' to generate it." in captured.err
    assert "missing parser output" in captured.err

    rows = list(csv.reader(io.StringIO(captured.out)))
    assert rows == [list(sb.results2csv.FIELDS)]


def test_main_deduplicates_result_directories(monkeypatch, capsys, tmp_path):
    monkeypatch.setattr(sb.results2csv.sb.cfg, "TASK_LOG", "task.json")
    monkeypatch.setattr(sb.results2csv.sb.cfg, "PARSER_OUTPUT", "parsed.json")

    root = tmp_path / "root"
    result_dir = root / "same"
    result_dir.mkdir(parents=True)
    (result_dir / "task.json").write_text("x", encoding="utf-8")

    calls = []

    def fake_read_json(path):
        calls.append(path)
        if path == str(result_dir / "task.json"):
            return {
                "filename": "contracts/E.sol",
                "tool": {"id": "toolE", "mode": "m5"},
                "runid": "runE",
                "result": {"start": 1, "duration": 1, "exit_code": 0},
            }
        if path == str(result_dir / "parsed.json"):
            return {
                "parser": {"version": "v5"},
                "findings": [],
                "infos": [],
                "errors": [],
                "fails": [],
            }
        raise AssertionError(f"Unexpected path: {path}")

    monkeypatch.setattr(sb.results2csv.sb.io, "read_json", fake_read_json)
    monkeypatch.setattr(sys, "argv", ["results2csv", str(root), str(root)])

    sb.results2csv.main()

    capsys.readouterr()
    assert calls.count(str(result_dir / "task.json")) == 1
    assert calls.count(str(result_dir / "parsed.json")) == 1
