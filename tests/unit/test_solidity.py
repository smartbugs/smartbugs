"""Unit tests for sb/solidity.py module.

This module tests Solidity pragma parsing, version selection,
contract name extraction, and compiler path resolution.
"""

from pathlib import Path
from unittest.mock import patch

from sb.solidity import (
    ensure_solc_versions_loaded,
    get_pragma_contractnames,
    get_solc_path,
    get_solc_version,
    remove_comments_strings,
)


class TestRemoveCommentsStrings:
    """Test the remove_comments_strings function."""

    def test_removes_single_line_comments(self):
        """Test removal of single-line comments."""
        code = ["pragma solidity ^0.8.0; // This is a comment"]
        result = remove_comments_strings(code)
        assert "// This is a comment" not in result
        assert "pragma solidity ^0.8.0;" in result

    def test_removes_multi_line_comments(self):
        """Test removal of multi-line comments."""
        code = [
            "pragma solidity ^0.8.0;",
            "/* This is a",
            "   multi-line comment */",
            "contract Test {}",
        ]
        result = remove_comments_strings(code)
        assert "/* This is a" not in result
        assert "multi-line comment" not in result
        assert "pragma solidity ^0.8.0;" in result
        assert "contract Test {}" in result

    def test_preserves_strings_with_quotes(self):
        """Test that strings with quotes are removed properly."""
        code = ['string public name = "MyContract"; // comment']
        result = remove_comments_strings(code)
        assert "// comment" not in result
        # Strings are removed, not preserved
        assert "MyContract" not in result

    def test_handles_unclosed_multi_line_comment(self):
        """Test handling of unclosed multi-line comment."""
        code = ["pragma solidity ^0.8.0;", "/* Unclosed comment", "contract Test {}"]
        result = remove_comments_strings(code)
        # Function should handle gracefully
        assert isinstance(result, str)

    def test_handles_unclosed_string(self):
        """Test handling of unclosed string."""
        code = ['string public name = "Unclosed', "contract Test {}"]
        result = remove_comments_strings(code)
        # Function should handle gracefully
        assert isinstance(result, str)

    def test_empty_input(self):
        """Test with empty input."""
        result = remove_comments_strings([])
        assert result == ""

    def test_mixed_comments_and_strings(self):
        """Test with mixed comments and strings."""
        code = [
            "pragma solidity ^0.8.0;",
            '// Single line comment with "string"',
            "/* Multi-line with 'string' */",
            "contract Test {",
            '    string public name = "Test"; // inline comment',
            "}",
        ]
        result = remove_comments_strings(code)
        assert "pragma solidity ^0.8.0;" in result
        assert "contract Test {" in result
        assert "// Single line comment" not in result
        assert "/* Multi-line" not in result


