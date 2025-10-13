"""Unit tests for sb.smartbugs orchestration logic.

This module tests the main orchestration functions in sb/smartbugs.py:
- collect_files: File collection with glob patterns
- collect_tasks: Task assembly pairing files with tools
- Tool/Docker image loading
- Handling of tool aliases and special file types (.sbd, .hex, .sol)
"""

import os
from pathlib import Path
from typing import Any
from unittest.mock import MagicMock, patch

import pytest

import sb.errors
import sb.smartbugs
import sb.tasks
import sb.tools
from sb.settings import Settings


class TestCollectFiles:
    """Tests for the collect_files function."""

    def test_collect_single_sol_file(self, tmp_path: Path) -> None:
        """Test collecting a single .sol file."""
        # Create test file
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("pragma solidity ^0.8.0;")

        # Collect with absolute path
        patterns = [(None, str(sol_file))]
        files = sb.smartbugs.collect_files(patterns)

        assert len(files) == 1
        absfn, relfn = files[0]
        assert os.path.isabs(absfn)
        assert absfn.endswith("Test.sol")

    def test_collect_multiple_sol_files_with_glob(self, tmp_path: Path) -> None:
        """Test collecting multiple .sol files using glob patterns."""
        # Create test files
        (tmp_path / "Contract1.sol").write_text("pragma solidity ^0.8.0;")
        (tmp_path / "Contract2.sol").write_text("pragma solidity ^0.8.0;")
        (tmp_path / "readme.txt").write_text("not a contract")

        # Collect with glob pattern
        patterns = [(None, str(tmp_path / "*.sol"))]
        files = sb.smartbugs.collect_files(patterns)

        assert len(files) == 2
        filenames = [os.path.basename(f[0]) for f in files]
        assert "Contract1.sol" in filenames
        assert "Contract2.sol" in filenames

    def test_collect_hex_files(self, tmp_path: Path) -> None:
        """Test collecting .hex files (bytecode)."""
        hex_file = tmp_path / "bytecode.hex"
        hex_file.write_text("608060405234801561001057600080fd5b50")

        patterns = [(None, str(hex_file))]
        files = sb.smartbugs.collect_files(patterns)

        assert len(files) == 1
        assert files[0][0].endswith(".hex")

    def test_collect_recursive_glob(self, tmp_path: Path) -> None:
        """Test collecting files recursively with ** glob pattern."""
        # Create nested directory structure
        subdir = tmp_path / "contracts" / "utils"
        subdir.mkdir(parents=True)
        (tmp_path / "Top.sol").write_text("pragma solidity ^0.8.0;")
        (tmp_path / "contracts" / "Middle.sol").write_text("pragma solidity ^0.8.0;")
        (subdir / "Deep.sol").write_text("pragma solidity ^0.8.0;")

        # Collect recursively
        patterns = [(None, str(tmp_path / "**/*.sol"))]
        files = sb.smartbugs.collect_files(patterns)

        assert len(files) == 3
        filenames = [os.path.basename(f[0]) for f in files]
        assert "Top.sol" in filenames
        assert "Middle.sol" in filenames
        assert "Deep.sol" in filenames

    def test_collect_sbd_file(self, tmp_path: Path) -> None:
        """Test collecting contracts from .sbd file (SmartBugs Dataset)."""
        # Create actual contract files
        contract1 = tmp_path / "Contract1.sol"
        contract2 = tmp_path / "Contract2.sol"
        contract1.write_text("pragma solidity ^0.8.0;")
        contract2.write_text("pragma solidity ^0.8.0;")

        # Create .sbd file with paths
        sbd_file = tmp_path / "dataset.sbd"
        sbd_file.write_text(f"{contract1}\n{contract2}\n")

        patterns = [(None, str(sbd_file))]
        files = sb.smartbugs.collect_files(patterns)

        assert len(files) == 2

    def test_collect_with_root_directory(self, tmp_path: Path) -> None:
        """Test collecting files with root directory specification (Python 3.10+)."""
        # Create test file
        (tmp_path / "Test.sol").write_text("pragma solidity ^0.8.0;")

        # Test with root parameter (may raise TypeError on Python < 3.10)
        patterns = [(str(tmp_path), "*.sol")]
        try:
            files = sb.smartbugs.collect_files(patterns)
            assert len(files) == 1
        except sb.errors.SmartBugsError as e:
            # Expected on Python < 3.10
            assert "colons in file patterns only supported" in str(e)

    def test_collect_ignores_directories(self, tmp_path: Path) -> None:
        """Test that directories are ignored, only files collected."""
        # Create directory with same name pattern
        (tmp_path / "NotAFile.sol").mkdir()
        real_file = tmp_path / "RealFile.sol"
        real_file.write_text("pragma solidity ^0.8.0;")

        patterns = [(None, str(tmp_path / "*.sol"))]
        files = sb.smartbugs.collect_files(patterns)

        assert len(files) == 1
        assert files[0][0] == str(real_file.resolve())

    def test_collect_ignores_non_sol_hex_files(self, tmp_path: Path) -> None:
        """Test that only .sol and .hex files are collected."""
        (tmp_path / "test.sol").write_text("pragma solidity ^0.8.0;")
        (tmp_path / "test.hex").write_text("608060405234801561001057600080fd5b50")
        (tmp_path / "test.txt").write_text("ignored")
        (tmp_path / "test.py").write_text("ignored")

        patterns = [(None, str(tmp_path / "*"))]
        files = sb.smartbugs.collect_files(patterns)

        assert len(files) == 2
        extensions = [os.path.splitext(f[0])[1] for f in files]
        assert ".sol" in extensions
        assert ".hex" in extensions

    def test_collect_empty_patterns(self) -> None:
        """Test collecting with empty patterns list."""
        patterns = []
        files = sb.smartbugs.collect_files(patterns)

        assert files == []

    def test_collect_nonexistent_file(self, tmp_path: Path) -> None:
        """Test collecting nonexistent file returns empty list."""
        patterns = [(None, str(tmp_path / "nonexistent.sol"))]
        files = sb.smartbugs.collect_files(patterns)

        assert files == []

    def test_collect_removes_duplicates(self, tmp_path: Path) -> None:
        """Test that duplicate file paths are handled correctly."""
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("pragma solidity ^0.8.0;")

        # Same file specified twice with different patterns
        patterns = [(None, str(sol_file)), (None, str(tmp_path / "*.sol"))]
        files = sb.smartbugs.collect_files(patterns)

        # Should include duplicates at collect stage (removed in collect_tasks)
        assert len(files) >= 1


