import os
from types import SimpleNamespace

import pytest
import sb.smartbugs as mut


def make_tool(**overrides):
    tool = SimpleNamespace(
        id="tool1",
        mode="solidity",
        solc=False,
        image="img:latest",
    )
    for k, v in overrides.items():
        setattr(tool, k, v)
    return tool


def make_settings(**overrides):
    settings = SimpleNamespace(
        runtime=False,
        main=False,
        continue_on_errors=False,
        quiet=False,
        tools=["tool1"],
        files=[(None, "**/*.sol")],
        resultdir=lambda toolid, mode, absfn, relfn: f"/results/{toolid}_{mode}_{os.path.basename(relfn)}",
        freeze=lambda: None,
    )
    for k, v in overrides.items():
        setattr(settings, k, v)
    return settings


def test_collect_files_reads_sbd_and_glob_patterns(monkeypatch, tmp_path):
    root = tmp_path / "root"
    root.mkdir()
    file1 = root / "A.sol"
    file2 = root / "B.hex"
    file3 = root / "skip.txt"
    file1.write_text("contract A {}", encoding="utf-8")
    file2.write_text("deadbeef", encoding="utf-8")
    file3.write_text("x", encoding="utf-8")

    sbd = root / "contracts.sbd"
    sbd.write_text("A.sol\nB.hex\nskip.txt\nmissing.sol\n", encoding="utf-8")

    monkeypatch.setattr(mut.os.path, "abspath", lambda path: str(root / path))

    result = mut.collect_files([(str(root), "**/*"), (None, str(sbd))])

    assert sorted(result) == [
        (os.path.normpath(str(file1.resolve())), "A.sol"),
        (os.path.normpath(str(file1.resolve())), "A.sol"),
        (os.path.normpath(str(file2.resolve())), "B.hex"),
        (os.path.normpath(str(file2.resolve())), "B.hex"),
    ]


def test_collect_files_uses_root_dir_for_normal_glob(monkeypatch, tmp_path):
    root = tmp_path / "root"
    root.mkdir()
    file1 = root / "C.sol"
    file1.write_text("contract C {}", encoding="utf-8")

    calls = []

    def fake_glob(spec, root_dir=None, recursive=False):
        calls.append((spec, root_dir, recursive))
        return ["C.sol"]

    monkeypatch.setattr(mut.glob, "glob", fake_glob)

    result = mut.collect_files([(str(root), "*.sol")])

    assert result == [(os.path.normpath(str(file1.resolve())), "C.sol")]
    assert calls == [("*.sol", str(root), True)]


def test_collect_tasks_creates_tasks_for_matching_tool_modes(monkeypatch, tmp_path):
    sol = tmp_path / "A.sol"
    byc = tmp_path / "B.hex"
    rtc = tmp_path / "C.rt.hex"
    sol.write_text("pragma solidity ^0.8.0;\ncontract A {}", encoding="utf-8")
    byc.write_text("deadbeef", encoding="utf-8")
    rtc.write_text("deadbeef", encoding="utf-8")

    files = [
        (str(sol), "A.sol"),
        (str(byc), "B.hex"),
        (str(rtc), "C.rt.hex"),
    ]
    tools = [
        make_tool(id="sol", mode="solidity"),
        make_tool(id="byc", mode="bytecode"),
        make_tool(id="rtc", mode="runtime"),
        make_tool(id="other", mode="solidity"),
    ]
    settings = make_settings()

    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: True)

    created = []

    def fake_task(absfn, relfn, rdir, solc_version, solc_path, tool, settings):
        task = SimpleNamespace(
            absfn=absfn,
            relfn=relfn,
            rdir=rdir,
            solc_version=solc_version,
            solc_path=solc_path,
            tool=tool,
            settings=settings,
        )
        created.append(task)
        return task

    monkeypatch.setattr(mut.sb.tasks, "Task", fake_task)

    tasks = mut.collect_tasks(files, tools, settings)

    assert [(t.relfn, t.tool.id, t.tool.mode) for t in tasks] == [
        ("A.sol", "other", "solidity"),
        ("A.sol", "sol", "solidity"),
        ("B.hex", "byc", "bytecode"),
        ("C.rt.hex", "rtc", "runtime"),
    ]


