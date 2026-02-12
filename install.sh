#!/bin/bash
################################################################################
# PyPortScan Installation Script
# Installs scanner.py to /usr/local/bin/pyportscan for system-wide access
################################################################################

# Color codes for output
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
BOLD='\033[1m'
END='\033[0m'

# Configuration
INSTALL_DIR="/usr/local/bin"
INSTALL_NAME="pyportscan"
SCRIPT_NAME="scanner.py"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════════╗${END}"
    echo -e "${BOLD}${BLUE}║     PyPortScan Installation Script                ║${END}"
    echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════════╝${END}"
    echo
}

print_section() {
    echo -e "${BOLD}${BLUE}→ $1${END}"
}

print_success() {
    echo -e "${GREEN}✓ $1${END}"
}

print_error() {
    echo -e "${RED}✗ Error: $1${END}"
}

print_warning() {
    echo -e "${YELLOW}⚠ Warning: $1${END}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${END}"
}

################################################################################
# Main Logic
################################################################################

main() {
    print_header
    
    # Check if running with sudo
    print_section "Checking for sudo privileges..."
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run with sudo"
        print_info "Please try: sudo ./install.sh"
        exit 1
    fi
    print_success "Running with sudo privileges"
    echo
    
    # Validate Python installation
    print_section "Validating Python installation..."
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 is not installed"
        print_info "Please install Python 3.7 or higher and try again"
        exit 1
    fi
    print_success "Python 3 found"
    
    # Check Python version
    PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
    PYTHON_CHECK=$(python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 7) else 1)')
    
    if [ $? -ne 0 ]; then
        print_error "Python version must be 3.7 or higher (found: $PYTHON_VERSION)"
        exit 1
    fi
    print_success "Python version is compatible ($PYTHON_VERSION)"
    echo
    
    # Verify scanner.py exists
    print_section "Verifying source file..."
    if [[ ! -f "$SCRIPT_NAME" ]]; then
        print_error "Cannot find $SCRIPT_NAME in current directory"
        print_info "Please run this script from the PyPortScan directory"
        exit 1
    fi
    print_success "Found $SCRIPT_NAME"
    echo
    
    # Create install destination
    print_section "Installing to $INSTALL_DIR/$INSTALL_NAME..."
    
    # Backup existing installation if it exists
    if [[ -f "$INSTALL_DIR/$INSTALL_NAME" ]]; then
        BACKUP_FILE="$INSTALL_DIR/$INSTALL_NAME.bak.$(date +%s)"
        print_warning "Existing installation found, creating backup"
        cp "$INSTALL_DIR/$INSTALL_NAME" "$BACKUP_FILE"
        print_success "Backup created at $BACKUP_FILE"
    fi
    
    # Copy and setup the script
    cp "$SCRIPT_NAME" "$INSTALL_DIR/$INSTALL_NAME"
    if [ $? -ne 0 ]; then
        print_error "Failed to copy $SCRIPT_NAME to $INSTALL_DIR"
        exit 1
    fi
    
    # Make executable
    chmod +x "$INSTALL_DIR/$INSTALL_NAME"
    if [ $? -ne 0 ]; then
        print_error "Failed to make $INSTALL_NAME executable"
        exit 1
    fi
    print_success "Successfully copied and made executable"
    echo
    
    # Verify installation
    print_section "Verifying installation..."
    if ! command -v $INSTALL_NAME &> /dev/null; then
        print_error "Installation verification failed"
        exit 1
    fi
    print_success "Installation verified"
    echo
    
    # Display success message
    echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════════════╗${END}"
    echo -e "${BOLD}${GREEN}║          Installation Successful! ✓                ║${END}"
    echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════════╝${END}"
    echo
    echo -e "${GREEN}PyPortScan has been installed to:${END} ${BOLD}$INSTALL_DIR/$INSTALL_NAME${END}"
    echo
    
    print_info "You can now use PyPortScan from anywhere by typing: ${BOLD}pyportscan${END}"
    echo
    
    print_section "Quick Start Examples:"
    echo "  • Scan a single port:     ${BOLD}pyportscan 192.168.1.1 22${END}"
    echo "  • Scan a port range:      ${BOLD}pyportscan 192.168.1.1 20-25${END}"
    echo "  • Scan multiple ports:    ${BOLD}pyportscan 192.168.1.1 22,80,443${END}"
    echo "  • Scan with threads:      ${BOLD}pyportscan -t 200 192.168.1.1 1-1000${END}"
    echo "  • View all options:       ${BOLD}pyportscan --help${END}"
    echo
    
    print_success "Installation complete!"
}

# Run main function
main "$@"
exit $?