class TestCollectTasks:
    """Tests for the collect_tasks function."""

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    @patch("sb.io.read_lines")
    def test_collect_tasks_basic(
        self,
        mock_read_lines: MagicMock,
        mock_load: MagicMock,
        mock_is_loaded: MagicMock,
        tmp_path: Path,
    ) -> None:
        """Test basic task assembly pairing files with tools."""
        mock_is_loaded.return_value = True
        mock_read_lines.return_value = ["pragma solidity ^0.8.0;", "contract Test {}"]

        # Create test file
        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("pragma solidity ^0.8.0;\ncontract Test {}")

        files = [(str(sol_file), "Test.sol")]
        tool = self._create_test_tool("test_tool", "solidity")
        tools = [tool]

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")
        settings.timeout = 60

        settings.freeze()  # Must freeze settings before collect_tasks

        tasks = sb.smartbugs.collect_tasks(files, tools, settings)

        assert len(tasks) == 1
        assert tasks[0].absfn == str(sol_file)
        assert tasks[0].relfn == "Test.sol"
        assert tasks[0].tool.id == "test_tool"

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    @patch("sb.solidity.ensure_solc_versions_loaded")
    @patch("sb.solidity.get_solc_version")
    @patch("sb.solidity.get_solc_path")
    @patch("sb.io.read_lines")
    def test_collect_tasks_with_solc(
        self,
        mock_read_lines: MagicMock,
        mock_get_solc_path: MagicMock,
        mock_get_solc_version: MagicMock,
        mock_ensure_loaded: MagicMock,
        mock_load: MagicMock,
        mock_is_loaded: MagicMock,
        tmp_path: Path,
    ) -> None:
        """Test task assembly for tool requiring Solidity compiler."""
        mock_is_loaded.return_value = True
        mock_ensure_loaded.return_value = True
        mock_get_solc_version.return_value = "0.8.0"
        mock_get_solc_path.return_value = "/path/to/solc"
        mock_read_lines.return_value = ["pragma solidity ^0.8.0;", "contract Test {}"]

        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("pragma solidity ^0.8.0;\ncontract Test {}")

        files = [(str(sol_file), "Test.sol")]
        tool = self._create_test_tool("test_tool", "solidity", solc=True)
        tools = [tool]

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")

        settings.freeze()  # Must freeze settings before collect_tasks

        tasks = sb.smartbugs.collect_tasks(files, tools, settings)

        assert len(tasks) == 1
        assert tasks[0].solc_version == "0.8.0"
        assert tasks[0].solc_path == "/path/to/solc"

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    @patch("sb.io.read_lines")
    def test_collect_tasks_multiple_tools(
        self,
        mock_read_lines: MagicMock,
        mock_load: MagicMock,
        mock_is_loaded: MagicMock,
        tmp_path: Path,
    ) -> None:
        """Test collecting tasks with multiple tools."""
        mock_is_loaded.return_value = True
        mock_read_lines.return_value = ["pragma solidity ^0.8.0;", "contract Test {}"]

        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("pragma solidity ^0.8.0;\ncontract Test {}")

        files = [(str(sol_file), "Test.sol")]
        tools = [
            self._create_test_tool("tool1", "solidity"),
            self._create_test_tool("tool2", "solidity"),
        ]

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")

        settings.freeze()  # Must freeze settings before collect_tasks

        tasks = sb.smartbugs.collect_tasks(files, tools, settings)

        assert len(tasks) == 2
        tool_ids = [t.tool.id for t in tasks]
        assert "tool1" in tool_ids
        assert "tool2" in tool_ids

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    @patch("sb.io.read_lines")
    def test_collect_tasks_multiple_files(
        self,
        mock_read_lines: MagicMock,
        mock_load: MagicMock,
        mock_is_loaded: MagicMock,
        tmp_path: Path,
    ) -> None:
        """Test collecting tasks with multiple files."""
        mock_is_loaded.return_value = True

        def read_side_effect(fn: str) -> list[str]:
            if "Test1" in fn:
                return ["pragma solidity ^0.8.0;", "contract Test1 {}"]
            return ["pragma solidity ^0.8.0;", "contract Test2 {}"]

        mock_read_lines.side_effect = read_side_effect

        sol1 = tmp_path / "Test1.sol"
        sol2 = tmp_path / "Test2.sol"
        sol1.write_text("pragma solidity ^0.8.0;\ncontract Test1 {}")
        sol2.write_text("pragma solidity ^0.8.0;\ncontract Test2 {}")

        files = [(str(sol1), "Test1.sol"), (str(sol2), "Test2.sol")]
        tool = self._create_test_tool("test_tool", "solidity")

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")

        settings.freeze()  # Must freeze settings before collect_tasks

        tasks = sb.smartbugs.collect_tasks(files, [tool], settings)

        assert len(tasks) == 2

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    def test_collect_tasks_hex_bytecode(
        self, mock_load: MagicMock, mock_is_loaded: MagicMock, tmp_path: Path
    ) -> None:
        """Test task assembly for hex bytecode files."""
        mock_is_loaded.return_value = True

        hex_file = tmp_path / "test.hex"
        hex_file.write_text("608060405234801561001057600080fd5b50")

        files = [(str(hex_file), "test.hex")]
        tool = self._create_test_tool("test_tool", "bytecode")

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")
        settings.runtime = False

        settings.freeze()  # Must freeze settings before collect_tasks

        tasks = sb.smartbugs.collect_tasks(files, [tool], settings)

        assert len(tasks) == 1
        assert tasks[0].tool.mode == "bytecode"

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    def test_collect_tasks_runtime_bytecode(
        self, mock_load: MagicMock, mock_is_loaded: MagicMock, tmp_path: Path
    ) -> None:
        """Test task assembly for runtime bytecode with .rt.hex extension."""
        mock_is_loaded.return_value = True

        hex_file = tmp_path / "test.rt.hex"
        hex_file.write_text("608060405234801561001057600080fd5b50")

        files = [(str(hex_file), "test.rt.hex")]
        tool = self._create_test_tool("test_tool", "runtime")

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")
        settings.runtime = False

        settings.freeze()  # Must freeze settings before collect_tasks

        tasks = sb.smartbugs.collect_tasks(files, [tool], settings)

        assert len(tasks) == 1
        assert tasks[0].tool.mode == "runtime"

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    def test_collect_tasks_runtime_flag(
        self, mock_load: MagicMock, mock_is_loaded: MagicMock, tmp_path: Path
    ) -> None:
        """Test task assembly with --runtime flag treats .hex as runtime."""
        mock_is_loaded.return_value = True

        hex_file = tmp_path / "test.hex"
        hex_file.write_text("608060405234801561001057600080fd5b50")

        files = [(str(hex_file), "test.hex")]
        tool = self._create_test_tool("test_tool", "runtime")

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")
        settings.runtime = True  # --runtime flag

        settings.freeze()  # Must freeze settings before collect_tasks

        tasks = sb.smartbugs.collect_tasks(files, [tool], settings)

        assert len(tasks) == 1
        assert tasks[0].tool.mode == "runtime"

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    def test_collect_tasks_mode_mismatch(
        self, mock_load: MagicMock, mock_is_loaded: MagicMock, tmp_path: Path
    ) -> None:
        """Test that tools only match appropriate file types."""
        mock_is_loaded.return_value = True

        sol_file = tmp_path / "test.sol"
        sol_file.write_text("pragma solidity ^0.8.0;\ncontract Test {}")

        files = [(str(sol_file), "test.sol")]
        # Tool only supports bytecode mode, should not match .sol file
        tool = self._create_test_tool("test_tool", "bytecode")

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")

        settings.freeze()  # Must freeze settings before collect_tasks

        tasks = sb.smartbugs.collect_tasks(files, [tool], settings)

        assert len(tasks) == 0  # No match

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    @patch("sb.io.read_lines")
    def test_collect_tasks_removes_duplicates(
        self,
        mock_read_lines: MagicMock,
        mock_load: MagicMock,
        mock_is_loaded: MagicMock,
        tmp_path: Path,
    ) -> None:
        """Test that duplicate files are removed during task collection."""
        mock_is_loaded.return_value = True
        mock_read_lines.return_value = ["pragma solidity ^0.8.0;", "contract Test {}"]

        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("pragma solidity ^0.8.0;\ncontract Test {}")

        # Same file specified twice
        files = [(str(sol_file), "Test.sol"), (str(sol_file), "Test.sol")]
        tool = self._create_test_tool("test_tool", "solidity")

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")

        settings.freeze()  # Must freeze settings before collect_tasks

        tasks = sb.smartbugs.collect_tasks(files, [tool], settings)

        # Should only create one task
        assert len(tasks) == 1

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    @patch("sb.io.read_lines")
    def test_collect_tasks_main_contract_not_found(
        self,
        mock_read_lines: MagicMock,
        mock_load: MagicMock,
        mock_is_loaded: MagicMock,
        tmp_path: Path,
    ) -> None:
        """Test error when --main contract not found in file."""
        mock_is_loaded.return_value = True
        mock_read_lines.return_value = [
            "pragma solidity ^0.8.0;",
            "contract OtherContract {}",
        ]

        sol_file = tmp_path / "MyContract.sol"
        sol_file.write_text("pragma solidity ^0.8.0;\ncontract OtherContract {}")

        files = [(str(sol_file), "MyContract.sol")]
        tool = self._create_test_tool("test_tool", "solidity")

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")
        settings.main = True  # Expect contract named 'MyContract'

        settings.freeze()  # Must freeze settings before collect_tasks

        with pytest.raises(sb.errors.SmartBugsError) as exc_info:
            sb.smartbugs.collect_tasks(files, [tool], settings)

        assert "MyContract" in str(exc_info.value)
        assert "not found" in str(exc_info.value)

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    @patch("sb.solidity.ensure_solc_versions_loaded")
    @patch("sb.solidity.get_solc_version")
    @patch("sb.io.read_lines")
    def test_collect_tasks_no_pragma(
        self,
        mock_read_lines: MagicMock,
        mock_get_solc_version: MagicMock,
        mock_ensure_loaded: MagicMock,
        mock_load: MagicMock,
        mock_is_loaded: MagicMock,
        tmp_path: Path,
    ) -> None:
        """Test error when tool needs solc but file has no pragma."""
        mock_is_loaded.return_value = True
        mock_ensure_loaded.return_value = True
        mock_read_lines.return_value = ["contract Test {}"]  # No pragma

        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("contract Test {}")

        files = [(str(sol_file), "Test.sol")]
        tool = self._create_test_tool("test_tool", "solidity", solc=True)

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")

        settings.freeze()  # Must freeze settings before collect_tasks

        with pytest.raises(sb.errors.SmartBugsError) as exc_info:
            sb.smartbugs.collect_tasks(files, [tool], settings)

        assert "no pragma" in str(exc_info.value)

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    @patch("sb.solidity.ensure_solc_versions_loaded")
    @patch("sb.solidity.get_solc_version")
    @patch("sb.io.read_lines")
    def test_collect_tasks_no_matching_compiler(
        self,
        mock_read_lines: MagicMock,
        mock_get_solc_version: MagicMock,
        mock_ensure_loaded: MagicMock,
        mock_load: MagicMock,
        mock_is_loaded: MagicMock,
        tmp_path: Path,
    ) -> None:
        """Test error when no compiler matches pragma."""
        mock_is_loaded.return_value = True
        mock_ensure_loaded.return_value = True
        mock_get_solc_version.return_value = None  # No matching version
        mock_read_lines.return_value = ["pragma solidity ^0.99.0;", "contract Test {}"]

        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("pragma solidity ^0.99.0;\ncontract Test {}")

        files = [(str(sol_file), "Test.sol")]
        tool = self._create_test_tool("test_tool", "solidity", solc=True)

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")

        settings.freeze()  # Must freeze settings before collect_tasks

        with pytest.raises(sb.errors.SmartBugsError) as exc_info:
            sb.smartbugs.collect_tasks(files, [tool], settings)

        assert "no compiler found" in str(exc_info.value)

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    @patch("sb.solidity.ensure_solc_versions_loaded")
    @patch("sb.solidity.get_solc_version")
    @patch("sb.solidity.get_solc_path")
    @patch("sb.io.read_lines")
    def test_collect_tasks_continue_on_errors(
        self,
        mock_read_lines: MagicMock,
        mock_get_solc_path: MagicMock,
        mock_get_solc_version: MagicMock,
        mock_ensure_loaded: MagicMock,
        mock_load: MagicMock,
        mock_is_loaded: MagicMock,
        tmp_path: Path,
    ) -> None:
        """Test continue_on_errors flag allows partial task collection."""
        mock_is_loaded.return_value = True
        mock_ensure_loaded.return_value = True

        # First file has no pragma (will fail)
        # Second file is valid
        def read_side_effect(fn: str) -> list[str]:
            if "Bad" in fn:
                return ["contract Bad {}"]  # No pragma
            return ["pragma solidity ^0.8.0;", "contract Good {}"]

        mock_read_lines.side_effect = read_side_effect
        mock_get_solc_version.return_value = "0.8.0"
        mock_get_solc_path.return_value = "/path/to/solc"

        bad_file = tmp_path / "Bad.sol"
        good_file = tmp_path / "Good.sol"
        bad_file.write_text("contract Bad {}")
        good_file.write_text("pragma solidity ^0.8.0;\ncontract Good {}")

        files = [(str(bad_file), "Bad.sol"), (str(good_file), "Good.sol")]
        tool = self._create_test_tool("test_tool", "solidity", solc=True)

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")
        settings.continue_on_errors = True
        settings.freeze()  # Must freeze settings before collect_tasks

        # Should not raise, should collect only valid tasks
        tasks = sb.smartbugs.collect_tasks(files, [tool], settings)

        # Only the good file should have a task
        assert len(tasks) == 1
        assert "Good.sol" in tasks[0].relfn

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    @patch("sb.io.read_lines")
    def test_collect_tasks_result_dir_collisions(
        self,
        mock_read_lines: MagicMock,
        mock_load: MagicMock,
        mock_is_loaded: MagicMock,
        tmp_path: Path,
    ) -> None:
        """Test that result directory collisions are handled with disambiguation."""
        mock_is_loaded.return_value = True
        mock_read_lines.return_value = ["pragma solidity ^0.8.0;", "contract Test {}"]

        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("pragma solidity ^0.8.0;\ncontract Test {}")

        files = [(str(sol_file), "Test.sol")]
        # Only solidity mode tool will match .sol file
        tools = [
            self._create_test_tool("tool1", "solidity"),
            self._create_test_tool("tool2", "solidity"),
        ]

        settings = Settings()
        # Simple template that could cause collisions
        settings.results = str(tmp_path / "results" / "same_for_all")

        settings.freeze()  # Must freeze settings before collect_tasks

        tasks = sb.smartbugs.collect_tasks(files, tools, settings)

        # Check that result directories are unique
        rdirs = [t.rdir for t in tasks]
        assert len(rdirs) == len(set(rdirs))  # All unique

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    @patch("sb.io.read_lines")
    def test_collect_tasks_loads_docker_images(
        self,
        mock_read_lines: MagicMock,
        mock_load: MagicMock,
        mock_is_loaded: MagicMock,
        tmp_path: Path,
    ) -> None:
        """Test that Docker images are loaded if not already present."""
        # Image not loaded initially
        mock_is_loaded.return_value = False
        mock_read_lines.return_value = ["pragma solidity ^0.8.0;", "contract Test {}"]

        sol_file = tmp_path / "Test.sol"
        sol_file.write_text("pragma solidity ^0.8.0;\ncontract Test {}")

        files = [(str(sol_file), "Test.sol")]
        tool = self._create_test_tool("test_tool", "solidity")

        settings = Settings()
        settings.results = str(tmp_path / "results" / "${TOOL}" / "${FILENAME}")

        settings.freeze()  # Must freeze settings before collect_tasks

        sb.smartbugs.collect_tasks(files, [tool], settings)

        # Should have called docker.load
        mock_load.assert_called_once_with(tool.image)

    @patch("sb.docker.is_loaded")
    @patch("sb.docker.load")
    def test_collect_tasks_empty_inputs(
        self, mock_load: MagicMock, mock_is_loaded: MagicMock
    ) -> None:
        """Test collecting tasks with empty inputs."""
        mock_is_loaded.return_value = True

        settings = Settings()
        settings.results = "results/${TOOL}/${FILENAME}"
        settings.freeze()  # Must freeze settings before collect_tasks

        # Empty files, empty tools
        tasks = sb.smartbugs.collect_tasks([], [], settings)
        assert tasks == []

        # No tools (files wouldn't be read if no tools match)
        tasks = sb.smartbugs.collect_tasks([], [], settings)
        assert tasks == []

    @staticmethod
    def _create_test_tool(tool_id: str, mode: str, solc: bool = False) -> sb.tools.Tool:
        """Helper to create a test Tool object."""
        config = {
            "id": tool_id,
            "mode": mode,
            "image": f"smartbugs/{tool_id}:latest",
            "name": f"Test {tool_id}",
            "origin": "https://example.com",
            "version": "1.0.0",
            "info": "Test tool",
            "parser": "parser.py",
            "output": None,
            "bin": None,
            "solc": solc,
            "cpu_quota": None,
            "mem_limit": None,
            "command": "$FILENAME",
            "entrypoint": None,
        }
        return sb.tools.Tool(config)


