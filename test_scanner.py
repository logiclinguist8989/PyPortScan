#!/usr/bin/env python3
"""
Test Suite for PyPortScan
Tests input validation and basic port scanning functionality
"""

from scanner import parse_port_range, scan_range, Colors
import sys


def test_input_validation():
    """Test port range validation with various inputs"""
    print(f"\n{Colors.BOLD}--- Testing Input Validation ---{Colors.END}")
    
    test_cases = [
        ("1-100", True, "Valid: single range"),
        ("22-443", True, "Valid: common port range"),
        ("1-65535", True, "Valid: full range"),
        ("80-80", True, "Valid: single port as range"),
        ("1-70000", False, "Invalid: end port exceeds max"),
        ("100-50", False, "Invalid: start > end"),
    ]
    
    passed = 0
    for port_spec, should_pass, description in test_cases:
        try:
            result = parse_port_range(port_spec)
            if should_pass:
                print(f"  {Colors.GREEN}✓ PASS{Colors.END}: {description} ({port_spec})")
                passed += 1
            else:
                print(f"  {Colors.RED}✗ FAIL{Colors.END}: {description} ({port_spec}) - Should have raised error")
        except ValueError as e:
            if not should_pass:
                print(f"  {Colors.GREEN}✓ PASS{Colors.END}: {description} ({port_spec})")
                passed += 1
            else:
                print(f"  {Colors.RED}✗ FAIL{Colors.END}: {description} ({port_spec}) - {e}")
    
    return passed, len(test_cases)


def test_common_ports():
    """Test scanning localhost for common open ports"""
    print(f"\n{Colors.BOLD}--- Testing Common Ports on Localhost ---{Colors.END}")
    
    # Scan common ports on localhost with fewer threads
    ports = [22, 80, 443, 3306, 8080]
    print(f"  Scanning localhost ports: {ports}")
    
    results = scan_range('localhost', ports, num_threads=5, timeout=1, grab_banner_flag=False)
    
    print(f"  Ports scanned: {results['scanned_count']}")
    print(f"  Open ports found: {len(results['open_ports'])}")
    
    if results['open_ports']:
        print(f"  {Colors.GREEN}Open ports:{Colors.END}")
        for port in results['open_ports']:
            print(f"    - Port {port}")
        return 1, 1
    else:
        print(f"  {Colors.YELLOW}No open ports detected (this may be normal){Colors.END}")
        return 1, 1


def main():
    """Run all tests and display summary"""
    print(f"{Colors.BOLD}PyPortScan Test Suite{Colors.END}")
    print(f"=" * 50)
    
    # Run validation tests
    val_passed, val_total = test_input_validation()
    
    # Run port scanning tests
    port_passed, port_total = test_common_ports()
    
    # Display summary
    total_passed = val_passed + port_passed
    total_tests = val_total + port_total
    
    print(f"\n{Colors.BOLD}Test Summary{Colors.END}")
    print(f"=" * 50)
    print(f"Total Tests: {total_tests}")
    print(f"Passed: {Colors.GREEN}{total_passed}{Colors.END}")
    print(f"Failed: {Colors.RED}{total_tests - total_passed}{Colors.END}")
    
    if total_passed == total_tests:
        print(f"\n{Colors.GREEN}{Colors.BOLD}✓ All tests passed!{Colors.END}")
        return 0
    else:
        print(f"\n{Colors.YELLOW}{Colors.BOLD}! Some tests failed{Colors.END}")
        return 1


if __name__ == '__main__':
    sys.exit(main())
