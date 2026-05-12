from pathlib import Path
from types import SimpleNamespace

import pytest

import sb.solc as mut


class DummyVersion:
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return self.value


class DummyRepositoryMatcher:
    def __init__(self, available):
        self._available = available

    def get_all_available_versions(self):
        return self._available


class DummyArtifactManager:
    def __init__(self, success=True):
        self.success = success
        self.calls = []

    def install_versions(self, versions, silent=True):
        self.calls.append((versions, silent))
        return self.success


class DummyService:
    def __init__(self, platform, available=None, installed=None, install_success=True):
        self.platform = platform
        self.repository_matcher = DummyRepositoryMatcher(available or {})
        self._installed = installed or []
        self.artifact_manager = DummyArtifactManager(success=install_success)

    def get_installed_versions(self):
        return self._installed


@pytest.fixture(autouse=True)
def reset_globals():
    mut.SERVICE = None
    mut.ONLINE = None
    mut.AVAILABLE = None
    yield
    mut.SERVICE = None
    mut.ONLINE = None
    mut.AVAILABLE = None


def test_init_service_patches_constants_and_sets_globals(monkeypatch, tmp_path):
    monkeypatch.setattr(mut.sb.cfg, "SOLC", tmp_path / "solc")

    debug_logs = []
    monkeypatch.setattr(mut.sb.debug, "log", lambda msg: debug_logs.append(msg))

    created_platforms = []
    created_services = []

    def fake_platform(os_name, arch):
        platform = SimpleNamespace(os=os_name, arch=arch)
        created_platforms.append(platform)
        return platform

    def fake_solc_service(platform):
        service = DummyService(
            platform,
            available={
                DummyVersion("0.8.20"): object(),
                DummyVersion("0.8.19"): object(),
            },
            installed=[DummyVersion("0.7.6")],
        )
        created_services.append(service)
        return service

    monkeypatch.setattr(
        mut.solc_select.models.platforms,
        "Platform",
        fake_platform,
    )
    monkeypatch.setattr(
        mut.solc_select.services.solc_service,
        "SolcService",
        fake_solc_service,
    )

    filesystem = mut.solc_select.infrastructure.filesystem
    filesystem.SOLC_SELECT_DIR = Path("/old/solc")
    filesystem.ARTIFACTS_DIR = Path("/old/artifacts")

    mut.SOLC_SELECT_DIR = tmp_path / "solc"
    mut.ARTIFACTS_DIR = tmp_path / "solc" / "artifacts"

    mut.init_service()

    assert filesystem.SOLC_SELECT_DIR == tmp_path / "solc"
    assert filesystem.ARTIFACTS_DIR == tmp_path / "solc" / "artifacts"
    assert len(created_platforms) == 1
    assert created_platforms[0].os == "linux"
    assert created_platforms[0].arch == "amd64"
    assert mut.SERVICE is created_services[0]
    assert mut.ONLINE == {"0.8.20", "0.8.19"}
    assert mut.AVAILABLE == {"0.8.20", "0.8.19", "0.7.6"}
    assert debug_logs[0] == "solc.init_service:"
    assert (
        "ONLINE={'0.8.20', '0.8.19'}" in debug_logs[1]
        or "ONLINE={'0.8.19', '0.8.20'}" in debug_logs[1]
    )
    assert "installed={'0.7.6'}" in debug_logs[1]


def test_path_returns_none_for_none_version(monkeypatch):
    debug_logs = []
    monkeypatch.setattr(mut.sb.debug, "log", lambda msg: debug_logs.append(msg))

    result = mut.path(None)

    assert result is None
    assert debug_logs == [
        "solc.path:\n   version=None",
        "   solc_path=None",
    ]


def test_path_uses_installed_version_without_install(monkeypatch, tmp_path):
    debug_logs = []
    monkeypatch.setattr(mut.sb.debug, "log", lambda msg: debug_logs.append(msg))

    service = DummyService(
        platform=None,
        available={DummyVersion("0.8.20"): object()},
        installed=[DummyVersion("0.8.20")],
    )
    mut.SERVICE = service
    mut.ONLINE = {"0.8.20"}
    mut.ARTIFACTS_DIR = tmp_path / "artifacts"

    result = mut.path("0.8.20")

    assert result == str(tmp_path / "artifacts" / "solc-0.8.20" / "solc-0.8.20")
    assert service.artifact_manager.calls == []
    assert debug_logs == [
        "solc.path:\n   version='0.8.20'",
        f"   solc_path='{result}'",
    ]


