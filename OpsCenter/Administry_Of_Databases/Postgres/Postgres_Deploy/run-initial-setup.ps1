
# ==========================================
# Script: run-initial-setup.ps1
# Purpose: Run SQL via Git Bash using psql flags only, with controlled verbosity
# ==========================================

param(
    [string]$DbName = "DBA",
    [Parameter(Mandatory=$true)][string]$DbHost,
    [Parameter(Mandatory=$true)][string]$User,
    [string]$Database = "postgres",
    [int]$Port = 5432
)

# --- CONFIGURATION ---
$gitBashPath = "C:/Program Files/Git/bin/bash.exe"
$sqlScriptPath = "C:/GitHub/as-jrussell/Opscenter/Administry_Of_Databases/Postgres/Postgres_Deploy/000_initial_setup.sql"
$tempSqlPath = "$env:TEMP\temp_initial_setup.sql"

if (-Not (Test-Path $sqlScriptPath)) {
    Write-Host "[ERROR] Cannot find SQL script at $sqlScriptPath" -ForegroundColor Red
    exit 1
}

# Prompt for password if not already set
if (-Not $env:PGPASSWORD) {
    [Console]::Write("Enter PostgreSQL password: ")
    $securePwd = Read-Host -AsSecureString
    $pgPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd)
    )
    $env:PGPASSWORD = $pgPass
}

# Add \set dbname to top of SQL file
"\set dbname '$DbName'" | Out-File -FilePath $tempSqlPath -Encoding ASCII
Get-Content $sqlScriptPath | Add-Content -Path $tempSqlPath

# Final command for display
$displayCmd = "psql -U '$User' -h '$DbHost' -p $Port -d '$Database' -f '$tempSqlPath'"

Write-Host "`n[INFO] Running the following psql command inside Git Bash:" -ForegroundColor Cyan
Write-Host $displayCmd -ForegroundColor Yellow
Write-Host "`n[INFO] Launching SQL setup via Git Bash..."

# Only show full output if -Verbose is passed
if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"]) {
    & "$gitBashPath" -c "$displayCmd"
} else {
    & "$gitBashPath" -c "$displayCmd" *> $null
}

# Result
if ($LASTEXITCODE -eq 0) {
    Write-Host "[SUCCESS] SQL script completed successfully." -ForegroundColor Green
} else {
    $failMsg = "[FAIL] SQL script failed with exit code {0}" -f $LASTEXITCODE
    Write-Host $failMsg -ForegroundColor Red
}