def test_collect_tasks_ignores_duplicate_absfn(monkeypatch, tmp_path):
    sol = tmp_path / "A.sol"
    sol.write_text("pragma solidity ^0.8.0\ncontract A {}", encoding="utf-8")

    files = [
        (str(sol), "x/A.sol"),
        (str(sol), "y/A.sol"),
    ]
    tools = [make_tool()]
    settings = make_settings()

    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: True)

    created = []
    monkeypatch.setattr(
        mut.sb.tasks,
        "Task",
        lambda absfn, relfn, rdir, solc_version, solc_path, tool, settings: created.append(
            (absfn, relfn, rdir)
        )
        or SimpleNamespace(absfn=absfn, relfn=relfn, rdir=rdir, tool=tool),
    )

    tasks = mut.collect_tasks(files, tools, settings)

    assert len(tasks) == 1
    assert len(created) == 1


def test_collect_tasks_runtime_setting_treats_hex_as_runtime(monkeypatch, tmp_path):
    hexfile = tmp_path / "A.hex"
    hexfile.write_text("deadbeef", encoding="utf-8")

    files = [(str(hexfile), "A.hex")]
    tools = [make_tool(id="rtc", mode="runtime"), make_tool(id="byc", mode="bytecode")]
    settings = make_settings(runtime=True)

    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: True)
    monkeypatch.setattr(
        mut.sb.tasks,
        "Task",
        lambda absfn, relfn, rdir, solc_version, solc_path, tool, settings: SimpleNamespace(
            absfn=absfn, relfn=relfn, tool=tool
        ),
    )

    tasks = mut.collect_tasks(files, tools, settings)

    assert [(t.relfn, t.tool.id) for t in tasks] == [("A.hex", "rtc")]


def test_collect_tasks_loads_solc_for_tools_that_require_it(monkeypatch, tmp_path):
    sol = tmp_path / "A.sol"
    sol.write_text("pragma solidity ^0.8.0;\ncontract A {}", encoding="utf-8")

    files = [(str(sol), "A.sol")]
    tools = [make_tool(solc=True)]
    settings = make_settings()

    monkeypatch.setattr(mut.sb.solc, "SERVICE", True)
    monkeypatch.setattr(mut.sb.solc, "AVAILABLE", ["0.8.20"])
    monkeypatch.setattr(mut.sb.semantic_version, "match", lambda versions, available: "0.8.20")
    monkeypatch.setattr(mut.sb.solc, "path", lambda version: "/usr/bin/solc")
    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: True)
    monkeypatch.setattr(
        mut.sb.tasks,
        "Task",
        lambda absfn, relfn, rdir, solc_version, solc_path, tool, settings: SimpleNamespace(
            solc_version=solc_version,
            solc_path=solc_path,
            relfn=relfn,
            tool=tool,
        ),
    )

    tasks = mut.collect_tasks(files, tools, settings)

    assert len(tasks) == 1
    assert tasks[0].solc_version == "0.8.20"
    assert tasks[0].solc_path == "/usr/bin/solc"


def test_collect_tasks_initializes_solc_service_and_warns_when_offline(monkeypatch, tmp_path):
    sol = tmp_path / "A.sol"
    sol.write_text("pragma solidity ^0.8.0;\ncontract A {}", encoding="utf-8")

    files = [(str(sol), "A.sol")]
    tools = [make_tool(solc=True)]
    settings = make_settings()

    monkeypatch.setattr(mut.sb.solc, "SERVICE", False)
    monkeypatch.setattr(mut.sb.solc, "ONLINE", False)
    monkeypatch.setattr(mut.sb.solc, "AVAILABLE", ["0.8.20"])

    init_calls = []
    monkeypatch.setattr(mut.sb.solc, "init_service", lambda: init_calls.append(True))
    monkeypatch.setattr(mut.sb.semantic_version, "match", lambda versions, available: "0.8.20")
    monkeypatch.setattr(mut.sb.solc, "path", lambda version: "/usr/bin/solc")
    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: True)

    messages = []
    monkeypatch.setattr(mut.sb.logging, "message", lambda *args: messages.append(args))
    monkeypatch.setattr(mut.sb.colors, "warning", lambda msg: f"WARN:{msg}")
    monkeypatch.setattr(
        mut.sb.tasks,
        "Task",
        lambda *args: SimpleNamespace(),
    )

    mut.collect_tasks(files, tools, settings)

    assert init_calls == [True]
    assert any("Proceeding with local compilers" in msg[0] for msg in messages)


