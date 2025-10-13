"""Unit tests for sb/settings.py.

This module tests the Settings class, including:
- Default settings initialization
- Loading from site_cfg.yaml
- Loading from user-provided config files
- CLI argument overrides
- Configuration hierarchy (site → user → CLI)
- Invalid YAML handling
- Missing config file handling
- Setting attribute access
- Settings freezing and template expansion
- Result directory path generation
"""

import os
import string
from pathlib import Path

import pytest

import sb.errors
from sb.settings import Settings


class TestSettingsInitialization:
    """Test default settings initialization."""

    def test_default_values(self):
        """Test that Settings initializes with correct default values."""
        settings = Settings()

        assert settings.frozen is False
        assert settings.files == []
        assert settings.main is False
        assert settings.runtime is False
        assert settings.tools == []
        assert settings.runid == "${YEAR}${MONTH}${DAY}_${HOUR}${MIN}"
        assert settings.overwrite is False
        assert settings.processes == 1
        assert settings.timeout is None
        assert settings.cpu_quota is None
        assert settings.mem_limit is None
        assert settings.continue_on_errors is False
        assert settings.results == os.path.join("results", "${TOOL}", "${RUNID}", "${FILENAME}")
        assert settings.log == os.path.join("results", "logs", "${RUNID}.log")
        assert settings.json is False
        assert settings.sarif is False
        assert settings.quiet is False

    def test_multiple_instances_independent(self):
        """Test that multiple Settings instances are independent."""
        settings1 = Settings()
        settings2 = Settings()

        settings1.timeout = 100
        settings1.processes = 4

        assert settings2.timeout is None
        assert settings2.processes == 1


class TestSettingsFreeze:
    """Test settings freezing and template expansion."""

    def test_freeze_expands_templates(self):
        """Test that freeze() expands template variables in runid and log."""
        settings = Settings()
        settings.freeze()

        assert settings.frozen is True
        assert "${YEAR}" not in settings.runid
        assert "${MONTH}" not in settings.runid
        assert "${DAY}" not in settings.runid
        assert "${HOUR}" not in settings.runid
        assert "${MIN}" not in settings.runid
        # Should be expanded to something like "20251013_1234"
        assert len(settings.runid) == 13
        assert "_" in settings.runid

        assert "${RUNID}" not in settings.log
        assert "results" in settings.log
        assert settings.runid in settings.log

    def test_freeze_converts_results_to_template(self):
        """Test that freeze() converts results path to a Template object."""
        settings = Settings()
        original_results = settings.results
        assert isinstance(original_results, str)

        settings.freeze()

        assert isinstance(settings.results, string.Template)

    def test_freeze_is_idempotent(self):
        """Test that calling freeze() multiple times has no additional effect."""
        settings = Settings()
        settings.freeze()
        runid_after_first = settings.runid
        log_after_first = settings.log

        settings.freeze()

        assert settings.runid == runid_after_first
        assert settings.log == log_after_first

    def test_freeze_with_custom_runid(self):
        """Test freezing with a custom runid template."""
        settings = Settings()
        settings.runid = "test_${YEAR}_${PID}"
        settings.freeze()

        assert "test_" in settings.runid
        assert "${YEAR}" not in settings.runid
        assert "${PID}" not in settings.runid
        assert str(os.getpid()) in settings.runid

    def test_freeze_with_invalid_variable_in_runid(self):
        """Test that freeze() raises error for unknown variables in runid."""
        settings = Settings()
        settings.runid = "${INVALID_VAR}"

        with pytest.raises(sb.errors.SmartBugsError, match="Unknown variable.*in run id"):
            settings.freeze()

    def test_freeze_with_invalid_variable_in_log(self):
        """Test that freeze() raises error for unknown variables in log path."""
        settings = Settings()
        settings.log = "logs/${INVALID_VAR}.log"

        with pytest.raises(sb.errors.SmartBugsError, match="Unknown variable.*in name of log file"):
            settings.freeze()

    def test_freeze_substitutes_all_env_variables(self):
        """Test that all expected environment variables are substituted."""
        settings = Settings()
        settings.runid = (
            "${SBVERSION}_${SBHOME}_${HOME}_${PID}_${YEAR}_${MONTH}_${DAY}_"
            "${HOUR}_${MIN}_${SEC}_${ZONE}"
        )
        settings.freeze()

        # Verify no template variables remain
        assert "$" not in settings.runid
        assert "{" not in settings.runid
        assert "}" not in settings.runid


