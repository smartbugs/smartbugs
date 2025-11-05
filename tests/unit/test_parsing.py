"""Unit tests for sb/parsing.py - Parser framework.

This module tests the parser loading, invocation, and validation framework
that provides the interface between SmartBugs core and tool-specific parsers.
"""

from pathlib import Path
from types import ModuleType
from typing import Any
from unittest.mock import patch

import pytest

import sb.cfg
import sb.errors
import sb.parsing


@pytest.fixture
def mock_parser_module() -> ModuleType:
    """Create a mock parser module with standard interface.

    Returns:
        A ModuleType with VERSION, FINDINGS, and parse function.
    """
    module = ModuleType("mock_parser")
    module.VERSION = "2025/01/01"
    module.FINDINGS = {"vulnerability1", "vulnerability2", "reentrancy"}

    def parse_func(exit_code, log, output):
        findings = [
            {
                "name": "vulnerability1",
                "message": "Test vulnerability",
                "line": 10,
                "filename": "/sb/test.sol",
            }
        ]
        infos = {"info message"}
        errors = {"error message"}
        fails = {"fail message"}
        return findings, infos, errors, fails

    module.parse = parse_func
    return module


@pytest.fixture
def mock_parser_no_findings() -> ModuleType:
    """Create a mock parser module without FINDINGS constant.

    Returns:
        A ModuleType with VERSION and parse function, but FINDINGS = None.
    """
    module = ModuleType("mock_parser_no_findings")
    module.VERSION = "2025/01/01"
    module.FINDINGS = None

    def parse_func(exit_code, log, output):
        findings = [{"name": "anything-goes", "message": "No validation", "line": 5}]
        return findings, set(), set(), set()

    module.parse = parse_func
    return module


@pytest.fixture
def mock_parser_empty_findings() -> ModuleType:
    """Create a mock parser module with empty FINDINGS set.

    Returns:
        A ModuleType with VERSION and empty FINDINGS set.
    """
    module = ModuleType("mock_parser_empty_findings")
    module.VERSION = "2025/01/01"
    module.FINDINGS = set()

    def parse_func(exit_code, log, output):
        return [], set(), set(), set()

    module.parse = parse_func
    return module


@pytest.fixture
def sample_task_log() -> dict[str, Any]:
    """Sample task log for testing parse function.

    Returns:
        A dictionary representing task metadata with tool info and filename.
    """
    return {
        "tool": {"id": "test_tool", "mode": "solidity", "parser": "parser.py"},
        "filename": "/path/to/test.sol",
        "result": {"exit_code": 0},
    }


@pytest.fixture
def sample_tool_log() -> list[str]:
    """Sample tool stdout/stderr output.

    Returns:
        A list of strings representing tool output lines.
    """
    return [
        "Tool starting...",
        "Analyzing contract...",
        "Found vulnerability: reentrancy at line 42",
        "Analysis complete",
    ]


class TestGetParser:
    """Tests for get_parser function - parser loading by tool ID."""

    def test_load_parser_success(self, mock_parser_module: ModuleType, tmp_path: Path):
        """Test successful parser loading from file."""
        # Create a temporary parser file
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = {"vuln1"}

def parse(exit_code, log, output):
    return [], set(), set(), set()
"""
        )

        tool = {"id": "test_tool", "mode": "solidity", "parser": "parser.py"}

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            parser = sb.parsing.get_parser(tool)
            assert parser is not None
            assert hasattr(parser, "VERSION")
            assert hasattr(parser, "FINDINGS")
            assert hasattr(parser, "parse")
            assert parser.VERSION == "2025/01/01"

    def test_parser_caching(self, mock_parser_module: ModuleType, tmp_path: Path):
        """Test that parsers are cached and not reloaded."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "1.0.0"
FINDINGS = set()
def parse(exit_code, log, output):
    return [], set(), set(), set()
