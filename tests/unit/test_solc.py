from unittest.mock import patch, MagicMock

import solc_select.models.versions
import sb.solc


@patch("sb.debug.log")
@patch("solc_select.services.solc_service.SolcService")
@patch("solc_select.infrastructure.filesystem")
def test_init_service_sets_globals(fs_mock, service_mock, log_mock, monkeypatch):
    mock_service = MagicMock()
    mock_service.repository_matcher.get_all_available_versions.return_value = {
        solc_select.models.versions.SolcVersion("1.0.0"): None
    }
    mock_service.get_installed_versions.return_value = [
        solc_select.models.versions.SolcVersion("0.9.0")
    ]
    service_mock.return_value = mock_service

    sb.solc.init_service()

    assert "1.0.0" in sb.solc.ONLINE
    assert "0.9.0" in sb.solc.AVAILABLE
    assert isinstance(sb.solc.SERVICE, MagicMock)


@patch("sb.debug.log")
@patch("solc_select.services.solc_service.SolcService")
@patch("solc_select.infrastructure.filesystem")
def test_path_returns_path_if_installed(fs_mock, service_mock, log_mock):
    mock_service = MagicMock()
    mock_service.get_installed_versions.return_value = [
        solc_select.models.versions.SolcVersion("1.2.3")
    ]
    mock_service.repository_matcher.get_all_available_versions.return_value = {}
    service_mock.return_value = mock_service

    sb.solc.init_service()
    result = sb.solc.path("1.2.3")
    assert "solc-1.2.3/solc-1.2.3" in result


@patch("sb.debug.log")
@patch("solc_select.services.solc_service.SolcService")
@patch("solc_select.infrastructure.filesystem")
def test_path_installs_if_online(fs_mock, service_mock, log_mock):
    mock_service = MagicMock()
    mock_service.get_installed_versions.return_value = []
    mock_service.repository_matcher.get_all_available_versions.return_value = {
        solc_select.models.versions.SolcVersion("2.0.0"): None
    }
    mock_service.artifact_manager.install_versions.return_value = True
    service_mock.return_value = mock_service

    sb.solc.SERVICE = None
    result = sb.solc.path("2.0.0")
    assert "solc-2.0.0/solc-2.0.0" in result


@patch("sb.debug.log")
@patch("solc_select.services.solc_service.SolcService")
@patch("solc_select.infrastructure.filesystem")
def test_path_returns_none_if_install_fails(fs_mock, service_mock, log_mock):
    mock_service = MagicMock()
    mock_service.get_installed_versions.return_value = []
    mock_service.repository_matcher.get_all_available_versions.return_value = {
        solc_select.models.versions.SolcVersion("2.0.0"): None
    }
    mock_service.artifact_manager.install_versions.return_value = False
    service_mock.return_value = mock_service

    sb.solc.SERVICE = None
    assert sb.solc.path("2.0.0") is None


@patch("sb.debug.log")
@patch("solc_select.services.solc_service.SolcService")
@patch("solc_select.infrastructure.filesystem")
def test_path_returns_none_if_unknown(fs_mock, service_mock, log_mock):
    mock_service = MagicMock()
    mock_service.get_installed_versions.return_value = []
    mock_service.repository_matcher.get_all_available_versions.return_value = {}
    service_mock.return_value = mock_service

    sb.solc.SERVICE = None
    assert sb.solc.path("9.9.9") is None


@patch("sb.debug.log")
def test_path_none_argument_returns_none(log_mock):
    assert sb.solc.path(None) is None
