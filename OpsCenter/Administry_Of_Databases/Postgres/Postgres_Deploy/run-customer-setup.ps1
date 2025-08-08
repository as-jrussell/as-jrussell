# ==========================================
# Script: run-customer-setup.ps1
# Purpose: Run parameterized SQL using Git Bash with optional verbosity
# ==========================================

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$CustomerDbName,
    [Parameter(Mandatory=$true)][string]$SchemaName,
    [Parameter(Mandatory=$true)][string]$DbHost,
    [Parameter(Mandatory=$true)][string]$User,
    [string]$Database = "DBA",
    [int]$Port = 5432
)

# --- CONFIGURATION ---
$gitBashPath = "C:/Program Files/Git/bin/bash.exe"
$sqlScriptPath = "C:/GitHub/as-jrussell/Opscenter/Administry_Of_Databases/Postgres/Postgres_Deploy/DatabaseName.sql"
$tempSqlPath = "$env:TEMP\temp_databasename_setup.sql"

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

# Create param injection at the top
$paramBlock = @"
\set customerdbname '$CustomerDbName'
\set schemaname '$SchemaName'
"@

$paramBlock | Out-File -FilePath $tempSqlPath -Encoding ASCII
Get-Content $sqlScriptPath | Add-Content -Path $tempSqlPath

# Build the psql command
$psqlCmd = "psql -U '$User' -h '$DbHost' -p $Port -d '$Database' -f '$tempSqlPath'"

# Print minimal info by default
Write-Host "[INFO] Launching customer setup via Git Bash..."


    Write-Host "`n[VERBOSE] Running the following psql command inside Git Bash:" -ForegroundColor Cyan
    Write-Host $psqlCmd -ForegroundColor Yellow


# Execute
if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"]) {
    & "$gitBashPath" -c "$psqlCmd"
} else {
    & "$gitBashPath" -c "$psqlCmd" *> $null
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "[SUCCESS] Customer setup completed successfully." -ForegroundColor Green
} else {
    $failMsg = "[FAIL] Setup failed with exit code {0}" -f $LASTEXITCODE
    Write-Host $failMsg -ForegroundColor Red
}