def test_collect_tasks_initializes_solc_service_when_online(monkeypatch, tmp_path):
    sol = tmp_path / "A.sol"
    sol.write_text("pragma solidity ^0.8.0;\ncontract A {}", encoding="utf-8")

    files = [(str(sol), "A.sol")]
    tools = [make_tool(solc=True)]
    settings = make_settings()

    monkeypatch.setattr(mut.sb.solc, "SERVICE", False)
    monkeypatch.setattr(mut.sb.solc, "ONLINE", True)
    monkeypatch.setattr(mut.sb.solc, "AVAILABLE", ["0.8.20"])

    init_calls = []
    monkeypatch.setattr(mut.sb.solc, "init_service", lambda: init_calls.append(True))

    monkeypatch.setattr(mut.sb.semantic_version, "match", lambda versions, available: "0.8.20")
    monkeypatch.setattr(mut.sb.solc, "path", lambda version: "/usr/bin/solc")
    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: True)

    messages = []
    monkeypatch.setattr(mut.sb.logging, "message", lambda *args: messages.append(args))
    monkeypatch.setattr(mut.sb.colors, "warning", lambda msg: f"WARN:{msg}")

    monkeypatch.setattr(
        mut.sb.tasks,
        "Task",
        lambda absfn, relfn, rdir, solc_version, solc_path, tool, settings: SimpleNamespace(
            solc_version=solc_version,
            solc_path=solc_path,
            relfn=relfn,
            tool=tool,
        ),
    )

    tasks = mut.collect_tasks(files, tools, settings)

    assert init_calls == [True]
    assert len(tasks) == 1
    assert tasks[0].solc_version == "0.8.20"
    assert tasks[0].solc_path == "/usr/bin/solc"
    assert messages == []


def test_collect_tasks_raises_when_main_contract_missing(monkeypatch, tmp_path):
    sol = tmp_path / "A.sol"
    sol.write_text("pragma solidity ^0.8.0;\ncontract B {}", encoding="utf-8")

    files = [(str(sol), "A.sol")]
    tools = [make_tool()]
    settings = make_settings(main=True, continue_on_errors=False)

    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: True)

    monkeypatch.setattr(
        mut.sb.tasks,
        "Task",
        lambda *args: SimpleNamespace(),
    )

    with pytest.raises(mut.sb.errors.SmartBugsError, match="Contract 'A' not found"):
        mut.collect_tasks(files, tools, settings)


def test_collect_tasks_continues_on_errors_and_logs_warning(monkeypatch, tmp_path):
    sol = tmp_path / "A.sol"
    sol.write_text("pragma solidity ^0.8.0;\ncontract B {}", encoding="utf-8")

    files = [(str(sol), "A.sol")]
    tools = [make_tool()]
    settings = make_settings(main=True, continue_on_errors=True)

    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: True)
    monkeypatch.setattr(
        mut.sb.tasks,
        "Task",
        lambda *args: SimpleNamespace(),
    )

    messages = []
    monkeypatch.setattr(mut.sb.logging, "message", lambda *args: messages.append(args))
    monkeypatch.setattr(mut.sb.colors, "warning", lambda msg: f"WARN:{msg}")

    tasks = mut.collect_tasks(files, tools, settings)

    assert len(tasks) == 1
    assert any(
        "Warning: 1 error(s) while collecting tasks, continuing ..." in msg[0] for msg in messages
    )
    assert any("Contract 'A' not found" in msg[0] for msg in messages)


def test_collect_tasks_raises_when_no_pragma_for_solc_tool(monkeypatch, tmp_path):
    sol = tmp_path / "A.sol"
    sol.write_text("contract A {}", encoding="utf-8")

    files = [(str(sol), "A.sol")]
    tools = [make_tool(solc=True)]
    settings = make_settings()

    with pytest.raises(
        mut.sb.errors.SmartBugsError, match="no pragma, cannot determine solc version"
    ):
        mut.collect_tasks(files, tools, settings)


