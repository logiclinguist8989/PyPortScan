#!/bin/bash
# PyPortScan Project Cleanup Guide
# This file contains commands to clean up duplicate/redundant files

# ============================================================================
# CLEANUP COMMANDS
# ============================================================================

# Remove duplicate documentation files (consolidate into INSTALLATION.md, QUICKSTART.md)
rm LINUX-INSTALLATION.md
rm README-UPDATED.md
rm TERMINAL-QUICKSTART.txt
rm TERMINAL-INSTALLATION-SUMMARY.txt

# Remove generated/temporary files
rm -f results.txt
rm -rf __pycache__/

# ============================================================================
# FINAL PROJECT STRUCTURE (11 files total)
# ============================================================================
# 
# ✓ Core Files (8):
#   1. scanner.py              - Main port scanner script
#   2. test_scanner.py         - Unit tests
#   3. install.sh              - Automated installation script
#   4. uninstall.sh            - Uninstallation script
#   5. Makefile                - Build automation
#   6. requirements.txt        - Python dependencies (none, but documentation)
#   7. LICENSE                 - MIT License
#   8. .gitignore              - Git ignore rules
#
# ✓ Documentation Files (3):
#   9. README.md               - Main project documentation
#   10. INSTALLATION.md        - Installation guide (consolidated)
#   11. QUICKSTART.md          - Quick reference guide (consolidated)
#
# ============================================================================

# Verify final structure
echo "Final Project Structure:"
echo "======================="
ls -lah | grep -E "^-" | awk '{print $9}' | sort
echo ""
echo "Total files: $(ls -1 | wc -l)"
echo ""
echo "To run cleanup commands:"
echo "  cd /home/ayush/MTPS/port-scanner"
echo "  rm LINUX-INSTALLATION.md"
echo "  rm README-UPDATED.md"
echo "  rm TERMINAL-QUICKSTART.txt"
echo "  rm TERMINAL-INSTALLATION-SUMMARY.txt"
echo "  rm -f results.txt"
echo "  rm -rf __pycache__/"
