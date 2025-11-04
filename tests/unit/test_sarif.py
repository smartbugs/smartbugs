"""Unit tests for sb/sarif.py - SARIF format generation.

This module tests the SARIF (Static Analysis Results Interchange Format) generation
functionality, including:
- SARIF document structure generation
- Finding conversion to SARIF results
- Location mapping (line numbers, file paths, address-to-position)
- Rule definition generation from tool metadata
- Handling of optional fields and edge cases
"""

from typing import Any
from unittest.mock import MagicMock, patch

import pytest

import sb.sarif


@pytest.fixture
def sample_tool_config() -> dict[str, Any]:
    """Minimal tool configuration for testing.

    Returns:
        Dictionary with basic tool metadata used in SARIF generation.
    """
    return {
        "id": "mythril",
        "name": "Mythril",
        "version": "0.23.0",
        "origin": "https://github.com/ConsenSys/mythril",
    }


@pytest.fixture
def sample_finding() -> dict[str, Any]:
    """Sample finding with all standard fields.

    Returns:
        Dictionary representing a typical vulnerability finding.
    """
    return {
        "name": "reentrancy",
        "message": "Potential reentrancy vulnerability detected",
        "filename": "/sb/test.sol",
        "line": 42,
        "line_end": 45,
        "column": 5,
        "column_end": 10,
        "severity": "high",
        "level": "warning",
        "contract": "Vulnerable",
        "function": "withdraw",
    }


@pytest.fixture
def sample_finding_minimal() -> dict[str, Any]:
    """Minimal finding with only required fields.

    Returns:
        Dictionary with minimal fields (name and filename only).
    """
    return {
        "name": "integer-overflow",
        "filename": "/sb/contract.sol",
    }


@pytest.fixture
def sample_info_finding() -> dict[str, Any]:
    """Sample vulnerability metadata from findings.yaml.

    Returns:
        Dictionary with vulnerability description and classification.
    """
    return {
        "descr_short": "Reentrancy vulnerability",
        "descr_long": "External calls can call back into the contract before state changes",
        "classification": "SWC-107",
        "method": "Symbolic execution",
        "level": "warning",
        "severity": "8.5",
    }


class TestSarify:
    """Tests for the main sarify() function."""

    def test_sarify_basic_structure(self, sample_tool_config: dict[str, Any]) -> None:
        """Test that sarify creates valid SARIF document structure."""
        findings = [{"name": "reentrancy", "filename": "test.sol"}]
        result = sb.sarif.sarify(sample_tool_config, findings)

        assert result["$schema"] == "https://json.schemastore.org/sarif-2.1.0.json"
        assert result["version"] == "2.1.0"
        assert "runs" in result
        assert len(result["runs"]) == 1
        assert isinstance(result["runs"], list)

    def test_sarify_empty_findings(self, sample_tool_config: dict[str, Any]) -> None:
        """Test SARIF generation with no findings."""
        result = sb.sarif.sarify(sample_tool_config, [])

        assert result["version"] == "2.1.0"
        assert len(result["runs"]) == 1
        assert result["runs"][0]["results"] == []

    def test_sarify_multiple_findings(self, sample_tool_config: dict[str, Any]) -> None:
        """Test SARIF generation with multiple findings."""
        findings = [
            {"name": "reentrancy", "filename": "test.sol"},
            {"name": "overflow", "filename": "test.sol"},
            {"name": "reentrancy", "filename": "other.sol"},
        ]
        result = sb.sarif.sarify(sample_tool_config, findings)

        assert len(result["runs"][0]["results"]) == 3
        # Should have 2 unique rule IDs (reentrancy and overflow)
        rules = result["runs"][0]["tool"]["driver"]["rules"]
        assert len(rules) == 2
        rule_names = {rule["name"] for rule in rules}
        assert rule_names == {"reentrancy", "overflow"}


