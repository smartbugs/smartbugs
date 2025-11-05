# Compilation Output Fixtures

This directory contains sample Solidity compilation outputs in standard-JSON format for testing purposes. These fixtures are used to test compilation parsing, source mapping, and bytecode analysis functionality.

## Overview

All JSON files follow the [Solidity standard-JSON output format](https://docs.soliditylang.org/en/latest/using-the-compiler.html#compiler-input-and-output-json-description) and include the critical fields required by SmartBugs:

- `compiler_version`: The Solidity compiler version used
- `platform`: The platform where compilation occurred
- `compiled_at`: ISO 8601 timestamp of compilation
- `sources`: Source code content and metadata for each file
- `contracts`: Compilation results for each contract
  - `abi`: Application Binary Interface
  - `evm.bytecode.object`: Deployment bytecode
  - `evm.bytecode.sourceMap`: Source map for deployment bytecode
  - `evm.deployedBytecode.object`: Runtime bytecode
  - `evm.deployedBytecode.sourceMap`: Source map for runtime bytecode
  - `metadata`: Compiler metadata including embedded source content
- `errors`: Compilation errors (if any)
- `warnings`: Compiler warnings (if any)

## Fixtures

### 1. simple_storage_output.json

**Purpose:** Basic single-file compilation output for testing standard workflows.

**Source Contract:** `SimpleStorage.sol` - A simple storage contract with getter and setter functions.

**Characteristics:**

- Single contract, single file
- No imports or dependencies
- Clean compilation (no errors or warnings)
- Includes full bytecode, ABI, and source maps
- Uses Solidity ^0.8.0

**Use Cases:**

- Testing basic compilation parsing
- Testing bytecode extraction
- Testing ABI parsing
- Testing source map parsing
- Baseline for integration tests

### 2. with_import_output.json

**Purpose:** Multi-file compilation output for testing import resolution and multi-contract projects.

**Source Contracts:**

- `WithImport.sol` - Calculator contract that imports a library
- `Library.sol` - MathLibrary with helper functions

**Characteristics:**

- Two source files with import relationship
- Multiple contracts in output (Calculator + MathLibrary)
- Clean compilation (no errors or warnings)
- Demonstrates library usage pattern
- Source IDs for multiple files (0 and 1)
- Source maps reference both files

**Use Cases:**

- Testing multi-file compilation parsing
- Testing import resolution
- Testing source mapping across multiple files
- Testing library contract handling
- Validating cross-file bytecode address mapping

### 3. failed_compilation.json

**Purpose:** Compilation output with errors for testing error handling.

**Source Contract:** `FailedContract.sol` - Contract with intentional compilation errors.

**Characteristics:**

- Compilation fails due to errors
- Empty `contracts` object (no bytecode generated)
- Contains detailed error information:
  - Error type (e.g., "DeclarationError")
  - Error code
  - Source location (file, line, column)
  - Formatted error message
- No bytecode, ABI, or source maps

**Errors Included:**

- Undeclared identifier (undefined variable)

**Use Cases:**

- Testing error handling in compilation workflow
- Testing error message parsing
- Testing graceful failure when compilation fails
- Validating error reporting to users
- Testing dummy compiler error reproduction

### 4. warnings_output.json

**Purpose:** Successful compilation with warnings for testing warning handling.

**Source Contract:** `WarningsContract.sol` - Contract that compiles but generates warnings.

**Characteristics:**

- Compilation succeeds (bytecode generated)
- Contains compiler warnings in `warnings` array
- Full bytecode, ABI, and source maps available
- Demonstrates non-fatal compilation issues

**Warnings Included:**

- Unused function parameter
- Function state mutability can be restricted to view

**Use Cases:**

- Testing warning detection and reporting
- Testing compilation that succeeds with warnings
- Validating warning vs error distinction
- Testing quality checks on compiled code
- Demonstrating non-blocking compilation issues

## Schema Reference

### Top-Level Structure

```json
{
  "compiler_version": "string",
  "platform": "string",
  "compiled_at": "string (ISO 8601)",
  "sources": {
    "filename.sol": {
      "content": "string (source code)",
      "id": number
    }
  },
  "contracts": {
    "filename.sol:ContractName": {
      "abi": [...],
      "evm": {...},
      "metadata": "string (JSON)"
    }
  },
  "errors": [...],
  "warnings": [...]
}
```

### Error/Warning Object

```json
{
  "component": "string",
  "errorCode": "string",
  "formattedMessage": "string",
  "message": "string",
  "severity": "error" | "warning",
  "sourceLocation": {
    "end": number,
    "file": "string",
    "start": number
  },
  "type": "string"
}
```

### EVM Bytecode Object

```json
{
  "bytecode": {
    "object": "0x...",
    "sourceMap": "s:l:f:j:m;..."
  },
  "deployedBytecode": {
    "object": "0x...",
    "sourceMap": "s:l:f:j:m;..."
  }
}
```

## Source Map Format

Source maps use the format: `s:l:f:j:m` where:

- `s` = byte offset in source file
- `l` = length of source range
- `f` = source file index
- `j` = jump type (i=into, o=return, -=regular)
- `m` = modifier depth

Multiple entries are separated by semicolons. Empty fields inherit from the previous entry (compression).

## Testing Considerations

### Critical Fields for SmartBugs

When testing with these fixtures, ensure your code correctly handles:

1. **Source Content Extraction:** The `sources[*].content` field must be available for source mapping
2. **Bytecode Access:** Both deployment and runtime bytecode should be accessible
3. **Source Map Parsing:** Source maps must be parsed correctly for address mapping
4. **Multi-File Support:** `with_import_output.json` tests cross-file references
5. **Error Handling:** `failed_compilation.json` tests error scenarios
6. **Warning Detection:** `warnings_output.json` tests non-fatal issues

### Metadata.useLiteralContent

All fixtures use `metadata.useLiteralContent: true` in compiler settings, which embeds the full source code in the metadata. This is critical for source mapping functionality.

## Regenerating Fixtures

If you need to regenerate these fixtures with a different compiler version:

```bash
cd tests/fixtures/contracts

# For simple_storage_output.json
solc --standard-json < input.json > output.json

# For with_import_output.json (multi-file)
# Ensure input.json includes all source files

# Post-process to add metadata fields:
# - compiler_version
# - platform
# - compiled_at
```

See the Python scripts used to generate these fixtures in the SmartBugs test suite.

## License

These fixtures are part of the SmartBugs testing infrastructure and are provided under the same license as SmartBugs (Apache 2.0).

## Related Documentation

- **Solidity Compiler Documentation:** See [documentation](https://docs.soliditylang.org/en/latest/using-the-compiler.html)
- **Source Mappings Spec:** See [documentation](https://docs.soliditylang.org/en/latest/internals/source_mappings.html)
- **SmartBugs PRD:** See `smartbugs_prd.md` for detailed compilation JSON schema requirements
- **Contract Fixtures:** See `tests/fixtures/contracts/README.md` for source contracts
