# User Guide - Advanced Windows Network Configuration Tool

## Quick Start

```powershell
# Run as Administrator in PowerShell
irm https://raw.githubusercontent.com/hugle2012/win-network-config/main/install.ps1 | iex
```

## Main Features Overview

### DNS Configuration (Options 1-6)

**Option 1: View Current Configuration**
- Shows your current IP address, DNS servers, MTU settings
- Displays DoH (DNS over HTTPS) status
- Shows number of custom hosts entries

**Options 2-5: DNS Providers**
- **Cloudflare (1.1.1.1)**: Fastest, privacy-focused
- **Google (8.8.8.8)**: Most reliable, widely supported
- **OpenDNS (208.67.222.222)**: Family-safe filtering, blocks malicious sites
- **Quad9 (9.9.9.9)**: Security-focused, blocks malware automatically

**Option 6: Flush DNS Cache**
- Clears temporary DNS lookup results
- Forces fresh DNS queries
- **Note**: Does NOT change your DNS server settings

### Advanced Features (Options 7-12)

**Option 7-8: DNS over HTTPS (DoH)**
- **Enable DoH**: Encrypts DNS queries for privacy
- **Disable DoH**: Returns to standard DNS
- Works with Cloudflare, Google, and Quad9 servers

**Option 9: Network Optimization**
- Optimizes TCP window scaling
- Enables receive side scaling (RSS)
- Sets optimal MTU size (1500)
- **Restart required** for full effect

**Option 10: Reset Network Optimizations**
- Resets all network settings to Windows defaults
- Uses `netsh int tcp reset` and `netsh winsock reset`
- **Restart required** to complete

**Option 11: Hosts File Management**
Sub-menu with powerful domain control:

- **View hosts file**: See current custom entries
- **Add custom entry**: 
  - Block sites: `127.0.0.1 facebook.com`
  - Redirect domains: `8.8.8.8 mysite.com`
  - Custom server: `192.168.1.100 localserver.dev`
- **Remove custom entries**: Clean up all custom additions
- **Backup/Restore**: Save and restore hosts file

**Option 12: Network Diagnostics**
- Tests connectivity to Google, Cloudflare, GitHub
- DNS resolution speed test
- Ping quality measurement

### System Options (13-14)

**Option 13: Complete Reset**
- Resets DNS to ISP default
- Disables DNS over HTTPS
- Clears all persistent settings

**Option 14: Persistent Mode Toggle**
- **ON**: Settings survive computer restart
- **OFF**: Settings reset automatically on reboot
- Saves settings in Windows Registry

## Understanding Key Concepts

### What is DNS?
DNS (Domain Name System) translates website names (google.com) to IP addresses (172.217.164.110). Different DNS servers offer:
- **Speed**: How fast they respond
- **Privacy**: Whether they log your requests
- **Security**: Blocking malicious sites
- **Filtering**: Blocking inappropriate content

### What is DNS Cache?
Your computer stores recent DNS lookups to speed up repeat visits. Flushing cache forces fresh lookups, useful when:
- Websites aren't loading properly
- After changing DNS servers
- Testing network changes

### What is DoH (DNS over HTTPS)?
Normal DNS queries are sent in plain text. DoH encrypts them for privacy, preventing ISPs from seeing which sites you visit.

### What is the Hosts File?
A local file that overrides DNS for specific domains. Uses:
- **Ad blocking**: `127.0.0.1 ads.example.com`
- **Development**: `192.168.1.50 myapp.local`  
- **Site blocking**: `127.0.0.1 distracting-site.com`

### Persistent vs Temporary Settings
- **Persistent**: Changes survive restart (saved in Registry)
- **Temporary**: Automatically reset when computer reboots
- Choose based on whether this is permanent or just testing

## Common Use Cases

### Basic Privacy Setup
1. Run tool as Administrator
2. Choose option 2 (Cloudflare DNS)
3. Choose option 7 (Enable DoH)
4. Choose option 14 (Enable Persistent Mode)

### Maximum Security Setup  
1. Choose option 5 (Quad9 DNS) - blocks malware
2. Choose option 7 (Enable DoH) - encrypt queries
3. Choose option 11 → Add entries to block known bad domains

### Network Troubleshooting
1. Choose option 12 (Run diagnostics)
2. If slow: try option 9 (Optimize network)
3. If DNS issues: option 6 (Flush cache) then option 13 (Reset)

### Content Filtering (Family Safe)
1. Choose option 4 (OpenDNS) - built-in family filtering
2. Choose option 11 → Add custom blocks for specific sites
3. Enable persistent mode to prevent changes

## Troubleshooting

**"Access Denied" Errors**
- Must run PowerShell as Administrator
- Right-click PowerShell → "Run as Administrator"

**Changes Don't Take Effect**
- Try option 6 (Flush DNS Cache)
- Restart browser/applications
- Some changes need computer restart

**Can't Access Certain Sites**
- Check hosts file (option 11 → view)
- Try different DNS server
- Use option 13 to reset everything

**Settings Don't Persist After Reboot**
- Enable Persistent Mode (option 14)
- Check if you have registry access permissions

## Safety Notes

- All changes are reversible with option 13
- Tool only modifies Windows network settings
- No external software installed
- Registry changes are minimal and safe
- Always backup important data before system changes

## Advanced Tips

**Speed Testing DNS Servers**
Use option 12 to compare response times with different DNS servers.

**Custom Development Environment**
Use hosts file management to point development domains to local servers.

**Family Internet Safety**  
Combine OpenDNS with custom hosts entries for comprehensive filtering.

**Corporate Environment**
Use temporary mode for testing, persistent mode for permanent deployment.

## Technical Details

**Registry Location**: `HKCU:\Software\NetworkConfigTool`  
**Hosts File**: `C:\Windows\System32\drivers\etc\hosts`  
**Requirements**: Windows 10/11, PowerShell 5.1+, Admin privileges