class TestSettingsResultDir:
    """Test result directory path generation."""

    def test_resultdir_requires_frozen_settings(self):
        """Test that resultdir() raises error if settings not frozen."""
        settings = Settings()

        with pytest.raises(sb.errors.InternalError, match="before settings have been frozen"):
            settings.resultdir("mythril", "solidity", "/path/to/file.sol", "file.sol")

    def test_resultdir_substitutes_variables(self):
        """Test that resultdir() correctly substitutes all template variables."""
        settings = Settings()
        settings.freeze()

        result = settings.resultdir(
            toolid="mythril",
            toolmode="solidity",
            absfn="/home/user/contracts/SimpleDAO.sol",
            relfn="contracts/SimpleDAO.sol",
        )

        assert "mythril" in result
        # MODE is not in default template, so just check tool, runid, and filename
        assert "SimpleDAO.sol" in result
        assert settings.runid in result

    def test_resultdir_extracts_file_components(self):
        """Test that resultdir() correctly extracts filename components."""
        settings = Settings()
        settings.results = "results/${FILEBASE}_${FILEEXT}/${TOOL}"
        settings.freeze()

        result = settings.resultdir(
            toolid="slither",
            toolmode="solidity",
            absfn="/path/to/Contract.sol",
            relfn="Contract.sol",
        )

        assert "Contract" in result
        assert "sol" in result
        assert "slither" in result

    def test_resultdir_handles_multiple_extensions(self):
        """Test that resultdir() correctly handles files like file.rt.hex."""
        settings = Settings()
        settings.results = "results/${FILEBASE}.${FILEEXT}"
        settings.freeze()

        result = settings.resultdir(
            toolid="mythril",
            toolmode="runtime",
            absfn="/path/to/contract.rt.hex",
            relfn="contract.rt.hex",
        )

        assert "contract.rt" in result
        assert "hex" in result

    def test_resultdir_with_invalid_variable(self):
        """Test that resultdir() raises error for unknown template variables."""
        settings = Settings()
        settings.results = "results/${INVALID}"
        settings.freeze()

        with pytest.raises(
            sb.errors.SmartBugsError, match="Unknown variable.*in template of result dir"
        ):
            settings.resultdir("tool", "mode", "/file.sol", "file.sol")

    def test_resultdir_with_absdir_and_reldir(self):
        """Test that resultdir() correctly substitutes directory paths."""
        settings = Settings()
        settings.results = "${ABSDIR}/${RELDIR}/${FILENAME}"
        settings.freeze()

        result = settings.resultdir(
            toolid="mythril",
            toolmode="solidity",
            absfn="/home/user/project/contracts/Token.sol",
            relfn="contracts/Token.sol",
        )

        assert "/home/user/project/contracts" in result
        assert "contracts" in result
        assert "Token.sol" in result


