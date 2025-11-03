#!/bin/bash

# Enhanced setup script for SmartBugs virtual environment
# Supports Python >= 3.9, Poetry, and development dependencies

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
DEV_MODE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --dev)
            DEV_MODE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--dev]"
            echo "  --dev    Install development dependencies (pytest, coverage, etc.)"
            echo "  -h, --help    Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}=== SmartBugs Virtual Environment Setup ===${NC}\n"

# Check Python version
echo -e "${BLUE}Checking Python version...${NC}"
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
PYTHON_MAJOR=$(python3 -c 'import sys; print(sys.version_info.major)')
PYTHON_MINOR=$(python3 -c 'import sys; print(sys.version_info.minor)')

echo -e "Found Python ${GREEN}${PYTHON_VERSION}${NC}"

if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 9 ]); then
    echo -e "${RED}Error: Python 3.9 or higher is required${NC}"
    echo -e "Current version: Python ${PYTHON_VERSION}"
    echo -e "Please upgrade Python and try again"
    exit 1
fi

# Create virtual environment
echo -e "\n${BLUE}Creating virtual environment...${NC}"
python3 -m venv venv
source venv/bin/activate

# Upgrade pip and install wheel
echo -e "\n${BLUE}Upgrading pip and installing wheel...${NC}"
pip install --upgrade pip --quiet
pip install wheel --quiet
echo -e "${GREEN}✓${NC} pip and wheel upgraded"

# Determine installation method
REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)
USE_POETRY=false
PYPROJECT_FILE="${REPO_ROOT}/pyproject.toml"

if [ -f "$PYPROJECT_FILE" ]; then
    echo -e "\n${BLUE}Detected pyproject.toml${NC}"

    # Check if Poetry is available
    if command -v poetry &> /dev/null; then
        USE_POETRY=true
        echo -e "${GREEN}✓${NC} Poetry is installed"
        echo -e "${BLUE}Using Poetry for dependency management${NC}"
    else
        echo -e "${YELLOW}! Poetry not found${NC}"
        echo -e "${BLUE}Falling back to pip installation${NC}"
    fi
fi

# Install dependencies
if [ "$USE_POETRY" = true ]; then
    # Install with Poetry
    echo -e "\n${BLUE}Installing dependencies with Poetry...${NC}"
    cd "$REPO_ROOT"

    if [ "$DEV_MODE" = true ]; then
        echo -e "${BLUE}Installing with development dependencies${NC}"
        poetry install --with dev
    else
        echo -e "${BLUE}Installing production dependencies only${NC}"
        poetry install --only main
    fi

    echo -e "${GREEN}✓${NC} Dependencies installed via Poetry"
else
    # Install with pip
    echo -e "\n${BLUE}Installing dependencies with pip...${NC}"

    # Determine requirements file based on Python version
    REQ_FILE="${REPO_ROOT}/install/requirements-${PYTHON_MAJOR}.${PYTHON_MINOR}.txt"

    if [ ! -f "$REQ_FILE" ]; then
        # Fallback to direct package installation if requirements file doesn't exist
        echo -e "${YELLOW}! Requirements file not found: $REQ_FILE${NC}"
        echo -e "${BLUE}Installing packages directly${NC}"
        pip install pyyaml colorama requests semantic_version docker py-cpuinfo --quiet
    else
        echo -e "${BLUE}Using requirements file: $(basename $REQ_FILE)${NC}"
        pip install -r "$REQ_FILE" --quiet
    fi

    echo -e "${GREEN}✓${NC} Core dependencies installed"

    # Install development dependencies if requested
    if [ "$DEV_MODE" = true ]; then
        echo -e "\n${BLUE}Installing development dependencies...${NC}"
        pip install pytest>=7.4.0 pytest-cov>=4.1.0 pytest-mock>=3.11.1 pytest-timeout>=2.1.0 --quiet
        echo -e "${GREEN}✓${NC} Development dependencies installed"
    fi
fi

# Verify installation
echo -e "\n${BLUE}Verifying installation...${NC}"

# Test core packages (use venv python)
python -c "import yaml; import colorama; import requests; import semantic_version; import docker; import cpuinfo" 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Core dependencies verified"
else
    echo -e "${RED}✗${NC} Core dependency verification failed"
    exit 1
fi

# Test development tools if in dev mode
if [ "$DEV_MODE" = true ]; then
    echo -e "${BLUE}Verifying development tools...${NC}"

    # Check pytest (use venv python)
    if python -c "import pytest" 2>/dev/null; then
        PYTEST_VERSION=$(python -c "import pytest; print(pytest.__version__)")
        echo -e "${GREEN}✓${NC} pytest ${PYTEST_VERSION}"
    else
        echo -e "${RED}✗${NC} pytest not available"
        exit 1
    fi

    # Check pytest-cov (use venv python)
    if python -c "import pytest_cov" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} pytest-cov available"
    else
        echo -e "${RED}✗${NC} pytest-cov not available"
        exit 1
    fi

    # Check pytest-mock (use venv python)
    if python -c "import pytest_mock" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} pytest-mock available"
    else
        echo -e "${RED}✗${NC} pytest-mock not available"
        exit 1
    fi

    # Check pytest-timeout (use venv python)
    if python -c "import pytest_timeout" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} pytest-timeout available"
    else
        echo -e "${RED}✗${NC} pytest-timeout not available"
        exit 1
    fi
fi

# Summary
echo -e "\n${GREEN}=== Setup Complete ===${NC}"
echo -e "Python version: ${GREEN}${PYTHON_VERSION}${NC}"
echo -e "Virtual environment: ${GREEN}$(pwd)/venv${NC}"

if [ "$USE_POETRY" = true ]; then
    echo -e "Package manager: ${GREEN}Poetry${NC}"
else
    echo -e "Package manager: ${GREEN}pip${NC}"
fi

if [ "$DEV_MODE" = true ]; then
    echo -e "Mode: ${GREEN}Development (with test tools)${NC}"
    echo -e "\n${BLUE}You can now run tests with:${NC}"
    echo -e "  source venv/bin/activate"
    echo -e "  pytest"
else
    echo -e "Mode: ${GREEN}Production${NC}"
    echo -e "\n${YELLOW}Tip: Use --dev flag to install development dependencies${NC}"
fi

echo -e "\n${BLUE}To activate the virtual environment:${NC}"
echo -e "  source venv/bin/activate"