class TestGetPragmaContractNames:
    """Test the get_pragma_contractnames function."""

    def test_extract_pragma_from_simple_contract(self, sample_contract):
        """Test pragma extraction from a simple contract."""
        pragma, contracts = get_pragma_contractnames([sample_contract])
        assert pragma == "pragma solidity ^0.8.0;"
        assert "SimpleStorage" in contracts

    def test_extract_pragma_from_old_pragma(self, fixtures_dir):
        """Test pragma extraction from old pragma contract."""
        old_pragma = (fixtures_dir / "contracts" / "OldPragma.sol").read_text()
        pragma, contracts = get_pragma_contractnames([old_pragma])
        assert pragma == "pragma solidity ^0.4.25;"
        assert "LegacyToken" in contracts

    def test_extract_pragma_from_new_pragma(self, fixtures_dir):
        """Test pragma extraction from new pragma contract."""
        new_pragma = (fixtures_dir / "contracts" / "NewPragma.sol").read_text()
        pragma, contracts = get_pragma_contractnames([new_pragma])
        assert pragma == "pragma solidity ^0.8.20;"
        assert "ModernToken" in contracts

    def test_no_pragma_returns_none(self, fixtures_dir):
        """Test that missing pragma returns None."""
        no_pragma = (fixtures_dir / "contracts" / "NoPragma.sol").read_text()
        pragma, contracts = get_pragma_contractnames([no_pragma])
        assert pragma is None
        assert "NoPragmaContract" in contracts

    def test_extract_multiple_contracts(self, fixtures_dir):
        """Test extraction of multiple contract names from single file."""
        multi_contract = (fixtures_dir / "contracts" / "MultiContract.sol").read_text()
        pragma, contracts = get_pragma_contractnames([multi_contract])
        assert pragma == "pragma solidity ^0.8.0;"
        assert "Base" in contracts
        assert "Derived" in contracts
        assert "Standalone" in contracts

    def test_extract_library_name(self, sample_library_contract):
        """Test extraction of library name."""
        pragma, contracts = get_pragma_contractnames([sample_library_contract])
        assert pragma == "pragma solidity ^0.8.0;"
        assert "Library" in contracts

    def test_contract_with_inheritance(self):
        """Test contract name extraction with inheritance."""
        code = """
        pragma solidity ^0.8.0;
        contract Base {
            uint256 public value;
        }
        contract Derived is Base {
            function setValue(uint256 _value) public {
                value = _value;
            }
        }
        """
        pragma, contracts = get_pragma_contractnames([code])
        assert pragma == "pragma solidity ^0.8.0;"
        assert "Base" in contracts
        assert "Derived" in contracts

    def test_pragma_in_comment_ignored(self):
        """Test that pragma in comments is ignored."""
        code = [
            "// pragma solidity ^0.4.0;",
            "/* pragma solidity ^0.5.0; */",
            "pragma solidity ^0.8.0;",
            "contract Test {}",
        ]
        pragma, contracts = get_pragma_contractnames(code)
        assert pragma == "pragma solidity ^0.8.0;"
        assert "Test" in contracts

    def test_empty_input(self):
        """Test with empty input."""
        pragma, contracts = get_pragma_contractnames([])
        assert pragma is None
        assert contracts == []


class TestEnsureSolcVersionsLoaded:
    """Test the ensure_solc_versions_loaded function."""

    @patch("sb.solidity.solcx.get_installable_solc_versions")
    def test_loads_installable_versions_successfully(self, mock_get_installable):
        """Test successful loading of installable versions."""
        mock_versions = ["0.8.20", "0.8.19", "0.8.18"]
        mock_get_installable.return_value = mock_versions

        # Clear cache
        import sb.solidity

        sb.solidity.cached_solc_versions = None

        result = ensure_solc_versions_loaded()
        assert result is True
        assert sb.solidity.cached_solc_versions == mock_versions
        mock_get_installable.assert_called_once()

    @patch("sb.solidity.solcx.get_installable_solc_versions")
    def test_returns_cached_versions(self, mock_get_installable):
        """Test that cached versions are returned without making new call."""
        import sb.solidity

        sb.solidity.cached_solc_versions = ["0.8.20"]

        result = ensure_solc_versions_loaded()
        assert result is True
        mock_get_installable.assert_not_called()

    @patch("sb.solidity.solcx.get_installable_solc_versions")
    @patch("sb.solidity.solcx.get_installed_solc_versions")
    def test_fallback_to_installed_versions_on_error(
        self, mock_get_installed, mock_get_installable
    ):
        """Test fallback to installed versions when installable fails."""
        mock_get_installable.side_effect = Exception("Network error")
        mock_installed = ["0.8.19"]
        mock_get_installed.return_value = mock_installed

        import sb.solidity

        sb.solidity.cached_solc_versions = None

        result = ensure_solc_versions_loaded()
        assert result is False
        assert sb.solidity.cached_solc_versions == mock_installed
        mock_get_installable.assert_called_once()
        mock_get_installed.assert_called_once()