class TestSettingsUpdate:
    """Test settings update from YAML files and dictionaries."""

    def test_update_cannot_modify_frozen_settings(self):
        """Test that update() raises error on frozen settings."""
        settings = Settings()
        settings.freeze()

        with pytest.raises(sb.errors.InternalError, match="Frozen settings cannot be updated"):
            settings.update({"timeout": 300})

    def test_update_with_none_does_nothing(self):
        """Test that update(None) does nothing."""
        settings = Settings()
        original_timeout = settings.timeout

        settings.update(None)

        assert settings.timeout == original_timeout

    def test_update_from_dict(self):
        """Test updating settings from a dictionary."""
        settings = Settings()
        config = {"timeout": 300, "processes": 4, "mem_limit": "2g", "overwrite": True}

        settings.update(config)

        assert settings.timeout == 300
        assert settings.processes == 4
        assert settings.mem_limit == "2g"
        assert settings.overwrite is True

    def test_update_from_yaml_file(self, tmp_path: Path):
        """Test updating settings from a YAML file."""
        config_file = tmp_path / "config.yaml"
        config_file.write_text(
            """
timeout: 600
processes: 2
tools:
  - mythril
  - slither
json: true
"""
        )

        settings = Settings()
        settings.update(str(config_file))

        assert settings.timeout == 600
        assert settings.processes == 2
        assert settings.tools == ["mythril", "slither"]
        assert settings.json is True

    def test_update_with_invalid_type_raises_error(self):
        """Test that update() raises error for invalid input types."""
        settings = Settings()

        with pytest.raises(sb.errors.SmartBugsError, match="cannot be updated by objects"):
            settings.update([1, 2, 3])  # type: ignore

    def test_update_replaces_hyphens_with_underscores(self):
        """Test that update() converts hyphens to underscores in keys."""
        settings = Settings()
        config = {"mem-limit": "4g", "cpu-quota": 50000, "continue-on-errors": True}

        settings.update(config)

        assert settings.mem_limit == "4g"
        assert settings.cpu_quota == 50000
        assert settings.continue_on_errors is True

    def test_update_timeout_with_none(self):
        """Test that timeout can be set to None."""
        settings = Settings()
        settings.timeout = 100

        settings.update({"timeout": None})

        assert settings.timeout is None

    def test_update_timeout_with_zero(self):
        """Test that timeout=0 is converted to None."""
        settings = Settings()
        settings.timeout = 100

        settings.update({"timeout": 0})

        assert settings.timeout is None

    def test_update_timeout_with_string_zero(self):
        """Test that timeout='0' is converted to None."""
        settings = Settings()
        settings.timeout = 100

        settings.update({"timeout": "0"})

        assert settings.timeout is None

    def test_update_positive_integer_fields(self):
        """Test updating positive integer fields (timeout, cpu_quota, processes)."""
        settings = Settings()
        config = {"timeout": "300", "cpu_quota": "50000", "processes": "4"}

        settings.update(config)

        assert settings.timeout == 300
        assert settings.cpu_quota == 50000
        assert settings.processes == 4

    def test_update_invalid_timeout_raises_error(self):
        """Test that invalid timeout values raise errors."""
        settings = Settings()

        with pytest.raises(
            sb.errors.SmartBugsError, match="'timeout' needs to be a positive integer"
        ):
            settings.update({"timeout": -100})

    def test_update_invalid_processes_raises_error(self):
        """Test that invalid processes values raise errors."""
        settings = Settings()

        with pytest.raises(
            sb.errors.SmartBugsError, match="'processes' needs to be a positive integer"
        ):
            settings.update({"processes": "invalid"})

    def test_update_tools_as_string(self):
        """Test that tools can be provided as a single string."""
        settings = Settings()

        settings.update({"tools": "mythril"})

        assert settings.tools == ["mythril"]

    def test_update_tools_as_list(self):
        """Test that tools can be provided as a list."""
        settings = Settings()

        settings.update({"tools": ["mythril", "slither", "oyente"]})

        assert settings.tools == ["mythril", "slither", "oyente"]

    def test_update_tools_with_dict_converts_to_string(self):
        """Test that tools with dict type converts the dict to a string."""
        settings = Settings()

        # The code converts dict to string via list comprehension [str(vi) for vi in v]
        # This documents the current behavior (dict gets stringified)
        settings.update({"tools": {"tool1": "value", "tool2": "value"}})

        # Dict gets converted to a string representation
        assert len(settings.tools) == 1
        assert isinstance(settings.tools[0], str)

    def test_update_files_as_string(self):
        """Test that files can be provided as a single string."""
        settings = Settings()

        settings.update({"files": "samples/*.sol"})

        assert settings.files == [(None, "samples/*.sol")]

    def test_update_files_as_list(self):
        """Test that files can be provided as a list."""
        settings = Settings()

        settings.update({"files": ["samples/*.sol", "contracts/*.sol"]})

        assert settings.files == [(None, "samples/*.sol"), (None, "contracts/*.sol")]

    def test_update_files_with_root_specification(self):
        """Test that files can include root:path specifications."""
        settings = Settings()

        settings.update({"files": ["/root/path:*.sol", "relative/*.sol"]})

        assert settings.files == [("/root/path", "*.sol"), (None, "relative/*.sol")]

    def test_update_files_with_home_variable(self, tmp_path: Path):
        """Test that files patterns can use $HOME variable."""
        settings = Settings()
        home = os.path.expanduser("~")

        settings.update({"files": "$HOME/contracts/*.sol"})

        assert settings.files == [(None, f"{home}/contracts/*.sol")]

    def test_update_files_with_invalid_colon_count_raises_error(self):
        """Test that files with too many colons raise error."""
        settings = Settings()

        with pytest.raises(sb.errors.SmartBugsError, match="contains more than one colon"):
            settings.update({"files": "a:b:c"})

    def test_update_files_with_unknown_variable_raises_error(self):
        """Test that files with unknown variables raise error."""
        settings = Settings()

        with pytest.raises(
            sb.errors.SmartBugsError, match="Unknown variable.*in file specification"
        ):
            settings.update({"files": "${UNKNOWN_VAR}/contracts/*.sol"})

    def test_update_boolean_fields(self):
        """Test updating boolean fields."""
        settings = Settings()
        config = {
            "main": True,
            "runtime": True,
            "overwrite": True,
            "quiet": True,
            "json": True,
            "sarif": True,
            "continue_on_errors": True,
        }

        settings.update(config)

        assert settings.main is True
        assert settings.runtime is True
        assert settings.overwrite is True
        assert settings.quiet is True
        assert settings.json is True
        assert settings.sarif is True
        assert settings.continue_on_errors is True

    def test_update_invalid_boolean_raises_error(self):
        """Test that invalid boolean values raise errors."""
        settings = Settings()

        with pytest.raises(sb.errors.SmartBugsError, match="'main' needs to be a Boolean"):
            settings.update({"main": "yes"})

    def test_update_path_fields(self):
        """Test updating path fields (results, log)."""
        settings = Settings()

        settings.update({"results": "output/${TOOL}/${FILENAME}", "log": "logs/run.log"})

        assert settings.results == os.path.join("output", "${TOOL}", "${FILENAME}")
        assert settings.log == "logs/run.log"

    def test_update_path_converts_slashes_to_os_sep(self):
        """Test that path fields convert slashes to os.path.sep."""
        settings = Settings()

        settings.update({"results": "output/results/${TOOL}"})

        expected = os.path.join("output", "results", "${TOOL}")
        assert settings.results == expected

    def test_update_runid_field(self):
        """Test updating runid field."""
        settings = Settings()

        settings.update({"runid": "custom_${YEAR}${MONTH}${DAY}"})

        assert settings.runid == "custom_${YEAR}${MONTH}${DAY}"

    def test_update_mem_limit_with_units(self):
        """Test updating mem_limit with various units."""
        settings = Settings()

        # Test with different units
        settings.update({"mem_limit": "2g"})
        assert settings.mem_limit == "2g"

        settings.update({"mem_limit": "512m"})
        assert settings.mem_limit == "512m"

        settings.update({"mem_limit": "1024k"})
        assert settings.mem_limit == "1024k"

    def test_update_mem_limit_removes_spaces(self):
        """Test that mem_limit removes spaces."""
        settings = Settings()

        settings.update({"mem_limit": "2 g"})

        assert settings.mem_limit == "2g"

    def test_update_mem_limit_without_unit(self):
        """Test that mem_limit accepts numbers without units."""
        settings = Settings()

        settings.update({"mem_limit": "2147483648"})

        assert settings.mem_limit == "2147483648"

    def test_update_mem_limit_invalid_value_raises_error(self):
        """Test that invalid mem_limit values raise errors."""
        settings = Settings()

        with pytest.raises(sb.errors.SmartBugsError, match="'mem_limit' needs to be a memory"):
            settings.update({"mem_limit": "invalid"})

    def test_update_mem_limit_negative_value_raises_error(self):
        """Test that negative mem_limit values raise errors."""
        settings = Settings()

        with pytest.raises(sb.errors.SmartBugsError, match="'mem_limit' needs to be a memory"):
            settings.update({"mem_limit": "-1g"})

    def test_update_mem_limit_with_none(self):
        """Test that mem_limit can be set to None."""
        settings = Settings()
        settings.mem_limit = "2g"

        settings.update({"mem_limit": None})

        assert settings.mem_limit is None

    def test_update_invalid_key_raises_error(self):
        """Test that invalid keys raise errors."""
        settings = Settings()

        with pytest.raises(sb.errors.SmartBugsError, match="Invalid key 'unknown_key'"):
            settings.update({"unknown_key": "value"})