"""
        )

        tool = {"id": "test_tool", "mode": "solidity", "parser": "parser.py"}

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            # Clear the cache first
            sb.parsing.tool_parsers.clear()

            # Load parser first time
            parser1 = sb.parsing.get_parser(tool)

            # Load parser second time
            parser2 = sb.parsing.get_parser(tool)

            # Should be the same object (cached)
            assert parser1 is parser2

    def test_different_modes_different_parsers(self, tmp_path: Path):
        """Test that different modes for the same tool are cached separately."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "1.0.0"
FINDINGS = set()
def parse(exit_code, log, output):
    return [], set(), set(), set()
"""
        )

        tool_solidity = {"id": "test_tool", "mode": "solidity", "parser": "parser.py"}
        tool_bytecode = {"id": "test_tool", "mode": "bytecode", "parser": "parser.py"}

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            # Clear the cache first
            sb.parsing.tool_parsers.clear()

            sb.parsing.get_parser(tool_solidity)
            sb.parsing.get_parser(tool_bytecode)

            # Should be cached under different keys
            assert ("test_tool", "solidity") in sb.parsing.tool_parsers
            assert ("test_tool", "bytecode") in sb.parsing.tool_parsers

    def test_parser_not_found(self):
        """Test error handling when parser file doesn't exist."""
        tool = {"id": "nonexistent_tool", "mode": "solidity", "parser": "parser.py"}

        with pytest.raises(sb.errors.SmartBugsError) as exc_info:
            sb.parsing.get_parser(tool)

        assert "Cannot load parser" in str(exc_info.value)
        assert "nonexistent_tool" in str(exc_info.value)

    def test_parser_syntax_error(self, tmp_path: Path):
        """Test error handling when parser file has syntax errors."""
        tool_dir = tmp_path / "bad_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text("def parse( invalid syntax here")

        tool = {"id": "bad_tool", "mode": "solidity", "parser": "parser.py"}

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            with pytest.raises(sb.errors.SmartBugsError) as exc_info:
                sb.parsing.get_parser(tool)

            assert "Cannot load parser" in str(exc_info.value)
            assert "bad_tool" in str(exc_info.value)

    def test_parser_missing_parse_function(self, tmp_path: Path):
        """Test that parser loads even if parse function is missing (will fail later)."""
        tool_dir = tmp_path / "incomplete_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "1.0.0"
FINDINGS = set()
"""
        )

        tool = {"id": "incomplete_tool", "mode": "solidity", "parser": "parser.py"}

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            # Parser loads successfully
            parser = sb.parsing.get_parser(tool)
            assert parser is not None
            # But doesn't have parse function
            assert not hasattr(parser, "parse")


class TestParse:
    """Tests for parse function - main parser invocation and validation."""

    def test_parse_success(self, sample_task_log: dict, sample_tool_log: list[str], tmp_path: Path):
        """Test successful parsing with valid findings."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = {"vulnerability1", "reentrancy"}

def parse(exit_code, log, output):
    findings = [
        {"name": "vulnerability1", "message": "Test", "line": 10, "filename": "/sb/test.sol"}
    ]
    return findings, {"info"}, {"error"}, {"fail"}
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(sample_task_log, sample_tool_log, None)

            assert "findings" in result
            assert "infos" in result
            assert "errors" in result
            assert "fails" in result
            assert "parser" in result

            assert len(result["findings"]) == 1
            assert result["findings"][0]["name"] == "vulnerability1"
            # Filename should be replaced with external path
            assert result["findings"][0]["filename"] == "/path/to/test.sol"

            assert result["infos"] == ["info"]
            assert result["errors"] == ["error"]
            assert result["fails"] == ["fail"]

            assert result["parser"]["id"] == "test_tool"
            assert result["parser"]["mode"] == "solidity"
            assert result["parser"]["version"] == "2025/01/01"

    def test_parse_with_none_findings(self, sample_task_log: dict, tmp_path: Path):
        """Test parsing with parser that has FINDINGS = None (no validation)."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = None

def parse(exit_code, log, output):
    findings = [
        {"name": "anything-goes", "message": "No validation"}
    ]
    return findings, set(), set(), set()
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(sample_task_log, None, None)

            assert len(result["findings"]) == 1
            assert result["findings"][0]["name"] == "anything-goes"

    def test_parse_with_empty_findings_set(self, sample_task_log: dict, tmp_path: Path):
        """Test parsing with parser that has empty FINDINGS set."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = set()

def parse(exit_code, log, output):
    # No findings expected from this tool
    return [], set(), set(), set()
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(sample_task_log, None, None)

            assert result["findings"] == []

    def test_parse_invalid_finding_name(self, sample_task_log: dict, tmp_path: Path):
        """Test that invalid finding names are caught and raise error."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = {"valid_vulnerability"}

def parse(exit_code, log, output):
    findings = [
        {"name": "invalid_vulnerability", "message": "Not in FINDINGS set"}
    ]
    return findings, set(), set(), set()
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            with pytest.raises(sb.errors.SmartBugsError) as exc_info:
                sb.parsing.parse(sample_task_log, None, None)

            assert "invalid_vulnerability" in str(exc_info.value)
            assert "not among the findings" in str(exc_info.value)
            assert "test_tool" in str(exc_info.value)

    def test_parse_filename_replacement(self, sample_task_log: dict, tmp_path: Path):
        """Test that Docker internal filenames are replaced with external paths."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = {"vuln"}

def parse(exit_code, log, output):
    findings = [
        {"name": "vuln", "filename": "/sb/contracts/test.sol"},
        {"name": "vuln", "filename": "/sb/test.sol"},
        {"name": "vuln", "filename": "test.sol"},
    ]
    return findings, set(), set(), set()
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(sample_task_log, None, None)

            # All findings should have the external filename
            for finding in result["findings"]:
                assert finding["filename"] == "/path/to/test.sol"

    def test_parse_filename_mismatch(self, sample_task_log: dict, tmp_path: Path):
        """Test that mismatched filenames raise assertion error."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = {"vuln"}

def parse(exit_code, log, output):
    findings = [
        {"name": "vuln", "filename": "/sb/different_file.sol"}
    ]
    return findings, set(), set(), set()
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            with pytest.raises(AssertionError):
                sb.parsing.parse(sample_task_log, None, None)

    def test_parse_no_filename_in_finding(self, sample_task_log: dict, tmp_path: Path):
        """Test that findings without filename field are handled correctly."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = {"vuln"}

def parse(exit_code, log, output):
    findings = [
        {"name": "vuln", "message": "No filename provided"}
    ]
    return findings, set(), set(), set()
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(sample_task_log, None, None)

            # Finding should still have filename added
            assert result["findings"][0]["filename"] == "/path/to/test.sol"

    def test_parse_with_exit_code(self, sample_task_log: dict, tmp_path: Path):
        """Test that exit code is passed to parser correctly."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = None

def parse(exit_code, log, output):
    # Parser can use exit code to determine if tool succeeded
    if exit_code != 0:
        return [], set(), {"Tool failed"}, set()
    return [], set(), set(), set()
"""
        )

        # Test with exit code 0
        task_log_success = sample_task_log.copy()
        task_log_success["result"]["exit_code"] = 0

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(task_log_success, None, None)
            assert result["errors"] == []

            # Test with non-zero exit code
            sb.parsing.tool_parsers.clear()
            task_log_fail = sample_task_log.copy()
            task_log_fail["result"]["exit_code"] = 1
            result = sb.parsing.parse(task_log_fail, None, None)
            assert "Tool failed" in result["errors"]

    def test_parse_with_tool_log(self, sample_task_log: dict, tmp_path: Path):
        """Test that tool log is passed as list of strings to parser."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = None

def parse(exit_code, log, output):
    # Parser expects log to be list of strings or None
    if log is not None:
        assert isinstance(log, list)
        for line in log:
            assert isinstance(line, str)
        return [], {f"Processed {len(log)} lines"}, set(), set()
    return [], set(), set(), set()
"""
        )

        tool_log = ["line1", "line2", "line3"]

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(sample_task_log, tool_log, None)
            assert "Processed 3 lines" in result["infos"]

    def test_parse_with_tool_output(self, sample_task_log: dict, tmp_path: Path):
        """Test that tool output is passed as bytes to parser."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = None

def parse(exit_code, log, output):
    # Parser expects output to be bytes or None
    if output is not None:
        assert isinstance(output, bytes)
        return [], {f"Output size: {len(output)}"}, set(), set()
    return [], set(), set(), set()
"""
        )

        tool_output = b"Binary output data here"

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(sample_task_log, None, tool_output)
            assert "Output size: 23" in result["infos"]

    def test_parse_sorts_infos_errors_fails(self, sample_task_log: dict, tmp_path: Path):
        """Test that infos, errors, and fails are sorted in the result."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = None

def parse(exit_code, log, output):
    infos = {"zebra", "apple", "mango"}
    errors = {"error3", "error1", "error2"}
    fails = {"fail_z", "fail_a"}
    return [], infos, errors, fails
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(sample_task_log, None, None)

            # Should be sorted
            assert result["infos"] == ["apple", "mango", "zebra"]
            assert result["errors"] == ["error1", "error2", "error3"]
            assert result["fails"] == ["fail_a", "fail_z"]

    def test_parse_multiple_findings(self, sample_task_log: dict, tmp_path: Path):
        """Test parsing with multiple findings."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = {"reentrancy", "overflow", "delegatecall"}