class TestRunInfo:
    """Tests for run_info() function."""

    def test_run_info_structure(self, sample_tool_config: dict[str, Any]) -> None:
        """Test run info contains tool and results sections."""
        findings = [{"name": "test", "filename": "test.sol"}]
        result = sb.sarif.run_info(sample_tool_config, findings)

        assert "tool" in result
        assert "results" in result
        assert isinstance(result["results"], list)

    def test_run_info_extracts_unique_finding_names(
        self, sample_tool_config: dict[str, Any]
    ) -> None:
        """Test that run_info extracts unique finding names for rules."""
        findings = [
            {"name": "reentrancy", "filename": "a.sol"},
            {"name": "reentrancy", "filename": "b.sol"},
            {"name": "overflow", "filename": "c.sol"},
        ]
        result = sb.sarif.run_info(sample_tool_config, findings)

        rules = result["tool"]["driver"]["rules"]
        rule_names = {rule["name"] for rule in rules}
        assert len(rule_names) == 2
        assert rule_names == {"reentrancy", "overflow"}


class TestToolInfo:
    """Tests for tool_info() function."""

    def test_tool_info_basic_fields(self) -> None:
        """Test tool info contains required fields."""
        tool = {"id": "slither", "name": "Slither", "version": "0.9.0"}
        fnames = {"reentrancy", "overflow"}
        result = sb.sarif.tool_info(tool, fnames)

        assert "driver" in result
        driver = result["driver"]
        assert driver["name"] == "Slither"
        assert driver["version"] == "0.9.0"
        assert "rules" in driver
        assert len(driver["rules"]) == 2

    def test_tool_info_uses_id_when_name_missing(self) -> None:
        """Test tool info falls back to ID when name is not provided."""
        tool = {"id": "mythril"}
        result = sb.sarif.tool_info(tool, set())

        assert result["driver"]["name"] == "mythril"

    def test_tool_info_optional_version(self) -> None:
        """Test tool info handles missing version."""
        tool = {"id": "tool1", "name": "Tool One"}
        result = sb.sarif.tool_info(tool, set())

        assert "version" not in result["driver"]

    def test_tool_info_optional_origin(self) -> None:
        """Test tool info includes origin as informationUri when present."""
        tool = {"id": "tool1", "origin": "https://example.com/tool"}
        result = sb.sarif.tool_info(tool, set())

        assert result["driver"]["informationUri"] == "https://example.com/tool"

    def test_tool_info_no_origin(self) -> None:
        """Test tool info omits informationUri when origin is missing."""
        tool = {"id": "tool1"}
        result = sb.sarif.tool_info(tool, set())

        assert "informationUri" not in result["driver"]