class TestSettingsConfigurationHierarchy:
    """Test configuration hierarchy (site → user → CLI)."""

    def test_user_config_overrides_site_config(self, tmp_path: Path):
        """Test that user config overrides site config."""
        site_config = tmp_path / "site.yaml"
        site_config.write_text("timeout: 100\nprocesses: 2\n")

        user_config = tmp_path / "user.yaml"
        user_config.write_text("timeout: 300\n")

        settings = Settings()
        settings.update(str(site_config))
        assert settings.timeout == 100
        assert settings.processes == 2

        settings.update(str(user_config))
        assert settings.timeout == 300
        assert settings.processes == 2  # Not overridden

    def test_cli_overrides_user_config(self, tmp_path: Path):
        """Test that CLI arguments override user config."""
        user_config = tmp_path / "user.yaml"
        user_config.write_text("timeout: 300\nprocesses: 2\n")

        settings = Settings()
        settings.update(str(user_config))
        assert settings.timeout == 300
        assert settings.processes == 2

        # Simulate CLI overrides
        settings.update({"timeout": 600})
        assert settings.timeout == 600
        assert settings.processes == 2  # Not overridden

    def test_three_level_hierarchy(self, tmp_path: Path):
        """Test complete hierarchy: site → user → CLI."""
        site_config = tmp_path / "site.yaml"
        site_config.write_text("timeout: 100\nprocesses: 2\nmem_limit: 2g\n")

        user_config = tmp_path / "user.yaml"
        user_config.write_text("timeout: 300\nprocesses: 4\n")

        settings = Settings()

        # Load site config
        settings.update(str(site_config))
        assert settings.timeout == 100
        assert settings.processes == 2
        assert settings.mem_limit == "2g"

        # Load user config (overrides timeout and processes)
        settings.update(str(user_config))
        assert settings.timeout == 300
        assert settings.processes == 4
        assert settings.mem_limit == "2g"  # Not overridden

        # CLI override (overrides only timeout)
        settings.update({"timeout": 600})
        assert settings.timeout == 600
        assert settings.processes == 4  # From user config
        assert settings.mem_limit == "2g"  # From site config


