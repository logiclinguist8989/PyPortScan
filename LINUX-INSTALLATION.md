# Linux Installation Guide - PyPortScan

Complete guide for installing PyPortScan on Linux systems with multiple installation methods, verification steps, and troubleshooting.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation Methods](#installation-methods)
   - [Method 1: Automatic Installation (Recommended)](#method-1-automatic-installation-recommended)
   - [Method 2: Makefile Installation](#method-2-makefile-installation)
   - [Method 3: Manual Installation](#method-3-manual-installation)
   - [Method 4: Symlink Installation](#method-4-symlink-installation)
   - [Method 5: Alias Installation](#method-5-alias-installation)
3. [Verification Steps](#verification-steps)
4. [Uninstallation](#uninstallation)
5. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before installing PyPortScan, ensure your system meets these requirements:

### Python Version Check

```bash
python3 --version
```

**Required:** Python 3.7 or higher

### System Requirements

- Linux operating system (Ubuntu, Debian, Fedora, CentOS, Arch, etc.)
- `bash` shell
- Write permissions to installation directory
- `sudo` access (for system-wide installation only)

### Verify Prerequisites

```bash
# Check Python3 installation
python3 -c "import sys; print('✓ Python', sys.version.split()[0])"

# Check bash availability
bash --version | head -1

# Verify you have write permissions
touch /tmp/test_write && rm /tmp/test_write && echo "✓ Write permissions OK"
```

---

## Installation Methods

### Method 1: Automatic Installation (Recommended)

The automated installation script handles all setup steps with validation and error checking.

#### Prerequisites for This Method

```bash
# Ensure install.sh is executable
chmod +x install.sh
```

#### Installation Steps

**For System-Wide Installation (Requires Sudo):**

```bash
sudo ./install.sh
```

**Sample Output:**

```
╔════════════════════════════════════════════════════╗
║     PyPortScan Installation Script                ║
╚════════════════════════════════════════════════════╝

→ Checking for sudo privileges...
✓ Running with sudo privileges

→ Validating Python installation...
✓ Python 3 found
✓ Python version is compatible (3.12)

→ Verifying source file...
✓ Found scanner.py

→ Installing to /usr/local/bin/pyportscan...
✓ Successfully copied and made executable

→ Verifying installation...
✓ Installation verified

╔════════════════════════════════════════════════════╗
║          Installation Successful! ✓                ║
╚════════════════════════════════════════════════════╝

ℹ PyPortScan is available as: pyportscan

→ Quick Start Examples:
  • Scan a single port:     pyportscan 192.168.1.1 22
  • Scan a port range:      pyportscan 192.168.1.1 20-25
  • Scan multiple ports:    pyportscan 192.168.1.1 22,80,443
  • Scan with threads:      pyportscan -t 200 192.168.1.1 1-1000
  • View all options:       pyportscan --help

✓ Installation complete!
```

#### What This Method Does

✅ Validates Python 3.7+ installation  
✅ Checks for sudo privileges  
✅ Creates backup of existing installation  
✅ Copies scanner.py to `/usr/local/bin/pyportscan`  
✅ Sets executable permissions  
✅ Verifies installation success  
✅ Displays helpful usage examples  

---

### Method 2: Makefile Installation

Use the Makefile for flexible installation with custom prefixes.

#### System-Wide Installation

```bash
# Basic installation to /usr/local/bin
make install

# Custom installation directory
make PREFIX=/opt install
make PREFIX=/home/username/.local install
```

#### User-Level Installation (No Sudo Required)

```bash
# Install to ~/.local/bin
make install-user
```

**Note:** Add `~/.local/bin` to your PATH if it's not already there:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Makefile Validation

```bash
# Check Python and validate setup
make check

# Display all available targets
make help
```

#### Sample Make Output

```
→ Checking Python installation...
✓ python3 found: Python 3.12.1
ℹ Python version: 3.12
✓ Python version compatible
✓ Scanner script found: scanner.py
✓ All checks passed

→ Installing PyPortScan to /usr/local/bin...
⚠ Backing up existing installation to pyportscan.bak.1707756123
✓ Installation successful
ℹ PyPortScan is available as: pyportscan
```

---

### Method 3: Manual Installation

Install PyPortScan manually with step-by-step commands.

#### System-Wide Installation

```bash
# Copy scanner.py to /usr/local/bin
sudo cp scanner.py /usr/local/bin/pyportscan

# Make it executable
sudo chmod +x /usr/local/bin/pyportscan

# Verify installation
ls -lah /usr/local/bin/pyportscan
```

#### User-Level Installation

```bash
# Create .local/bin directory if it doesn't exist
mkdir -p ~/.local/bin

# Copy scanner.py
cp scanner.py ~/.local/bin/pyportscan

# Make it executable
chmod +x ~/.local/bin/pyportscan

# Verify installation
ls -lah ~/.local/bin/pyportscan
```

#### Add to PATH (if needed)

For user-level installations, ensure `~/.local/bin` is in your PATH:

```bash
# Check if already in PATH
echo $PATH | grep -q "$HOME/.local/bin" && echo "Already in PATH" || echo "Not in PATH"

# Add to PATH permanently
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Custom Installation Location

```bash
# Copy to any custom location
sudo cp scanner.py /opt/pyportscan
sudo chmod +x /opt/pyportscan

# Add custom location to PATH
echo 'export PATH="/opt:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

### Method 4: Symlink Installation

Create a symbolic link to the scanner.py from any PATH location.

#### Create Symlink

```bash
# System-wide symlink
sudo ln -s /path/to/scanner.py /usr/local/bin/pyportscan

# User-level symlink
ln -s /path/to/scanner.py ~/.local/bin/pyportscan
```

#### Advantages of Symlinks

✅ Updates to scanner.py automatically reflect when run  
✅ Single source file, multiple access points  
✅ Easy to remove (just delete the link)  
✅ Good for development environments  

#### Verify Symlink

```bash
# Check if it's a symlink
ls -l /usr/local/bin/pyportscan
# Output: lrwxrwxrwx 1 root root 38 Feb 12 10:30 /usr/local/bin/pyportscan -> /path/to/scanner.py

# Verify target
readlink /usr/local/bin/pyportscan
```

#### Remove Symlink

```bash
# Remove without affecting original file
sudo rm /usr/local/bin/pyportscan
```

---

### Method 5: Alias Installation

Create a shell alias for quick access (temporary or permanent).

#### Temporary Alias (Current Session Only)

```bash
# Create temporary alias
alias pyportscan="python3 /path/to/scanner.py"

# Use immediately
pyportscan 192.168.1.1 22

# Alias disappears when you close the terminal
```

#### Permanent Alias

Add to your shell configuration file:

**For Bash (`~/.bashrc`):**

```bash
echo 'alias pyportscan="python3 /path/to/scanner.py"' >> ~/.bashrc
source ~/.bashrc
```

**For Zsh (`~/.zshrc`):**

```bash
echo 'alias pyportscan="python3 /path/to/scanner.py"' >> ~/.zshrc
source ~/.zshrc
```

**For Fish (`~/.config/fish/config.fish`):**

```bash
echo 'alias pyportscan="python3 /path/to/scanner.py"' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
```

#### Verify Alias

```bash
# Check if alias is defined
alias | grep pyportscan

# Or use type command
type pyportscan
```

#### Advantages of Aliases

✅ Works with any Python version (specify in alias)  
✅ No file copying needed  
✅ Easy to create/remove  
✅ Good for testing and development  

#### Disadvantages of Aliases

❌ Not available in non-interactive shells  
❌ Requires shell configuration files  
❌ Not accessible from scripts  
❌ Need separate setup per shell  

---

## Verification Steps

After any installation method, verify PyPortScan is working correctly.

### Step 1: Basic Command Check

```bash
# Check if command is available
which pyportscan

# Should output: /usr/local/bin/pyportscan (or similar)
```

### Step 2: Help Menu

```bash
# Display help information
pyportscan --help

# Should display usage, options, and examples
```

### Step 3: Version Check

```bash
# Check Python version used
pyportscan --help | head -5
# Or check directly
python3 --version
```

### Step 4: Dependency Verification

```bash
# Verify all required modules are available
python3 -c "import socket, threading, queue, argparse; print('✓ All dependencies available')"
```

### Step 5: Test Scan

```bash
# Test with localhost (safe, no network required)
pyportscan localhost 22

# Or test with a public website
pyportscan google.com 80,443

# Expected output:
# - Port status (open/closed)
# - Response times
# - Banner information (if available)
```

### Step 6: Permission Check

```bash
# For system-wide installations
ls -l /usr/local/bin/pyportscan
# Should show: -rwxr-xr-x (executable by all)

# For user installations
ls -l ~/.local/bin/pyportscan
# Should show: -rwxr-xr-x (executable by owner)
```

### Complete Verification Script

```bash
#!/bin/bash

echo "╔════════════════════════════════════════════════════╗"
echo "║     PyPortScan Installation Verification           ║"
echo "╚════════════════════════════════════════════════════╝"
echo

# Check if command exists
if ! command -v pyportscan &> /dev/null; then
    echo "✗ Error: pyportscan command not found"
    exit 1
fi
echo "✓ pyportscan command found: $(which pyportscan)"

# Check Python version
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo "✓ Python version: $PYTHON_VERSION"

# Check dependencies
python3 -c "import socket, threading, queue; import argparse" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✓ All dependencies available"
else
    echo "✗ Missing dependencies"
    exit 1
fi

# Check file permissions
INSTALL_PATH=$(which pyportscan)
if [ -x "$INSTALL_PATH" ]; then
    echo "✓ Correct permissions: $(ls -lh "$INSTALL_PATH" | awk '{print $1, $9}')"
else
    echo "✗ File is not executable"
    exit 1
fi

echo
echo "╔════════════════════════════════════════════════════╗"
echo "║      All Verification Checks Passed! ✓            ║"
echo "╚════════════════════════════════════════════════════╝"
```

---

## Uninstallation

### Using Uninstall Script

```bash
sudo ./uninstall.sh
```

### Using Makefile

```bash
# System-wide uninstall
make uninstall

# User-level uninstall
make uninstall-user
```

### Manual Uninstallation

```bash
# System-wide
sudo rm /usr/local/bin/pyportscan

# User-level
rm ~/.local/bin/pyportscan

# Symlink
sudo rm /usr/local/bin/pyportscan

# Alias (remove from ~/.bashrc or ~/.zshrc)
# Edit the file and remove the alias line, then: source ~/.bashrc
```

---

## Troubleshooting

### Problem: "pyportscan: command not found"

**Cause:** PyPortScan is not in your PATH or not installed correctly.

**Solutions:**

```bash
# 1. Verify installation location
ls -la /usr/local/bin/pyportscan
ls -la ~/.local/bin/pyportscan

# 2. Check if directory is in PATH
echo $PATH
# Should contain /usr/local/bin or ~/.local/bin

# 3. Add to PATH if missing
export PATH="/usr/local/bin:$PATH"
# Or permanently add to ~/.bashrc

# 4. Reinstall
sudo ./install.sh  # or make install
```

### Problem: "Permission denied" when running pyportscan

**Cause:** File doesn't have execute permissions.

**Solution:**

```bash
# Fix permissions
sudo chmod +x /usr/local/bin/pyportscan
chmod +x ~/.local/bin/pyportscan
```

### Problem: "python3: No such file or directory"

**Cause:** Python 3 is not installed or not in PATH.

**Solutions:**

```bash
# 1. Check Python installation
which python3
python3 --version

# 2. Install Python 3 (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install python3

# 3. Install Python 3 (Fedora/CentOS)
sudo dnf install python3

# 4. Install Python 3 (Arch)
sudo pacman -S python
```

### Problem: "You must be root" error during installation

**Cause:** Attempting system-wide installation without sudo.

**Solutions:**

```bash
# Use sudo for system-wide install
sudo ./install.sh
sudo make install

# Or use user-level installation (no sudo needed)
make install-user
./install.sh  # Run as regular user for ~/.local/bin installation (with modifications)
```

### Problem: Python version too old (3.6 or earlier)

**Cause:** System Python is older than required.

**Solutions:**

```bash
# 1. Check installed versions
python3 --version
python3.12 --version
python3.11 --version

# 2. Install newer Python (Ubuntu/Debian)
sudo apt-get install python3.12

# 3. Create wrapper to use specific version
sudo tee /usr/local/bin/pyportscan > /dev/null <<'EOF'
#!/usr/bin/env python3.12
# Copy contents of scanner.py here
EOF

# 4. Make executable
sudo chmod +x /usr/local/bin/pyportscan
```

### Problem: Insufficient permissions for ~/.local/bin

**Cause:** Directory doesn't exist or permission issues.

**Solutions:**

```bash
# 1. Create directory with correct permissions
mkdir -p ~/.local/bin
chmod 755 ~/.local/bin

# 2. Verify ownership
ls -ld ~/.local/bin
# Should be owned by your user, not root

# 3. Fix ownership if needed
sudo chown -R $USER:$USER ~/.local/bin
```

### Problem: "make: command not found"

**Cause:** GNU Make is not installed on the system.

**Solutions:**

```bash
# Install make (Ubuntu/Debian)
sudo apt-get install make

# Install make (Fedora/CentOS)
sudo dnf install make

# Install make (Arch)
sudo pacman -S make

# Or use manual installation method
sudo cp scanner.py /usr/local/bin/pyportscan
sudo chmod +x /usr/local/bin/pyportscan
```

### Problem: Multiple PyPortScan installations conflict

**Cause:** PyPortScan installed in multiple locations.

**Solutions:**

```bash
# 1. Find all installations
which pyportscan
which -a pyportscan

# 2. Check PATH order
echo $PATH

# 3. Remove unwanted installations
sudo rm /usr/local/bin/pyportscan
rm ~/.local/bin/pyportscan

# 4. Reinstall to single location
sudo ./install.sh
```

### Problem: Installation fails with "device or resource busy"

**Cause:** File is currently in use.

**Solutions:**

```bash
# 1. Close any running instances
pkill -f pyportscan

# 2. Check for running processes
ps aux | grep pyportscan

# 3. Retry installation
sudo ./install.sh
```

### Problem: Symlink points to old location

**Cause:** Original file moved, but symlink not updated.

**Solutions:**

```bash
# 1. Check symlink target
readlink /usr/local/bin/pyportscan

# 2. Remove broken symlink
sudo rm /usr/local/bin/pyportscan

# 3. Recreate with correct path
sudo ln -s /correct/path/to/scanner.py /usr/local/bin/pyportscan
```

### Getting Help

If you're still having issues:

```bash
# 1. Run verification script
bash verify_installation.sh  # (if available)

# 2. Check system information
uname -a
python3 --version
bash --version

# 3. Check installation directory
ls -la /usr/local/bin/pyportscan
ls -la ~/.local/bin/pyportscan

# 4. Test Python directly
python3 scanner.py --help

# 5. Check file syntax
python3 -m py_compile scanner.py
```

---

## Installation Decision Matrix

Choose the best installation method for your use case:

| Method | Ease | No Sudo | Updates | Dev-Friendly | Recommendation |
|--------|------|---------|---------|--------------|-----------------|
| **install.sh** | ⭐⭐⭐⭐⭐ | ❌ | ⭐⭐⭐ | ⭐⭐ | Best for most users |
| **Makefile** | ⭐⭐⭐⭐ | ✅ (user) | ⭐⭐⭐ | ⭐⭐⭐ | Flexible, professional |
| **Manual** | ⭐⭐ | ✅ (user) | ⭐⭐ | ⭐⭐ | Understanding how it works |
| **Symlink** | ⭐⭐⭐ | ✅ (user) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Development, live updates |
| **Alias** | ⭐⭐⭐ | ✅ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Quick testing |

---

## Summary

- **For Most Users:** Use `install.sh` for automated installation
- **For Flexibility:** Use `make install` or `make install-user`
- **For Development:** Use symlinks to keep source and binary in sync
- **For Quick Testing:** Use aliases
- **For Understanding:** Try manual installation
- **Always:** Verify installation with the verification steps

---

**Last Updated:** February 12, 2026  
**PyPortScan Version:** Compatible with Python 3.7+
