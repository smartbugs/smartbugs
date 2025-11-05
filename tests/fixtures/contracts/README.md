# Test Contract Fixtures

This directory contains sample Solidity contracts used for testing SmartBugs functionality. Each contract is designed to test specific aspects of the analysis framework.

## Contract Files

### SimpleStorage.sol

**Purpose:** Basic contract with state variable for fundamental testing
**Pragma:** `^0.8.0`
**Features:**

- Single state variable (`storedData`)
- Simple getter and setter methods
- Event emission
- Constructor initialization

**Use Cases:**

- Testing basic file parsing
- Verifying tool execution on simple contracts
- Validating pragma extraction
- Testing standard contract structure handling

### Library.sol

**Purpose:** Library contract for import testing
**Pragma:** `^0.8.0`
**Features:**

- Pure mathematical functions
- Internal library functions
- Basic arithmetic operations (add, multiply)
- Boolean logic (isEven)

**Use Cases:**

- Testing library detection
- Validating import resolution (used by WithImport.sol)
- Testing multi-file analysis scenarios

### WithImport.sol

**Purpose:** Contract with relative import for dependency testing
**Pragma:** `^0.8.0`
**Features:**

- Imports Library.sol using relative path (`./Library.sol`)
- Uses library functions via `MathLibrary`
- State variable to store results
- Event emission

**Use Cases:**

- Testing relative import resolution
- Validating multi-file compilation
- Testing dependency graph construction
- Verifying library usage detection

### MultiContract.sol

**Purpose:** File with multiple contract definitions
**Pragma:** `^0.8.0`
**Contracts:**

- `Base` - Parent contract with basic functionality
- `Derived` - Child contract inheriting from Base
- `Standalone` - Independent contract

**Use Cases:**

- Testing --main flag functionality (contract selection)
- Validating handling of multiple contracts in one file
- Testing inheritance detection
- Verifying contract disambiguation

### OldPragma.sol

**Purpose:** Contract with old pragma (0.4.x) for backward compatibility testing
**Pragma:** `^0.4.25`
**Features:**

- Legacy constructor syntax (function name matches contract name)
- Old-style event emission (without `emit` keyword)
- ERC20-like token implementation
- No SafeMath (manual overflow checks)

**Use Cases:**

- Testing Solidity 0.4.x support
- Validating pragma version parsing for old versions
- Testing compiler version selection (solcx integration)
- Verifying backward compatibility of analysis tools

### NewPragma.sol

**Purpose:** Contract with recent pragma (0.8.x) for modern Solidity features
**Pragma:** `^0.8.20`
**Features:**

- Modern constructor syntax
- Custom error types (`InsufficientBalance`, `InsufficientAllowance`)
- Built-in overflow protection
- `emit` keyword for events
- ERC20-like token implementation with allowances

**Use Cases:**

- Testing modern Solidity version support
- Validating custom error detection
- Testing latest compiler features
- Verifying analysis of current Solidity standards

### NoPragma.sol

**Purpose:** Edge case contract without pragma statement
**Pragma:** None
**Features:**

- Missing pragma directive
- Standard contract structure
- Modifier usage
- Multiple functions with different visibility

**Use Cases:**

- Testing edge case handling (missing pragma)
- Validating default compiler selection
- Testing error handling for files without version specification
- Verifying fallback behavior

## Testing Scenarios

### Pragma Parsing Tests

- **OldPragma.sol** - Tests `^0.4.25` parsing and version selection
- **NewPragma.sol** - Tests `^0.8.20` parsing and version selection
- **SimpleStorage.sol** - Tests `^0.8.0` parsing (common case)
- **NoPragma.sol** - Tests missing pragma handling (edge case)

### Import Resolution Tests

- **WithImport.sol** + **Library.sol** - Tests relative import resolution
- Validates multi-file analysis
- Tests dependency graph construction

### Multi-Contract Tests

- **MultiContract.sol** - Tests handling of multiple contracts per file
- Validates contract selection with --main flag
- Tests inheritance detection

### Compiler Version Tests

All contracts test different aspects of compiler version handling:

- Automatic version detection from pragma
- Compiler download via solcx
- Version compatibility with analysis tools

## File Relationships

```plaintext
WithImport.sol
    └── imports Library.sol

MultiContract.sol
    ├── Base (parent contract)
    ├── Derived (child of Base)
    └── Standalone (independent)
```

## Compilation Notes

1. **SimpleStorage.sol**, **Library.sol**, **WithImport.sol**, **MultiContract.sol**, **NewPragma.sol**
   - Require Solidity 0.8.x compiler
   - Compatible with modern analysis tools

2. **OldPragma.sol**
   - Requires Solidity 0.4.25 compiler
   - Tests backward compatibility

3. **NoPragma.sol**
   - Will use framework's default compiler version
   - May fail compilation without explicit version specification

## Usage in Tests

These fixtures are used across multiple test modules:

- **test_solidity.py** - Tests pragma parsing and compiler selection
- **test_tasks.py** - Tests task creation with different contract types
- **test_file_collection.py** - Tests contract file discovery
- **test_smartbugs.py** - Integration tests using real contracts

## Maintenance

When adding new fixtures:

1. Ensure contract is valid and compilable
2. Add clear purpose and features in this README
3. Include SPDX license identifier
4. Add descriptive comments in the contract
5. Document expected behavior in tests
