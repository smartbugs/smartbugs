"""Unit tests for sb/solidity.py module.

This module tests Solidity pragma parsing and contract name extraction.
"""

from sb.solidity import (
    extract_versions_contractnames,
    remove_comments_strings,
    remove_strings,
)


class TestRemoveCommentsStrings:
    """Test the remove_comments_strings function."""

    def test_removes_single_line_comments(self):
        """Test removal of single-line comments."""
        code = "pragma solidity ^0.8.0; // This is a comment"
        result = remove_comments_strings(code)
        assert result == "pragma solidity ^0.8.0; "

    def test_removes_multi_line_comments(self):
        """Test removal of multi-line comments."""
        code = (
            "pragma solidity ^0.8.0;\n"
            "/* This is a\n"
            "   multi-line comment */\n"
            "contract Test {}\n"
        )
        result = remove_comments_strings(code)
        assert result == "pragma solidity ^0.8.0;\n\n\ncontract Test {}\n"

    def test_removes_single_quoted_strings(self):
        """Test that strings with single quotes are removed properly."""
        code = "string public name = 'MyContract'; // comment"
        result = remove_comments_strings(code)
        assert result == "string public name = ''; "

    def test_removes_double_quoted_strings(self):
        """Test that strings with double quotes are removed properly."""
        code = 'string public name = "MyContract"; // comment'
        result = remove_comments_strings(code)
        assert result == 'string public name = ""; '

    def test_handles_unclosed_multi_line_comment(self):
        """Test handling of unclosed multi-line comment."""
        code = "pragma solidity ^0.8.0;\n/* Unclosed comment\ncontract Test {}"
        result = remove_comments_strings(code)
        assert result == "pragma solidity ^0.8.0;\n\n"

    def test_handles_unclosed_single_quoted_string(self):
        """Test handling of unclosed double quoted string."""
        code = "string public name = 'Unclosed\ncontract Test {}"
        result = remove_comments_strings(code)
        assert result == "string public name = ''"

    def test_handles_unclosed_double_quoted_string(self):
        """Test handling of unclosed double quoted string."""
        code = 'string public name = "Unclosed\ncontract Test {}'
        result = remove_comments_strings(code)
        assert result == 'string public name = ""'

    def test_empty_input(self):
        """Test with empty input."""
        result = remove_comments_strings("")
        assert result == ""

    def test_mixed_comments_and_strings(self):
        """Test with mixed comments and strings."""
        code = (
            "pragma solidity ^0.8.0;\n"
            '// Single line comment with "string"\n'
            "/* Multi-line with 'string' */\n"
            "contract Test {\n"
            '    string public name = "Test"; // inline comment\n'
            "}"
        )
        result = remove_comments_strings(code)
        assert result == (
            "pragma solidity ^0.8.0;\n\n \n" 'contract Test {\n    string public name = ""; \n}'
        )


class TestRemoveStrings:
    """Test the remove_strings function."""

    def test_does_not_remove_single_line_comments(self):
        """Test non-removal of single-line comments."""
        code = "pragma solidity ^0.8.0; // This is a comment"
        result = remove_strings(code)
        assert result == code

    def test_does_not_remove_multi_line_comments(self):
        """Test non-removal of multi-line comments."""
        code = (
            "pragma solidity ^0.8.0;\n"
            "/* This is a\n"
            "   multi-line comment */\n"
            "contract Test {}\n"
        )
        result = remove_strings(code)
        assert result == code

    def test_removes_single_quoted_strings(self):
        """Test that strings with single quotes are removed properly."""
        code = "string public name = 'MyContract'; // comment"
        result = remove_strings(code)
        assert result == "string public name = ''; // comment"

    def test_removes_double_quoted_strings(self):
        """Test that strings with double quotes are removed properly."""
        code = 'string public name = "MyContract"; // comment'
        result = remove_strings(code)
        assert result == 'string public name = ""; // comment'

    def test_handles_unclosed_multi_line_comment(self):
        """Test handling of unclosed multi-line comment."""
        code = "pragma solidity ^0.8.0;\n/* Unclosed comment\ncontract Test {}"
        result = remove_strings(code)
        assert result == code

    def test_handles_unclosed_single_quoted_string(self):
        """Test handling of unclosed single quoted string."""
        code = "string public name = 'Unclosed\ncontract Test {}"
        result = remove_strings(code)
        assert result == "string public name = ''"

    def test_handles_unclosed_double_quoted_string(self):
        """Test handling of unclosed double quoted string."""
        code = 'string public name = "Unclosed\ncontract Test {}'
        result = remove_strings(code)
        assert result == 'string public name = ""'

    def test_empty_input(self):
        """Test with empty input."""
        result = remove_strings("")
        assert result == ""

    def test_mixed_comments_and_strings(self):
        """Test with mixed comments and strings."""
        code = (
            "pragma solidity ^0.8.0;\n"
            '// Single line comment with "string"\n'
            "/* Multi-line with 'string' */\n"
            "contract Test {\n"
            "    string public name = 'Test'; // inline comment\n"
            "}"
        )
        result = remove_strings(code)
        assert result == code.replace("'Test'", "''")


