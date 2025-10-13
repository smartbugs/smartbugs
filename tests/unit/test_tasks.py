"""Unit tests for sb/tasks.py module.

This module tests the Task class, which represents a single analysis task
pairing a file with a tool configuration.
"""

from sb.settings import Settings
from sb.tasks import Task
from sb.tools import Tool


class TestTaskCreation:
    """Test Task object creation and initialization."""

    def test_task_creation_with_all_attributes(self, mock_tool, mock_settings):
        """Test creating a Task with all attributes specified."""
        task = Task(
            absfn="/home/user/project/test.sol",
            relfn="test.sol",
            rdir="/home/user/results/mythril/test_run/test.sol",
            solc_version="0.8.0",
            solc_path="/usr/bin/solc",
            tool=mock_tool,
            settings=mock_settings,
        )

        assert task.absfn == "/home/user/project/test.sol"
        assert task.relfn == "test.sol"
        assert task.rdir == "/home/user/results/mythril/test_run/test.sol"
        assert task.solc_version == "0.8.0"
        assert task.solc_path == "/usr/bin/solc"
        assert task.tool == mock_tool
        assert task.settings == mock_settings

    def test_task_creation_with_none_solc(self, mock_tool, mock_settings):
        """Test creating a Task with None solc_version and solc_path."""
        task = Task(
            absfn="/home/user/project/bytecode.hex",
            relfn="bytecode.hex",
            rdir="/home/user/results/mythril/test_run/bytecode.hex",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        assert task.absfn == "/home/user/project/bytecode.hex"
        assert task.relfn == "bytecode.hex"
        assert task.solc_version is None
        assert task.solc_path is None

    def test_task_creation_minimal(self, mock_tool, mock_settings):
        """Test creating a Task with minimal required attributes."""
        task = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        assert task.absfn == "/test.sol"
        assert task.relfn == "test.sol"
        assert task.rdir == "/results/test.sol"
        assert task.tool is not None
        assert task.settings is not None


class TestTaskAttributeAccess:
    """Test Task attribute access and modification."""

    def test_attribute_access(self, mock_tool, mock_settings):
        """Test accessing Task attributes."""
        task = Task(
            absfn="/home/user/contracts/SimpleDAO.sol",
            relfn="contracts/SimpleDAO.sol",
            rdir="/home/user/results/slither/run_001/SimpleDAO.sol",
            solc_version="0.7.6",
            solc_path="/usr/local/bin/solc-0.7.6",
            tool=mock_tool,
            settings=mock_settings,
        )

        # Test file paths
        assert task.absfn == "/home/user/contracts/SimpleDAO.sol"
        assert task.relfn == "contracts/SimpleDAO.sol"
        assert task.rdir == "/home/user/results/slither/run_001/SimpleDAO.sol"

        # Test solc attributes
        assert task.solc_version == "0.7.6"
        assert task.solc_path == "/usr/local/bin/solc-0.7.6"

        # Test objects
        assert isinstance(task.tool, Tool)
        assert isinstance(task.settings, Settings)

    def test_attribute_modification(self, mock_tool, mock_settings):
        """Test modifying Task attributes after creation."""
        task = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version="0.8.0",
            solc_path="/bin/solc",
            tool=mock_tool,
            settings=mock_settings,
        )

        # Modify attributes
        task.absfn = "/new/path/test.sol"
        task.solc_version = "0.8.1"

        assert task.absfn == "/new/path/test.sol"
        assert task.solc_version == "0.8.1"

    def test_tool_attribute_access(self, mock_tool, mock_settings):
        """Test accessing nested tool attributes through Task."""
        task = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        assert task.tool.id == "test_tool"
        assert task.tool.mode == "solidity"
        assert task.tool.image == "smartbugs/test_tool:latest"

    def test_settings_attribute_access(self, mock_tool, mock_settings):
        """Test accessing nested settings attributes through Task."""
        task = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        assert task.settings.timeout == 60
        assert task.settings.processes == 1
        assert task.settings.quiet is True


