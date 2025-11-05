# Tool Configuration Test Fixtures

This directory contains minimal tool configuration files for testing SmartBugs tool loading and validation.

## Fixtures

### test_tool_simple.yaml

A minimal valid tool configuration with:

- Basic required fields: name, version, origin, info, image
- Single mode support (solidity)
- Simple command template
- No compiler injection (solc: no)

**Use for:**

- Testing basic tool config loading
- Validating minimal required fields
- Testing simple command execution

### test_tool_with_modes.yaml

A comprehensive tool configuration with:

- All three analysis modes: solidity, bytecode, runtime
- Script binaries (bin directory)
- Output file specifications (global and per-mode)
- Entrypoint templates with variable substitution ($BIN, $FILENAME, $TIMEOUT, $MAIN)
- Compiler injection enabled for solidity mode (solc: yes)

**Use for:**

- Testing multi-mode tool support
- Validating mode-specific configurations
- Testing entrypoint vs command handling
- Testing output file handling
- Testing compiler injection

### test_tool_alias.yaml

A tool alias configuration that:

- Points to multiple other tools (test_tool_simple, test_tool_with_modes)
- Contains only the 'alias' field

**Use for:**

- Testing alias expansion
- Validating alias-only configs
- Testing tool groups

### test_tool_invalid.yaml

An intentionally invalid configuration with:

- Missing required 'name' field
- Invalid 'solc' value (should be yes/no or true/false)

**Use for:**

- Testing error handling
- Validating config validation
- Testing parser robustness

## Usage in Tests

```python
import yaml
from pathlib import Path

fixtures_dir = Path(__file__).parent / "fixtures" / "tool_configs"

# Load a valid config
with open(fixtures_dir / "test_tool_simple.yaml") as f:
    config = yaml.safe_load(f)

# Test alias expansion
with open(fixtures_dir / "test_tool_alias.yaml") as f:
    alias_config = yaml.safe_load(f)
    assert "alias" in alias_config

# Test error handling with invalid config
with open(fixtures_dir / "test_tool_invalid.yaml") as f:
    invalid_config = yaml.safe_load(f)
    assert "name" not in invalid_config  # Missing required field
```

## Configuration Structure

Tool configs follow this structure:

### Standard Tool Config

```yaml
name: ToolName                     # Required: tool display name
version: x.y.z                     # Required: tool version
origin: https://github.com/...     # Required: tool repository URL
info: Tool description             # Required: tool description
image: smartbugs/tool:version      # Required: Docker image
bin: scripts                       # Optional: scripts directory to mount
output: /output.json               # Optional: output file path in container

# Mode-specific configs (at least one required)
solidity:
    command: "..."                 # Command template (simple form)
    # OR
    entrypoint: "..."              # Entrypoint template (advanced form)
    solc: yes/no                   # Whether to inject Solidity compiler
    output: /output.json           # Optional: mode-specific output file

bytecode:
    entrypoint: "..."              # Entrypoint for bytecode analysis

runtime:
    entrypoint: "..."              # Entrypoint for runtime bytecode analysis
```

### Alias Config

```yaml
alias:                             # List of tool IDs to alias
    - tool1
    - tool2
    - tool3
```

## Variable Substitution

Commands and entrypoints support these variables:

- `$FILENAME` - Path to the file being analyzed
- `$TIMEOUT` - Timeout value in seconds
- `$BIN` - Path to the bin/scripts directory
- `$MAIN` - Main contract name (for multi-contract files)

## Notes

- All tool configs must be valid YAML (except test_tool_invalid.yaml)
- At least one mode (solidity/bytecode/runtime) is required for standard configs
- Alias configs contain ONLY the 'alias' field
- The 'solc' field accepts: yes, no, true, false (YAML booleans or strings)
- Image names typically follow the pattern: smartbugs/toolname:version
