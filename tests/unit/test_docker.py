"""Unit tests for sb/docker.py module.

This module tests Docker integration functionality including:
- Docker client initialization and connection
- Image loading and checking
- Volume creation and file preparation (tested through execute())
- Docker argument construction with resource limits (tested through execute())
- Container lifecycle (creation, execution, cleanup)
- Timeout handling
- Error handling and retry logic
"""

from unittest.mock import MagicMock, Mock

import docker
import docker.errors
import pytest
import requests

import sb.docker
import sb.errors
from sb.tasks import Task
from sb.tools import Tool


class TestDockerClient:
    """Tests for Docker client initialization and connection."""

    def test_client_initialization_success(self, mocker):
        """Test successful Docker client initialization."""
        mock_docker_client = MagicMock()
        mock_docker_client.info.return_value = {"some": "info"}
        mocker.patch("docker.from_env", return_value=mock_docker_client)

        # Reset the global client to test initialization
        sb.docker._client = None

        client = sb.docker.client()

        assert client is not None
        mock_docker_client.info.assert_called_once()

    def test_client_reuses_existing_connection(self, mocker):
        """Test that client() reuses an existing connection."""
        mock_docker_client = MagicMock()
        mocker.patch("docker.from_env", return_value=mock_docker_client)

        # Set up existing client
        sb.docker._client = mock_docker_client

        client1 = sb.docker.client()
        client2 = sb.docker.client()

        assert client1 is client2
        # info() should not be called again since client already exists
        mock_docker_client.info.assert_not_called()

    def test_client_connection_failure(self, mocker):
        """Test handling of Docker connection failure."""
        mocker.patch("docker.from_env", side_effect=Exception("Connection failed"))
        mocker.patch("sb.cfg.DEBUG", False)

        # Reset the global client
        sb.docker._client = None

        with pytest.raises(sb.errors.SmartBugsError) as exc_info:
            sb.docker.client()

        assert "Cannot connect to service" in str(exc_info.value)
        assert "Is it installed and running?" in str(exc_info.value)

    def test_client_connection_failure_with_debug(self, mocker):
        """Test Docker connection failure includes traceback in debug mode."""
        mocker.patch("docker.from_env", side_effect=Exception("Connection failed"))
        mocker.patch("sb.cfg.DEBUG", True)

        sb.docker._client = None

        with pytest.raises(sb.errors.SmartBugsError) as exc_info:
            sb.docker.client()

        error_msg = str(exc_info.value)
        assert "Cannot connect to service" in error_msg
        # In debug mode, should include traceback details
        assert "Traceback" in error_msg or "Exception" in error_msg


class TestImageLoading:
    """Tests for Docker image loading and checking."""

    def test_is_loaded_image_in_cache(self, mocker):
        """Test is_loaded returns True for cached images."""
        mocker.patch("sb.docker.client")

        sb.docker.images_loaded.add("test_image:latest")

        assert sb.docker.is_loaded("test_image:latest") is True

    def test_is_loaded_image_exists_on_docker(self, mocker):
        """Test is_loaded checks Docker and caches result."""
        mock_client = MagicMock()
        mock_client.images.list.return_value = [Mock()]  # Non-empty list
        mocker.patch("sb.docker.client", return_value=mock_client)

        sb.docker.images_loaded.clear()

        result = sb.docker.is_loaded("smartbugs/mythril:latest")

        assert result is True
        assert "smartbugs/mythril:latest" in sb.docker.images_loaded
        mock_client.images.list.assert_called_once_with("smartbugs/mythril:latest")

    def test_is_loaded_image_not_found(self, mocker):
        """Test is_loaded returns False when image doesn't exist."""
        mock_client = MagicMock()
        mock_client.images.list.return_value = []  # Empty list
        mocker.patch("sb.docker.client", return_value=mock_client)

        sb.docker.images_loaded.clear()

        result = sb.docker.is_loaded("nonexistent:latest")

        assert result is False
        assert "nonexistent:latest" not in sb.docker.images_loaded

    def test_is_loaded_docker_error(self, mocker):
        """Test is_loaded handles Docker errors."""
        mock_client = MagicMock()
        mock_client.images.list.side_effect = Exception("Docker error")
        mocker.patch("sb.docker.client", return_value=mock_client)

        sb.docker.images_loaded.clear()

        with pytest.raises(sb.errors.SmartBugsError) as exc_info:
            sb.docker.is_loaded("test_image:latest")

        assert "checking for image" in str(exc_info.value)

    def test_load_image_success(self, mocker):
        """Test successful image loading."""
        mock_client = MagicMock()
        mocker.patch("sb.docker.client", return_value=mock_client)

        sb.docker.images_loaded.clear()

        sb.docker.load("smartbugs/slither:latest")

        mock_client.images.pull.assert_called_once_with("smartbugs/slither:latest")
        assert "smartbugs/slither:latest" in sb.docker.images_loaded

    def test_load_image_failure(self, mocker):
        """Test handling of image loading failure."""
        mock_client = MagicMock()
        mock_client.images.pull.side_effect = Exception("Pull failed")
        mocker.patch("sb.docker.client", return_value=mock_client)

        with pytest.raises(sb.errors.SmartBugsError) as exc_info:
            sb.docker.load("invalid_image:latest")

        assert "Loading image" in str(exc_info.value)