class TestToolLoading:
    """Tests for tool and tool alias handling."""

    @patch("sb.io.read_yaml")
    def test_load_single_tool(self, mock_read_yaml: MagicMock, tmp_path: Path) -> None:
        """Test loading a single tool configuration."""
        mock_read_yaml.return_value = {
            "name": "TestTool",
            "version": "1.0.0",
            "origin": "https://example.com",
            "info": "Test tool",
            "image": "smartbugs/test:latest",
            "solidity": {"command": "$FILENAME", "solc": False},
        }

        with patch("sb.cfg.TOOLS_HOME", str(tmp_path)):
            (tmp_path / "testtool").mkdir()
            tools = sb.tools.load(["testtool"])

        assert len(tools) == 1
        assert tools[0].id == "testtool"
        assert tools[0].mode == "solidity"

    @patch("sb.io.read_yaml")
    def test_load_tool_with_multiple_modes(self, mock_read_yaml: MagicMock, tmp_path: Path) -> None:
        """Test loading a tool with multiple mode configurations."""
        mock_read_yaml.return_value = {
            "name": "MultiTool",
            "version": "1.0.0",
            "origin": "https://example.com",
            "info": "Multi-mode tool",
            "image": "smartbugs/multi:latest",
            "solidity": {"command": "analyze-sol $FILENAME", "solc": False},
            "bytecode": {"command": "analyze-byc $FILENAME", "solc": False},
            "runtime": {"command": "analyze-rt $FILENAME", "solc": False},
        }

        with patch("sb.cfg.TOOLS_HOME", str(tmp_path)):
            (tmp_path / "multitool").mkdir()
            tools = sb.tools.load(["multitool"])

        assert len(tools) == 3
        modes = [t.mode for t in tools]
        assert "solidity" in modes
        assert "bytecode" in modes
        assert "runtime" in modes

    @patch("sb.io.read_yaml")
    def test_load_tool_alias(self, mock_read_yaml: MagicMock, tmp_path: Path) -> None:
        """Test loading a tool alias that points to other tools."""

        def yaml_side_effect(fn: str) -> dict[str, Any]:
            if "all" in fn:
                return {"alias": ["tool1", "tool2"]}
            elif "tool1" in fn:
                return {
                    "name": "Tool1",
                    "image": "smartbugs/tool1:latest",
                    "solidity": {"command": "$FILENAME"},
                }
            elif "tool2" in fn:
                return {
                    "name": "Tool2",
                    "image": "smartbugs/tool2:latest",
                    "solidity": {"command": "$FILENAME"},
                }
            return {}

        mock_read_yaml.side_effect = yaml_side_effect

        with patch("sb.cfg.TOOLS_HOME", str(tmp_path)):
            (tmp_path / "all").mkdir()
            (tmp_path / "tool1").mkdir()
            (tmp_path / "tool2").mkdir()
            tools = sb.tools.load(["all"])

        assert len(tools) == 2
        tool_ids = [t.id for t in tools]
        assert "tool1" in tool_ids
        assert "tool2" in tool_ids

    @patch("sb.io.read_yaml")
    def test_load_prevents_duplicate_tools(self, mock_read_yaml: MagicMock, tmp_path: Path) -> None:
        """Test that loading same tool ID multiple times only includes it once."""
        mock_read_yaml.return_value = {
            "name": "TestTool",
            "image": "smartbugs/test:latest",
            "solidity": {"command": "$FILENAME"},
        }

        with patch("sb.cfg.TOOLS_HOME", str(tmp_path)):
            (tmp_path / "testtool").mkdir()
            tools = sb.tools.load(["testtool", "testtool"])

        # Should only load once despite being specified twice
        assert len(tools) == 1


