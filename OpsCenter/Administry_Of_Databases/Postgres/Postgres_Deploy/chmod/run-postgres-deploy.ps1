
# ==========================================
# Script: run-postgres-wrapper.ps1
# Purpose: Clean wrapper for Git Bash deployment — supports -Verbose only
# ==========================================

param(
    [switch]$Verbose
)

# --- CONFIGURATION ---
$scriptPath = "C:/GitHub/as-jrussell/Opscenter/Administry_Of_Databases/Postgres/Postgres_Deploy/chmod/run_initial_setup.sh"
$gitBashPath = "C:/Program Files/Git/bin/bash.exe"

if (-Not (Test-Path $scriptPath)) {
    Write-Host "❌ ERROR: Cannot find the script at $scriptPath" -ForegroundColor Red
    exit 1
}

# Quote and assemble full Bash command
$bashCommand = "`"$scriptPath`""
if ($Verbose) {
    $bashCommand += " --verbose"
}

Write-Host "`n🚀 Launching PostgreSQL deployment via Git Bash..."
& "$gitBashPath" -c "bash $bashCommand"

# Report result
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Deployment completed successfully." -ForegroundColor Green
} else {
    Write-Host ("❌ Deployment failed with exit code {0}" -f $LASTEXITCODE) -ForegroundColor Red
}
