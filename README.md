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

No installation required! Just ensure you have **Python 3.7 or higher** installed.

```bash
# Check your Python version
python --version

# Clone the repository (optional, or just copy the files)
git clone https://github.com/logiclinguist8989/PyPortScan.git
cd PyPortScan

# Make the script executable (Linux/Mac)
chmod +x scanner.py test_scanner.py
```

## Quick Start

```bash
# Basic scan: localhost, ports 1-1000
python scanner.py localhost 1-1000

# Scan specific ports with banner grabbing
python scanner.py 192.168.1.1 22,80,443,3306,8080 --banner

# Advanced: custom threads, timeout, and file export
python scanner.py example.com 1-10000 --threads 200 --timeout 1 --banner -o results.txt

# Get help
python scanner.py --help
```

## Usage

### Command Syntax

```
python scanner.py <target> <ports> [options]
```

### Arguments

| Argument | Description | Example |
|----------|-------------|---------|
| `target` | IP address, IPv6, or hostname | `192.168.1.1` / `localhost` / `example.com` |
| `ports` | Port range or list | `1-1000` / `22,80,443` / `80` |

### Options

| Option | Description | Default |
|--------|-------------|---------|
| `--threads NUM` | Number of concurrent threads | 100 |
| `--timeout SEC` | Connection timeout in seconds | 2 |
| `--banner` | Attempt to grab service banners | Disabled |
| `-o, --output FILE` | Save results to file | (stdout only) |

## Examples

### Example 1: Scan localhost, ports 1-100
```bash
python scanner.py localhost 1-100
```

Output:
```
[*] Starting scan on localhost
[*] Scanning 100 ports with 100 threads
[*] Scan completed in 0.45 seconds
[*] Ports scanned: 100
[*] Open ports found: 1

Open Ports:
  Port 80
```

### Example 2: Scan with banner grabbing
```bash
python scanner.py 192.168.1.1 80,443,8080 --banner
```

Output:
```
[*] Starting scan on 192.168.1.1
[*] Scanning 3 ports with 100 threads
[*] Banner grabbing enabled
[*] Scan completed in 0.12 seconds
[*] Ports scanned: 3
[*] Open ports found: 2

Open Ports:
  Port 80: HTTP/1.1 200 OK
  Port 8080: HTTP/1.1 404 Not Found
```

### Example 3: Scan with file export
```bash
python scanner.py example.com 1-1000 --threads 200 --timeout 1 --banner -o scan_results.txt
```

### Example 4: Scan custom port list
```bash
python scanner.py 192.168.1.0 22,25,80,110,143,443,465,587,993,995,3306,3389
```

### Example 5: Full network scan with options
```bash
python scanner.py 192.168.1.1 1-65535 --threads 500 --timeout 1 --banner -o full_scan.txt
```

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

## Input Validation Examples

The scanner validates inputs before scanning:

```bash
# Valid inputs
python scanner.py 192.168.1.1 1-1000          # Valid range
python scanner.py localhost 22,80,443          # Valid port list
python scanner.py example.com 80               # Valid single port
python scanner.py ::1 1-1000                   # Valid IPv6

# Invalid inputs (will show error)
python scanner.py 999.999.999.999 1-1000      # Invalid IP
python scanner.py localhost 1-70000            # Port 70000 exceeds max (65535)
python scanner.py localhost 100-50             # Start > end
python scanner.py localhost -50                # Negative port
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

## Troubleshooting

### Issue: All ports appear closed even though services are running

**Solution**: Check if a firewall is blocking connections. Try:
- Increasing `--timeout` value
- Reducing `--threads` to allow proper connection handling
- Whitelisting the scanning machine's IP

### Issue: Banner grabbing returns empty/incomplete banners

**Solution**: This is normal. Not all services respond immediately:
- Some services require specific protocol commands
- HTTP services may require proper headers
- Try increasing `--timeout` value

### Issue: Scanner hangs or is very slow

**Solution**:
- Reduce `--threads` value (too many threads can overwhelm network)
- Increase `--timeout` to allow more time per connection
- Try scanning fewer ports (`1-1000` instead of `1-65535`)
- Check network connectivity to target

### Issue: Permission denied when writing output file

**Solution**: Ensure write permissions in current directory:
```bash
chmod 755 .
python scanner.py localhost 1-1000 -o results.txt
```

### Issue: Target resolution failed

**Solution**: Check hostname is resolvable:
```bash
# Linux/Mac
nslookup example.com
ping example.com

# Windows
nslookup example.com
ping example.com
```

## Testing

Run the included test suite:

```bash
python test_scanner.py
```

This tests:
- Input validation (valid/invalid port ranges)
- Port scanning on localhost
- Results formatting

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

### Version 1.0.0 (2024-12-20)
- Initial release
- Multi-threaded scanning with Queue-based distribution
- Banner grabbing support
- File export functionality
- Comprehensive input validation
- Colorized output
- Full test suite
- Detailed documentation