class TestExtractVersionsContractnames:
    """Test the extract_versions_contractnames function."""

    def test_extract_pragma_from_simple_contract(self, sample_contract):
        """Test pragma extraction from a simple contract."""
        versions, contracts = extract_versions_contractnames(sample_contract)
        assert versions == ["^0.8.0"]
        assert contracts == ["SimpleStorage"]

    def test_extract_pragma_from_old_pragma(self, fixtures_dir):
        """Test pragma extraction from old pragma contract."""
        code = (fixtures_dir / "contracts" / "OldPragma.sol").read_text()
        versions, contracts = extract_versions_contractnames(code)
        assert versions == ["^0.4.25"]
        assert contracts == ["LegacyToken"]

    def test_extract_pragma_from_new_pragma(self, fixtures_dir):
        """Test pragma extraction from new pragma contract."""
        code = (fixtures_dir / "contracts" / "NewPragma.sol").read_text()
        versions, contracts = extract_versions_contractnames(code)
        assert versions == ["^0.8.20"]
        assert contracts == ["ModernToken"]

    def test_no_pragma_returns_none(self, fixtures_dir):
        """Test that missing pragma returns empty list."""
        code = (fixtures_dir / "contracts" / "NoPragma.sol").read_text()
        versions, contracts = extract_versions_contractnames(code)
        assert versions == []
        assert contracts == ["NoPragmaContract"]

    def test_extract_multiple_contracts(self, fixtures_dir):
        """Test extraction of multiple contract names from single file."""
        code = (fixtures_dir / "contracts" / "MultiContract.sol").read_text()
        versions, contracts = extract_versions_contractnames(code)
        assert versions == ["^0.8.0"]
        assert contracts == ["Base", "Derived", "Standalone"]

    def test_extract_library_name(self, sample_library_contract):
        """Test extraction of library name."""
        versions, contracts = extract_versions_contractnames(sample_library_contract)
        assert versions == ["^0.8.0"]
        assert contracts == ["Library"]

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
        versions, contracts = extract_versions_contractnames(code)
        assert versions == ["^0.8.0"]
        assert contracts == ["Base", "Derived"]

    def test_pragma_in_comment_ignored(self):
        """Test that pragma in comments is ignored."""
        code = """
        // pragma solidity ^0.4.0;
        pragma solidity >=0.7.5;
        /* pragma solidity ^0.5.0; */
        pragma solidity ^0.8.0;
        contract Test {}
        """
        versions, contracts = extract_versions_contractnames(code)
        assert versions == [">=0.7.5", "^0.8.0"]
        assert contracts == ["Test"]

    def test_pragma_in_comment_not_ignored(self):
        """Test that first pragma in comments is picked if regular pragma is missing."""
        code = """
        // pragma solidity ^0.4.0;
        // pragma solidity >=0.7.5;
        /* pragma solidity ^0.5.0; */
        /* pragma solidity ^0.8.0; */
        contract Test {}
        """
        versions, contracts = extract_versions_contractnames(code)
        assert versions == ["^0.4.0"]
        assert contracts == ["Test"]

    def test_empty_input(self):
        """Test with empty input."""
        versions, contracts = extract_versions_contractnames([])
        assert versions == []
        assert contracts == []
