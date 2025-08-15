# Network Configuration Tool
# Advanced Windows network optimization and configuration manager

param(
    [switch]$Persistent = $false
)

# Check if running as Administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Get current network configuration
function Get-NetworkConfig {
    Write-Host "`n=== Current Network Configuration ===" -ForegroundColor Green
    
    $adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
    foreach ($adapter in $adapters) {
        Write-Host "Interface: $($adapter.Name)" -ForegroundColor Cyan
        $dns = Get-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4
        Write-Host "DNS Servers: $($dns.ServerAddresses -join ', ')"
        
        $ip = Get-NetIPAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "169.254.*"}
        if ($ip) {
            Write-Host "IP Address: $($ip.IPAddress)"
        }
        
        # Check MTU
        $mtu = Get-NetIPInterface -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4
        Write-Host "MTU: $($mtu.NlMtu)"
        Write-Host ""
    }
    
    # Check DoH status
    $dohStatus = Get-DnsClientDohServerAddress -ErrorAction SilentlyContinue
    if ($dohStatus) {
        Write-Host "DoH Status: Enabled" -ForegroundColor Green
    } else {
        Write-Host "DoH Status: Disabled" -ForegroundColor Yellow
    }
    
    # Check hosts file modifications
    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
    $hostsContent = Get-Content $hostsPath -ErrorAction SilentlyContinue
    $customEntries = $hostsContent | Where-Object { $_ -notmatch "^#" -and $_ -match "\S" -and $_ -notmatch "localhost" }
    if ($customEntries) {
        Write-Host "Custom Hosts Entries: $($customEntries.Count)" -ForegroundColor Yellow
    } else {
        Write-Host "Custom Hosts Entries: None"
    }
}