def parse(exit_code, log, output):
    findings = [
        {"name": "reentrancy", "line": 10, "filename": "/sb/test.sol"},
        {"name": "overflow", "line": 20, "filename": "/sb/test.sol"},
        {"name": "delegatecall", "line": 30, "filename": "/sb/test.sol"},
    ]
    return findings, set(), set(), set()
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(sample_task_log, None, None)

            assert len(result["findings"]) == 3
            assert result["findings"][0]["name"] == "reentrancy"
            assert result["findings"][1]["name"] == "overflow"
            assert result["findings"][2]["name"] == "delegatecall"

    def test_parse_preserves_finding_fields(self, sample_task_log: dict, tmp_path: Path):
        """Test that all finding fields are preserved (line, column, message, etc.)."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/01/01"
FINDINGS = {"vuln"}

def parse(exit_code, log, output):
    findings = [
        {
            "name": "vuln",
            "filename": "/sb/test.sol",
            "line": 42,
            "line_end": 45,
            "column": 10,
            "column_end": 20,
            "message": "Detailed message",
            "impact": "high",
            "confidence": "medium",
            "function": "withdraw",
            "contract": "Vulnerable",
        }
    ]
    return findings, set(), set(), set()
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(sample_task_log, None, None)

            finding = result["findings"][0]
            assert finding["line"] == 42
            assert finding["line_end"] == 45
            assert finding["column"] == 10
            assert finding["column_end"] == 20
            assert finding["message"] == "Detailed message"
            assert finding["impact"] == "high"
            assert finding["confidence"] == "medium"
            assert finding["function"] == "withdraw"
            assert finding["contract"] == "Vulnerable"


class TestParserVersionHandling:
    """Tests for parser VERSION constant handling."""

    def test_parse_includes_parser_version(self, sample_task_log: dict, tmp_path: Path):
        """Test that parser version is included in result."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "2025/12/31"