class TestRuleInfo:
    """Tests for rule_info() function."""

    @patch("sb.tools.info_finding")
    def test_rule_info_basic_structure(self, mock_info_finding: MagicMock) -> None:
        """Test rule info contains required fields."""
        mock_info_finding.return_value = {}
        result = sb.sarif.rule_info("mythril", "reentrancy")

        assert result["name"] == "reentrancy"
        assert "id" in result
        assert result["id"] == "mythril_reentrancy"
        mock_info_finding.assert_called_once_with("mythril", "reentrancy")

    @patch("sb.tools.info_finding")
    def test_rule_info_with_descriptions(self, mock_info_finding: MagicMock) -> None:
        """Test rule info includes descriptions when available."""
        mock_info_finding.return_value = {
            "descr_short": "Short description",
            "descr_long": "Long description",
        }
        result = sb.sarif.rule_info("tool", "vuln")

        assert result["shortDescription"]["text"] == "Short description"
        assert "Long description" in result["fullDescription"]["text"]

    @patch("sb.tools.info_finding")
    def test_rule_info_with_classification_and_method(self, mock_info_finding: MagicMock) -> None:
        """Test rule info includes classification and detection method in full description."""
        mock_info_finding.return_value = {
            "descr_short": "Vuln",
            "classification": "SWC-107",
            "method": "Symbolic execution",
        }
        result = sb.sarif.rule_info("tool", "vuln")

        full_desc = result["fullDescription"]["text"]
        assert "Classification: SWC-107." in full_desc
        assert "Detection method: Symbolic execution" in full_desc

    @patch("sb.tools.info_finding")
    def test_rule_info_help_text(self, mock_info_finding: MagicMock) -> None:
        """Test rule info help text prefers long description."""
        mock_info_finding.return_value = {
            "descr_short": "Short",
            "descr_long": "Long",
        }
        result = sb.sarif.rule_info("tool", "vuln")

        assert result["help"]["text"] == "Long"

    @patch("sb.tools.info_finding")
    def test_rule_info_help_text_fallback(self, mock_info_finding: MagicMock) -> None:
        """Test rule info help text falls back to short description."""
        mock_info_finding.return_value = {"descr_short": "Short"}
        result = sb.sarif.rule_info("tool", "vuln")

        assert result["help"]["text"] == "Short"

    @patch("sb.tools.info_finding")
    def test_rule_info_security_severity_numeric(self, mock_info_finding: MagicMock) -> None:
        """Test rule info converts numeric severity to float."""
        mock_info_finding.return_value = {"severity": "8.5"}
        result = sb.sarif.rule_info("tool", "vuln")

        assert result["properties"]["security-severity"] == 8.5

    @patch("sb.tools.info_finding")
    def test_rule_info_security_severity_text(self, mock_info_finding: MagicMock) -> None:
        """Test rule info converts text severity to numeric values."""
        test_cases = [
            ("low", "2.0"),
            ("medium", "5.5"),
            ("high", "8.0"),
        ]
        for severity, expected in test_cases:
            mock_info_finding.return_value = {"severity": severity}
            result = sb.sarif.rule_info("tool", "vuln")
            assert result["properties"]["security-severity"] == expected

        # Test unknown severity (returns empty string, no properties added)
        mock_info_finding.return_value = {"severity": "unknown"}
        result = sb.sarif.rule_info("tool", "vuln")
        assert "properties" not in result

    @patch("sb.tools.info_finding")
    def test_rule_info_problem_severity(self, mock_info_finding: MagicMock) -> None:
        """Test rule info includes problem severity when present."""
        mock_info_finding.return_value = {"level": "warning"}
        result = sb.sarif.rule_info("tool", "vuln")

        # Note: Based on code, security-severity overwrites properties dict
        # So we need to check if level exists when severity doesn't
        mock_info_finding.return_value = {"level": "error"}
        result = sb.sarif.rule_info("tool", "vuln")
        assert result["properties"]["problem"]["severity"] == "error"


