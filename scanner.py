#!/usr/bin/env python3
"""
PyPortScan - Multi-threaded Port Scanner
A fast, efficient port scanner with banner grabbing, validation, and colorized output.
Requires: Python 3.7+
No external dependencies required (uses standard library only)
"""

import argparse
import socket
import threading
import queue
import time
import datetime
import re
import sys

# ============================================================================
# COLOR CODES FOR TERMINAL OUTPUT
# ============================================================================

class Colors:
    """ANSI color codes for terminal output"""
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    BOLD = '\033[1m'
    END = '\033[0m'


# ============================================================================
# INPUT VALIDATION FUNCTIONS
# ============================================================================

def is_valid_ip(target):
    """
    Validates if the target is a valid IPv4, IPv6, or resolvable hostname.
    
    Args:
        target (str): The target IP address or hostname
        
    Returns:
        bool: True if valid, False otherwise
    """
    # Try IPv4
    try:
        socket.inet_aton(target)
        return True
    except socket.error:
        pass
    
    # Try IPv6
    try:
        socket.inet_pton(socket.AF_INET6, target)
        return True
    except (socket.error, OSError):
        pass
    
    # Try hostname resolution
    try:
        socket.gethostbyname(target)
        return True
    except socket.gaierror:
        return False


def parse_port_range(port_range_str):
    """
    Parses a port range string and returns a list of ports to scan.
    Supports formats: "80" (single port), "1-1000" (range), "22,80,443" (list)
    
    Args:
        port_range_str (str): Port range specification
        
    Returns:
        list: List of valid ports, or empty list if invalid
        
    Raises:
        ValueError: If port values are out of valid range (1-65535)
    """
    ports = []
    
    # Handle comma-separated values
    if ',' in port_range_str:
        parts = port_range_str.split(',')
        for part in parts:
            part = part.strip()
            if part.isdigit():
                port = int(part)
                if 1 <= port <= 65535:
                    ports.append(port)
                else:
                    raise ValueError(f"Port {port} is out of range (1-65535)")
    # Handle range format (e.g., "1-1000")
    elif '-' in port_range_str:
        match = re.match(r'(\d+)-(\d+)', port_range_str)
        if match:
            start, end = int(match.group(1)), int(match.group(2))
            
            if not (1 <= start <= 65535):
                raise ValueError(f"Start port {start} is out of range (1-65535)")
            if not (1 <= end <= 65535):
                raise ValueError(f"End port {end} is out of range (1-65535)")
            if start > end:
                raise ValueError(f"Invalid range: start port ({start}) is greater than end port ({end})")
            
            ports = list(range(start, end + 1))
    # Handle single port
    elif port_range_str.isdigit():
        port = int(port_range_str)
        if 1 <= port <= 65535:
            ports.append(port)
        else:
            raise ValueError(f"Port {port} is out of range (1-65535)")
    else:
        raise ValueError(f"Invalid port format: {port_range_str}")
    
    return ports


# ============================================================================
# CORE SCANNING FUNCTIONS
# ============================================================================

def scan_port(ip, port, timeout=2):
    """
    Attempts to connect to a port using TCP to determine if it's open.
    
    Args:
        ip (str): Target IP address or hostname
        port (int): Port number to scan
        timeout (int): Connection timeout in seconds
        
    Returns:
        bool: True if port is open, False if closed
    """
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((ip, port))
        sock.close()
        return result == 0
    except (socket.timeout, socket.error, OSError):
        return False


def grab_banner(ip, port, timeout=2):
    """
    Attempts to grab the service banner from an open port.
    Handles HTTP, SSH, FTP and other services with appropriate methods.
    
    Args:
        ip (str): Target IP address or hostname
        port (int): Port number
        timeout (int): Connection timeout in seconds
        
    Returns:
        str: Service banner or empty string if unable to grab
    """
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        sock.connect((ip, port))
        
        # For HTTP services, send GET request
        if port == 80 or port == 443 or port == 8080 or port == 8443:
            sock.send(b'GET / HTTP/1.1\r\nHost: ' + ip.encode() + b'\r\nConnection: close\r\n\r\n')
        
        # Receive banner
        banner = sock.recv(1024).decode('utf-8', errors='ignore').strip()
        sock.close()
        
        # Extract first line of response
        if banner:
            first_line = banner.split('\n')[0]
            return first_line[:100]  # Limit banner length
        return ""
    except (socket.timeout, socket.error, OSError):
        return ""


