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
python3 -m venv .venv
source .venv/bin/activate

# Upgrade pip and install wheel
echo -e "\n${BLUE}Upgrading pip and installing wheel...${NC}"
pip install --upgrade pip --quiet
pip install wheel --quiet
echo -e "${GREEN}✓${NC} pip and wheel upgraded"
pip install "poetry>=2.0.0"

POETRY_VERSION=$(poetry --version)
echo -e "${GREEN}✓${NC} Installed ${POETRY_VERSION}"

# Install dependencies
if [ "$DEV_MODE" = true ]; then
    echo -e "${BLUE}Installing with development dependencies${NC}"
    poetry install --with dev
else
    echo -e "${BLUE}Installing production dependencies only${NC}"
    poetry install --only main
fi
echo -e "${GREEN}✓${NC} Dependencies installed via Poetry"

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
echo -e "Virtual environment: ${GREEN}$(pwd)/.venv${NC}"
echo -e "Package manager: ${GREEN}${POETRY_VERSION}${NC}"

if [ "$DEV_MODE" = true ]; then
    echo -e "Mode: ${GREEN}Development (with test tools)${NC}"
    echo -e "\n${BLUE}You can now run tests with:${NC}"
    echo -e "  source .venv/bin/activate"
    echo -e "  pytest"
    echo -e "or use 'make test'"
else
    echo -e "Mode: ${GREEN}Production${NC}"
    echo -e "\n${YELLOW}Tip: Use --dev flag to install development dependencies${NC}"
fi

echo -e "\n${BLUE}You can now run the commands 'smartbugs', 'reparse' and 'results2csv' directly.${NC}"

echo -e "\n${BLUE}For other activities, activate the virtual environment first:${NC}"
echo -e "  source .venv/bin/activate"