class TestGetSolcVersion:
    """Test the get_solc_version function."""

    @patch("sb.solidity.solcx.install._select_pragma_version")
    def test_selects_version_from_pragma(self, mock_select_version):
        """Test version selection from pragma."""
        mock_select_version.return_value = "0.8.20"
        version = get_solc_version("pragma solidity ^0.8.0;")
        assert version == "0.8.20"
        mock_select_version.assert_called_once()

    @patch("sb.solidity.solcx.install._select_pragma_version")
    def test_transforms_gte_to_caret(self, mock_select_version):
        """Test transformation of >= to ^ for version selection."""
        mock_select_version.return_value = "0.8.20"
        get_solc_version("pragma solidity >=0.8.0;")
        # Verify the pragma was transformed
        call_args = mock_select_version.call_args[0][0]
        assert "^0.8" in call_args
        assert ">=0.8" not in call_args

    @patch("sb.solidity.solcx.install._select_pragma_version")
    def test_adds_patch_version_to_short_version(self, mock_select_version):
        """Test adding .0 patch version to short versions."""
        mock_select_version.return_value = "0.8.0"
        get_solc_version("pragma solidity 0.8;")
        # Verify version was expanded
        call_args = mock_select_version.call_args[0][0]
        assert "0.8.0" in call_args

    def test_returns_none_for_none_pragma(self):
        """Test that None pragma returns None."""
        result = get_solc_version(None)
        assert result is None

    def test_returns_none_for_empty_pragma(self):
        """Test that empty pragma returns None."""
        result = get_solc_version("")
        assert result is None

    @patch("sb.solidity.solcx.install._select_pragma_version")
    def test_handles_version_selection_error(self, mock_select_version):
        """Test handling of version selection errors."""
        mock_select_version.side_effect = Exception("Invalid pragma")
        version = get_solc_version("pragma solidity invalid;")
        assert version is None

    @patch("sb.solidity.solcx.install._select_pragma_version")
    def test_handles_complex_pragma_range(self, mock_select_version):
        """Test handling of complex pragma version range."""
        mock_select_version.return_value = "0.8.15"
        version = get_solc_version("pragma solidity >=0.8.0 <0.9.0;")
        assert version == "0.8.15"


class TestGetSolcPath:
    """Test the get_solc_path function."""

    @patch("sb.solidity.solcx.install_solc")
    @patch("sb.solidity.solcx.get_executable")
    def test_installs_and_returns_path(self, mock_get_executable, mock_install):
        """Test installation and path retrieval."""
        mock_path = Path("/usr/local/bin/solc-0.8.20")
        mock_get_executable.return_value = mock_path

        # Clear cache
        import sb.solidity

        sb.solidity.cached_solc_paths.clear()

        result = get_solc_path("0.8.20")
        assert result == str(mock_path)
        mock_install.assert_called_once_with("0.8.20")
        mock_get_executable.assert_called_once_with("0.8.20")

    @patch("sb.solidity.solcx.install_solc")
    @patch("sb.solidity.solcx.get_executable")
    def test_returns_cached_path(self, mock_get_executable, mock_install):
        """Test that cached path is returned without reinstalling."""
        import sb.solidity

        sb.solidity.cached_solc_paths["0.8.20"] = "/cached/path/solc"

        result = get_solc_path("0.8.20")
        assert result == "/cached/path/solc"
        mock_install.assert_not_called()
        mock_get_executable.assert_not_called()

    def test_returns_none_for_none_version(self):
        """Test that None version returns None."""
        result = get_solc_path(None)
        assert result is None

    def test_returns_none_for_empty_version(self):
        """Test that empty version returns None."""
        result = get_solc_path("")
        assert result is None

    @patch("sb.solidity.solcx.install_solc")
    @patch("sb.solidity.solcx.get_executable")
    def test_handles_installation_error(self, mock_get_executable, mock_install):
        """Test handling of installation errors."""
        mock_install.side_effect = Exception("Installation failed")

        import sb.solidity

        sb.solidity.cached_solc_paths.clear()

        result = get_solc_path("0.8.20")
        assert result is None
        mock_install.assert_called_once()
        mock_get_executable.assert_not_called()

    @patch("sb.solidity.solcx.install_solc")
    @patch("sb.solidity.solcx.get_executable")
    def test_handles_get_executable_error(self, mock_get_executable, mock_install):
        """Test handling of get_executable errors."""
        mock_get_executable.side_effect = Exception("Executable not found")

        import sb.solidity

        sb.solidity.cached_solc_paths.clear()

        result = get_solc_path("0.8.20")
        assert result is None
        mock_install.assert_called_once()
        mock_get_executable.assert_called_once()

    @patch("sb.solidity.solcx.install_solc")
    @patch("sb.solidity.solcx.get_executable")
    def test_handles_none_executable_path(self, mock_get_executable, mock_install):
        """Test handling when get_executable returns None."""
        mock_get_executable.return_value = None

        import sb.solidity

        sb.solidity.cached_solc_paths.clear()

        result = get_solc_path("0.8.20")
        assert result is None


