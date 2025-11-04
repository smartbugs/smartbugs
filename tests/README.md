# SmartBugs Testing Guide

## Quick Start

```bash
# Install test dependencies
source .venv/bin/activate
bash install/setup-venv.sh --dev

# Run all tests
make test

# Run specific tests
pytest tests/unit/test_solidity.py
pytest -m unit              # Unit tests only
pytest -m integration       # Integration tests only
pytest -k "test_pragma"     # Tests matching pattern
```

## Directory Structure

```plaintext
tests/
├── unit/              # Unit tests for core modules
├── integration/       # End-to-end workflow tests
├── fixtures/          # Test data (contracts, configs, outputs)
└── conftest.py        # Shared pytest fixtures
```

## Writing Tests

Use the standard pytest structure with descriptive names:

```python
def test_pragma_extraction():
    """Test that pragma is correctly extracted from Solidity source."""
    source = ["pragma solidity ^0.8.0;", "contract Test {}"]
    pragma, contracts = get_pragma_contractnames(source)

    assert pragma == "pragma solidity ^0.8.0;"
    assert "Test" in contracts
```

### Key Fixtures (in conftest.py)

- `sample_contract` - Simple Solidity contract string
- `sample_compilation_json` - Standard-JSON compilation output
- `tmp_contract_file` - Temporary .sol file (auto-cleanup)
- `mock_docker_client` - Mocked Docker client
- `mock_settings` - SmartBugs settings with test defaults

### Mocking

Mock external dependencies to keep tests fast and isolated:

```python
def test_compilation(mocker, tmp_path):
    """Test contract compilation without running actual solc."""
    mock_run = mocker.patch('subprocess.run')
    mock_run.return_value.stdout = '{"contracts": {...}}'

    result = compile_contract(tmp_path / "test.sol")
    assert result.success
```

## Coverage

```bash
# Generate coverage report
pytest --cov=sb --cov-report=html

# View in browser
open htmlcov/index.html
```

**Targets:** 70% minimum for core modules, 80% for new modules.

## Test Markers

Use markers to categorize tests:

```python
@pytest.mark.unit
def test_something_fast():
    pass

@pytest.mark.integration
def test_full_workflow():
    pass

@pytest.mark.slow
def test_expensive_operation():
    pass
```

Run specific markers: `pytest -m unit`

## Tips

- **One assertion per test** - Keep tests focused
- **Descriptive names** - `test_pragma_extraction_handles_missing_pragma` not `test_pragma_2`
- **Mock external calls** - Docker, filesystem, network, subprocess
- **Use tmp_path** - For file operations, pytest provides `tmp_path` fixture
- **Fast tests** - Unit tests should be <1s each

## Troubleshooting

**Import errors?** Ensure venv is activated: `source .venv/bin/activate`

**Tests not discovered?** Check file/function names start with `test_`

**Coverage too low?** Run `pytest --cov=sb --cov-report=term-missing` to see uncovered lines

**Docker issues?** Integration tests need Docker daemon running