class TestResultInfo:
    """Tests for result_info() function."""

    @patch("sb.tools.info_finding")
    def test_result_info_basic_structure(
        self, mock_info_finding: MagicMock, sample_finding: dict[str, Any]
    ) -> None:
        """Test result info contains required fields."""
        mock_info_finding.return_value = {}
        result = sb.sarif.result_info("mythril", sample_finding)

        assert result["ruleId"] == "mythril_reentrancy"
        assert "locations" in result
        assert len(result["locations"]) == 1
        assert (
            result["locations"][0]["physicalLocation"]["artifactLocation"]["uri"] == "/sb/test.sol"
        )

    @patch("sb.tools.info_finding")
    def test_result_info_with_line_numbers(
        self, mock_info_finding: MagicMock, sample_finding: dict[str, Any]
    ) -> None:
        """Test result info includes region with line numbers."""
        mock_info_finding.return_value = {}
        result = sb.sarif.result_info("tool", sample_finding)

        region = result["locations"][0]["physicalLocation"]["region"]
        assert region["startLine"] == 42
        assert region["endLine"] == 45
        assert region["startColumn"] == 5
        assert region["endColumn"] == 10

    @patch("sb.tools.info_finding")
    def test_result_info_without_line_numbers(
        self, mock_info_finding: MagicMock, sample_finding_minimal: dict[str, Any]
    ) -> None:
        """Test result info handles findings without line numbers."""
        mock_info_finding.return_value = {}
        result = sb.sarif.result_info("tool", sample_finding_minimal)

        # Region should not be present if no line information
        assert "region" not in result["locations"][0]["physicalLocation"]

    @patch("sb.tools.info_finding")
    def test_result_info_message_from_finding(
        self, mock_info_finding: MagicMock, sample_finding: dict[str, Any]
    ) -> None:
        """Test result message uses finding message and severity."""
        mock_info_finding.return_value = {}
        result = sb.sarif.result_info("tool", sample_finding)

        assert "Potential reentrancy vulnerability detected" in result["message"]["text"]
        assert "Severity: high" in result["message"]["text"]

    @patch("sb.tools.info_finding")
    def test_result_info_message_fallback(
        self, mock_info_finding: MagicMock, sample_finding_minimal: dict[str, Any]
    ) -> None:
        """Test result message falls back to finding name when no message."""
        mock_info_finding.return_value = {"descr_short": "Integer overflow vulnerability"}
        result = sb.sarif.result_info("tool", sample_finding_minimal)

        assert result["message"]["text"] == "Integer overflow vulnerability"

    @patch("sb.tools.info_finding")
    def test_result_info_level_valid(
        self, mock_info_finding: MagicMock, sample_finding: dict[str, Any]
    ) -> None:
        """Test result level is included when valid."""
        mock_info_finding.return_value = {}
        result = sb.sarif.result_info("tool", sample_finding)

        assert result["level"] == "warning"

    @patch("sb.tools.info_finding")
    def test_result_info_level_invalid(self, mock_info_finding: MagicMock) -> None:
        """Test result level is omitted when invalid."""
        mock_info_finding.return_value = {}
        finding = {"name": "test", "filename": "test.sol", "level": "invalid"}
        result = sb.sarif.result_info("tool", finding)

        assert "level" not in result

    @patch("sb.tools.info_finding")
    def test_result_info_location_message(self, mock_info_finding: MagicMock) -> None:
        """Test result includes location message with contract/function info."""
        mock_info_finding.return_value = {}
        finding = {
            "name": "vuln",
            "filename": "test.sol",
            "contract": "Token",
            "function": "transfer",
        }
        result = sb.sarif.result_info("tool", finding)

        assert result["locations"][0]["message"]["text"] == "contract Token, function transfer"

    @patch("sb.tools.info_finding")
    def test_result_info_location_message_contract_only(self, mock_info_finding: MagicMock) -> None:
        """Test result location message with contract only."""
        mock_info_finding.return_value = {}
        finding = {"name": "vuln", "filename": "test.sol", "contract": "Token"}
        result = sb.sarif.result_info("tool", finding)

        assert result["locations"][0]["message"]["text"] == "contract Token"

    @patch("sb.tools.info_finding")
    def test_result_info_with_address_mapping(self, mock_info_finding: MagicMock) -> None:
        """Test result handles bytecode address to position mapping."""
        mock_info_finding.return_value = {}
        finding = {
            "name": "vuln",
            "filename": "contract.hex",
            "address": 100,
            "address_end": 150,
        }
        result = sb.sarif.result_info("tool", finding)

        region = result["locations"][0]["physicalLocation"]["region"]
        # Address mapping: line=1, column=1+2*address
        assert region["startLine"] == 1
        assert region["startColumn"] == 201  # 1 + 2*100
        assert region["endLine"] == 1
        assert region["endColumn"] == 301  # 1 + 2*150

    @patch("sb.tools.info_finding")
    def test_result_info_without_message(self, mock_info_finding: MagicMock) -> None:
        """Test result handles findings with no message content."""
        mock_info_finding.return_value = {}
        finding = {"name": "", "filename": "test.sol", "message": ""}
        result = sb.sarif.result_info("tool", finding)

        # Should not have message field when message is empty
        assert "message" not in result


class TestRuleId:
    """Tests for rule_id() function."""

    def test_rule_id_basic(self) -> None:
        """Test rule ID generation from tool ID and finding name."""
        result = sb.sarif.rule_id("mythril", "reentrancy")
        assert result == "mythril_reentrancy"

    def test_rule_id_with_special_chars(self) -> None:
        """Test rule ID sanitizes special characters."""
        result = sb.sarif.rule_id("my-tool", "integer-overflow")
        # str2label should convert hyphens to underscores
        assert result == "my_tool_integer_overflow"

    def test_rule_id_with_spaces(self) -> None:
        """Test rule ID handles spaces."""
        result = sb.sarif.rule_id("tool name", "finding name")
        assert result == "tool_name_finding_name"


