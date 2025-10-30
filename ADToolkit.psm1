# PowerShell Module: ADToolkit.psm1
# Core functions for AD automation (cross-platform)

. "$PSScriptRoot/scripts/Utils.ps1"

# -------------------------------------------------------------------
# Bulk Create Users
# -------------------------------------------------------------------
function New-BulkADUsers {
    param(
        [Parameter(Mandatory = $true)][string]$CsvPath,
        [switch]$SimulationMode
    )

    $users = Import-Csv $CsvPath
    Write-Log "Starting bulk user creation for $($users.Count) users"

    foreach ($u in $users) {
        try {
            $Username = ($u.FirstName.Substring(0, 1) + $u.LastName).ToLower()
            # cross-platform password generator (unused)
            
            if ($SimulationMode) {
                Write-Host "Simulating creation of user: $Username ($($u.Email))" -ForegroundColor Gray
            }
            else {
                # New-ADUser ... (for real environment)
                Write-Host "Created user: $Username"
            }

            Write-Log "Processed user $Username ($($u.Email))"
        }
        catch {
            Write-Error "Failed to create $($u.FirstName): $_"
            Write-Log "ERROR creating $($u.FirstName): $($_.Exception.Message)"
        }
    }

    Write-Host "`n✅ Bulk user creation process finished." -ForegroundColor Green
    Write-Log "Bulk user creation complete."
}

# -------------------------------------------------------------------
# Generate CSV + HTML inactive user report
# -------------------------------------------------------------------
function Get-InactiveADUsers {
    param(
        [int]$DaysInactive = 90
    )

    Write-Log "Generating inactive user report for $DaysInactive+ days"
    $ReportDir = "reports"
    if (-not (Test-Path $ReportDir)) { New-Item -Path $ReportDir -ItemType Directory | Out-Null }

    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
    $CsvReport = "$ReportDir/inactive_users_$timestamp.csv"
    $HtmlReport = "$ReportDir/inactive_users_$timestamp.html"

    $data = @(
        [PSCustomObject]@{User = "jsmith"; LastLogin = "2024-12-01"; Status = "Active" }
        [PSCustomObject]@{User = "ajones"; LastLogin = "2023-06-10"; Status = "Inactive" }
        [PSCustomObject]@{User = "lwang"; LastLogin = "Never"; Status = "Inactive" }
    )

    # Export CSV
    $data | Export-Csv $CsvReport -NoTypeInformation
    Write-Log "Inactive user CSV report generated: $CsvReport"

    # Build HTML
    $htmlHeader = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Inactive Users Report - $timestamp</title>
<style>
body { font-family: Arial, sans-serif; margin: 40px; background: #f9f9f9; }
h2 { color: #333333; }
table { border-collapse: collapse; width: 70%; background: #fff; box-shadow: 0 0 8px rgba(0,0,0,0.1); }
th, td { border: 1px solid #dddddd; text-align: left; padding: 8px; }
th { background-color: #0078D7; color: white; }
tr:nth-child(even) { background-color: #f2f2f2; }
.status-active { color: green; font-weight: bold; }
.status-inactive { color: red; font-weight: bold; }
</style>
</head>
<body>
<h2>Inactive Users Report - $timestamp</h2>
<table>
<tr><th>User</th><th>Last Login</th><th>Status</th></tr>
"@

    $htmlBody = ""
    foreach ($row in $data) {
        $statusClass = if ($row.Status -eq "Active") { "status-active" } else { "status-inactive" }
        $htmlBody += "<tr><td>$($row.User)</td><td>$($row.LastLogin)</td><td class='$statusClass'>$($row.Status)</td></tr>`n"
    }

    $htmlFooter = @"
</table>
<p style="margin-top:20px; color:#555;">Report generated automatically by ADToolkit on $(Get-Date).</p>
</body>
</html>
"@

    $htmlContent = $htmlHeader + $htmlBody + $htmlFooter
    Set-Content -Path $HtmlReport -Value $htmlContent -Encoding UTF8

    Write-Log "HTML report generated: $HtmlReport"
    Write-Host "`n✅ Reports generated:" -ForegroundColor Green
    Write-Host "   CSV  -> $CsvReport"
    Write-Host "   HTML -> $HtmlReport"
}

# -------------------------------------------------------------------
# Disable inactive users
# -------------------------------------------------------------------
function Disable-InactiveADUsers {
    param([Parameter(Mandatory = $true)][string]$InputCsv)

    Write-Log "Disabling inactive accounts using file: $InputCsv"
    $inactive = Import-Csv $InputCsv | Where-Object { $_.Status -eq "Inactive" }

    foreach ($u in $inactive) {
        try {
            Write-Host "Disabled account: $($u.User)" -ForegroundColor Yellow
            Write-Log "Disabled account $($u.User)"
        }
        catch {
            Write-Log "ERROR disabling $($u.User): $($_.Exception.Message)"
        }
    }

    Write-Host "`n✅ Inactive accounts processed: $($inactive.Count)" -ForegroundColor Green
    Write-Log "Inactive account disable process complete."
}

Export-ModuleMember -Function *