class TestIntegrationScenarios:
    """Integration tests combining multiple functions."""

    @patch("sb.solidity.solcx.install._select_pragma_version")
    @patch("sb.solidity.solcx.install_solc")
    @patch("sb.solidity.solcx.get_executable")
    def test_full_workflow_simple_contract(
        self, mock_get_executable, mock_install, mock_select_version, sample_contract
    ):
        """Test full workflow from contract to compiler path."""
        mock_select_version.return_value = "0.8.20"
        mock_get_executable.return_value = Path("/usr/bin/solc-0.8.20")

        import sb.solidity

        sb.solidity.cached_solc_paths.clear()

        # Extract pragma and contract names
        pragma, contracts = get_pragma_contractnames([sample_contract])
        assert pragma is not None
        assert "SimpleStorage" in contracts

        # Get version from pragma
        version = get_solc_version(pragma)
        assert version == "0.8.20"

        # Get compiler path
        path = get_solc_path(version)
        assert path == "/usr/bin/solc-0.8.20"

    @patch("sb.solidity.solcx.install._select_pragma_version")
    @patch("sb.solidity.solcx.install_solc")
    @patch("sb.solidity.solcx.get_executable")
    def test_full_workflow_old_pragma(
        self, mock_get_executable, mock_install, mock_select_version, fixtures_dir
    ):
        """Test full workflow with old pragma (0.4.x)."""
        old_pragma = (fixtures_dir / "contracts" / "OldPragma.sol").read_text()
        mock_select_version.return_value = "0.4.25"
        mock_get_executable.return_value = Path("/usr/bin/solc-0.4.25")

        import sb.solidity

        sb.solidity.cached_solc_paths.clear()

        pragma, contracts = get_pragma_contractnames([old_pragma])
        assert pragma == "pragma solidity ^0.4.25;"

        version = get_solc_version(pragma)
        assert version == "0.4.25"

        path = get_solc_path(version)
        assert path == "/usr/bin/solc-0.4.25"

    @patch("sb.solidity.solcx.install._select_pragma_version")
    @patch("sb.solidity.solcx.install_solc")
    @patch("sb.solidity.solcx.get_executable")
    def test_full_workflow_new_pragma(
        self, mock_get_executable, mock_install, mock_select_version, fixtures_dir
    ):
        """Test full workflow with new pragma (0.8.x)."""
        new_pragma = (fixtures_dir / "contracts" / "NewPragma.sol").read_text()
        mock_select_version.return_value = "0.8.20"
        mock_get_executable.return_value = Path("/usr/bin/solc-0.8.20")

        import sb.solidity

        sb.solidity.cached_solc_paths.clear()

        pragma, contracts = get_pragma_contractnames([new_pragma])
        assert pragma == "pragma solidity ^0.8.20;"

        version = get_solc_version(pragma)
        assert version == "0.8.20"

        path = get_solc_path(version)
        assert path == "/usr/bin/solc-0.8.20"

    def test_no_pragma_workflow(self, fixtures_dir):
        """Test workflow when contract has no pragma."""
        no_pragma = (fixtures_dir / "contracts" / "NoPragma.sol").read_text()

        pragma, contracts = get_pragma_contractnames([no_pragma])
        assert pragma is None
        assert "NoPragmaContract" in contracts

        version = get_solc_version(pragma)
        assert version is None

        path = get_solc_path(version)
        assert path is None