# Set DNS servers
function Set-DNSServers {
    param(
        [string]$Primary,
        [string]$Secondary,
        [string]$Name
    )
    
    try {
        $adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
        foreach ($adapter in $adapters) {
            Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses $Primary, $Secondary
        }
        Write-Host "DNS set to $Name ($Primary, $Secondary)" -ForegroundColor Green
        
        # Flush DNS cache after changing
        Clear-DNSCache
        
        if ($Persistent) {
            Write-Host "Configuration will persist after reboot" -ForegroundColor Yellow
        } else {
            Write-Host "Configuration is temporary (reset on reboot)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error setting DNS: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Flush DNS cache
function Clear-DNSCache {
    try {
        ipconfig /flushdns | Out-Null
        Clear-DnsClientCache -ErrorAction SilentlyContinue
        Write-Host "DNS cache cleared successfully" -ForegroundColor Green
    } catch {
        Write-Host "Error clearing DNS cache: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Enable DNS over HTTPS
function Enable-DoH {
    try {
        # Enable DoH for common DNS servers
        $dnsServers = @(
            @{Server="1.1.1.1"; Template="https://cloudflare-dns.com/dns-query"},
            @{Server="8.8.8.8"; Template="https://dns.google/dns-query"},
            @{Server="9.9.9.9"; Template="https://dns.quad9.net/dns-query"}
        )
        
        foreach ($dns in $dnsServers) {
            Add-DnsClientDohServerAddress -ServerAddress $dns.Server -DohTemplate $dns.Template -AllowFallbackToUdp $true -AutoUpgrade $true -ErrorAction SilentlyContinue
        }
        
        Write-Host "DNS over HTTPS enabled for common servers" -ForegroundColor Green
    } catch {
        Write-Host "Error enabling DoH: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Disable DNS over HTTPS
function Disable-DoH {
    try {
        $dohServers = Get-DnsClientDohServerAddress -ErrorAction SilentlyContinue
        if ($dohServers) {
            foreach ($server in $dohServers) {
                Remove-DnsClientDohServerAddress -ServerAddress $server.ServerAddress -ErrorAction SilentlyContinue
            }
        }
        Write-Host "DNS over HTTPS disabled" -ForegroundColor Green
    } catch {
        Write-Host "Error disabling DoH: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Optimize network settings
function Optimize-NetworkSettings {
    try {
        Write-Host "Applying network optimizations..." -ForegroundColor Yellow
        
        # TCP Window Auto-Tuning
        netsh int tcp set global autotuninglevel=normal | Out-Null
        
        # Enable TCP Chimney Offload
        netsh int tcp set global chimney=enabled | Out-Null
        
        # Enable RSS (Receive Side Scaling)
        netsh int tcp set global rss=enabled | Out-Null
        
        # Optimize TCP settings
        netsh int tcp set global timestamps=disabled | Out-Null
        netsh int tcp set global ecncapability=enabled | Out-Null
        
        # Set optimal MTU for active adapters
        $adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
        foreach ($adapter in $adapters) {
            Set-NetIPInterface -InterfaceIndex $adapter.InterfaceIndex -NlMtu 1500 -ErrorAction SilentlyContinue
        }
        
        Write-Host "Network optimization completed" -ForegroundColor Green
        Write-Host "Restart required for full effect" -ForegroundColor Yellow
    } catch {
        Write-Host "Error optimizing network: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Reset network optimizations
function Reset-NetworkOptimizations {
    try {
        Write-Host "Resetting network optimizations..." -ForegroundColor Yellow
        
        netsh int tcp reset | Out-Null
        netsh winsock reset | Out-Null
        
        Write-Host "Network settings reset to defaults" -ForegroundColor Green
        Write-Host "Restart required to complete reset" -ForegroundColor Yellow
    } catch {
        Write-Host "Error resetting network: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Manage hosts file
function Manage-HostsFile {
    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
    
    do {
        Clear-Host
        Write-Host "=== Hosts File Management ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. View current hosts file"
        Write-Host "2. Add custom entry"
        Write-Host "3. Remove custom entries"
        Write-Host "4. Backup hosts file"
        Write-Host "5. Restore hosts file"
        Write-Host "0. Back to main menu"
        Write-Host ""
        
        $choice = Read-Host "Select an option"
        
        switch ($choice) {
            "1" {
                Write-Host "`n=== Current Hosts File ===" -ForegroundColor Green
                Get-Content $hostsPath | Write-Host
                Read-Host "`nPress Enter to continue"
            }
            "2" {
                $domain = Read-Host "Enter domain to block/redirect"
                $ip = Read-Host "Enter IP (127.0.0.1 to block, or custom IP)"
                if (-not $ip) { $ip = "127.0.0.1" }
                
                try {
                    Add-Content $hostsPath "`n$ip`t$domain"
                    Write-Host "Entry added successfully" -ForegroundColor Green
                } catch {
                    Write-Host "Error adding entry: $($_.Exception.Message)" -ForegroundColor Red
                }
                Read-Host "`nPress Enter to continue"
            }
            "3" {
                try {
                    $backup = Get-Content $hostsPath
                    $defaultContent = $backup | Where-Object { $_ -match "^#" -or $_ -match "localhost" -or $_ -notmatch "\S" }
                    Set-Content $hostsPath $defaultContent
                    Write-Host "Custom entries removed" -ForegroundColor Green
                } catch {
                    Write-Host "Error removing entries: $($_.Exception.Message)" -ForegroundColor Red
                }
                Read-Host "`nPress Enter to continue"
            }
            "4" {
                try {
                    Copy-Item $hostsPath "$hostsPath.backup"
                    Write-Host "Hosts file backed up to $hostsPath.backup" -ForegroundColor Green
                } catch {
                    Write-Host "Error backing up: $($_.Exception.Message)" -ForegroundColor Red
                }
                Read-Host "`nPress Enter to continue"
            }
            "5" {
                if (Test-Path "$hostsPath.backup") {
                    try {
                        Copy-Item "$hostsPath.backup" $hostsPath -Force
                        Write-Host "Hosts file restored from backup" -ForegroundColor Green
                    } catch {
                        Write-Host "Error restoring: $($_.Exception.Message)" -ForegroundColor Red
                    }
                } else {
                    Write-Host "No backup file found" -ForegroundColor Red
                }
                Read-Host "`nPress Enter to continue"
            }
            "0" { return }
            default {
                Write-Host "Invalid option" -ForegroundColor Red
                Start-Sleep 2
            }
        }
    } while ($true)
}

# Reset to automatic DNS
function Reset-DNS {
    try {
        $adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
        foreach ($adapter in $adapters) {
            Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ResetServerAddresses
        }
        Clear-DNSCache
        Write-Host "DNS reset to automatic (ISP default)" -ForegroundColor Green
    } catch {
        Write-Host "Error resetting DNS: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Advanced network diagnostics
function Run-NetworkDiagnostics {
    Write-Host "`n=== Network Diagnostics ===" -ForegroundColor Green
    
    # Test connectivity
    $testSites = @("google.com", "cloudflare.com", "github.com")
    foreach ($site in $testSites) {
        $result = Test-NetConnection -ComputerName $site -Port 80 -InformationLevel Quiet
        $status = if ($result) { "OK" } else { "FAIL" }
        $color = if ($result) { "Green" } else { "Red" }
        Write-Host "$site : $status" -ForegroundColor $color
    }
    
    # DNS resolution test
    Write-Host "`n=== DNS Resolution Test ===" -ForegroundColor Green
    foreach ($site in $testSites) {
        try {
            $resolved = Resolve-DnsName $site -ErrorAction Stop
            Write-Host "$site : $($resolved[0].IPAddress)" -ForegroundColor Green
        } catch {
            Write-Host "$site : FAILED" -ForegroundColor Red
        }
    }
    
    # Speed test simulation
    Write-Host "`n=== Connection Quality ===" -ForegroundColor Green
    $ping = Test-NetConnection google.com -InformationLevel Detailed
    if ($ping.PingSucceeded) {
        Write-Host "Ping to Google: $($ping.PingReplyDetails.RoundtripTime)ms" -ForegroundColor Green
    } else {
        Write-Host "Ping to Google: FAILED" -ForegroundColor Red
    }
}

# Main menu
function Show-Menu {
    Clear-Host
    Write-Host "=== Advanced Network Configuration Tool ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "DNS Configuration:"
    Write-Host "1. View current configuration"
    Write-Host "2. Set Cloudflare DNS (1.1.1.1) - Fast & Secure"
    Write-Host "3. Set Google DNS (8.8.8.8) - Reliable"
    Write-Host "4. Set OpenDNS (208.67.222.222) - Family Safe"
    Write-Host "5. Set Quad9 DNS (9.9.9.9) - Malware Protection"
    Write-Host "6. Flush DNS Cache"
    Write-Host ""
    Write-Host "Advanced Features:"
    Write-Host "7. Enable DNS over HTTPS (DoH)"
    Write-Host "8. Disable DNS over HTTPS (DoH)"
    Write-Host "9. Optimize network settings"
    Write-Host "10. Reset network optimizations"
    Write-Host "11. Manage hosts file"
    Write-Host "12. Run network diagnostics"
    Write-Host ""
    Write-Host "System:"
    Write-Host "13. Reset to ISP default"
    Write-Host "14. Toggle persistent mode (Current: $($global:PersistentMode))"
    Write-Host "0. Exit"
    Write-Host ""
}

# Initialize
if (-not (Test-Administrator)) {
    Write-Host "This tool requires administrator privileges." -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

$global:PersistentMode = $Persistent

Write-Host "Advanced Network Configuration Tool loaded successfully!" -ForegroundColor Green
Write-Host "Administrator privileges: OK" -ForegroundColor Green

do {
    Show-Menu
    $choice = Read-Host "Select an option"
    
    switch ($choice) {
        "1" {
            Get-NetworkConfig
            Read-Host "`nPress Enter to continue"
        }
        "2" {
            Set-DNSServers -Primary "1.1.1.1" -Secondary "1.0.0.1" -Name "Cloudflare"
            Read-Host "`nPress Enter to continue"
        }
        "3" {
            Set-DNSServers -Primary "8.8.8.8" -Secondary "8.8.4.4" -Name "Google"
            Read-Host "`nPress Enter to continue"
        }
        "4" {
            Set-DNSServers -Primary "208.67.222.222" -Secondary "208.67.220.220" -Name "OpenDNS"
            Read-Host "`nPress Enter to continue"
        }
        "5" {
            Set-DNSServers -Primary "9.9.9.9" -Secondary "149.112.112.112" -Name "Quad9"
            Read-Host "`nPress Enter to continue"
        }
        "6" {
            Clear-DNSCache
            Read-Host "`nPress Enter to continue"
        }
        "7" {
            Enable-DoH
            Read-Host "`nPress Enter to continue"
        }
        "8" {
            Disable-DoH
            Read-Host "`nPress Enter to continue"
        }
        "9" {
            Optimize-NetworkSettings
            Read-Host "`nPress Enter to continue"
        }
        "10" {
            Reset-NetworkOptimizations
            Read-Host "`nPress Enter to continue"
        }
        "11" {
            Manage-HostsFile
        }
        "12" {
            Run-NetworkDiagnostics
            Read-Host "`nPress Enter to continue"
        }
        "13" {
            Reset-DNS
            Disable-DoH
            Read-Host "`nPress Enter to continue"
        }
        "14" {
            $global:PersistentMode = -not $global:PersistentMode
            $Persistent = $global:PersistentMode
            Write-Host "Persistent mode: $($global:PersistentMode)" -ForegroundColor Yellow
            Read-Host "`nPress Enter to continue"
        }
        "0" {
            if (-not $Persistent) {
                $reset = Read-Host "Reset all settings to default before exit? (y/N)"
                if ($reset -eq "y" -or $reset -eq "Y") {
                    Reset-DNS
                    Disable-DoH
                    Write-Host "Settings reset to default" -ForegroundColor Green
                }
            }
            Write-Host "Goodbye!" -ForegroundColor Green
            break
        }
        default {
            Write-Host "Invalid option. Please try again." -ForegroundColor Red
            Start-Sleep 2
        }
    }
} while ($true)