FINDINGS = None

def parse(exit_code, log, output):
    return [], set(), set(), set()
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            result = sb.parsing.parse(sample_task_log, None, None)

            assert result["parser"]["version"] == "2025/12/31"

    def test_parser_missing_version(self, sample_task_log: dict, tmp_path: Path):
        """Test handling when parser is missing VERSION constant."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
FINDINGS = None

def parse(exit_code, log, output):
    return [], set(), set(), set()
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            # Should raise AttributeError when accessing VERSION
            with pytest.raises(AttributeError):
                sb.parsing.parse(sample_task_log, None, None)


class TestParserModuleCache:
    """Tests for parser module caching behavior."""

    def test_cache_key_includes_mode(self, tmp_path: Path):
        """Test that cache key includes both tool ID and mode."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "1.0.0"
FINDINGS = None
def parse(exit_code, log, output):
    return [], set(), set(), set()
"""
        )

        tool1 = {"id": "test_tool", "mode": "solidity", "parser": "parser.py"}
        tool2 = {"id": "test_tool", "mode": "bytecode", "parser": "parser.py"}

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()

            sb.parsing.get_parser(tool1)
            sb.parsing.get_parser(tool2)

            # Should be two entries in cache
            assert len(sb.parsing.tool_parsers) == 2
            assert ("test_tool", "solidity") in sb.parsing.tool_parsers
            assert ("test_tool", "bytecode") in sb.parsing.tool_parsers

    def test_cache_persists_across_calls(self, tmp_path: Path):
        """Test that parser cache persists across multiple parse calls."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "1.0.0"
