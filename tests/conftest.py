"""Shared pytest fixtures for SmartBugs testing.

This module provides commonly used fixtures that are automatically
available to all tests in the test suite.
"""

from collections.abc import Generator
from pathlib import Path
from typing import Any
from unittest.mock import MagicMock

import pytest

from sb.settings import Settings
from sb.tools import Tool


@pytest.fixture
def sample_contract() -> str:
    """Simple Solidity contract for testing.

    Returns:
        A string containing a basic Solidity contract with pragma,
        state variable, and setter function.
    """
    return """// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value;
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}
"""


@pytest.fixture
def sample_contract_with_imports() -> str:
    """Solidity contract with import statements.

    Returns:
        A string containing a Solidity contract that imports
        another contract using a relative path.
    """
    return """// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Library.sol";

contract WithImport {
    using Library for uint256;

    uint256 public counter;

    function increment() public {
        counter = counter.add(1);
    }
}
"""


@pytest.fixture
def sample_library_contract() -> str:
    """Solidity library for import testing.

    Returns:
        A string containing a simple Solidity library that can be
        imported by other contracts.
    """
    return """// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Library {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
}
"""


@pytest.fixture
def sample_compilation_json() -> dict[str, Any]:
    """Valid standard-JSON compilation output.

    Returns:
        A dictionary representing a valid Solidity standard-JSON
        compilation output with contracts, sources, bytecode, ABI,
        and source maps.
    """
    return {
        "contracts": {
            "SimpleStorage.sol": {
                "SimpleStorage": {
                    "abi": [
                        {
                            "inputs": [],
                            "name": "getValue",
                            "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
                            "stateMutability": "view",
                            "type": "function",
                        },
                        {
                            "inputs": [
                                {"internalType": "uint256", "name": "_value", "type": "uint256"}
                            ],
                            "name": "setValue",
                            "outputs": [],
                            "stateMutability": "nonpayable",
                            "type": "function",
                        },
                        {
                            "inputs": [],
                            "name": "value",
                            "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
                            "stateMutability": "view",
                            "type": "function",
                        },
                    ],
                    "evm": {
                        "bytecode": {
                            "linkReferences": {},
                            "object": "608060405234801561001057600080fd5b5060f78061001f6000396000f3fe",
                            "opcodes": "PUSH1 0x80 PUSH1 0x40 MSTORE CALLVALUE DUP1 ISZERO",
                            "sourceMap": "57:187:0:-:0;;;;;;;;;;;;;;;;;;;",
                        },
                        "deployedBytecode": {
                            "immutableReferences": {},
                            "linkReferences": {},
                            "object": "6080604052348015600f57600080fd5b506004361060325760003560e01c8063",
                            "opcodes": "PUSH1 0x80 PUSH1 0x40 MSTORE CALLVALUE DUP1 ISZERO",
                            "sourceMap": "57:187:0:-:0;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;",
                        },
                    },
                }
            }
        },
        "sources": {
            "SimpleStorage.sol": {
                "id": 0,
                "ast": {
                    "absolutePath": "SimpleStorage.sol",
                    "exportedSymbols": {"SimpleStorage": [15]},
                    "id": 16,
                    "nodeType": "SourceUnit",
                    "nodes": [],
                    "src": "32:212:0",
                },
            }
        },
    }


@pytest.fixture
def tmp_contract_file(tmp_path: Path) -> Generator[Path, None, None]:
    """Creates a temporary .sol file with simple contract.

    Args:
        tmp_path: Pytest's built-in temporary directory fixture

    Yields:
        Path to the temporary .sol file

    Note:
        The temporary file is automatically cleaned up after the test
        completes via pytest's tmp_path fixture.
    """
    contract_file = tmp_path / "Test.sol"
    contract_file.write_text(
        """// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Test {
    uint256 public x;
}
"""
    )
    yield contract_file
    # Cleanup handled automatically by tmp_path fixture


@pytest.fixture
def mock_docker_client(mocker) -> MagicMock:
    """Mocked Docker client for testing without Docker daemon.

    Args:
        mocker: pytest-mock fixture for creating mocks

    Returns:
        A MagicMock object that replaces the Docker client

    Example:
        def test_docker_execution(mock_docker_client):
            # Docker operations will use the mock instead of real Docker
            container = mock_docker_client.containers.run(...)
            assert container.wait.called
    """
    mock_client = mocker.MagicMock()
    mocker.patch("docker.from_env", return_value=mock_client)
    return mock_client