class TestEdgeCases:
    """Test edge cases and boundary conditions."""

    def test_pragma_with_experimental_features(self):
        """Test pragma with experimental features."""
        code = [
            "pragma solidity ^0.8.0;",
            "pragma experimental ABIEncoderV2;",
            "contract Test {}",
        ]
        pragma, contracts = get_pragma_contractnames(code)
        # Should find the solidity pragma, not the experimental one
        assert pragma == "pragma solidity ^0.8.0;"

    def test_multiple_pragmas_returns_first(self):
        """Test that multiple pragmas returns the first one."""
        code = [
            "pragma solidity ^0.8.0;",
            "pragma solidity ^0.7.0;",  # Second pragma (shouldn't happen but test it)
            "contract Test {}",
        ]
        pragma, contracts = get_pragma_contractnames(code)
        assert pragma == "pragma solidity ^0.8.0;"

    def test_contract_name_with_numbers(self):
        """Test contract names with numbers."""
        code = ["pragma solidity ^0.8.0;", "contract ERC20Token {}", "contract Test123 {}"]
        pragma, contracts = get_pragma_contractnames(code)
        assert "ERC20Token" in contracts
        assert "Test123" in contracts

    def test_contract_name_with_underscore(self):
        """Test contract names with underscores."""
        code = ["pragma solidity ^0.8.0;", "contract My_Contract {}", "contract Test_123 {}"]
        pragma, contracts = get_pragma_contractnames(code)
        assert "My_Contract" in contracts
        assert "Test_123" in contracts

    def test_library_with_inheritance_syntax(self):
        """Test that 'is' keyword in contract is handled correctly."""
        code = [
            "pragma solidity ^0.8.0;",
            "contract Base {}",
            "contract Derived is Base {}",
        ]
        pragma, contracts = get_pragma_contractnames(code)
        assert "Base" in contracts
        assert "Derived" in contracts

    def test_version_transformation_with_multiple_ranges(self):
        """Test version transformation with multiple version constraints."""
        pragma = "pragma solidity >=0.8.0 <0.9.0;"
        # Just ensure it doesn't crash - result depends on mock
        get_solc_version(pragma)

    @patch("sb.solidity.solcx.install_solc")
    @patch("sb.solidity.solcx.get_executable")
    def test_caching_works_across_multiple_calls(self, mock_get_executable, mock_install):
        """Test that caching prevents multiple installations."""
        mock_get_executable.return_value = Path("/usr/bin/solc-0.8.20")

        import sb.solidity

        sb.solidity.cached_solc_paths.clear()

        # First call should install
        path1 = get_solc_path("0.8.20")
        assert path1 == "/usr/bin/solc-0.8.20"
        assert mock_install.call_count == 1

        # Second call should use cache
        path2 = get_solc_path("0.8.20")
        assert path2 == "/usr/bin/solc-0.8.20"
        assert mock_install.call_count == 1  # Still 1, not 2

    def test_pragma_with_whitespace_variations(self):
        """Test pragma extraction with various whitespace patterns.

        Note: The regex is strict and only matches 'pragma solidity' with
        exactly one space between pragma and solidity.
        """
        test_cases = [
            ("pragma solidity ^0.8.0;", True),  # Normal case
            ("pragma  solidity  ^0.8.0;", False),  # Extra spaces don't match
            ("pragma\tsolidity\t^0.8.0;", False),  # Tabs don't match
            ("pragma\nsolidity\n^0.8.0;", False),  # Newlines don't match
        ]
        for code, should_match in test_cases:
            pragma, _ = get_pragma_contractnames([code])
            if should_match:
                assert pragma is not None
                assert "pragma solidity" in pragma
                assert "0.8.0" in pragma
            else:
                # Regex is strict - only standard formatting matches
                assert pragma is None