FINDINGS = None
call_count = 0

def parse(exit_code, log, output):
    global call_count
    call_count += 1
    return [], set(), set(), set()
"""
        )

        sample_task_log = {
            "tool": {"id": "test_tool", "mode": "solidity", "parser": "parser.py"},
            "filename": "/path/to/test.sol",
            "result": {"exit_code": 0},
        }

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()

            # First parse call - loads parser
            sb.parsing.parse(sample_task_log, None, None)
            assert len(sb.parsing.tool_parsers) == 1

            # Second parse call - uses cached parser
            sb.parsing.parse(sample_task_log, None, None)
            assert len(sb.parsing.tool_parsers) == 1


class TestErrorHandling:
    """Tests for error handling in parsing framework."""

    def test_parse_parser_exception(self, sample_task_log: dict, tmp_path: Path):
        """Test handling when parser.parse() raises an exception."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "1.0.0"
FINDINGS = None

def parse(exit_code, log, output):
    raise RuntimeError("Parser internal error")
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            # Exception should propagate (not caught by parse function)
            with pytest.raises(RuntimeError) as exc_info:
                sb.parsing.parse(sample_task_log, None, None)
            assert "Parser internal error" in str(exc_info.value)

    def test_parse_parser_returns_wrong_type(self, sample_task_log: dict, tmp_path: Path):
        """Test handling when parser returns wrong data structure."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        parser_file.write_text(
            """
VERSION = "1.0.0"
FINDINGS = None

def parse(exit_code, log, output):
    # Return wrong number of values
    return [], set()
"""
        )

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            with pytest.raises(ValueError):
                sb.parsing.parse(sample_task_log, None, None)

    def test_get_parser_import_error(self, tmp_path: Path):
        """Test handling when parser module has import errors."""
        tool_dir = tmp_path / "test_tool"
        tool_dir.mkdir()
        parser_file = tool_dir / "parser.py"
        # Write parser that imports non-existent module
        parser_file.write_text("import nonexistent_module\nVERSION = '1.0.0'\nFINDINGS = None")

        tool = {"id": "test_tool", "mode": "solidity", "parser": "parser.py"}

        with patch.object(sb.cfg, "TOOLS_HOME", str(tmp_path)):
            sb.parsing.tool_parsers.clear()
            with pytest.raises(sb.errors.SmartBugsError) as exc_info:
                sb.parsing.get_parser(tool)

            assert "Cannot load parser" in str(exc_info.value)
            assert "test_tool" in str(exc_info.value)