@pytest.fixture
def mock_settings() -> Settings:
    """SmartBugs settings object with test defaults.

    Returns:
        A Settings instance configured with sensible defaults for testing.
        Settings are not frozen, allowing tests to modify them as needed.

    Example:
        def test_with_settings(mock_settings):
            mock_settings.timeout = 60
            mock_settings.processes = 2
            assert mock_settings.timeout == 60
    """
    settings = Settings()
    # Override defaults with test-friendly values
    settings.files = []
    settings.tools = []
    settings.runid = "test_run"
    settings.overwrite = True
    settings.processes = 1
    settings.timeout = 60
    settings.cpu_quota = None
    settings.mem_limit = None
    settings.continue_on_errors = False
    settings.results = "results/${TOOL}/${RUNID}/${FILENAME}"
    settings.log = "results/logs/${RUNID}.log"
    settings.json = False
    settings.sarif = False
    settings.quiet = True  # Reduce noise in tests
    settings.main = False
    settings.runtime = False
    return settings


@pytest.fixture
def mock_tool() -> Tool:
    """Mock Tool configuration for testing.

    Returns:
        A Tool instance configured with minimal valid settings
        for testing tool-related functionality.

    Example:
        def test_tool_command(mock_tool):
            cmd = mock_tool.command("test.sol", 60, "/bin/solc", "")
            assert "test.sol" in cmd
    """
    tool_config = {
        "id": "test_tool",
        "mode": "solidity",
        "image": "smartbugs/test_tool:latest",
        "name": "Test Tool",
        "origin": "https://example.com/test_tool",
        "version": "1.0.0",
        "info": "A test tool for unit testing",
        "parser": "parser.py",
        "output": None,
        "bin": None,
        "solc": False,
        "cpu_quota": None,
        "mem_limit": None,
        "command": "$FILENAME",
        "entrypoint": None,
    }
    return Tool(tool_config)


@pytest.fixture
def sample_bytecode() -> str:
    """Sample Ethereum bytecode for testing.

    Returns:
        A string containing valid EVM bytecode in hexadecimal format.
    """
    return (
        "608060405234801561001057600080fd5b5060f78061001f6000396000f3fe"
        "6080604052348015600f57600080fd5b506004361060325760003560e01c8063"
    )


@pytest.fixture
def sample_source_map() -> str:
    """Sample Solidity source map for testing.

    Returns:
        A string containing a valid Solidity source map in the
        compressed format (s:l:f:j:m entries separated by semicolons).
    """
    return "57:187:0:-:0;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1:2:0:i:1;:9:::-;2:1:1"


@pytest.fixture
def sample_findings() -> list[dict[str, Any]]:
    """Sample findings list for parser testing.

    Returns:
        A list of finding dictionaries with standard fields used
        in SmartBugs parser output.
    """
    return [
        {
            "name": "reentrancy",
            "message": "Potential reentrancy vulnerability detected",
            "line": 42,
            "line_end": 45,
            "filename": "test.sol",
            "impact": "high",
            "confidence": "medium",
            "function": "withdraw",
            "contract": "Vulnerable",
        },
        {
            "name": "integer-overflow",
            "message": "Integer overflow possible",
            "line": 67,
            "filename": "test.sol",
            "impact": "medium",
            "confidence": "high",
        },
    ]


@pytest.fixture
def tmp_results_dir(tmp_path: Path) -> Path:
    """Creates a temporary results directory structure.

    Args:
        tmp_path: Pytest's built-in temporary directory fixture

    Returns:
        Path to the temporary results directory

    Note:
        The directory is automatically cleaned up after the test
        completes via pytest's tmp_path fixture.
    """
    results_dir = tmp_path / "results"
    results_dir.mkdir(parents=True, exist_ok=True)
    return results_dir


@pytest.fixture(scope="session")
def fixtures_dir() -> Path:
    """Path to the tests/fixtures directory.

    Returns:
        Path object pointing to the fixtures directory.
        This fixture has session scope as the path doesn't change.

    Example:
        def test_load_fixture(fixtures_dir):
            contract = (fixtures_dir / "contracts" / "SimpleStorage.sol").read_text()
            assert "pragma solidity" in contract
    """
    return Path(__file__).parent / "fixtures"