def test_collect_tasks_raises_when_no_matching_compiler(monkeypatch, tmp_path):
    sol = tmp_path / "A.sol"
    sol.write_text("pragma solidity ^0.8.0;\ncontract A {}", encoding="utf-8")

    files = [(str(sol), "A.sol")]
    tools = [make_tool(solc=True)]
    settings = make_settings()

    monkeypatch.setattr(mut.sb.solc, "SERVICE", True)
    monkeypatch.setattr(mut.sb.solc, "AVAILABLE", ["0.7.0"])
    monkeypatch.setattr(mut.sb.semantic_version, "match", lambda versions, available: None)

    with pytest.raises(mut.sb.errors.SmartBugsError, match="no compiler found that matches"):
        mut.collect_tasks(files, tools, settings)


def test_collect_tasks_raises_when_solc_path_missing(monkeypatch, tmp_path):
    sol = tmp_path / "A.sol"
    sol.write_text("pragma solidity ^0.8.0;\ncontract A {}", encoding="utf-8")

    files = [(str(sol), "A.sol")]
    tools = [make_tool(solc=True)]
    settings = make_settings()

    monkeypatch.setattr(mut.sb.solc, "SERVICE", True)
    monkeypatch.setattr(mut.sb.solc, "AVAILABLE", ["0.8.20"])
    monkeypatch.setattr(mut.sb.semantic_version, "match", lambda versions, available: "0.8.20")
    monkeypatch.setattr(mut.sb.solc, "path", lambda version: None)

    with pytest.raises(
        mut.sb.errors.SmartBugsError, match="cannot load solc 0.8.20 needed by tool1"
    ):
        mut.collect_tasks(files, tools, settings)


def test_collect_tasks_loads_missing_docker_image(monkeypatch, tmp_path):
    sol = tmp_path / "A.sol"
    sol.write_text("pragma solidity ^0.8.0;\ncontract A {}", encoding="utf-8")

    files = [(str(sol), "A.sol")]
    tools = [make_tool(image="img:1")]
    settings = make_settings()

    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: False)

    load_calls = []
    monkeypatch.setattr(mut.sb.docker, "load", lambda image: load_calls.append(image))

    messages = []
    monkeypatch.setattr(mut.sb.logging, "message", lambda *args: messages.append(args))
    monkeypatch.setattr(
        mut.sb.tasks,
        "Task",
        lambda *args: SimpleNamespace(),
    )

    mut.collect_tasks(files, tools, settings)

    assert load_calls == ["img:1"]
    assert messages[0] == ("Loading docker image img:1, may take a while ...",)


def test_collect_tasks_disambiguates_result_dirs_and_reports_collisions_with_hint(
    monkeypatch, tmp_path
):
    sol1 = tmp_path / "A.sol"
    sol2 = tmp_path / "B.sol"
    sol1.write_text("pragma solidity ^0.8.0;\ncontract A {}", encoding="utf-8")
    sol2.write_text("pragma solidity ^0.8.0;\ncontract B {}", encoding="utf-8")

    files = [(str(sol1), "A.sol"), (str(sol2), "B.sol")]
    tools = [make_tool()]
    settings = make_settings(resultdir=lambda *args: "/results/same")

    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: True)

    tasks = []
    monkeypatch.setattr(
        mut.sb.tasks,
        "Task",
        lambda absfn, relfn, rdir, solc_version, solc_path, tool, settings: tasks.append(rdir)
        or SimpleNamespace(rdir=rdir),
    )

    messages = []
    monkeypatch.setattr(mut.sb.logging, "message", lambda *args: messages.append(args))
    monkeypatch.setattr(mut.sb.colors, "warning", lambda msg: f"WARN:{msg}")

    mut.collect_tasks(files, tools, settings)

    assert tasks == ["/results/same", "/results/same_2"]
    assert any("1 collision(s) of result directories resolved." in msg[0] for msg in messages)
    assert any("Consider using more of" in msg[0] for msg in messages)


