function Write-Log {
    param([string]$Message)
    $LogDir = "logs"
    if (-not (Test-Path $LogDir)) { New-Item -Path $LogDir -ItemType Directory | Out-Null }
    $LogFile = "$LogDir\adtoolkit_$(Get-Date -Format yyyy-MM-dd).log"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$Timestamp] $Message"
}
