# PyPortScan - Quick Start Guide

Quick reference for installing and using PyPortScan.

## Installation (Choose One)

```bash
# Recommended: Automatic installation
sudo ./install.sh

# Or: Makefile (system-wide)
make install

# Or: Makefile (user-level, no sudo)
make install-user

# Or: Manual installation
sudo cp scanner.py /usr/local/bin/pyportscan
sudo chmod +x /usr/local/bin/pyportscan
```

## Verify Installation

```bash
which pyportscan
pyportscan --help
```

## Basic Usage

```bash
# Single port scan
pyportscan localhost 22

# Port range
pyportscan 192.168.1.1 20-25

# Multiple ports
pyportscan 192.168.1.1 22,80,443,3306

# Hostname
pyportscan example.com 80,443
```

## Advanced Usage

```bash
# With banner grabbing (detect service versions)
pyportscan 192.168.1.1 80,443 --banner

# Custom thread count (faster)
pyportscan -t 200 192.168.1.1 1-1000

# Save results to file
pyportscan -o scan_results.txt 192.168.1.1 1-1000

# Full port scan with options
pyportscan -t 500 -o results.txt example.com 1-65535 --banner
```

## Real-World Examples

```bash
# Check SSH on multiple servers
for ip in 192.168.1.{1..10}; do
  pyportscan $ip 22
done

# Network troubleshooting (common ports)
pyportscan 192.168.1.100 22,80,443,3306,5432,27017

# Scan with monitoring
watch -n 60 'pyportscan localhost 8080'

# Extract open ports and pipe to nmap
pyportscan 192.168.1.1 1-1000 > ports.txt
nmap -p $(cat ports.txt) 192.168.1.1

# Batch scan multiple hosts
for target in $(cat targets.txt); do
  echo "Scanning $target..."
  pyportscan -o "results_${target}.txt" "$target" 1-10000
done
```

## Command Reference

```
Usage: pyportscan <target> <ports> [options]

Arguments:
  target              IP address, IPv6, or hostname
  ports               Single port, range (1-100), or list (22,80,443)

Options:
  -t, --threads N     Number of threads (default: 100)
  --timeout SEC       Connection timeout in seconds (default: 2)
  --banner            Attempt to grab service banners
  -o, --output FILE   Save results to file
  --help              Show help message
```

## Threading Guide

```bash
# Default: 100 threads (good for most cases)
pyportscan host.com 1-1000

# Faster scanning (high thread count)
pyportscan -t 500 host.com 1-10000

# Network-friendly (lower thread count)
pyportscan -t 50 external-host.com 1-1000

# Tuning tips:
# - External/internet: -t 50-100
# - LAN: -t 200-500
# - Localhost: -t 500+
```

## Troubleshooting

```bash
# Command not found?
hash -r                    # Refresh shell cache
which pyportscan           # Verify location
echo $PATH                 # Check PATH

# Permission denied?
sudo chmod +x /usr/local/bin/pyportscan

# Port scanning slow?
pyportscan -t 200 host 1-1000    # Increase threads
pyportscan --timeout 1 host 22   # Decrease timeout

# Target not found?
ping example.com           # Test connectivity
nslookup example.com       # Test DNS resolution
```

## Uninstall

```bash
# Using uninstall script
sudo ./uninstall.sh

# Using Makefile
make uninstall
make uninstall-user

# Manual removal
sudo rm /usr/local/bin/pyportscan
rm ~/.local/bin/pyportscan
```

## Pro Tips

1. **Development**: Use symlink for live updates
   ```bash
   sudo ln -s $(pwd)/scanner.py /usr/local/bin/pyportscan
   ```

2. **Testing**: Use alias for quick testing
   ```bash
   alias pyportscan="python3 $(pwd)/scanner.py"
   ```

3. **Output handling**: Combine with grep
   ```bash
   pyportscan 192.168.1.1 1-1000 | grep -i "open"
   ```

4. **Scheduled scans**: Add to crontab
   ```bash
   0 2 * * * /usr/local/bin/pyportscan -o /var/scans/daily_%Y%m%d.txt host 1-1000
   ```

5. **Parallel scanning**: Background multiple scans
   ```bash
   pyportscan -t 100 host1 1-1000 &
   pyportscan -t 100 host2 1-1000 &
   wait
   ```

## More Information

- Full documentation: [README.md](README.md)
- Installation guide: [INSTALLATION.md](INSTALLATION.md)
- View help: `pyportscan --help`

---

**Quick fact:** PyPortScan has zero external dependencies - uses only Python standard library!
