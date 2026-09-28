from unittest.mock import patch
import sb.semantic_version


@patch("sb.debug.log")
def test_exact_match(mock_log):
    versions = ["1.2.3"]
    available = {"1.2.3", "1.2.4"}
    assert sb.semantic_version.match(versions, available) == "1.2.3"


@patch("sb.debug.log")
def test_match_removes_leading_zeros(mock_log):
    versions = ["01.002.0003"]
    available = {"1.2.3"}
    assert sb.semantic_version.match(versions, available) == "1.2.3"


@patch("sb.debug.log")
def test_match_ge_zero_rewritten_without_upper_bound(mock_log):
    versions = [">= 0.5.1"]
    available = {"0.5.1", "0.5.9", "0.6.0"}
    assert sb.semantic_version.match(versions, available) == "0.5.9"


@patch("sb.debug.log")
def test_match_ge_zero_not_rewritten_with_upper_bound(mock_log):
    versions = [">= 0.5.1 < 0.6.0"]
    available = {"0.5.1", "0.5.9", "0.6.0"}
    assert sb.semantic_version.match(versions, available) == "0.5.9"


@patch("sb.debug.log")
def test_match_two_segment_version_expansion(mock_log):
    versions = ["1.5"]
    available = {"1.5.0", "1.5.1"}
    assert sb.semantic_version.match(versions, available) == "1.5.1"


@patch("sb.debug.log")
def test_match_range_replacement(mock_log):
    versions = ["1.2.0 - 1.2.5"]
    available = {"1.2.0", "1.2.3", "1.2.5", "1.3.0"}
    assert sb.semantic_version.match(versions, available) == "1.2.5"


@patch("sb.debug.log")
def test_match_or_alternatives(mock_log):
    versions = ["<1.0.0 || >=2.0.0"]
    available = {"0.9.9", "1.5.0", "2.1.0"}
    assert sb.semantic_version.match(versions, available) == "2.1.0"


@patch("sb.debug.log")
def test_match_or_normalizes_unbounded_branch_independently(mock_log):
    versions = [">=0.4.0 || >=0.6.1 <0.7.0"]
    available = {"0.4.9", "0.5.0", "0.6.0"}
    assert sb.semantic_version.match(versions, available) == "0.4.9"


@patch("sb.debug.log")
def test_match_or_rewrites_branch_even_when_other_branch_is_bounded(mock_log):
    versions = [">=0.4.0 <0.5.0 || >=0.6.1"]
    available = {"0.4.9", "0.6.2", "0.7.0"}
    assert sb.semantic_version.match(versions, available) == "0.6.2"


@patch("sb.debug.log")
def test_match_or_intersects_another_pragma(mock_log):
    versions = [">=0.4.0 <0.5.0 || >=0.7.0 <0.8.0", ">=0.4.5 <0.7.5"]
    available = {"0.4.4", "0.4.6", "0.6.0", "0.7.4", "0.7.6"}
    assert sb.semantic_version.match(versions, available) == "0.7.4"


@patch("sb.debug.log")
def test_match_multiple_constraints_product(mock_log):
    versions = ["^1.2.0", ">1.2.3"]
    available = {"1.2.0", "1.2.3", "1.3.0", "2.0.0"}
    assert sb.semantic_version.match(versions, available) == "1.3.0"


@patch("sb.debug.log")
def test_match_tilde_operator(mock_log):
    versions = ["~1.2.0"]
    available = {"1.2.0", "1.2.5", "1.3.0"}
    assert sb.semantic_version.match(versions, available) == "1.2.5"


@patch("sb.debug.log")
def test_match_no_valid_comparators(mock_log):
    versions = ["invalid"]
    available = {"1.0.0"}
    assert sb.semantic_version.match(versions, available) is None


@patch("sb.debug.log")
def test_match_empty_versions_list(mock_log):
    assert sb.semantic_version.match([], {"1.0.0"}) is None


@patch("sb.debug.log")
def test_match_no_available_versions(mock_log):
    versions = [">=1.0.0"]
    assert sb.semantic_version.match(versions, set()) is None


@patch("sb.debug.log")
def test_match_selects_highest_valid(mock_log):
    versions = [">=1.0.0"]
    available = {"1.0.0", "1.5.0", "2.0.0"}
    assert sb.semantic_version.match(versions, available) == "2.0.0"


@patch("sb.debug.log")
def test_match_handles_spaces_in_comparators(mock_log):
    versions = [">= 1.0.0  < 2.0.0"]
    available = {"1.0.0", "1.5.0", "2.0.0"}
    assert sb.semantic_version.match(versions, available) == "1.5.0"


@patch("sb.debug.log")
def test_match_mixed_complex_expression(mock_log):
    versions = [" >=0.4.0 || 1.2.0 - 1.2.5 "]
    available = {"0.4.1", "0.4.9", "1.2.3", "1.3.0"}
    assert sb.semantic_version.match(versions, available) == "1.2.3"
