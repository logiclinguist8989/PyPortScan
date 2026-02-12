#!/bin/bash
################################################################################
# PyPortScan Uninstallation Script
# Removes pyportscan from /usr/local/bin
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

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════════╗${END}"
    echo -e "${BOLD}${BLUE}║     PyPortScan Uninstallation Script               ║${END}"
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

confirm() {
    local prompt="$1"
    local response
    
    while true; do
        read -p "$(echo -e ${BOLD}$prompt${END})" response
        case "$response" in
            [Yy][Ee][Ss]|[Yy])
                return 0
                ;;
            [Nn][Oo]|[Nn])
                return 1
                ;;
            *)
                echo "Please enter yes or no."
                ;;
        esac
    done
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
        print_info "Please try: sudo ./uninstall.sh"
        exit 1
    fi
    print_success "Running with sudo privileges"
    echo
    
    # Verify installation exists
    print_section "Verifying PyPortScan installation..."
    if [[ ! -f "$INSTALL_DIR/$INSTALL_NAME" ]]; then
        print_error "PyPortScan is not installed at $INSTALL_DIR/$INSTALL_NAME"
        print_info "Nothing to uninstall"
        exit 1
    fi
    print_success "Found PyPortScan installation"
    echo
    
    # Display installation details
    print_section "Installation Details:"
    echo -e "  Location: ${BOLD}$INSTALL_DIR/$INSTALL_NAME${END}"
    echo -e "  Size: $(du -h $INSTALL_DIR/$INSTALL_NAME | cut -f1)"
    echo
    
    # Confirmation prompt
    if ! confirm "Are you sure you want to uninstall PyPortScan? (yes/no): "; then
        print_info "Uninstallation cancelled"
        exit 0
    fi
    echo
    
    # Remove the installation
    print_section "Removing PyPortScan..."
    rm -f "$INSTALL_DIR/$INSTALL_NAME"
    if [ $? -ne 0 ]; then
        print_error "Failed to remove PyPortScan"
        exit 1
    fi
    print_success "PyPortScan removed"
    echo
    
    # Check for backup files and offer cleanup
    BACKUP_FILES=$(find "$INSTALL_DIR" -name "${INSTALL_NAME}.bak.*" 2>/dev/null)
    if [[ -n "$BACKUP_FILES" ]]; then
        echo -e "${YELLOW}Found backup files:${END}"
        echo "$BACKUP_FILES" | sed 's/^/  /'
        echo
        if confirm "Would you like to remove backup files as well? (yes/no): "; then
            find "$INSTALL_DIR" -name "${INSTALL_NAME}.bak.*" -delete
            print_success "Backup files removed"
            echo
        fi
    fi
    
    # Verify removal
    print_section "Verifying uninstallation..."
    if command -v $INSTALL_NAME &> /dev/null; then
        print_warning "PyPortScan command still found in PATH"
        print_info "This may be due to other installations or cached paths"
    else
        print_success "PyPortScan successfully removed from PATH"
    fi
    echo
    
    # Display success message
    echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════════════╗${END}"
    echo -e "${BOLD}${GREEN}║      Uninstallation Successful! ✓                  ║${END}"
    echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════════╝${END}"
    echo
    
    print_success "PyPortScan has been uninstalled"
    print_info "The pyportscan command is no longer available"
    echo
    
    if [[ -n "$BACKUP_FILES" ]]; then
        print_info "Backup files remain in ${BOLD}$INSTALL_DIR${END} if you need to restore"
    fi
    
    echo
}

# Run main function
main "$@"
exit $?
