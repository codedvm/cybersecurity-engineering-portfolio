
# Project 01 - Windows Endpoint Security Audit
# Version: 0.1
# Purpose: Read-only endpoint security assessment

$results = @()

function Add-AuditResult {
    param(
        [string]$Check,
        [string]$Status,
        [string]$Details
    )

    $script:results += [PSCustomObject]@{
        Check   = $Check
        Status  = $Status
        Details = $Details
    }
}

Write-Host "Windows Endpoint Security Audit"
Write-Host "-------------------------------"

# 1. Microsoft Defender
try {
    $defender = Get-MpComputerStatus -ErrorAction Stop

    if ($defender.AntivirusEnabled -and
        $defender.RealTimeProtectionEnabled) {
        Add-AuditResult "Microsoft Defender" "PASS" "Real-time AV protection enabled"
    }
    else {
        Add-AuditResult "Microsoft Defender" "REVIEW" "Defender protection not fully active; check AV configuration"
    }
}
catch {
    Add-AuditResult "Microsoft Defender" "UNKNOWN" "Unable to retrieve Defender status"
}

# 2. Windows Firewall
try {
    $profiles = Get-NetFirewallProfile -ErrorAction Stop

    foreach ($profile in $profiles) {
        $status = if ($profile.Enabled) { "PASS" } else { "REVIEW" }

        Add-AuditResult "Firewall: $($profile.Name)" $status "Enabled: $($profile.Enabled)"
    }
}
catch {
    Add-AuditResult "Windows Firewall" "UNKNOWN" "Unable to retrieve firewall profiles"
}

# 3. Secure Boot
try {
    $secureBoot = Confirm-SecureBootUEFI -ErrorAction Stop

    if ($secureBoot) {
        Add-AuditResult "Secure Boot" "PASS" "Enabled"
    }
    else {
        Add-AuditResult "Secure Boot" "REVIEW" "Disabled"
    }
}
catch {
    Add-AuditResult "Secure Boot" "UNKNOWN" "Unsupported or insufficient permissions"
}

# 4. BitLocker
try {
    $bitlocker = Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction Stop

    if ($bitlocker.ProtectionStatus -eq "On") {
        Add-AuditResult "BitLocker" "PASS" "OS drive protection enabled"
    }
    else {
        Add-AuditResult "BitLocker" "REVIEW" "OS drive protection not enabled"
    }
}
catch {
    Add-AuditResult "BitLocker" "UNKNOWN" "Unable to retrieve encryption status"
}

# 5. Installed Windows update information
try {
    $latestUpdate = Get-HotFix -ErrorAction Stop |
        Where-Object { $_.InstalledOn } |
        Sort-Object InstalledOn -Descending |
        Select-Object -First 1

    if ($latestUpdate) {
        Add-AuditResult "Windows Updates" "INFO" "Latest listed hotfix: $($latestUpdate.HotFixID)"
    }
    else {
        Add-AuditResult "Windows Updates" "UNKNOWN" "No dated hotfix records returned"
    }
}
catch {
    Add-AuditResult "Windows Updates" "UNKNOWN" "Unable to retrieve hotfix information"
}

# Display audit results
Write-Host ""
Write-Host "SECURITY AUDIT RESULTS"
$results | Format-Table -AutoSize -Wrap
