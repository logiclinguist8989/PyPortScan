# PyPortScan - Multi-threaded Port Scanner

A fast, efficient, and professional port scanner written in Python with zero external dependencies. Supports concurrent scanning, banner grabbing, file export, and comprehensive input validation.

## Features

- ✅ **Multi-threaded scanning**: Configurable thread pool (default 100 threads)
- ✅ **Banner grabbing**: Detect service versions and information
- ✅ **IPv4/IPv6/Hostname support**: Works with addresses and domain names
- ✅ **Flexible port specification**: Single ports, ranges, or comma-separated lists
- ✅ **File export**: Save results to text file with timestamps
- ✅ **Input validation**: Comprehensive validation for IPs and port ranges (1-65535)
- ✅ **Colorized output**: Color-coded terminal output for easy reading
- ✅ **Performance tracking**: Execution time and statistics display
- ✅ **Zero dependencies**: Uses only Python standard library (3.7+)

## Installation

PyPortScan can be installed as a system-wide `pyportscan` command or run directly.

### Quick Install (Recommended)

```bash
chmod +x install.sh
sudo ./install.sh
```

This installs PyPortScan as a global command. After installation, use `pyportscan` from anywhere.

### Other Installation Methods

- **Makefile**: `make install` or `make install-user`
- **Manual**: `sudo cp scanner.py /usr/local/bin/pyportscan && sudo chmod +x /usr/local/bin/pyportscan`
- **Development**: Create symlink `sudo ln -s $(pwd)/scanner.py /usr/local/bin/pyportscan`
- **Quick test**: Create alias `alias pyportscan="python3 $(pwd)/scanner.py"`

For detailed instructions, see [INSTALLATION.md](INSTALLATION.md)

### Direct Execution

If you prefer not to install, run directly:

```bash
chmod +x scanner.py
python3 scanner.py <target> <ports> [options]
```

## Quick Start

After installation, use the `pyportscan` command:

```bash
# Basic scan
pyportscan localhost 1-1000

# Scan specific ports with banner grabbing
pyportscan 192.168.1.1 22,80,443,3306

# Advanced: custom threads and file export
pyportscan example.com 1-10000 --threads 200 --banner -o results.txt

# Get help
pyportscan --help
```

For more examples, see [QUICKSTART.md](QUICKSTART.md)

## Usage

### Command Syntax

```
pyportscan <target> <ports> [options]
```

### Arguments

| Argument | Description | Example |
|----------|-------------|---------|
| `target` | IP address, IPv6, or hostname | `192.168.1.1` / `localhost` / `example.com` |
| `ports` | Port range or list | `1-1000` / `22,80,443` / `80` |

### Options

| Option | Description | Default |
|--------|-------------|---------|
| `--threads N` | Number of concurrent threads | 100 |
| `--timeout SEC` | Connection timeout in seconds | 2 |
| `--banner` | Attempt to grab service banners | Disabled |
| `-o, --output FILE` | Save results to file | (stdout only) |

### Examples

See [QUICKSTART.md](QUICKSTART.md) for detailed usage examples including:
- Single port scans
- Port ranges and lists
- Banner grabbing
- Multi-threading optimization
- File export
- Real-world scenarios

## Performance

Typical scanning performance (varies by network and target):

| Scope | Threads | Time | Speed |
|-------|---------|------|-------|
| localhost 1-100 | 100 | ~0.5 sec | 200 ports/sec |
| localhost 1-1000 | 100 | ~2.0 sec | 500 ports/sec |
| localhost 1-10000 | 200 | ~5.0 sec | 2000 ports/sec |
| 192.168.1.0 1-1000 (LAN) | 100 | ~3-5 sec | 200-300 ports/sec |
| internet 1-1000 | 100 | ~10-30 sec | 30-100 ports/sec |

**Note**: Speed depends on network latency, target response time, and firewall rules.

## Input Validation

The scanner validates inputs before scanning:

```bash
# Valid inputs
pyportscan 192.168.1.1 1-1000          # Valid range
pyportscan localhost 22,80,443          # Valid port list
pyportscan example.com 80               # Valid single port
pyportscan ::1 1-1000                   # Valid IPv6

# Invalid inputs (will show error)
pyportscan 999.999.999.999 1-1000      # Invalid IP
pyportscan localhost 1-70000            # Port exceeds max (65535)
pyportscan localhost 100-50             # Start > end
pyportscan localhost -50                # Negative port
```