class TestRuleDescriptions:
    """Tests for rule description helper functions."""

    def test_rule_short_description_present(self) -> None:
        """Test short description extraction when present."""
        info = {"descr_short": "Short description"}
        result = sb.sarif.rule_short_description(info)
        assert result == "Short description"

    def test_rule_short_description_missing(self) -> None:
        """Test short description returns None when missing."""
        info = {}
        result = sb.sarif.rule_short_description(info)
        assert result is None

    def test_rule_full_description_combined(self) -> None:
        """Test full description combines all available information."""
        info = {
            "descr_short": "Short",
            "descr_long": "Long",
            "classification": "SWC-107",
            "method": "Symbolic",
        }
        result = sb.sarif.rule_full_description(info)

        assert "Short" in result
        assert "Long" in result
        assert "Classification: SWC-107." in result
        assert "Detection method: Symbolic" in result

    def test_rule_full_description_empty(self) -> None:
        """Test full description with no information."""
        info = {}
        result = sb.sarif.rule_full_description(info)
        assert result == ""

    def test_rule_full_description_partial(self) -> None:
        """Test full description with only some fields."""
        info = {"descr_short": "Short", "classification": "SWC-107"}
        result = sb.sarif.rule_full_description(info)

        assert "Short" in result
        assert "Classification: SWC-107." in result
        assert "Detection method" not in result

    def test_rule_help_prefers_long(self) -> None:
        """Test help text prefers long description."""
        info = {"descr_short": "Short", "descr_long": "Long"}
        result = sb.sarif.rule_help(info)
        assert result == "Long"

    def test_rule_help_fallback_to_short(self) -> None:
        """Test help text falls back to short description."""
        info = {"descr_short": "Short"}
        result = sb.sarif.rule_help(info)
        assert result == "Short"

    def test_rule_help_empty(self) -> None:
        """Test help text returns empty string when no descriptions."""
        info = {}
        result = sb.sarif.rule_help(info)
        assert result == ""


class TestRuleSeverities:
    """Tests for rule severity conversion functions."""

    def test_rule_problem_severity_valid(self) -> None:
        """Test problem severity extraction and normalization."""
        info = {"level": "  WARNING  "}
        result = sb.sarif.rule_problem_severity(info)
        assert result == "warning"

    def test_rule_problem_severity_missing(self) -> None:
        """Test problem severity returns empty string when missing."""
        info = {}
        result = sb.sarif.rule_problem_severity(info)
        assert result == ""

    def test_rule_security_severity_numeric(self) -> None:
        """Test security severity conversion from numeric string."""
        info = {"severity": "8.5"}
        result = sb.sarif.rule_security_severity(info)
        assert result == 8.5

    def test_rule_security_severity_low(self) -> None:
        """Test security severity conversion for 'low'."""
        info = {"severity": "  LOW  "}
        result = sb.sarif.rule_security_severity(info)
        assert result == "2.0"

    def test_rule_security_severity_medium(self) -> None:
        """Test security severity conversion for 'medium'."""
        info = {"severity": "medium"}
        result = sb.sarif.rule_security_severity(info)
        assert result == "5.5"

    def test_rule_security_severity_high(self) -> None:
        """Test security severity conversion for 'high'."""
        info = {"severity": "HIGH"}
        result = sb.sarif.rule_security_severity(info)
        assert result == "8.0"

    def test_rule_security_severity_unknown(self) -> None:
        """Test security severity returns empty for unknown values."""
        info = {"severity": "unknown"}
        result = sb.sarif.rule_security_severity(info)
        assert result == ""

    def test_rule_security_severity_missing(self) -> None:
        """Test security severity returns empty when missing."""
        info = {}
        result = sb.sarif.rule_security_severity(info)
        assert result == ""


