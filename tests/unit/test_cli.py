import sys
from types import SimpleNamespace

import pytest

import sb.cli


class DummyPath:
    def __init__(self, is_file=False):
        self._is_file = is_file

    def is_file(self):
        return self._is_file


class DummySettings:
    def __init__(self):
        self.tools = ["slither", "mythril"]
        self.files = ["contracts/*.sol"]
        self.runtime = False
        self.processes = 4
        self.timeout = 120
        self.cpu_quota = 200000
        self.mem_limit = "1g"
        self.continue_on_errors = False
        self.runid = "run-1"
        self.results = "results"
        self.log = "smartbugs.log"
        self.overwrite = False
        self.json = True
        self.sarif = False
        self.quiet = False
        self.updated = []

    def update(self, value):
        self.updated.append(value)


@pytest.fixture
def patched_cfg(monkeypatch):
    monkeypatch.setattr(sb.cli.sb.cfg, "PARSER_OUTPUT", "parsed.json")
    monkeypatch.setattr(sb.cli.sb.cfg, "SARIF_OUTPUT", "result.sarif")
    monkeypatch.setattr(sb.cli.sb.cfg, "SB_VERSION", "9.9.9")
    monkeypatch.setattr(sb.cli.sb.cfg, "CPU", {"python_version": "3.12.0", "brand_raw": "Test CPU"})
    monkeypatch.setattr(
        sb.cli.sb.cfg,
        "UNAME",
        SimpleNamespace(system="TestOS", release="1.2.3", version="Build 7"),
    )


def test_cli_args_exits_with_help_when_no_arguments(patched_cfg, monkeypatch, capsys):
    defaults = DummySettings()
    monkeypatch.setattr(sys, "argv", ["smartbugs"])

    with pytest.raises(SystemExit) as excinfo:
        sb.cli.cli_args(defaults)

    assert excinfo.value.code == 1
    captured = capsys.readouterr()
    assert "Automated analysis of Ethereum smart contracts" in captured.err


def test_cli_args_parses_arguments_and_filters_none(patched_cfg, monkeypatch):
    defaults = DummySettings()
    debug_logs = []

    monkeypatch.setattr(sb.cli.sb.debug, "log", lambda message: debug_logs.append(message))
    monkeypatch.setattr(
        sys, "argv", ["smartbugs", "--tools", "slither", "--processes", "8", "--main"]
    )

    cfg_file, args = sb.cli.cli_args(defaults)

    assert cfg_file is None
    assert args == {
        "tools": ["slither"],
        "main": True,
        "processes": 8,
    }
    assert sb.cli.sb.debug.ENABLED is False
    assert any("SmartBugs 9.9.9" in entry for entry in debug_logs)
    assert "Modules:" in debug_logs


def test_cli_args_returns_configuration_file(patched_cfg, monkeypatch):
    defaults = DummySettings()
    monkeypatch.setattr(sb.cli.sb.debug, "log", lambda *_: None)
    monkeypatch.setattr(
        sys,
        "argv",
        ["smartbugs", "--configuration", "config.yml", "--results", "out", "--quiet"],
    )

    cfg_file, args = sb.cli.cli_args(defaults)

    assert cfg_file == "config.yml"
    assert args == {
        "results": "out",
        "quiet": True,
    }


def test_cli_args_sets_debug_enabled(patched_cfg, monkeypatch):
    defaults = DummySettings()
    monkeypatch.setattr(sb.cli.sb.debug, "log", lambda *_: None)
    monkeypatch.setattr(sys, "argv", ["smartbugs", "--debug"])

    _, args = sb.cli.cli_args(defaults)

    assert sb.cli.sb.debug.ENABLED is True
    assert args == {}


def test_cli_args_prints_version_and_exits(patched_cfg, monkeypatch, capsys):
    defaults = DummySettings()
    debug_logs = []
    monkeypatch.setattr(sb.cli.sb.debug, "log", lambda message: debug_logs.append(message))
    monkeypatch.setattr(sys, "argv", ["smartbugs", "--version"])

    with pytest.raises(SystemExit) as excinfo:
        sb.cli.cli_args(defaults)

    assert excinfo.value.code == 0
    captured = capsys.readouterr()
    assert "SmartBugs 9.9.9" in captured.out
    assert "Python 3.12.0" in captured.out
    assert "TestOS 1.2.3 Build 7" in captured.out
    assert "CPU Test CPU" in captured.out
    assert any("SmartBugs 9.9.9" in entry for entry in debug_logs)


