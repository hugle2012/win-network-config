# User Guide - Advanced Windows Network Configuration Tool

## Overview
This tool is a comprehensive Windows network optimization and configuration manager designed for both casual users and power users. It provides easy-to-use interfaces for advanced network configurations that would normally require complex command-line operations.

## Quick Start
1. **Run as Administrator**: Right-click PowerShell and select "Run as Administrator"
2. **Execute the script**: Navigate to the script directory and run `.\install.ps1`
3. **Choose your option**: Use the numbered menu to select desired operations

```powershell
# Run as Administrator in PowerShell
irm https://raw.githubusercontent.com/hugle2012/win-network-config/main/install.ps1 | iex
```

### 1. DNS Configuration (Options 1-6)

#### When to Use:
- **Slow internet browsing** - DNS issues often cause slow page loads
- **Gaming lag** - Better DNS can reduce ping and improve connection stability
- **Streaming issues** - Faster DNS resolution for video platforms
- **Work from home** - Reliable DNS for remote work applications

#### Popular DNS Options:
- **Cloudflare (1.1.1.1)** - Best for speed and privacy
- **Google (8.8.8.8)** - Most reliable and widely supported
- **OpenDNS (208.67.222.222)** - Good for family safety features
- **Quad9 (9.9.9.9)** - Excellent malware protection

#### Option 6 - Flush DNS Cache:
Use this when:
- Websites not loading properly
- DNS changes not taking effect
- After changing DNS servers
- General network troubleshooting

### 2. Advanced Features (Options 7-12)

#### Option 7-8: DNS over HTTPS (DoH)
**When to Enable:**
- Privacy-conscious users
- Public WiFi networks
- Corporate environments with strict security
- Bypassing ISP DNS restrictions

**When to Disable:**
- Corporate networks with specific DNS requirements
- Troubleshooting DNS issues
- Some VPN configurations

#### Option 9: Optimize Network Settings
**Use this when experiencing:**
- Slow download/upload speeds
- High ping in games
- Video streaming buffering
- Network lag during video calls
- Poor performance on high-speed connections

**What it does:**
- Optimizes TCP settings for better throughput
- Enables hardware acceleration features
- Configures optimal MTU settings
- Improves multi-core network processing

**Note:** Restart required for full effect

#### Option 10: Reset Network Optimizations
**Use this when:**
- Option 9 causes network issues
- Experiencing connection problems after optimization
- Want to return to Windows default settings
- Troubleshooting network problems

#### Option 11: Hosts File Management
**What is the hosts file?**
A system file that maps domain names to IP addresses, allowing you to:
- Block websites (redirect to 127.0.0.1)
- Redirect domains to different IPs
- Bypass DNS for specific sites
- Create local development environments

**When to use:**
- **Block ads and trackers** - Redirect ad domains to 127.0.0.1
- **Parental control** - Block inappropriate websites
- **Development** - Point domains to local servers
- **Security** - Block known malicious sites
- **Testing** - Redirect production domains to staging

**Custom Entries Examples:**
```
# Block ads
127.0.0.1    ads.google.com
127.0.0.1    doubleclick.net

# Block social media
127.0.0.1    facebook.com
127.0.0.1    twitter.com

# Development redirects
192.168.1.100    mysite.local
192.168.1.101    api.mysite.local

# Block malicious sites
127.0.0.1    malware-site.com
127.0.0.1    phishing-attempt.net
```

**Safety Tips:**
- Always backup before editing
- Use 127.0.0.1 to block (localhost)
- Test entries before applying broadly
- Remove entries if they cause issues

#### Option 12: Network Diagnostics
**Use this for:**
- Troubleshooting connection issues
- Testing DNS resolution
- Checking website accessibility
- Measuring connection quality
- Pre-flight checks before important online activities

### 3. System Management (Options 13-14)

#### Option 13: Reset to ISP Default
**Use this when:**
- Want to return to original settings
- Experiencing persistent issues
- Selling/giving away the computer
- Troubleshooting complex network problems
- ISP requires specific DNS settings

#### Option 14: Persistent Mode Toggle
**What it does:**
- **ON**: Settings persist after reboot
- **OFF**: Settings reset to default on restart

**When to use Persistent Mode:**
- Personal computers you want to keep configured
- Gaming rigs with optimized settings
- Work machines with specific requirements
- When you're satisfied with current configuration

**When to turn OFF:**
- Testing different configurations
- Troubleshooting
- Shared computers
- Temporary network changes

## Common Use Cases

### For Gamers:
1. Set Cloudflare DNS (Option 2)
2. Enable DoH (Option 7)
3. Optimize network settings (Option 9)
4. Enable persistent mode (Option 14)

### For Privacy-Conscious Users:
1. Set Cloudflare or Quad9 DNS (Options 2 or 5)
2. Enable DoH (Option 7)
3. Use hosts file to block trackers (Option 11)
4. Enable persistent mode (Option 14)

### For Work/Professional Use:
1. Set Google DNS for reliability (Option 3)
2. Test network diagnostics (Option 12)
3. Keep persistent mode OFF for flexibility
4. Use hosts file for development (Option 11)

### For Troubleshooting:
1. Run diagnostics (Option 12)
2. Flush DNS cache (Option 6)
3. Reset to ISP default (Option 13)
4. Reset network optimizations (Option 10)

## Safety and Best Practices

### Before Making Changes:
- Backup current settings
- Note down original DNS servers
- Test on non-critical devices first
- Have a recovery plan

### After Making Changes:
- Test internet connectivity
- Verify important websites work
- Check if gaming/streaming improved
- Monitor for any issues

### Recovery Steps:
- Use Option 13 to reset everything
- Disable DoH if having issues
- Clear hosts file entries if problems persist
- Restart computer if needed

## Troubleshooting

### Common Issues:
- **"Access Denied"**: Run as Administrator
- **Settings not persisting**: Check persistent mode status
- **Slow performance after optimization**: Use Option 10 to reset
- **Websites not loading**: Flush DNS cache (Option 6)
- **Can't access certain sites**: Check hosts file entries

### When to Seek Help:
- Network completely down after changes
- Persistent errors despite resets
- Corporate network restrictions
- Advanced networking requirements

## Advanced Tips

### Custom DNS Combinations:
- Primary: 1.1.1.1 (Cloudflare)
- Secondary: 8.8.8.8 (Google)
- Provides redundancy and fallback

### Hosts File Advanced Usage:
- Block entire ad networks
- Create local development shortcuts
- Implement basic firewall rules
- Test website changes locally

### Performance Monitoring:
- Use Option 12 regularly
- Compare ping times before/after changes
- Monitor download speeds
- Check for DNS resolution improvements

## Support and Updates

This tool is designed to be self-contained and doesn't require internet updates. However, for the best experience:
- Keep Windows updated
- Update network drivers
- Monitor for new DNS providers
- Stay informed about network security best practices

---

**Remember**: This tool gives you powerful control over your network. Use it wisely, test changes thoroughly, and always have a recovery plan. When in doubt, the reset options (10 and 13) will get you back to a working state.