class TestSettingsErrorHandling:
    """Test error handling for invalid inputs."""

    def test_missing_config_file_raises_error(self):
        """Test that missing config file raises SmartBugsError."""
        settings = Settings()

        with pytest.raises(sb.errors.SmartBugsError):
            settings.update("/nonexistent/config.yaml")

    def test_invalid_yaml_raises_error(self, tmp_path: Path):
        """Test that invalid YAML raises SmartBugsError."""
        config_file = tmp_path / "invalid.yaml"
        config_file.write_text("invalid: yaml: content: {{{")

        settings = Settings()

        with pytest.raises(sb.errors.SmartBugsError):
            settings.update(str(config_file))

    def test_empty_yaml_file_is_valid(self, tmp_path: Path):
        """Test that empty YAML file is handled gracefully."""
        config_file = tmp_path / "empty.yaml"
        config_file.write_text("")

        settings = Settings()
        original_timeout = settings.timeout

        # Should not raise an error
        settings.update(str(config_file))

        # Settings should remain unchanged
        assert settings.timeout == original_timeout


class TestSettingsDictAndStr:
    """Test dictionary conversion and string representation."""

    def test_dict_conversion(self):
        """Test that dict() returns all settings as dictionary."""
        settings = Settings()
        settings.timeout = 300
        settings.processes = 4
        settings.tools = ["mythril", "slither"]

        d = settings.dict()

        assert "timeout" in d
        assert "processes" in d
        assert "tools" in d
        assert d["timeout"] == 300
        assert d["processes"] == 4
        assert d["tools"] == ["mythril", "slither"]
        assert "frozen" not in d  # frozen is excluded

    def test_dict_with_template_results(self):
        """Test that dict() includes results.template when results is a Template."""
        settings = Settings()
        settings.freeze()

        d = settings.dict()

        assert "results" in d
        assert isinstance(d["results"], str)
        assert "${TOOL}" in d["results"]

    def test_str_representation(self):
        """Test string representation of settings."""
        settings = Settings()
        settings.timeout = 300
        settings.processes = 2

        s = str(settings)

        assert "timeout: 300" in s
        assert "processes: 2" in s
        assert "{" in s  # String starts with {
        assert "}" in s  # String ends with }

    def test_dict_excludes_frozen(self):
        """Test that dict() excludes the 'frozen' attribute."""
        settings = Settings()
        settings.freeze()

        d = settings.dict()

        assert "frozen" not in d


