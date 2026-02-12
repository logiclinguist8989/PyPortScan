.PHONY: help install install-user uninstall uninstall-user test check clean

# Color codes for output
RED := \033[91m
GREEN := \033[92m
YELLOW := \033[93m
BLUE := \033[94m
BOLD := \033[1m
END := \033[0m

# Configuration variables
PREFIX ?= /usr/local
INSTALL_DIR := $(PREFIX)/bin
INSTALL_NAME := pyportscan
SCRIPT_NAME := scanner.py
TEST_FILE := test_scanner.py
PYTHON := python3
PYTHON_MIN_VERSION := 3.7

# Derived variables
USER_BIN := $(HOME)/.local/bin
BACKUP_EXT := bak.$(shell date +%s)

################################################################################
# Help Target
################################################################################

help:
	@echo "$(BOLD)$(BLUE)╔════════════════════════════════════════════════════╗$(END)"
	@echo "$(BOLD)$(BLUE)║         PyPortScan - Make Targets                  ║$(END)"
	@echo "$(BOLD)$(BLUE)╚════════════════════════════════════════════════════╝$(END)"
	@echo ""
	@echo "$(BOLD)System-wide Installation (requires sudo):$(END)"
	@echo "  $(BOLD)make install$(END)          Install to $(INSTALL_DIR)"
	@echo "  $(BOLD)make uninstall$(END)        Remove from $(INSTALL_DIR)"
	@echo ""
	@echo "$(BOLD)User Installation (no sudo required):$(END)"
	@echo "  $(BOLD)make install-user$(END)     Install to $(USER_BIN)"
	@echo "  $(BOLD)make uninstall-user$(END)   Remove from $(USER_BIN)"
	@echo ""
	@echo "$(BOLD)Development & Testing:$(END)"
	@echo "  $(BOLD)make test$(END)             Run unit tests"
	@echo "  $(BOLD)make check$(END)            Validate Python and installation"
	@echo "  $(BOLD)make clean$(END)            Remove cache and temporary files"
	@echo ""
	@echo "$(BOLD)Utility:$(END)"
	@echo "  $(BOLD)make help$(END)             Display this help message"
	@echo ""
	@echo "$(BOLD)Examples:$(END)"
	@echo "  $(BOLD)make install$(END)          # System-wide install"
	@echo "  $(BOLD)make install-user$(END)     # User-level install"
	@echo "  $(BOLD)make PREFIX=/opt install$(END)  # Custom prefix"
	@echo ""

################################################################################
# Installation Targets
################################################################################

install: check
	@echo "$(BOLD)$(BLUE)→ Installing PyPortScan to $(INSTALL_DIR)...$(END)"
	@if [ ! -f "$(SCRIPT_NAME)" ]; then \
		echo "$(RED)✗ Error: Cannot find $(SCRIPT_NAME)$(END)"; \
		exit 1; \
	fi
	@if [ ! -d "$(INSTALL_DIR)" ]; then \
		echo "$(YELLOW)⚠ Creating $(INSTALL_DIR)$(END)"; \
		sudo mkdir -p "$(INSTALL_DIR)"; \
	fi
	@if [ -f "$(INSTALL_DIR)/$(INSTALL_NAME)" ]; then \
		echo "$(YELLOW)⚠ Backing up existing installation to $(INSTALL_NAME).$(BACKUP_EXT)$(END)"; \
		sudo cp "$(INSTALL_DIR)/$(INSTALL_NAME)" "$(INSTALL_DIR)/$(INSTALL_NAME).$(BACKUP_EXT)"; \
	fi
	@sudo cp "$(SCRIPT_NAME)" "$(INSTALL_DIR)/$(INSTALL_NAME)"
	@sudo chmod +x "$(INSTALL_DIR)/$(INSTALL_NAME)"
	@echo "$(GREEN)✓ Installation successful$(END)"
	@echo "$(BLUE)ℹ PyPortScan is available as: $(BOLD)pyportscan$(END)"

install-user: check
	@echo "$(BOLD)$(BLUE)→ Installing PyPortScan to $(USER_BIN)...$(END)"
	@if [ ! -f "$(SCRIPT_NAME)" ]; then \
		echo "$(RED)✗ Error: Cannot find $(SCRIPT_NAME)$(END)"; \
		exit 1; \
	fi
	@mkdir -p "$(USER_BIN)"
	@if [ -f "$(USER_BIN)/$(INSTALL_NAME)" ]; then \
		echo "$(YELLOW)⚠ Backing up existing installation to $(INSTALL_NAME).$(BACKUP_EXT)$(END)"; \
		cp "$(USER_BIN)/$(INSTALL_NAME)" "$(USER_BIN)/$(INSTALL_NAME).$(BACKUP_EXT)"; \
	fi
	@cp "$(SCRIPT_NAME)" "$(USER_BIN)/$(INSTALL_NAME)"
	@chmod +x "$(USER_BIN)/$(INSTALL_NAME)"
	@echo "$(GREEN)✓ Installation successful$(END)"
	@if echo "$$PATH" | grep -q "$(USER_BIN)"; then \
		echo "$(BLUE)ℹ PyPortScan is available as: $(BOLD)pyportscan$(END)"; \
	else \
		echo "$(YELLOW)⚠ Warning: $(USER_BIN) is not in your PATH$(END)"; \
		echo "$(BLUE)ℹ Add to ~/.bashrc or ~/.zshrc: export PATH=\"$(USER_BIN):$$PATH\"$(END)"; \
	fi

################################################################################
# Uninstallation Targets
################################################################################

uninstall:
	@echo "$(BOLD)$(BLUE)→ Removing PyPortScan from $(INSTALL_DIR)...$(END)"
	@if [ ! -f "$(INSTALL_DIR)/$(INSTALL_NAME)" ]; then \
		echo "$(YELLOW)⚠ PyPortScan is not installed at $(INSTALL_DIR)/$(INSTALL_NAME)$(END)"; \
		exit 0; \
	fi
	@sudo rm -f "$(INSTALL_DIR)/$(INSTALL_NAME)"
	@echo "$(GREEN)✓ Uninstallation successful$(END)"
	@echo "$(BLUE)ℹ The $(BOLD)pyportscan$(END)$(BLUE) command is no longer available$(END)"

uninstall-user:
	@echo "$(BOLD)$(BLUE)→ Removing PyPortScan from $(USER_BIN)...$(END)"
	@if [ ! -f "$(USER_BIN)/$(INSTALL_NAME)" ]; then \
		echo "$(YELLOW)⚠ PyPortScan is not installed at $(USER_BIN)/$(INSTALL_NAME)$(END)"; \
		exit 0; \
	fi
	@rm -f "$(USER_BIN)/$(INSTALL_NAME)"
	@echo "$(GREEN)✓ Uninstallation successful$(END)"
	@echo "$(BLUE)ℹ The $(BOLD)pyportscan$(END)$(BLUE) command is no longer available$(END)"

################################################################################
# Testing & Validation Targets
################################################################################

test:
	@echo "$(BOLD)$(BLUE)→ Running tests...$(END)"
	@if [ ! -f "$(TEST_FILE)" ]; then \
		echo "$(YELLOW)⚠ Warning: $(TEST_FILE) not found$(END)"; \
		exit 1; \
	fi
	@$(PYTHON) -m pytest "$(TEST_FILE)" -v || $(PYTHON) "$(TEST_FILE)"
	@echo "$(GREEN)✓ Tests completed$(END)"

check:
	@echo "$(BOLD)$(BLUE)→ Checking Python installation...$(END)"
	@if ! command -v $(PYTHON) > /dev/null; then \
		echo "$(RED)✗ Error: $(PYTHON) is not installed$(END)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✓ $(PYTHON) found: $$($(PYTHON) --version)$(END)"
	@PYTHON_VERSION=$$($(PYTHON) -c 'import sys; print(".".join(map(str, sys.version_info[:2])))'); \
	echo "$(BLUE)ℹ Python version: $$PYTHON_VERSION$(END)"
	@$(PYTHON) -c 'import sys; sys.exit(0 if sys.version_info >= (3, 7) else 1)' || \
		(echo "$(RED)✗ Error: Python 3.7+ required$(END)" && exit 1)
	@echo "$(GREEN)✓ Python version compatible$(END)"
	@if [ -f "$(SCRIPT_NAME)" ]; then \
		echo "$(GREEN)✓ Scanner script found: $(SCRIPT_NAME)$(END)"; \
	else \
		echo "$(RED)✗ Error: $(SCRIPT_NAME) not found$(END)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✓ All checks passed$(END)"

################################################################################
# Cleanup Target
################################################################################

clean:
	@echo "$(BOLD)$(BLUE)→ Cleaning up...$(END)"
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type f -name "*.pyo" -delete 2>/dev/null || true
	@find . -type f -name ".pytest_cache" -delete 2>/dev/null || true
	@if [ -f ".coverage" ]; then rm -f .coverage; fi
	@if [ -d ".pytest_cache" ]; then rm -rf .pytest_cache; fi
	@echo "$(GREEN)✓ Cleanup completed$(END)"

################################################################################
# Phony targets (do not create files with these names)
################################################################################

.PHONY: help install install-user uninstall uninstall-user test check clean