class TestResultMessage:
    """Tests for result_message() function."""

    def test_result_message_with_both(self) -> None:
        """Test result message with both message and severity."""
        finding = {"message": "Test message", "severity": "high"}
        info = {}
        result = sb.sarif.result_message(finding, info)

        assert "Test message" in result
        assert "Severity: high" in result

    def test_result_message_only_message(self) -> None:
        """Test result message with only message."""
        finding = {"message": "Test message"}
        info = {}
        result = sb.sarif.result_message(finding, info)

        assert result == "Test message"
        assert "Severity" not in result

    def test_result_message_only_severity(self) -> None:
        """Test result message with only severity."""
        finding = {"name": "test", "severity": "high"}
        info = {}
        result = sb.sarif.result_message(finding, info)

        assert "test" in result
        assert "Severity: high" in result

    def test_result_message_fallback_to_info(self) -> None:
        """Test result message falls back to info description."""
        finding = {"name": "reentrancy"}
        info = {"descr_short": "Reentrancy detected"}
        result = sb.sarif.result_message(finding, info)

        assert result == "Reentrancy detected"

    def test_result_message_fallback_to_name(self) -> None:
        """Test result message falls back to finding name."""
        finding = {"name": "reentrancy"}
        info = {}
        result = sb.sarif.result_message(finding, info)

        assert result == "reentrancy"

    def test_result_message_empty_message(self) -> None:
        """Test result message handles empty string as no message."""
        finding = {"message": "", "name": "test"}
        info = {"descr_short": "Description"}
        result = sb.sarif.result_message(finding, info)

        # Empty message should trigger fallback
        assert result == "Description"

    def test_result_message_returns_empty_string(self) -> None:
        """Test result message can return empty string when all fields empty."""
        finding = {"message": "", "name": ""}
        info = {}
        result = sb.sarif.result_message(finding, info)

        # Should return empty string when everything is empty
        assert result == ""


class TestResultLevel:
    """Tests for result_level() function."""

    def test_result_level_valid_values(self) -> None:
        """Test result level accepts valid SARIF level values."""
        valid_levels = ["none", "note", "warning", "error"]
        for level in valid_levels:
            finding = {"level": level}
            result = sb.sarif.result_level(finding)
            assert result == level

    def test_result_level_case_insensitive(self) -> None:
        """Test result level normalizes to lowercase."""
        finding = {"level": "  WARNING  "}
        result = sb.sarif.result_level(finding)
        assert result == "warning"

    def test_result_level_invalid(self) -> None:
        """Test result level returns None for invalid values."""
        invalid_levels = ["critical", "info", "high", "low", "unknown"]
        for level in invalid_levels:
            finding = {"level": level}
            result = sb.sarif.result_level(finding)
            assert result is None

    def test_result_level_missing(self) -> None:
        """Test result level returns None when missing."""
        finding = {}
        result = sb.sarif.result_level(finding)
        assert result is None


class TestResultLocationMessage:
    """Tests for result_location_message() function."""

    def test_result_location_message_both(self) -> None:
        """Test location message with both contract and function."""
        finding = {"contract": "Token", "function": "transfer"}
        result = sb.sarif.result_location_message(finding)
        assert result == "contract Token, function transfer"

    def test_result_location_message_contract_only(self) -> None:
        """Test location message with contract only."""
        finding = {"contract": "Token"}
        result = sb.sarif.result_location_message(finding)
        assert result == "contract Token"

    def test_result_location_message_function_only(self) -> None:
        """Test location message with function only."""
        finding = {"function": "transfer"}
        result = sb.sarif.result_location_message(finding)
        assert result == "function transfer"

    def test_result_location_message_neither(self) -> None:
        """Test location message returns empty string when both missing."""
        finding = {}
        result = sb.sarif.result_location_message(finding)
        assert result == ""