class TestSettingsEdgeCases:
    """Test edge cases and corner scenarios."""

    def test_update_with_empty_dict(self):
        """Test that update with empty dict does nothing."""
        settings = Settings()
        original_timeout = settings.timeout

        settings.update({})

        assert settings.timeout == original_timeout

    def test_tools_with_numeric_values(self):
        """Test that tools list handles numeric values correctly."""
        settings = Settings()

        settings.update({"tools": [1, 2, 3]})

        assert settings.tools == ["1", "2", "3"]

    def test_files_with_numeric_values(self):
        """Test that files list handles numeric values correctly."""
        settings = Settings()

        settings.update({"files": [123]})

        assert settings.files == [(None, "123")]

    def test_resultdir_with_no_extension(self):
        """Test resultdir() with files that have no extension."""
        settings = Settings()
        settings.results = "${FILEBASE}_${FILEEXT}"
        settings.freeze()

        result = settings.resultdir("tool", "mode", "/path/to/filename", "filename")

        assert "filename" in result

    def test_resultdir_with_dot_in_filename(self):
        """Test resultdir() with multiple dots in filename."""
        settings = Settings()
        settings.results = "${FILEBASE}.${FILEEXT}"
        settings.freeze()

        result = settings.resultdir("tool", "mode", "/path/to/my.contract.sol", "my.contract.sol")

        assert "my.contract" in result
        assert "sol" in result

    def test_cpu_quota_with_zero_becomes_none(self):
        """Test that cpu_quota=0 is converted to None."""
        settings = Settings()
        settings.cpu_quota = 50000

        settings.update({"cpu_quota": 0})

        assert settings.cpu_quota is None

    def test_multiple_updates_accumulate(self):
        """Test that multiple update calls accumulate settings."""
        settings = Settings()

        settings.update({"timeout": 100})
        settings.update({"processes": 2})
        settings.update({"mem_limit": "4g"})

        assert settings.timeout == 100
        assert settings.processes == 2
        assert settings.mem_limit == "4g"

    def test_paths_field_handles_windows_style_paths(self):
        """Test that path fields handle different path separators."""
        settings = Settings()

        # Even if input uses forward slashes, should work
        settings.update({"results": "C:/output/results"})

        # Should convert to os-appropriate separators
        assert "C:" in settings.results or "output" in settings.results


class TestSettingsIntegration:
    """Integration tests for realistic usage scenarios."""

    def test_typical_cli_usage_scenario(self, tmp_path: Path):
        """Test a typical CLI usage scenario with all features."""
        # Create a site config
        site_config = tmp_path / "site_cfg.yaml"
        site_config.write_text(
            """
timeout: 600
processes: 2
results: results/${TOOL}/${RUNID}/${FILENAME}
log: results/logs/${RUNID}.log
"""
        )

        # Create user config
        user_config = tmp_path / "user_config.yaml"
        user_config.write_text(
            """
timeout: 300
tools:
  - mythril
  - slither
files:
  - samples/*.sol
json: true
"""
        )

        # Initialize and load configs
        settings = Settings()
        settings.update(str(site_config))
        settings.update(str(user_config))

        # CLI overrides
        settings.update({"timeout": 900, "processes": 4, "mem_limit": "4g"})

        # Verify hierarchy
        assert settings.timeout == 900  # CLI override
        assert settings.processes == 4  # CLI override
        assert settings.mem_limit == "4g"  # CLI override
        assert settings.tools == ["mythril", "slither"]  # User config
        assert settings.json is True  # User config

        # Freeze and verify
        settings.freeze()
        assert settings.frozen is True
        assert isinstance(settings.results, string.Template)

        # Generate result directory
        result_dir = settings.resultdir("mythril", "solidity", "/tmp/test.sol", "test.sol")
        assert "mythril" in result_dir
        assert "test.sol" in result_dir

    def test_minimal_usage_scenario(self):
        """Test minimal usage with just defaults."""
        settings = Settings()
        settings.freeze()

        result_dir = settings.resultdir("slither", "solidity", "/path/test.sol", "test.sol")

        assert "slither" in result_dir
        assert "test.sol" in result_dir
        assert settings.runid in result_dir

    def test_mocked_site_cfg_loading(self, tmp_path: Path):
        """Test loading from site_cfg.yaml location."""
        # Create a mock site_cfg.yaml
        site_cfg = tmp_path / "site_cfg.yaml"
        site_cfg.write_text(
            """
timeout: 500
processes: 3
mem_limit: 8g
"""
        )

        # Load it
        settings = Settings()
        settings.update(str(site_cfg))

        assert settings.timeout == 500
        assert settings.processes == 3
        assert settings.mem_limit == "8g"