class TestTaskStringRepresentation:
    """Test Task string representation."""

    def test_str_representation_with_solc(self, mock_tool, mock_settings):
        """Test __str__ method with solc information."""
        task = Task(
            absfn="/home/user/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version="0.8.0",
            solc_path="/bin/solc",
            tool=mock_tool,
            settings=mock_settings,
        )

        str_repr = str(task)

        # Check that all key attributes are in the string representation
        assert "absfn: /home/user/test.sol" in str_repr
        assert "relfn: test.sol" in str_repr
        assert "rdir: /results/test.sol" in str_repr
        assert "solc_version: 0.8.0" in str_repr
        assert "solc_path: /bin/solc" in str_repr
        assert "tool:" in str_repr
        assert "settings:" in str_repr

    def test_str_representation_without_solc(self, mock_tool, mock_settings):
        """Test __str__ method without solc information."""
        task = Task(
            absfn="/home/user/bytecode.hex",
            relfn="bytecode.hex",
            rdir="/results/bytecode.hex",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        str_repr = str(task)

        assert "absfn: /home/user/bytecode.hex" in str_repr
        assert "solc_version: None" in str_repr
        assert "solc_path: None" in str_repr

    def test_str_representation_format(self, mock_tool, mock_settings):
        """Test that __str__ returns properly formatted string."""
        task = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        str_repr = str(task)

        # Should be enclosed in curly braces
        assert str_repr.startswith("{")
        assert str_repr.endswith("}")
        # Should contain comma-separated key-value pairs
        assert ", " in str_repr
        assert ": " in str_repr


class TestTaskEquality:
    """Test Task equality and comparison."""

    def test_task_identity(self, mock_tool, mock_settings):
        """Test that a task is equal to itself."""
        task = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version="0.8.0",
            solc_path="/bin/solc",
            tool=mock_tool,
            settings=mock_settings,
        )

        # Same object reference
        assert task is task

    def test_task_different_instances_same_values(self, mock_tool, mock_settings):
        """Test that two tasks with same values are different objects."""
        task1 = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version="0.8.0",
            solc_path="/bin/solc",
            tool=mock_tool,
            settings=mock_settings,
        )
        task2 = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version="0.8.0",
            solc_path="/bin/solc",
            tool=mock_tool,
            settings=mock_settings,
        )

        # Different objects
        assert task1 is not task2
        # But have same attribute values
        assert task1.absfn == task2.absfn
        assert task1.relfn == task2.relfn
        assert task1.solc_version == task2.solc_version

    def test_task_different_files(self, mock_tool, mock_settings):
        """Test tasks with different files are distinguishable."""
        task1 = Task(
            absfn="/test1.sol",
            relfn="test1.sol",
            rdir="/results/test1.sol",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )
        task2 = Task(
            absfn="/test2.sol",
            relfn="test2.sol",
            rdir="/results/test2.sol",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        assert task1.absfn != task2.absfn
        assert task1.relfn != task2.relfn


class TestTaskResultDirectory:
    """Test Task result directory path generation."""

    def test_result_directory_path(self, mock_tool, mock_settings):
        """Test that result directory path is correctly set."""
        rdir = "/home/user/results/mythril/20250101_1030/test.sol"
        task = Task(
            absfn="/home/user/contracts/test.sol",
            relfn="contracts/test.sol",
            rdir=rdir,
            solc_version="0.8.0",
            solc_path="/bin/solc",
            tool=mock_tool,
            settings=mock_settings,
        )

        assert task.rdir == rdir

    def test_result_directory_with_nested_path(self, mock_tool, mock_settings):
        """Test result directory with nested file path."""
        task = Task(
            absfn="/home/user/project/contracts/token/ERC20.sol",
            relfn="contracts/token/ERC20.sol",
            rdir="/results/slither/run_001/ERC20.sol",
            solc_version="0.8.19",
            solc_path="/bin/solc-0.8.19",
            tool=mock_tool,
            settings=mock_settings,
        )

        assert task.rdir == "/results/slither/run_001/ERC20.sol"
        assert task.relfn == "contracts/token/ERC20.sol"

    def test_result_directory_modification(self, mock_tool, mock_settings):
        """Test modifying result directory after Task creation."""
        task = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/old/results/test.sol",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        new_rdir = "/new/results/test.sol"
        task.rdir = new_rdir

        assert task.rdir == new_rdir


class TestTaskWithDifferentTools:
    """Test Task creation with different tool configurations."""

    def test_task_with_solidity_tool(self, mock_settings):
        """Test Task with a Solidity analysis tool."""
        tool_config = {
            "id": "mythril",
            "mode": "solidity",
            "image": "smartbugs/mythril:latest",
            "name": "Mythril",
            "origin": "https://github.com/ConsenSys/mythril",
            "version": "0.24.0",
            "info": "Security analysis tool for Ethereum smart contracts",
            "parser": "parser.py",
            "output": None,
            "bin": None,
            "solc": True,
            "cpu_quota": None,
            "mem_limit": "4g",
            "command": "myth analyze $FILENAME --timeout $TIMEOUT",
            "entrypoint": None,
        }
        tool = Tool(tool_config)

        task = Task(
            absfn="/contracts/Vulnerable.sol",
            relfn="Vulnerable.sol",
            rdir="/results/mythril/Vulnerable.sol",
            solc_version="0.8.0",
            solc_path="/bin/solc",
            tool=tool,
            settings=mock_settings,
        )

        assert task.tool.id == "mythril"
        assert task.tool.solc is True
        assert task.tool.mem_limit == "4g"
        assert task.solc_version == "0.8.0"

    def test_task_with_bytecode_tool(self, mock_settings):
        """Test Task with a bytecode analysis tool."""
        tool_config = {
            "id": "oyente",
            "mode": "bytecode",
            "image": "smartbugs/oyente:latest",
            "name": "Oyente",
            "origin": "https://github.com/enzymefinance/oyente",
            "version": "1.0",
            "info": "Bytecode analyzer",
            "parser": "parser.py",
            "output": None,
            "bin": None,
            "solc": False,
            "cpu_quota": None,
            "mem_limit": None,
            "command": "$FILENAME",
            "entrypoint": None,
        }
        tool = Tool(tool_config)

        task = Task(
            absfn="/bytecode/contract.hex",
            relfn="contract.hex",
            rdir="/results/oyente/contract.hex",
            solc_version=None,
            solc_path=None,
            tool=tool,
            settings=mock_settings,
        )

        assert task.tool.id == "oyente"
        assert task.tool.mode == "bytecode"
        assert task.tool.solc is False
        assert task.solc_version is None
        assert task.solc_path is None


class TestTaskWithDifferentSettings:
    """Test Task with various settings configurations."""

    def test_task_with_timeout_settings(self, mock_tool):
        """Test Task with timeout configured in settings."""
        settings = Settings()
        settings.timeout = 300
        settings.processes = 4
        settings.mem_limit = "8g"

        task = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=settings,
        )

        assert task.settings.timeout == 300
        assert task.settings.processes == 4
        assert task.settings.mem_limit == "8g"

    def test_task_with_output_format_settings(self, mock_tool):
        """Test Task with JSON and SARIF output enabled."""
        settings = Settings()
        settings.json = True
        settings.sarif = True
        settings.quiet = False

        task = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=settings,
        )

        assert task.settings.json is True
        assert task.settings.sarif is True
        assert task.settings.quiet is False

    def test_task_with_overwrite_settings(self, mock_tool):
        """Test Task with overwrite and continue_on_errors flags."""
        settings = Settings()
        settings.overwrite = True
        settings.continue_on_errors = True

        task = Task(
            absfn="/test.sol",
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=settings,
        )

        assert task.settings.overwrite is True
        assert task.settings.continue_on_errors is True


