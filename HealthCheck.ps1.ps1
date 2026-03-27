# Automated PC Health Check Script
# Author: Caleb
# Purpose: Run basic diagnostics on a Windows PC

Write-Host "=== Automated PC Health Check ==="

# 1. Internet Connectivity Test
Write-Host "`n[Internet Connectivity]"
try {
    Test-Connection -ComputerName google.com -Count 2 -ErrorAction Stop | Out-Null
    Write-Host "Internet: Connected"
} catch {
    Write-Host "Internet: Not Connected"
}

# 2. Disk Space Usage
Write-Host "`n[Disk Space]"
Get-PSDrive -PSProvider 'FileSystem' | ForEach-Object {
    Write-Host "$($_.Name): $([math]::Round($_.Free/1GB,2)) GB free of $([math]::Round($_.Used/1GB + $_.Free/1GB,2)) GB"
}

# 3. CPU & Memory Usage
Write-Host "`n[CPU & Memory]"
$cpu = Get-Counter '\Processor(_Total)\% Processor Time'
$mem = Get-Counter '\Memory\% Committed Bytes In Use'
Write-Host "CPU Usage: $([math]::Round($cpu.CounterSamples.CookedValue,2))%"
Write-Host "Memory Usage: $([math]::Round($mem.CounterSamples.CookedValue,2))%"

# 4. Startup Programs
Write-Host "`n[Startup Programs]"
Get-CimInstance Win32_StartupCommand | Select-Object Name, Command | Format-Table -AutoSize