def test_collect_tasks_reports_collisions_without_hint(monkeypatch, tmp_path):
    files = []
    for i in range(21):
        d = tmp_path / str(i)
        os.mkdir(d)
        f = d / f"{i%20}.sol"
        f.write_text("pragma solidity ^0.8.0;\ncontract X {}", encoding="utf-8")
        files.append((str(f), f"{i%20}.sol"))

    print(f"{files=}")
    tools = [make_tool()]
    settings = make_settings()

    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: True)
    monkeypatch.setattr(mut.sb.tasks, "Task", lambda *args: SimpleNamespace())

    messages = []
    monkeypatch.setattr(mut.sb.logging, "message", lambda *args: messages.append(args))
    monkeypatch.setattr(mut.sb.colors, "warning", lambda msg: f"WARN:{msg}")

    mut.collect_tasks(files, tools, settings)

    assert any("1 collision(s) of result directories resolved." in msg[0] for msg in messages)
    assert not any("Consider using more of" in msg[0] for msg in messages)


def test_collect_tasks_reports_many_collisions_with_hint(monkeypatch, tmp_path):
    files = []
    for i in range(20):
        f = tmp_path / f"{i}.sol"
        f.write_text("pragma solidity ^0.8.0;\ncontract X {}", encoding="utf-8")
        files.append((str(f), f"{i}.sol"))

    tools = [make_tool()]
    settings = make_settings(resultdir=lambda *args: "/results/same")

    monkeypatch.setattr(mut.sb.docker, "is_loaded", lambda image: True)
    monkeypatch.setattr(mut.sb.tasks, "Task", lambda *args: SimpleNamespace())

    messages = []
    monkeypatch.setattr(mut.sb.logging, "message", lambda *args: messages.append(args))
    monkeypatch.setattr(mut.sb.colors, "warning", lambda msg: f"WARN:{msg}")

    mut.collect_tasks(files, tools, settings)

    assert any("19 collision(s) of result directories resolved." in msg[0] for msg in messages)
    assert any("Consider using more of" in msg[0] for msg in messages)


def test_main_freezes_settings_logs_and_runs_analysis(monkeypatch):
    freeze_calls = []
    settings = make_settings(
        quiet=True,
        tools=["toolA"],
        files=[(None, "*.sol")],
        freeze=lambda: freeze_calls.append(True),
    )

    tool_objects = [make_tool(id="toolA")]
    file_list = [("/abs/A.sol", "A.sol")]
    task_list = [SimpleNamespace(id="task1")]

    monkeypatch.setattr(mut.sb.cfg, "SB_VERSION", "1.2.3")
    monkeypatch.setattr(mut.sb.tools, "load", lambda tools: tool_objects)
    monkeypatch.setattr(mut, "collect_files", lambda patterns: file_list)
    monkeypatch.setattr(mut, "collect_tasks", lambda files, tools, settings: task_list)

    messages = []
    monkeypatch.setattr(mut.sb.logging, "message", lambda *args: messages.append(args))

    run_calls = []
    monkeypatch.setattr(
        mut.sb.analysis, "run", lambda tasks, settings: run_calls.append((tasks, settings))
    )
    monkeypatch.setattr(mut.sb.colors, "success", lambda msg: f"OK:{msg}")

    mut.main(settings)

    assert freeze_calls == [True]
    assert mut.sb.logging.quiet is True
    assert messages[0] == ("OK:Welcome to SmartBugs 1.2.3!", f"Settings: {settings}")
    assert messages[1] == ("Collecting files ...",)
    assert messages[2] == ("1 files to analyse",)
    assert messages[3] == ("Assembling tasks ...",)
    assert messages[4] == ("1 tasks to execute",)
    assert run_calls == [(task_list, settings)]


def test_main_warns_when_no_tools_selected(monkeypatch):
    settings = make_settings(freeze=lambda: None)

    monkeypatch.setattr(mut.sb.cfg, "SB_VERSION", "1.2.3")
    monkeypatch.setattr(mut.sb.tools, "load", lambda tools: [])
    monkeypatch.setattr(mut, "collect_files", lambda patterns: [])
    monkeypatch.setattr(mut, "collect_tasks", lambda files, tools, settings: [])
    monkeypatch.setattr(mut.sb.analysis, "run", lambda tasks, settings: None)
    monkeypatch.setattr(mut.sb.colors, "success", lambda msg: msg)
    monkeypatch.setattr(mut.sb.colors, "warning", lambda msg: f"WARN:{msg}")

    messages = []
    monkeypatch.setattr(mut.sb.logging, "message", lambda *args: messages.append(args))

    mut.main(settings)

    assert any(msg[0] == "WARN:Warning: no tools selected!" for msg in messages)
