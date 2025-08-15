# Advanced Windows Network Configuration Tool

Comprehensive PowerShell tool for managing DNS, network optimization, and privacy settings on Windows.

## Quick Start

```powershell
irm https://raw.githubusercontent.com/hugle2012/win-network-config/main/install.ps1 | iex
```

## Features

**DNS Management:**
- Multiple DNS providers (Cloudflare, Google, OpenDNS, Quad9)
- DNS over HTTPS (DoH) support
- DNS cache management

**Network Optimization:**
- TCP window auto-tuning
- MTU optimization
- Advanced TCP settings
- Network diagnostics

**Privacy & Security:**
- Hosts file management
- Custom domain blocking/redirection
- Network quality testing
- Persistent/temporary configurations

**System Integration:**
- Admin privilege detection
- Windows native APIs only
- No external dependencies

## Requirements

- Windows 10/11
- Administrator privileges
- PowerShell 5.1+

## Usage

The tool provides an interactive menu with 14+ options:
1. DNS configuration (4 providers)
2. Advanced DoH settings
3. Network optimization
4. Hosts file management
5. Network diagnostics
6. System reset options

## Legal Notice

This tool is for legitimate network configuration purposes only. Users are responsible for compliance with local laws and network policies.

## Disclaimer

Use at your own risk. Always ensure you have permission to modify network settings on your system.