def test_path_initializes_service_when_missing(monkeypatch, tmp_path):
    debug_logs = []
    monkeypatch.setattr(mut.sb.debug, "log", lambda msg: debug_logs.append(msg))

    service = DummyService(
        platform=None,
        available={DummyVersion("0.8.20"): object()},
        installed=[DummyVersion("0.8.20")],
    )
    mut.SERVICE = None
    mut.ONLINE = {"0.8.20"}
    mut.ARTIFACTS_DIR = tmp_path / "artifacts"

    init_calls = []

    def fake_init_service():
        init_calls.append(True)
        mut.SERVICE = service

    monkeypatch.setattr(mut, "init_service", fake_init_service)

    result = mut.path("0.8.20")

    assert init_calls == [True]
    assert result == str(tmp_path / "artifacts" / "solc-0.8.20" / "solc-0.8.20")


def test_path_installs_online_version_when_not_installed(monkeypatch, tmp_path):
    debug_logs = []
    monkeypatch.setattr(mut.sb.debug, "log", lambda msg: debug_logs.append(msg))

    created_versions = []

    def fake_solc_version(version):
        obj = SimpleNamespace(version=version)
        created_versions.append(obj)
        return obj

    monkeypatch.setattr(
        mut.solc_select.models.versions,
        "SolcVersion",
        fake_solc_version,
    )

    service = DummyService(
        platform=None,
        available={DummyVersion("0.8.21"): object()},
        installed=[],
        install_success=True,
    )
    mut.SERVICE = service
    mut.ONLINE = {"0.8.21"}
    mut.ARTIFACTS_DIR = tmp_path / "artifacts"

    result = mut.path("0.8.21")

    assert len(created_versions) == 1
    assert created_versions[0].version == "0.8.21"
    assert service.artifact_manager.calls == [([created_versions[0]], True)]
    assert result == str(tmp_path / "artifacts" / "solc-0.8.21" / "solc-0.8.21")


def test_path_returns_none_when_install_fails(monkeypatch, tmp_path):
    monkeypatch.setattr(mut.sb.debug, "log", lambda msg: None)
    monkeypatch.setattr(
        mut.solc_select.models.versions,
        "SolcVersion",
        lambda version: SimpleNamespace(version=version),
    )

    service = DummyService(
        platform=None,
        available={DummyVersion("0.8.21"): object()},
        installed=[],
        install_success=False,
    )
    mut.SERVICE = service
    mut.ONLINE = {"0.8.21"}
    mut.ARTIFACTS_DIR = tmp_path / "artifacts"

    result = mut.path("0.8.21")

    assert result is None
    assert len(service.artifact_manager.calls) == 1


def test_path_returns_none_when_version_not_installed_or_online(monkeypatch):
    monkeypatch.setattr(mut.sb.debug, "log", lambda msg: None)

    service = DummyService(
        platform=None,
        available={DummyVersion("0.8.20"): object()},
        installed=[DummyVersion("0.7.6")],
    )
    mut.SERVICE = service
    mut.ONLINE = {"0.8.20"}

    result = mut.path("0.6.0")

    assert result is None
    assert service.artifact_manager.calls == []


def test_path_checks_installed_versions_each_call(monkeypatch, tmp_path):
    monkeypatch.setattr(mut.sb.debug, "log", lambda msg: None)

    calls = {"count": 0}

    class CountingService(DummyService):
        def get_installed_versions(self):
            calls["count"] += 1
            return [DummyVersion("0.8.20")]

    service = CountingService(platform=None)
    mut.SERVICE = service
    mut.ONLINE = set()
    mut.ARTIFACTS_DIR = tmp_path / "artifacts"

    result = mut.path("0.8.20")

    assert result == str(tmp_path / "artifacts" / "solc-0.8.20" / "solc-0.8.20")
    assert calls["count"] == 1