class TestResultRegion:
    """Tests for result_region() function."""

    def test_result_region_with_lines(self) -> None:
        """Test region mapping with line and column information."""
        finding = {"line": 10, "line_end": 15, "column": 5, "column_end": 20}
        result = sb.sarif.result_region(finding)

        assert result == {
            "startLine": 10,
            "endLine": 15,
            "startColumn": 5,
            "endColumn": 20,
        }

    def test_result_region_with_line_only(self) -> None:
        """Test region mapping with only start line."""
        finding = {"line": 42}
        result = sb.sarif.result_region(finding)

        assert result == {"startLine": 42}

    def test_result_region_with_line_range(self) -> None:
        """Test region mapping with line range."""
        finding = {"line": 10, "line_end": 15}
        result = sb.sarif.result_region(finding)

        assert result == {"startLine": 10, "endLine": 15}

    def test_result_region_with_columns_only(self) -> None:
        """Test region mapping with only columns (unusual but valid)."""
        finding = {"column": 5, "column_end": 10}
        result = sb.sarif.result_region(finding)

        assert result == {"startColumn": 5, "endColumn": 10}

    def test_result_region_without_lines(self) -> None:
        """Test region returns None when no line information."""
        finding = {}
        result = sb.sarif.result_region(finding)
        assert result is None

    def test_result_region_with_address(self) -> None:
        """Test region mapping from bytecode addresses."""
        finding = {"address": 100}
        result = sb.sarif.result_region(finding)

        # Address mapping: line=1, column=1+2*address
        assert result == {"startLine": 1, "startColumn": 201}

    def test_result_region_with_address_range(self) -> None:
        """Test region mapping from bytecode address range."""
        finding = {"address": 50, "address_end": 75}
        result = sb.sarif.result_region(finding)

        assert result == {
            "startLine": 1,
            "startColumn": 101,  # 1 + 2*50
            "endLine": 1,
            "endColumn": 151,  # 1 + 2*75
        }

    def test_result_region_with_address_end_only(self) -> None:
        """Test region mapping with only end address."""
        finding = {"address_end": 100}
        result = sb.sarif.result_region(finding)

        assert result == {"endLine": 1, "endColumn": 201}

    def test_result_region_prefers_line_over_address(self) -> None:
        """Test region prefers line information over address when both present."""
        finding = {
            "line": 10,
            "address": 100,  # Should be ignored
        }
        result = sb.sarif.result_region(finding)

        # Should use line information
        assert result == {"startLine": 10}
        assert "startColumn" not in result or result["startColumn"] != 201

    def test_result_region_string_conversion(self) -> None:
        """Test region converts string numbers to integers."""
        finding = {"line": "42", "column": "5"}
        result = sb.sarif.result_region(finding)

        assert result == {"startLine": 42, "startColumn": 5}
        assert isinstance(result["startLine"], int)
        assert isinstance(result["startColumn"], int)


class TestSarifSchemaValidation:
    """Tests for SARIF schema compliance.

    These tests validate that the generated SARIF documents conform to
    the official SARIF 2.1.0 JSON schema.
    """

    def test_sarif_schema_validation_basic(
        self, sample_tool_config: dict[str, Any], sample_finding: dict[str, Any]
    ) -> None:
        """Test that generated SARIF validates against schema."""
        pytest.importorskip("jsonschema")
        import json

        import jsonschema
        import requests

        findings = [sample_finding]
        sarif_doc = sb.sarif.sarify(sample_tool_config, findings)

        # Fetch SARIF 2.1.0 schema
        schema_url = "https://json.schemastore.org/sarif-2.1.0"
        try:
            response = requests.get(schema_url, timeout=5)
            response.raise_for_status()
            schema = response.json()

            # Validate
            jsonschema.validate(instance=sarif_doc, schema=schema)
        except (requests.RequestException, json.JSONDecodeError):
            pytest.skip("Could not fetch SARIF schema for validation")

    @patch("sb.tools.info_finding")
    def test_sarif_schema_validation_complex(
        self, mock_info_finding: MagicMock, sample_tool_config: dict[str, Any]
    ) -> None:
        """Test complex SARIF document validates against schema."""
        pytest.importorskip("jsonschema")
        import json

        import jsonschema
        import requests

        mock_info_finding.return_value = {
            "descr_short": "Reentrancy",
            "descr_long": "Detailed description",
            "classification": "SWC-107",
            "severity": "high",
        }

        findings = [
            {
                "name": "reentrancy",
                "message": "Reentrancy detected",
                "filename": "test.sol",
                "line": 10,
                "line_end": 20,
                "contract": "Token",
                "function": "transfer",
                "severity": "high",
                "level": "warning",
            },
            {
                "name": "overflow",
                "filename": "test.sol",
                "address": 100,
            },
        ]
        sarif_doc = sb.sarif.sarify(sample_tool_config, findings)

        # Fetch SARIF 2.1.0 schema
        schema_url = "https://json.schemastore.org/sarif-2.1.0.json"
        try:
            response = requests.get(schema_url, timeout=5)
            response.raise_for_status()
            schema = response.json()

            # Validate
            jsonschema.validate(instance=sarif_doc, schema=schema)
        except (requests.RequestException, json.JSONDecodeError):
            pytest.skip("Could not fetch SARIF schema for validation")


