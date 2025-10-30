#!/usr/bin/env pwsh
# Cross-platform CLI launcher for ADToolkit
# Auto-cleans old logs and reports on startup

Import-Module "$PSScriptRoot/ADToolkit.psm1" -Force

# Clean previous logs and reports
$foldersToClean = @("logs", "reports")
foreach ($folder in $foldersToClean) {
    $path = Join-Path $PSScriptRoot $folder
    if (Test-Path $path) {
        Write-Host "🧹 Cleaning previous data in $folder..." -ForegroundColor DarkGray
        Get-ChildItem -Path $path -File | Remove-Item -Force
    }
}

function Show-Menu {
    Clear-Host
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host " Active Directory Automation Toolkit" -ForegroundColor White
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "1) Bulk Create AD Users"
    Write-Host "2) Generate Inactive User Report"
    Write-Host "3) Disable Inactive Accounts"
    Write-Host "4) Open Last HTML Report"
    Write-Host "q) Quit"
    Write-Host "--------------------------------------------"
}

do {
    Show-Menu
    $choice = Read-Host "Select an option"
    switch ($choice) {
        '1' { 
            New-BulkADUsers -CsvPath "data/sample_users.csv" -SimulationMode
            Pause
        }
        '2' { 
            Get-InactiveADUsers -DaysInactive 180
            Pause
        }
        '3' { 
            Disable-InactiveADUsers -InputCsv "data/inactive_users_report.csv"
            Pause
        }
        '4' {
            $latestReport = Get-ChildItem "reports" -Filter "*.html" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
            if ($latestReport) {
                Write-Host "🌐 Opening last HTML report: $($latestReport.Name)"
                if ($IsMacOS) { open $latestReport.FullName }
                elseif ($IsLinux) { xdg-open $latestReport.FullName }
                elseif ($IsWindows) { Start-Process $latestReport.FullName }
            }
            else {
                Write-Host "⚠️  No HTML reports found."
            }
            Pause
        }
        default { 
            if ($choice -ne 'q') { 
                Write-Host "Invalid selection"; Pause 
            } 
        }
    }
} while ($choice -ne 'q')