# ============================================================================
# FILE EXPORT FUNCTION
# ============================================================================

def save_results(results, target, filename):
    """
    Saves scan results to a text file with timestamp and formatting.
    
    Args:
        results (dict): Dictionary with 'open_ports' list and 'scanned_count' integer
        target (str): The scanned target
        filename (str): Output filename
        
    Returns:
        bool: True if successful, False otherwise
    """
    try:
        with open(filename, 'w') as f:
            f.write(f"PyPortScan Results\n")
            f.write(f"==================\n")
            f.write(f"Target: {target}\n")
            f.write(f"Timestamp: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"Ports Scanned: {results['scanned_count']}\n")
            f.write(f"Open Ports Found: {len(results['open_ports'])}\n")
            f.write(f"\nOpen Ports:\n")
            
            if results['open_ports']:
                for port_info in results['open_ports']:
                    if isinstance(port_info, dict):
                        f.write(f"  - Port {port_info['port']}")
                        if port_info.get('banner'):
                            f.write(f": {port_info['banner']}\n")
                        else:
                            f.write(f" (open)\n")
                    else:
                        f.write(f"  - Port {port_info}\n")
            else:
                f.write("  None\n")
            
            f.write(f"\n==================\n")
        return True
    except IOError as e:
        print(f"{Colors.RED}[ERROR] Could not write to file {filename}: {e}{Colors.END}")
        return False


# ============================================================================
# MULTI-THREADING FUNCTIONS
# ============================================================================

def worker(port_queue, open_ports, scanned_count, scanned_lock, ip, timeout, grab_banner_flag):
    """
    Worker thread function that pulls ports from queue and scans them.
    Updates shared resources (open_ports, scanned_count) with thread-safe locks.
    
    Args:
        port_queue (queue.Queue): Queue of ports to scan
        open_ports (list): Shared list of open ports
        scanned_count (list): Shared count as single-element list for mutability
        scanned_lock (threading.Lock): Lock for updating shared resources
        ip (str): Target IP to scan
        timeout (int): Connection timeout
        grab_banner_flag (bool): Whether to grab banners
    """
    while True:
        port = port_queue.get()
        
        # Sentinel value signals end of work
        if port is None:
            port_queue.task_done()
            break
        
        # Scan the port
        if scan_port(ip, port, timeout):
            # Record the open port
            with scanned_lock:
                if grab_banner_flag:
                    banner = grab_banner(ip, port, timeout)
                    open_ports.append({'port': port, 'banner': banner})
                else:
                    open_ports.append(port)
        
        # Update scanned count
        with scanned_lock:
            scanned_count[0] += 1
        
        port_queue.task_done()


def scan_range(ip, ports, num_threads=100, timeout=2, grab_banner_flag=False):
    """
    Orchestrates multi-threaded port scanning using a Queue-based thread pool.
    
    Args:
        ip (str): Target IP address or hostname
        ports (list): List of ports to scan
        num_threads (int): Number of worker threads to spawn
        timeout (int): Connection timeout in seconds
        grab_banner_flag (bool): Whether to grab service banners
        
    Returns:
        dict: Results with 'open_ports' list and 'scanned_count' integer
    """
    # Shared resources
    port_queue = queue.Queue()
    open_ports = []
    scanned_count = [0]  # Use list for mutability in threads
    scanned_lock = threading.Lock()
    
    # Start worker threads
    threads = []
    for _ in range(min(num_threads, len(ports))):  # Don't spawn more threads than ports
        t = threading.Thread(
            target=worker,
            args=(port_queue, open_ports, scanned_count, scanned_lock, ip, timeout, grab_banner_flag),
            daemon=True
        )
        t.start()
        threads.append(t)
    
    # Queue all ports
    for port in ports:
        port_queue.put(port)
    
    # Add sentinel values to signal thread shutdown
    for _ in range(num_threads):
        port_queue.put(None)
    
    # Wait for queue to be processed
    port_queue.join()
    
    # Wait for all threads to finish
    for t in threads:
        t.join()
    
    # Sort open ports by port number
    if open_ports:
        if isinstance(open_ports[0], dict):
            open_ports.sort(key=lambda x: x['port'])
        else:
            open_ports.sort()
    
    return {'open_ports': open_ports, 'scanned_count': scanned_count[0]}


# ============================================================================
# MAIN FUNCTION & CLI
# ============================================================================

def main():
    """Main entry point with command-line argument parsing"""
    parser = argparse.ArgumentParser(
        description='PyPortScan - Fast multi-threaded port scanner',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python scanner.py 192.168.1.1 1-1000
  python scanner.py localhost 22,80,443,3306,8080
  python scanner.py example.com 1-65535 --threads 200 --timeout 1 --banner
  python scanner.py 192.168.1.1 1-10000 -o results.txt --banner
        """
    )
    
    parser.add_argument('target', help='Target IP address, IPv6, or hostname')
    parser.add_argument('ports', help='Port range (e.g., "1-1000") or list (e.g., "22,80,443")')
    parser.add_argument('--threads', type=int, default=100, 
                        help='Number of concurrent threads (default: 100)')
    parser.add_argument('--timeout', type=int, default=2,
                        help='Connection timeout in seconds (default: 2)')
    parser.add_argument('--banner', action='store_true',
                        help='Attempt to grab service banners')
    parser.add_argument('-o', '--output', dest='output_file',
                        help='Save results to file')
    
    args = parser.parse_args()
    
    try:
        # Validate target
        if not is_valid_ip(args.target):
            print(f"{Colors.RED}[ERROR] Invalid target: {args.target} (not a valid IP or hostname){Colors.END}")
            sys.exit(1)
        
        # Parse ports
        ports = parse_port_range(args.ports)
        if not ports:
            print(f"{Colors.RED}[ERROR] No valid ports specified{Colors.END}")
            sys.exit(1)
        
        # Inform user of scan start
        print(f"{Colors.BOLD}[*] Starting scan on {args.target}{Colors.END}")
        print(f"{Colors.BOLD}[*] Scanning {len(ports)} ports with {args.threads} threads{Colors.END}")
        if args.banner:
            print(f"{Colors.BOLD}[*] Banner grabbing enabled{Colors.END}")
        
        # Perform scan
        start_time = time.time()
        results = scan_range(args.target, ports, args.threads, args.timeout, args.banner)
        elapsed = time.time() - start_time
        
        # Display results
        print(f"\n{Colors.BOLD}[*] Scan completed in {elapsed:.2f} seconds{Colors.END}")
        print(f"{Colors.BOLD}[*] Ports scanned: {results['scanned_count']}{Colors.END}")
        print(f"{Colors.BOLD}[*] Open ports found: {len(results['open_ports'])}{Colors.END}")
        
        if results['open_ports']:
            print(f"\n{Colors.BOLD}Open Ports:{Colors.END}")
            for port_info in results['open_ports']:
                if isinstance(port_info, dict):
                    port_num = port_info['port']
                    banner = port_info.get('banner', '')
                    if banner:
                        print(f"  {Colors.GREEN}Port {port_num}: {banner}{Colors.END}")
                    else:
                        print(f"  {Colors.GREEN}Port {port_num} (open){Colors.END}")
                else:
                    print(f"  {Colors.GREEN}Port {port_info}{Colors.END}")
        else:
            print(f"\n{Colors.YELLOW}[!] No open ports found{Colors.END}")
        
        # Save to file if requested
        if args.output_file:
            if save_results(results, args.target, args.output_file):
                print(f"\n{Colors.GREEN}[+] Results saved to {args.output_file}{Colors.END}")
        
    except ValueError as e:
        print(f"{Colors.RED}[ERROR] {e}{Colors.END}")
        sys.exit(1)
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}[!] Scan interrupted by user{Colors.END}")
        sys.exit(0)
    except Exception as e:
        print(f"{Colors.RED}[ERROR] An unexpected error occurred: {e}{Colors.END}")
        sys.exit(1)


if __name__ == '__main__':
    main()