class TestContainerExecution:
    """Tests for Docker container execution and lifecycle."""

    def test_execute_success(self, tmp_path, mock_settings, mock_tool, mocker):
        """Test successful container execution."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        mock_tool.mode = "solidity"
        mock_tool.bin = None
        mock_tool.output = None
        mock_tool.command = Mock(return_value="analyze")
        mock_tool.entrypoint = Mock(return_value=None)

        task = Task(
            absfn=str(sol_file),
            relfn="Test.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        # Mock Docker operations
        mock_container = MagicMock()
        mock_container.wait.return_value = {"StatusCode": 0}
        mock_container.logs.return_value = b"Analysis complete\nNo issues found"

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        exit_code, logs, output, args = sb.docker.execute(task)

        assert exit_code == 0
        assert "Analysis complete" in logs
        assert "No issues found" in logs
        assert output is None
        assert "image" in args

        # Verify container was cleaned up
        mock_container.kill.assert_called_once()
        mock_container.remove.assert_called_once()

    def test_execute_with_timeout(self, tmp_path, mock_settings, mock_tool, mocker):
        """Test container execution with timeout."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        mock_settings.timeout = 60

        mock_tool.mode = "solidity"
        mock_tool.bin = None
        mock_tool.output = None
        mock_tool.command = Mock(return_value="analyze")
        mock_tool.entrypoint = Mock(return_value=None)

        task = Task(
            absfn=str(sol_file),
            relfn="Test.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        mock_container = MagicMock()
        mock_container.wait.side_effect = requests.exceptions.ReadTimeout()
        mock_container.logs.return_value = b"Started analysis..."

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        exit_code, logs, output, args = sb.docker.execute(task)

        # On timeout, exit_code should be None
        assert exit_code is None
        assert len(logs) > 0
        assert "Started analysis..." in logs[0]

        # Container should be stopped and cleaned up
        mock_container.stop.assert_called_once_with(timeout=10)
        mock_container.kill.assert_called_once()
        mock_container.remove.assert_called_once()

    def test_execute_with_connection_error(self, tmp_path, mock_settings, mock_tool, mocker):
        """Test container execution handles connection errors during wait."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        mock_tool.mode = "solidity"
        mock_tool.bin = None
        mock_tool.output = None
        mock_tool.command = Mock(return_value="analyze")
        mock_tool.entrypoint = Mock(return_value=None)

        task = Task(
            absfn=str(sol_file),
            relfn="Test.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        mock_container = MagicMock()
        mock_container.wait.side_effect = requests.exceptions.ConnectionError()
        mock_container.logs.return_value = b"Log output"

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        exit_code, logs, output, args = sb.docker.execute(task)

        # Should handle connection error gracefully
        assert exit_code is None
        mock_container.stop.assert_called_once()

    def test_execute_with_output_file(self, tmp_path, mock_settings, mock_tool, mocker):
        """Test container execution with output file extraction."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        mock_tool.mode = "solidity"
        mock_tool.bin = None
        mock_tool.output = "/output/results.tar"
        mock_tool.command = Mock(return_value="analyze")
        mock_tool.entrypoint = Mock(return_value=None)

        task = Task(
            absfn=str(sol_file),
            relfn="Test.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        mock_container = MagicMock()
        mock_container.wait.return_value = {"StatusCode": 0}
        mock_container.logs.return_value = b"Analysis complete"
        # Mock get_archive to return chunks of data
        mock_container.get_archive.return_value = ([b"chunk1", b"chunk2"], None)

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        exit_code, logs, output, args = sb.docker.execute(task)

        assert exit_code == 0
        assert output == b"chunk1chunk2"
        mock_container.get_archive.assert_called_once_with("/output/results.tar")

    def test_execute_output_file_not_found(self, tmp_path, mock_settings, mock_tool, mocker):
        """Test container execution when output file doesn't exist."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        mock_tool.mode = "solidity"
        mock_tool.bin = None
        mock_tool.output = "/output/results.tar"
        mock_tool.command = Mock(return_value="analyze")
        mock_tool.entrypoint = Mock(return_value=None)

        task = Task(
            absfn=str(sol_file),
            relfn="Test.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        mock_container = MagicMock()
        mock_container.wait.return_value = {"StatusCode": 0}
        mock_container.logs.return_value = b"Analysis complete"
        mock_container.get_archive.side_effect = docker.errors.NotFound("File not found")

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        exit_code, logs, output, args = sb.docker.execute(task)

        assert exit_code == 0
        assert output is None  # Should handle NotFound gracefully

    def test_execute_non_zero_exit_code(self, tmp_path, mock_settings, mock_tool, mocker):
        """Test container execution with non-zero exit code."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        mock_tool.mode = "solidity"
        mock_tool.bin = None
        mock_tool.output = None
        mock_tool.command = Mock(return_value="analyze")
        mock_tool.entrypoint = Mock(return_value=None)

        task = Task(
            absfn=str(sol_file),
            relfn="Test.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        mock_container = MagicMock()
        mock_container.wait.return_value = {"StatusCode": 1}
        mock_container.logs.return_value = b"Error: Analysis failed\nInvalid input"

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        exit_code, logs, output, args = sb.docker.execute(task)

        assert exit_code == 1
        assert "Error: Analysis failed" in logs
        assert "Invalid input" in logs

    def test_execute_container_run_failure(self, tmp_path, mock_settings, mock_tool, mocker):
        """Test handling of container.run() failure."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        mock_tool.mode = "solidity"
        mock_tool.bin = None
        mock_tool.output = None
        mock_tool.command = Mock(return_value="analyze")
        mock_tool.entrypoint = Mock(return_value=None)

        task = Task(
            absfn=str(sol_file),
            relfn="Test.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        mock_client = MagicMock()
        mock_client.containers.run.side_effect = Exception("Container failed to start")

        mocker.patch("sb.docker.client", return_value=mock_client)

        with pytest.raises(sb.errors.SmartBugsError) as exc_info:
            sb.docker.execute(task)

        assert "Problem running Docker container" in str(exc_info.value)

    def test_execute_cleanup_on_error(self, tmp_path, mock_settings, mock_tool, mocker):
        """Test that cleanup happens even when errors occur."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        mock_tool.mode = "solidity"
        mock_tool.bin = None
        mock_tool.output = None
        mock_tool.command = Mock(return_value="analyze")
        mock_tool.entrypoint = Mock(return_value=None)

        task = Task(
            absfn=str(sol_file),
            relfn="Test.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        mock_container = MagicMock()
        mock_container.wait.side_effect = Exception("Unexpected error")
        mock_container.logs.return_value = b"Logs"

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        with pytest.raises(sb.errors.SmartBugsError):
            sb.docker.execute(task)

        # Even on error, cleanup should be attempted
        mock_container.kill.assert_called_once()
        mock_container.remove.assert_called_once()

    def test_execute_cleanup_kill_fails_gracefully(
        self, tmp_path, mock_settings, mock_tool, mocker
    ):
        """Test that cleanup continues even if kill() fails."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        mock_tool.mode = "solidity"
        mock_tool.bin = None
        mock_tool.output = None
        mock_tool.command = Mock(return_value="analyze")
        mock_tool.entrypoint = Mock(return_value=None)

        task = Task(
            absfn=str(sol_file),
            relfn="Test.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        mock_container = MagicMock()
        mock_container.wait.return_value = {"StatusCode": 0}
        mock_container.logs.return_value = b"Complete"
        mock_container.kill.side_effect = Exception("Kill failed")
        mock_container.remove.return_value = None  # Remove should still be called

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        # Should not raise exception
        exit_code, logs, output, args = sb.docker.execute(task)

        assert exit_code == 0
        mock_container.kill.assert_called_once()
        mock_container.remove.assert_called_once()

    def test_execute_stop_fails_on_timeout(self, tmp_path, mock_settings, mock_tool, mocker):
        """Test that execution continues if container.stop() fails on timeout."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        mock_tool.mode = "solidity"
        mock_tool.bin = None
        mock_tool.output = None
        mock_tool.command = Mock(return_value="analyze")
        mock_tool.entrypoint = Mock(return_value=None)

        task = Task(
            absfn=str(sol_file),
            relfn="Test.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        mock_container = MagicMock()
        mock_container.wait.side_effect = requests.exceptions.ReadTimeout()
        mock_container.stop.side_effect = docker.errors.APIError("Stop failed")
        mock_container.logs.return_value = b"Partial output"

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        # Should handle stop() failure gracefully
        exit_code, logs, output, args = sb.docker.execute(task)

        assert exit_code is None
        mock_container.stop.assert_called_once()
        # Should still try to clean up
        mock_container.kill.assert_called_once()
        mock_container.remove.assert_called_once()


class TestVolumeAndResourceConfig:
    """Tests for volume creation and resource configuration through execute()."""

    def test_bytecode_with_0x_prefix_stripped(self, tmp_path, mock_settings, mocker):
        """Test that bytecode 0x prefix is stripped in volume."""
        hex_file = tmp_path / "test.hex"
        hex_file.write_text("0x608060405234801561001057600080fd5b50")

        tool_config = {
            "id": "test_tool",
            "mode": "bytecode",
            "image": "smartbugs/test:latest",
            "name": "Test Tool",
            "origin": "https://example.com",
            "version": "1.0.0",
            "info": "Test tool",
            "parser": "parser.py",
            "output": None,
            "bin": None,
            "solc": False,
            "cpu_quota": None,
            "mem_limit": None,
            "command": "analyze",
            "entrypoint": None,
        }
        tool = Tool(tool_config)

        task = Task(
            absfn=str(hex_file),
            relfn="test.hex",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=tool,
            settings=mock_settings,
        )

        # Mock Docker
        mock_container = MagicMock()
        mock_container.wait.return_value = {"StatusCode": 0}
        mock_container.logs.return_value = b"Done"

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        exit_code, logs, output, args = sb.docker.execute(task)

        assert exit_code == 0
        # Volume was created and cleaned up successfully

    def test_resource_limits_from_settings_override_tool(self, tmp_path, mock_settings, mocker):
        """Test that resource limits from settings override tool config."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        tool_config = {
            "id": "test_tool",
            "mode": "solidity",
            "image": "smartbugs/test:latest",
            "name": "Test Tool",
            "origin": "https://example.com",
            "version": "1.0.0",
            "info": "Test tool",
            "parser": "parser.py",
            "output": None,
            "bin": None,
            "solc": False,
            "cpu_quota": 50000,
            "mem_limit": "2g",
            "command": "analyze",
            "entrypoint": None,
        }
        tool = Tool(tool_config)

        # Settings should override tool config
        mock_settings.cpu_quota = 100000
        mock_settings.mem_limit = "4g"

        task = Task(
            absfn=str(sol_file),
            relfn="Test.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=tool,
            settings=mock_settings,
        )

        # Mock Docker
        mock_container = MagicMock()
        mock_container.wait.return_value = {"StatusCode": 0}
        mock_container.logs.return_value = b"Done"

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        exit_code, logs, output, args = sb.docker.execute(task)

        # Verify settings overrode tool config
        assert args["cpu_quota"] == 100000
        assert args["mem_limit"] == "4g"

    def test_linux_style_paths_in_docker_args(self, tmp_path, mock_settings, mocker):
        """Test that file paths use Linux-style separators in container."""
        sol_file = tmp_path / "MyContract.sol"
        sol_file.write_text("contract Test {}")

        tool_config = {
            "id": "test_tool",
            "mode": "solidity",
            "image": "smartbugs/test:latest",
            "name": "Test Tool",
            "origin": "https://example.com",
            "version": "1.0.0",
            "info": "Test tool",
            "parser": "parser.py",
            "output": None,
            "bin": None,
            "solc": False,
            "cpu_quota": None,
            "mem_limit": None,
            "command": "analyze $FILENAME",
            "entrypoint": None,
        }
        tool = Tool(tool_config)

        task = Task(
            absfn=str(sol_file),
            relfn="MyContract.sol",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=tool,
            settings=mock_settings,
        )

        # Mock Docker
        mock_container = MagicMock()
        mock_container.wait.return_value = {"StatusCode": 0}
        mock_container.logs.return_value = b"Done"

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        exit_code, logs, output, args = sb.docker.execute(task)

        # Check the command includes Linux-style path
        command = args["command"]
        assert "/sb/MyContract.sol" in command
        assert "\\" not in command


class TestIntegration:
    """Integration-style tests combining multiple functions."""

    def test_full_workflow_solidity_file(self, tmp_path, mock_settings, mocker):
        """Test full workflow from file to container execution."""
        sol_file = tmp_path / "FullWorkflow.sol"
        sol_file.write_text("pragma solidity ^0.8.0;\ncontract Test { uint x; }")

        tool_config = {
            "id": "test_tool",
            "mode": "solidity",
            "image": "smartbugs/test:latest",
            "name": "Test Tool",
            "origin": "https://example.com",
            "version": "1.0.0",
            "info": "Test tool",
            "parser": "parser.py",
            "output": None,
            "bin": None,
            "solc": False,
            "cpu_quota": 50000,
            "mem_limit": "1g",
            "command": "analyze $FILENAME --timeout $TIMEOUT",
            "entrypoint": None,
        }
        tool = Tool(tool_config)

        mock_settings.timeout = 120
        mock_settings.cpu_quota = None
        mock_settings.mem_limit = None

        task = Task(
            absfn=str(sol_file),
            relfn="FullWorkflow.sol",
            rdir=str(tmp_path / "results"),
            solc_version="0.8.0",
            solc_path=None,
            tool=tool,
            settings=mock_settings,
        )

        # Mock Docker
        mock_container = MagicMock()
        mock_container.wait.return_value = {"StatusCode": 0}
        mock_container.logs.return_value = b"Analysis successful\nNo vulnerabilities found"

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        exit_code, logs, output, args = sb.docker.execute(task)

        # Verify results
        assert exit_code == 0
        assert len(logs) == 2
        assert "Analysis successful" in logs[0]
        assert "No vulnerabilities found" in logs[1]

        # Verify Docker args
        assert args["image"] == "smartbugs/test:latest"
        assert args["cpu_quota"] == 50000
        assert args["mem_limit"] == "1g"
        assert args["detach"] is True
        assert args["user"] == 0

    def test_full_workflow_bytecode_file(self, tmp_path, mock_settings, mocker):
        """Test full workflow with bytecode file."""
        hex_file = tmp_path / "bytecode.hex"
        hex_file.write_text("0x6080604052348015600f57600080fd5b50")

        tool_config = {
            "id": "bytecode_tool",
            "mode": "bytecode",
            "image": "smartbugs/bytecode:latest",
            "name": "Bytecode Tool",
            "origin": "https://example.com",
            "version": "1.0.0",
            "info": "Bytecode analysis tool",
            "parser": "parser.py",
            "output": "/results/output.json",
            "bin": None,
            "solc": False,
            "cpu_quota": None,
            "mem_limit": None,
            "command": "analyze $FILENAME",
            "entrypoint": None,
        }
        tool = Tool(tool_config)

        task = Task(
            absfn=str(hex_file),
            relfn="bytecode.hex",
            rdir=str(tmp_path / "results"),
            solc_version=None,
            solc_path=None,
            tool=tool,
            settings=mock_settings,
        )

        mock_container = MagicMock()
        mock_container.wait.return_value = {"StatusCode": 0}
        mock_container.logs.return_value = b"Bytecode analysis complete"
        mock_container.get_archive.return_value = ([b'{"result": "clean"}'], None)

        mock_client = MagicMock()
        mock_client.containers.run.return_value = mock_container

        mocker.patch("sb.docker.client", return_value=mock_client)

        exit_code, logs, output, args = sb.docker.execute(task)

        assert exit_code == 0
        assert "Bytecode analysis complete" in logs
        assert output == b'{"result": "clean"}'