def test_cli_args_logs_modules_with_versions(patched_cfg, monkeypatch):
    defaults = DummySettings()
    debug_logs = []

    fake_module = SimpleNamespace(__name__="fake_module", __version__="1.0")
    fake_module2 = SimpleNamespace(__name__="another_module", __version__="2.3")
    original_modules = dict(sys.modules)
    original_modules["fake_module"] = fake_module
    original_modules["another_module"] = fake_module2

    monkeypatch.setattr(sys, "modules", original_modules)
    monkeypatch.setattr(sb.cli.sb.debug, "log", lambda message: debug_logs.append(message))
    monkeypatch.setattr(sys, "argv", ["smartbugs", "--quiet"])

    _, args = sb.cli.cli_args(defaults)

    assert args == {"quiet": True}
    assert "   fake_module 1.0" in debug_logs
    assert "   another_module 2.3" in debug_logs


def test_cli_uses_site_user_cfg_then_cli_updates(monkeypatch):
    settings = DummySettings()
    monkeypatch.setattr(sb.cli.sb.settings, "Settings", lambda: settings)
    monkeypatch.setattr(sb.cli.sb.cfg, "SITE_CFG", DummyPath(is_file=True))
    monkeypatch.setattr(sb.cli.sb.cfg, "USER_CFG", DummyPath(is_file=True))
    monkeypatch.setattr(
        sb.cli, "cli_args", lambda defaults: ("custom.yml", {"quiet": True, "processes": 9})
    )

    result = sb.cli.cli()

    assert result is settings
    assert settings.updated == [
        sb.cli.sb.cfg.SITE_CFG,
        sb.cli.sb.cfg.USER_CFG,
        "custom.yml",
        {"quiet": True, "processes": 9},
    ]


def test_cli_skips_missing_site_and_user_cfg(monkeypatch):
    settings = DummySettings()
    monkeypatch.setattr(sb.cli.sb.settings, "Settings", lambda: settings)
    monkeypatch.setattr(sb.cli.sb.cfg, "SITE_CFG", DummyPath(is_file=False))
    monkeypatch.setattr(sb.cli.sb.cfg, "USER_CFG", DummyPath(is_file=False))
    monkeypatch.setattr(sb.cli, "cli_args", lambda defaults: (None, {"json": True}))

    result = sb.cli.cli()

    assert result is settings
    assert settings.updated == [None, {"json": True}]


def test_main_calls_smartbugs_with_cli_settings(monkeypatch):
    settings = DummySettings()
    messages = []

    monkeypatch.setattr(sb.cli, "cli", lambda: settings)
    monkeypatch.setattr(sb.cli.sb.logging, "message", lambda *args: messages.append(args))
    called = {"settings": None}
    monkeypatch.setattr(sb.cli.sb.smartbugs, "main", lambda s: called.__setitem__("settings", s))
    monkeypatch.setattr(sys, "argv", ["smartbugs", "--quiet"])

    sb.cli.main()

    assert messages == [(None, "Arguments passed: ['smartbugs', '--quiet']")]
    assert called["settings"] is settings


def test_main_handles_smartbugs_error_and_exits(monkeypatch):
    error = sb.cli.sb.errors.SmartBugsError("boom")
    messages = []

    monkeypatch.setattr(sb.cli, "cli", lambda: (_ for _ in ()).throw(error))
    monkeypatch.setattr(sb.cli.sb.colors, "error", lambda e: f"ERR:{e}")
    monkeypatch.setattr(sb.cli.sb.logging, "message", lambda *args: messages.append(args))

    with pytest.raises(SystemExit) as excinfo:
        sb.cli.main()

    assert excinfo.value.code == 1
    assert messages == [("ERR:boom",)]


def test_cli_args_help_text_formats_defaults(patched_cfg, monkeypatch, capsys):
    defaults = DummySettings()
    monkeypatch.setattr(sys, "argv", ["smartbugs", "--help"])

    with pytest.raises(SystemExit) as excinfo:
        sb.cli.cli_args(defaults)

    assert excinfo.value.code == 0
    captured = capsys.readouterr()
    captured_out = " ".join(captured.out.split())
    assert "[default: slither mythril]" in captured_out
    assert "[default: contracts/*.sol]" in captured_out
    assert "[default: no]" in captured_out
    assert "[default: 4]" in captured_out
    assert "[default: 120]" in captured_out
    assert '[default: "1g"]' in captured_out
    assert '[default: "run-1"]' in captured_out
    assert "--json parse output and write it to parsed.json [default: yes]" in captured_out
    assert (
        "--sarif parse output and write it to parsed.json as well as result.sarif [default: no]"
        in captured_out
    )