class TestTaskEdgeCases:
    """Test Task with edge cases and special scenarios."""

    def test_task_with_empty_strings(self, mock_tool, mock_settings):
        """Test Task with empty string values (edge case)."""
        task = Task(
            absfn="",
            relfn="",
            rdir="",
            solc_version="",
            solc_path="",
            tool=mock_tool,
            settings=mock_settings,
        )

        assert task.absfn == ""
        assert task.relfn == ""
        assert task.rdir == ""
        assert task.solc_version == ""
        assert task.solc_path == ""

    def test_task_with_unicode_paths(self, mock_tool, mock_settings):
        """Test Task with Unicode characters in file paths."""
        task = Task(
            absfn="/home/用户/合约/测试.sol",
            relfn="合约/测试.sol",
            rdir="/results/测试.sol",
            solc_version="0.8.0",
            solc_path="/bin/solc",
            tool=mock_tool,
            settings=mock_settings,
        )

        assert task.absfn == "/home/用户/合约/测试.sol"
        assert task.relfn == "合约/测试.sol"
        assert task.rdir == "/results/测试.sol"

    def test_task_with_special_characters_in_paths(self, mock_tool, mock_settings):
        """Test Task with special characters in paths."""
        task = Task(
            absfn="/home/user/contracts (v2)/test-contract_2024.sol",
            relfn="contracts (v2)/test-contract_2024.sol",
            rdir="/results/test-contract_2024.sol",
            solc_version="0.8.20",
            solc_path="/usr/local/bin/solc-v0.8.20+commit.a1b2c3d4",
            tool=mock_tool,
            settings=mock_settings,
        )

        assert "(v2)" in task.absfn
        assert "test-contract_2024" in task.relfn
        assert "+commit" in task.solc_path

    def test_task_with_windows_style_paths(self, mock_tool, mock_settings):
        """Test Task with Windows-style paths."""
        task = Task(
            absfn=r"C:\Users\user\contracts\test.sol",
            relfn=r"contracts\test.sol",
            rdir=r"C:\results\mythril\test.sol",
            solc_version="0.8.0",
            solc_path=r"C:\Program Files\solc\solc.exe",
            tool=mock_tool,
            settings=mock_settings,
        )

        assert task.absfn == r"C:\Users\user\contracts\test.sol"
        assert task.solc_path == r"C:\Program Files\solc\solc.exe"

    def test_task_with_very_long_paths(self, mock_tool, mock_settings):
        """Test Task with very long file paths."""
        long_path = "/home/user/" + "very_long_directory_name/" * 20 + "test.sol"
        task = Task(
            absfn=long_path,
            relfn="test.sol",
            rdir="/results/test.sol",
            solc_version=None,
            solc_path=None,
            tool=mock_tool,
            settings=mock_settings,
        )

        assert len(task.absfn) > 200
        assert task.absfn == long_path


