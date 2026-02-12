# PyPortScan Installation Guide

Complete guide for installing PyPortScan on Linux systems with multiple installation methods.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation Methods](#installation-methods)
3. [Verification](#verification)
4. [Uninstallation](#uninstallation)
5. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Python Version Check

Ensure you have Python 3.7 or higher:

```bash
python3 --version
```

### System Requirements

- Linux operating system (Ubuntu, Debian, Fedora, CentOS, Arch, etc.)
- `bash` shell
- Write permissions to installation directory
- `sudo` access (for system-wide installation only)

---

## Installation Methods

### Method 1: Automatic Installation (Recommended) ⭐

The fastest and safest way to install PyPortScan system-wide.

```bash
chmod +x install.sh
sudo ./install.sh
```

**What it does:**
- Validates Python 3.7+ installation
- Checks sudo privileges
- Backs up existing installations
- Installs to `/usr/local/bin/pyportscan`
- Creates colored output messages
- Displays usage examples

**Time:** < 30 seconds  
**Best for:** Most users, production deployment

---

### Method 2: Makefile Installation (Flexible)

Use the Makefile for flexible installation with custom prefixes and user-level options.

**System-wide installation:**
```bash
make install
make check      # Validate Python before install
```

**Custom installation path:**
```bash
make PREFIX=/opt install
```

**User-level installation (no sudo required):**
```bash
make install-user
```

**Time:** < 20 seconds  
**Best for:** Developers, CI/CD, build systems

---

### Method 3: Manual Installation (Learning)

For full control and understanding of the installation process.

**System-wide:**
```bash
sudo cp scanner.py /usr/local/bin/pyportscan
sudo chmod +x /usr/local/bin/pyportscan
```

**User-level (no sudo):**
```bash
mkdir -p ~/.local/bin
cp scanner.py ~/.local/bin/pyportscan
chmod +x ~/.local/bin/pyportscan
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Time:** < 2 minutes  
**Best for:** Understanding the process, minimal dependencies

---

### Method 4: Symlink Installation (Development)

Perfect for development - changes to `scanner.py` are immediately reflected.

```bash
sudo ln -s $(pwd)/scanner.py /usr/local/bin/pyportscan
```

**User-level symlink:**
```bash
ln -s $(pwd)/scanner.py ~/.local/bin/pyportscan
```

**Verify symlink:**
```bash
ls -l /usr/local/bin/pyportscan
readlink /usr/local/bin/pyportscan
```

**Remove symlink (doesn't delete original):**
```bash
sudo rm /usr/local/bin/pyportscan
```

**Time:** < 1 minute  
**Best for:** Development, live testing

---

### Method 5: Alias Installation (Quick Testing)

No installation needed - just create an alias.

**Temporary (current session only):**
```bash
alias pyportscan="python3 $(pwd)/scanner.py"
```

**Permanent (add to ~/.bashrc):**
```bash
echo 'alias pyportscan="python3 $(pwd)/scanner.py"' >> ~/.bashrc
source ~/.bashrc
```

**For Zsh (~/.zshrc):**
```bash
echo 'alias pyportscan="python3 $(pwd)/scanner.py"' >> ~/.zshrc
source ~/.zshrc
```

**Time:** < 30 seconds  
**Best for:** Testing, quick access, no-install scenarios

---

## Installation Comparison

| Method | Speed | Ease | No Sudo | Best For |
|--------|-------|------|---------|----------|
| **Automatic (install.sh)** | ⚡⚡⚡ | ⭐⭐⭐⭐⭐ | ❌ | Most users |
| **Makefile** | ⚡⚡⚡ | ⭐⭐⭐⭐ | ✅ (user) | Developers |
| **Manual** | ⚡⚡ | ⭐⭐⭐ | ✅ (user) | Learning |
| **Symlink** | ⚡⚡⚡ | ⭐⭐⭐⭐ | ✅ (user) | Development |
| **Alias** | ⚡⚡⚡⚡⚡ | ⭐⭐⭐⭐ | ✅ | Quick test |

---

## Verification

### Step 1: Check Installation

```bash
which pyportscan
pyportscan --help
```

### Step 2: Verify Executability

```bash
ls -l /usr/local/bin/pyportscan
# Should show: -rwxr-xr-x (executable)
```

### Step 3: Test Scan

```bash
# Test with localhost (safe, no network required)
pyportscan localhost 22

# Test with hostname
pyportscan example.com 80,443
```

### Step 4: Verify Dependencies

```bash
python3 -c "import socket, threading, queue; print('✓ All dependencies available')"
```

---

## Uninstallation

### Using the uninstall script

```bash
sudo ./uninstall.sh
```

### Using Makefile

```bash
make uninstall          # System-wide
make uninstall-user     # User-level
```

### Manual removal

```bash
# System-wide
sudo rm /usr/local/bin/pyportscan

# User-level
rm ~/.local/bin/pyportscan

# Remove backup files (if desired)
sudo rm /usr/local/bin/pyportscan.bak.*

# Remove alias from ~/.bashrc (if used)
nano ~/.bashrc  # Remove the alias line
source ~/.bashrc
```

---

## Troubleshooting

### "pyportscan: command not found"

**Solutions:**
```bash
# 1. Verify installation
which pyportscan
ls -la /usr/local/bin/pyportscan

# 2. Check if location is in PATH
echo $PATH

# 3. Refresh shell cache
hash -r

# 4. Add to PATH if missing (user installation)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 5. Reinstall
sudo ./install.sh
```

### "Permission denied" when running

**Solutions:**
```bash
# Fix permissions
sudo chmod +x /usr/local/bin/pyportscan

# Verify
ls -l /usr/local/bin/pyportscan
```

### "python3: No such file or directory"

**Solutions:**
```bash
# Verify Python installation
which python3
python3 --version

# Install Python 3 (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install python3

# Install Python 3 (Fedora/CentOS)
sudo dnf install python3

# Install Python 3 (Arch)
sudo pacman -S python
```

### "You must be root" error

**Solutions:**
```bash
# Use sudo for system-wide install
sudo ./install.sh
sudo make install

# Or use user-level installation (no sudo needed)
make install-user
```

### Python version too old

**Solutions:**
```bash
# Check available versions
python3.12 --version
python3.11 --version

# Install specific version (Ubuntu/Debian)
sudo apt-get install python3.12

# Use specific version
sudo /usr/bin/python3.12 scanner.py --help
```

### Symlink points to wrong location

**Solutions:**
```bash
# Check symlink target
readlink /usr/local/bin/pyportscan

# Verify target exists
ls -la $(readlink /usr/local/bin/pyportscan)

# Remove and recreate
sudo rm /usr/local/bin/pyportscan
sudo ln -s /correct/path/to/scanner.py /usr/local/bin/pyportscan
```

### Installation fails: "device or resource busy"

**Solutions:**
```bash
# Stop running instances
pkill -f pyportscan

# Check for running processes
ps aux | grep pyportscan

# Retry installation
sudo ./install.sh
```

---

## Getting Help

For additional help:

1. Check [QUICKSTART.md](QUICKSTART.md) for usage examples
2. Run `pyportscan --help` for command options
3. See [README.md](README.md) for full documentation
4. Check scanner.py source code for implementation details

---

**Last Updated:** February 12, 2026  
**PyPortScan Version:** Compatible with Python 3.7+