## Error Handling

The scanner handles various error conditions gracefully:

```
[ERROR] Invalid target: 999.999.999.999 (not a valid IP or hostname)
[ERROR] Port 70000 is out of range (1-65535)
[ERROR] Invalid range: start port (100) is greater than end port (50)
[ERROR] Could not write to file results.txt: Permission denied
```

## Exit Codes

- `0`: Successful execution
- `1`: Input validation error or unexpected error
- `127`: Scan interrupted by user (Ctrl+C)

## Output File Format

When exporting with `-o/--output`, results are saved as:

```
PyPortScan Results
==================
Target: 192.168.1.1
Timestamp: 2024-12-20 15:30:45
Ports Scanned: 100
Open Ports Found: 3

Open Ports:
  - Port 22: SSH-2.0-OpenSSH_7.4
  - Port 80: HTTP/1.1 200 OK
  - Port 443: HTTP/1.1 200 OK

==================
```

## Legal Disclaimer

**Important**: Port scanning can be illegal if performed on networks or systems you don't own or have explicit permission to test. Always:

- ✓ Obtain written authorization before scanning any network
- ✓ Only scan your own infrastructure for security testing
- ✓ Respect privacy and legal regulations in your jurisdiction
- ✗ Don't use this tool for unauthorized access attempts
- ✗ Don't scan third-party networks without permission

The author assumes no liability for misuse or damage caused by this tool. Use responsibly and ethically.

## Future Enhancements

Potential features for future versions:

- [ ] UDP port scanning support
- [ ] JSON/CSV export formats
- [ ] OS fingerprinting from responses
- [ ] Parallel multi-target scanning
- [ ] GeoIP service lookup
- [ ] Stealth/evasion modes (rate limiting)
- [ ] DNS enumeration
- [ ] Service version detection database
- [ ] Idle timeout detection
- [ ] Packet fragmentation options
- [ ] Custom scan profiles
- [ ] Web UI dashboard

## Documentation

Complete documentation is available in the following files:

- **[INSTALLATION.md](INSTALLATION.md)** - Installation and uninstallation guide with 5 different methods
- **[QUICKSTART.md](QUICKSTART.md)** - Quick reference with usage examples and tips
- **[README.md](README.md)** - This file with features and technical details

## Troubleshooting

### Issue: Unable to locate pyportscan command

**Solution**: Ensure the script is installed or in your PATH. See [INSTALLATION.md](INSTALLATION.md) for troubleshooting.

### Issue: All ports appear closed

**Solution**: Check if a firewall is blocking connections:
- Try increasing `--timeout` value
- Check network connectivity to target
- Try reducing `--threads` value

### Issue: Permission denied

**Solution**: Ensure the script has execute permissions:
```bash
chmod +x /usr/local/bin/pyportscan
```

For more troubleshooting, see [INSTALLATION.md](INSTALLATION.md).

## Testing

Run the included test suite:

```bash
python3 test_scanner.py
```

Or using Makefile:

```bash
make test
```

This tests input validation, port scanning, and results formatting.

## Architecture

The scanner uses a **Queue-based thread pool** for efficient parallel scanning:

1. **Main thread**: Creates work queue and thread pool
2. **Worker threads**: Pull ports from queue and scan them
3. **Synchronization**: Uses locks for thread-safe shared resources
4. **Graceful shutdown**: Sentinel values (None) signal thread completion

This approach is more efficient than one thread per port and scales well with many ports.

## License

This project is provided as-is for educational and authorized testing purposes.

## Contributing

Pull requests and issues are welcome! Feel free to fork, modify, and improve.

## Author

Created by Ayush Hamal [@logiclinguist8989](https://github.com/logiclinguist8989)

## Changelog

### Version 1.1.0 (2026-02-12)
- Added system-wide installation support (`pyportscan` command)
- Added install.sh automated installation script
- Added uninstall.sh for safe removal
- Added Makefile with flexible installation options
- Created comprehensive documentation:
  - INSTALLATION.md: Detailed install/uninstall guide
  - QUICKSTART.md: Quick usage reference
- Consolidated documentation to reduce redundancy
- Updated README for cleaner navigation

### Version 1.0.0 (2024-12-20)
- Initial release
- Multi-threaded scanning with Queue-based distribution
- Banner grabbing support
- File export functionality
- Comprehensive input validation
- Colorized output
- Full test suite
- Detailed documentation
