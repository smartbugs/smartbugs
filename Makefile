# SmartBugs Makefile
# Provides common development commands for testing, linting, formatting, and setup

# Configuration
PYTHON := python3
VENV := .venv
VENV_ACTIVATE := . $(VENV)/bin/activate
PIP := $(VENV)/bin/pip
PYTEST := $(VENV)/bin/pytest
BLACK := $(VENV)/bin/black
RUFF := $(VENV)/bin/ruff
MYPY := $(VENV)/bin/mypy

# Source directories
SRC_DIR := sb
TEST_DIR := tests
TOOLS_DIR := tools

# Coverage settings
COV_MIN := 70
COV_REPORT := term-missing

# Phony targets (not actual files)
.PHONY: all help install test test-unit test-integration format lint typecheck check clean

# Default target: run all checks
all: check
	@echo ""
	@echo "Tip: Run 'make help' to see all available commands"

# Show help
help:
	@echo "SmartBugs Development Commands"
	@echo "==============================="
	@echo ""
	@echo "Default:"
	@echo "  make all              - Run all checks (same as 'make check')"
	@echo "  make                  - Same as 'make all'"
	@echo ""
	@echo "Setup:"
	@echo "  make install          - Install dependencies and set up virtual environment"
	@echo ""
	@echo "Testing:"
	@echo "  make test             - Run all tests with coverage"
	@echo "  make test-unit        - Run only unit tests"
	@echo "  make test-integration - Run only integration tests"
	@echo ""
	@echo "Code Quality:"
	@echo "  make format           - Format code with Black"
	@echo "  make lint             - Lint code with Ruff"
	@echo "  make typecheck        - Type check with Mypy"
	@echo "  make check            - Run all checks (lint, typecheck, test)"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean            - Remove virtual environment and cache files"
	@echo ""

# Install dependencies and set up virtual environment
install:
	@bash install/setup-venv.sh --dev

# Run all tests with coverage
test:
	@if [ ! -d "$(VENV)" ]; then \
		echo "Error: Virtual environment not found. Run 'make install' first."; \
		exit 1; \
	fi
	@echo "Running all tests with coverage..."
	@$(VENV_ACTIVATE) && $(PYTEST) $(TEST_DIR) \
		--cov=$(SRC_DIR) \
		--cov-report=$(COV_REPORT) \
		--cov-report=html \
		--cov-report=xml \
		--cov-fail-under=$(COV_MIN) \
		-v

# Run only unit tests
test-unit:
	@if [ ! -d "$(VENV)" ]; then \
		echo "Error: Virtual environment not found. Run 'make install' first."; \
		exit 1; \
	fi
	@if [ ! -d "$(TEST_DIR)/unit" ]; then \
		echo "Warning: Unit test directory not found at $(TEST_DIR)/unit"; \
		echo "Running all tests instead..."; \
		$(VENV_ACTIVATE) && $(PYTEST) $(TEST_DIR) -v; \
	else \
		echo "Running unit tests..."; \
		$(VENV_ACTIVATE) && $(PYTEST) $(TEST_DIR)/unit \
			--cov=$(SRC_DIR) \
			--cov-report=$(COV_REPORT) \
			-v; \
	fi

# Run only integration tests
test-integration:
	@if [ ! -d "$(VENV)" ]; then \
		echo "Error: Virtual environment not found. Run 'make install' first."; \
		exit 1; \
	fi
	@if [ ! -d "$(TEST_DIR)/integration" ]; then \
		echo "Warning: Integration test directory not found at $(TEST_DIR)/integration"; \
		echo "No integration tests to run."; \
	else \
		echo "Running integration tests..."; \
		$(VENV_ACTIVATE) && $(PYTEST) $(TEST_DIR)/integration -v; \
	fi

# Format code with Black
format:
	@if [ ! -d "$(VENV)" ]; then \
		echo "Error: Virtual environment not found. Run 'make install' first."; \
		exit 1; \
	fi
	@echo "Formatting code with Black..."
	@if [ -d "$(TEST_DIR)" ]; then \
		$(VENV_ACTIVATE) && $(BLACK) $(SRC_DIR) $(TEST_DIR) \
			--line-length 100 \
			--exclude '/(\.git|\.mypy_cache|\.pytest_cache|\.venv|venv|__pycache__|solcx)/'; \
	else \
		$(VENV_ACTIVATE) && $(BLACK) $(SRC_DIR) $(TOOLS_DIR) \
			--line-length 100 \
			--exclude '/(\.git|\.mypy_cache|\.pytest_cache|\.venv|venv|__pycache__|solcx)/'; \
	fi
	@echo "Formatting complete!"

# Lint code with Ruff
lint:
	@if [ ! -d "$(VENV)" ]; then \
		echo "Error: Virtual environment not found. Run 'make install' first."; \
		exit 1; \
	fi
	@echo "Linting code with Ruff..."
	@if [ -d "$(TEST_DIR)" ]; then \
		$(VENV_ACTIVATE) && $(RUFF) check $(SRC_DIR) $(TEST_DIR) \
			--exclude solcx \
			--line-length 100; \
	else \
		$(VENV_ACTIVATE) && $(RUFF) check $(SRC_DIR) $(TOOLS_DIR) \
			--exclude solcx \
			--line-length 100; \
	fi
	@echo "Linting complete!"

# Type check with Mypy
typecheck:
	@if [ ! -d "$(VENV)" ]; then \
		echo "Error: Virtual environment not found. Run 'make install' first."; \
		exit 1; \
	fi
	@echo "Type checking with Mypy..."
	@$(VENV_ACTIVATE) && $(MYPY) $(SRC_DIR) $(TOOLS_DIR) \
		--ignore-missing-imports \
		--exclude solcx \
		--no-strict-optional \
		|| echo "Note: Mypy may report errors. Consider adding type hints gradually."
	@echo "Type checking complete!"

# Run all checks (lint, typecheck, test)
check: lint typecheck test
	@echo ""
	@echo "==============================="
	@echo "All checks passed successfully!"
	@echo "==============================="

# Clean up virtual environment and cache files
clean:
	@echo "Cleaning up..."
	@rm -rf $(VENV)
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@rm -rf htmlcov
	@rm -f coverage.xml
	@rm -f .coverage
	@echo "Cleanup complete!"