class TestEdgeCases:
    """Tests for edge cases and error conditions."""

    def test_finding_with_none_values(self) -> None:
        """Test handling of findings with None values."""
        finding = {
            "name": "test",
            "filename": "test.sol",
            "message": None,
            "severity": None,
            "contract": None,
        }
        # Should not raise an exception
        result = sb.sarif.result_location_message(finding)
        assert result == ""

    def test_empty_tool_config(self) -> None:
        """Test SARIF generation with minimal tool config."""
        tool = {"id": "test"}
        findings = [{"name": "vuln", "filename": "test.sol"}]
        result = sb.sarif.sarify(tool, findings)

        assert result["version"] == "2.1.0"
        assert len(result["runs"]) == 1

    @patch("sb.tools.info_finding")
    def test_missing_finding_info(self, mock_info_finding: MagicMock) -> None:
        """Test handling when finding info is not available."""
        mock_info_finding.return_value = {}
        finding = {"name": "unknown", "filename": "test.sol"}
        result = sb.sarif.result_info("tool", finding)

        # Should still create valid result with minimal info
        assert result["ruleId"] == "tool_unknown"
        assert result["locations"][0]["physicalLocation"]["artifactLocation"]["uri"] == "test.sol"

    def test_unicode_in_messages(self) -> None:
        """Test handling of unicode characters in messages."""
        finding = {
            "name": "test",
            "message": "Unicode test: \u2713 \u00e9 \u4e2d\u6587",
        }
        info = {}
        result = sb.sarif.result_message(finding, info)

        assert "\u2713" in result  # Check mark
        assert "\u00e9" in result  # é
        assert "\u4e2d\u6587" in result  # Chinese characters

    def test_very_large_line_numbers(self) -> None:
        """Test handling of very large line numbers."""
        finding = {"line": 999999, "line_end": 1000000}
        result = sb.sarif.result_region(finding)

        assert result["startLine"] == 999999
        assert result["endLine"] == 1000000

    def test_zero_address(self) -> None:
        """Test handling of zero bytecode address."""
        finding = {"address": 0}
        result = sb.sarif.result_region(finding)

        # Address mapping: line=1, column=1+2*0=1
        assert result == {"startLine": 1, "startColumn": 1}

    @patch("sb.tools.info_finding")
    def test_multiple_findings_same_name_different_locations(
        self, mock_info_finding: MagicMock
    ) -> None:
        """Test handling of multiple findings with same name in different locations."""
        mock_info_finding.return_value = {}
        tool = {"id": "tool"}
        findings = [
            {"name": "vuln", "filename": "a.sol", "line": 10},
            {"name": "vuln", "filename": "a.sol", "line": 20},
            {"name": "vuln", "filename": "b.sol", "line": 30},
        ]

        sarif = sb.sarif.sarify(tool, findings)

        # Should have 3 results but only 1 rule
        assert len(sarif["runs"][0]["results"]) == 3
        assert len(sarif["runs"][0]["tool"]["driver"]["rules"]) == 1

    def test_whitespace_handling(self) -> None:
        """Test handling of whitespace in severity and level values."""
        info = {"severity": "  high  ", "level": "  warning  "}
        severity = sb.sarif.rule_security_severity(info)
        level = sb.sarif.rule_problem_severity(info)

        assert severity == "8.0"
        assert level == "warning"

    def test_filename_with_special_chars(self) -> None:
        """Test handling of filenames with special characters."""
        finding = {
            "name": "test",
            "filename": "/path/to/my-contract (v2).sol",
        }
        result = sb.sarif.result_info("tool", finding)

        assert (
            result["locations"][0]["physicalLocation"]["artifactLocation"]["uri"]
            == "/path/to/my-contract (v2).sol"
        )