class TestTaskWithRealWorldScenarios:
    """Test Task with real-world usage scenarios."""

    def test_task_for_simple_contract_analysis(self, mock_settings):
        """Test Task setup for analyzing a simple contract."""
        tool_config = {
            "id": "slither",
            "mode": "solidity",
            "image": "smartbugs/slither:latest",
            "name": "Slither",
            "origin": "https://github.com/crytic/slither",
            "version": "0.9.3",
            "info": "Static analysis framework",
            "parser": "parser.py",
            "output": None,
            "bin": None,
            "solc": True,
            "cpu_quota": None,
            "mem_limit": None,
            "command": "slither $FILENAME",
            "entrypoint": None,
        }
        tool = Tool(tool_config)

        task = Task(
            absfn="/home/user/project/contracts/SimpleStorage.sol",
            relfn="contracts/SimpleStorage.sol",
            rdir="/home/user/results/slither/20250113_1234/SimpleStorage.sol",
            solc_version="0.8.19",
            solc_path="/home/user/.solcx/solc-v0.8.19",
            tool=tool,
            settings=mock_settings,
        )

        # Verify task is properly configured
        assert task.tool.id == "slither"
        assert task.tool.solc is True
        assert task.solc_version is not None
        assert "SimpleStorage.sol" in task.absfn
        assert "SimpleStorage.sol" in task.relfn
        assert "slither" in task.rdir

    def test_task_for_bytecode_analysis(self, mock_settings):
        """Test Task setup for analyzing bytecode."""
        tool_config = {
            "id": "mythril",
            "mode": "bytecode",
            "image": "smartbugs/mythril:latest",
            "name": "Mythril",
            "origin": "https://github.com/ConsenSys/mythril",
            "version": "0.24.0",
            "info": "Security analysis tool",
            "parser": "parser.py",
            "output": None,
            "bin": None,
            "solc": False,
            "cpu_quota": None,
            "mem_limit": "4g",
            "command": "myth analyze --bin-runtime $FILENAME",
            "entrypoint": None,
        }
        tool = Tool(tool_config)

        task = Task(
            absfn="/home/user/bytecodes/contract.hex",
            relfn="contract.hex",
            rdir="/home/user/results/mythril/20250113_1234/contract.hex",
            solc_version=None,
            solc_path=None,
            tool=tool,
            settings=mock_settings,
        )

        # Verify bytecode analysis task
        assert task.tool.mode == "bytecode"
        assert task.tool.solc is False
        assert task.solc_version is None
        assert task.solc_path is None
        assert task.absfn.endswith(".hex")

    def test_task_for_multi_contract_project(self, mock_settings):
        """Test Task for analyzing one file in a multi-contract project."""
        tool_config = {
            "id": "mythril",
            "mode": "solidity",
            "image": "smartbugs/mythril:latest",
            "name": "Mythril",
            "origin": "https://github.com/ConsenSys/mythril",
            "version": "0.24.0",
            "info": "Security analysis tool",
            "parser": "parser.py",
            "output": None,
            "bin": None,
            "solc": True,
            "cpu_quota": None,
            "mem_limit": None,
            "command": "myth analyze $FILENAME",
            "entrypoint": None,
        }
        tool = Tool(tool_config)

        task = Task(
            absfn="/home/user/defi-project/contracts/core/Vault.sol",
            relfn="contracts/core/Vault.sol",
            rdir="/home/user/results/mythril/20250113_1234/Vault.sol",
            solc_version="0.8.20",
            solc_path="/home/user/.solcx/solc-v0.8.20",
            tool=tool,
            settings=mock_settings,
        )

        # Verify nested project structure is preserved
        assert "contracts/core/Vault.sol" in task.relfn
        assert task.absfn.endswith("Vault.sol")
        assert task.solc_version == "0.8.20"


class TestTaskDocumentation:
    """Test that Task has proper documentation."""

    def test_task_class_has_docstring(self):
        """Test that Task class has a docstring."""
        assert Task.__doc__ is not None
        assert len(Task.__doc__.strip()) > 0

    def test_task_init_has_docstring_or_annotations(self):
        """Test that Task.__init__ has type annotations."""
        # Check for type annotations
        annotations = Task.__init__.__annotations__
        assert annotations is not None
        assert "absfn" in annotations
        assert "tool" in annotations
        assert "settings" in annotations