class TestMain:
    """Tests for the main orchestration function."""

    @patch("sb.analysis.run")
    @patch("sb.smartbugs.collect_tasks")
    @patch("sb.smartbugs.collect_files")
    @patch("sb.tools.load")
    def test_main_orchestration_flow(
        self,
        mock_load_tools: MagicMock,
        mock_collect_files: MagicMock,
        mock_collect_tasks: MagicMock,
        mock_analysis_run: MagicMock,
    ) -> None:
        """Test the main function orchestrates the full workflow."""
        # Setup mocks
        mock_tool = MagicMock()
        mock_tool.id = "test_tool"
        mock_load_tools.return_value = [mock_tool]
        mock_collect_files.return_value = [("/path/test.sol", "test.sol")]
        mock_task = MagicMock()
        mock_collect_tasks.return_value = [mock_task]

        settings = Settings()
        settings.files = [(None, "*.sol")]
        settings.tools = ["test_tool"]
        settings.quiet = True

        sb.smartbugs.main(settings)

        # Verify the orchestration flow
        mock_load_tools.assert_called_once_with(["test_tool"])
        mock_collect_files.assert_called_once_with([(None, "*.sol")])
        mock_collect_tasks.assert_called_once_with(
            [("/path/test.sol", "test.sol")], [mock_tool], settings
        )
        mock_analysis_run.assert_called_once_with([mock_task], settings)

    @patch("sb.analysis.run")
    @patch("sb.smartbugs.collect_tasks")
    @patch("sb.smartbugs.collect_files")
    @patch("sb.tools.load")
    def test_main_with_no_tools(
        self,
        mock_load_tools: MagicMock,
        mock_collect_files: MagicMock,
        mock_collect_tasks: MagicMock,
        mock_analysis_run: MagicMock,
    ) -> None:
        """Test main function with no tools selected."""
        mock_load_tools.return_value = []
        mock_collect_files.return_value = [("/path/test.sol", "test.sol")]
        mock_collect_tasks.return_value = []

        settings = Settings()
        settings.files = [(None, "*.sol")]
        settings.tools = []
        settings.quiet = True

        # Should not raise error, just proceed with no tasks
        sb.smartbugs.main(settings)

        mock_analysis_run.assert_called_once_with([], settings)

    @patch("sb.analysis.run")
    @patch("sb.smartbugs.collect_tasks")
    @patch("sb.smartbugs.collect_files")
    @patch("sb.tools.load")
    def test_main_freezes_settings(
        self,
        mock_load_tools: MagicMock,
        mock_collect_files: MagicMock,
        mock_collect_tasks: MagicMock,
        mock_analysis_run: MagicMock,
    ) -> None:
        """Test that main function freezes settings before processing."""
        mock_load_tools.return_value = []
        mock_collect_files.return_value = []
        mock_collect_tasks.return_value = []

        settings = Settings()
        settings.files = []
        settings.tools = []
        settings.quiet = True

        assert not settings.frozen

        sb.smartbugs.main(settings)

        # Settings should be frozen after main is called
        assert settings.frozen
