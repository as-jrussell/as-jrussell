# ==========================================
# Script: run-postgres-deploy.ps1
# Purpose: Wrapper to execute Git Bash deployment script from PowerShell
# ==========================================

# --- CONFIGURATION ---
$scriptPath = "C:\GitHub\as-jrussell\OpsCenter\Administry_Of_Databases\Postgres\Postgres_Deploy\chmod\run_initial_setup.sh"
$gitBashPath = "C:\Program Files\Git\bin\bash.exe"  # Update if installed elsewhere

# Optional flags
$verboseFlag = "--verbose"

# Validate script file
if (-Not (Test-Path $scriptPath)) {
    Write-Host "❌ Deployment script not found at: $scriptPath" -ForegroundColor Red
    exit 1
}

# Validate Git Bash
if (-Not (Test-Path $gitBashPath)) {
    Write-Host "❌ Git Bash not found at: $gitBashPath" -ForegroundColor Red
    exit 1
}

# Execute the Bash script
Write-Host "🚀 Launching PostgreSQL deployment via Git Bash..." -ForegroundColor Cyan

& "$gitBashPath" "$scriptPath" $verboseFlag

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Deployment completed successfully." -ForegroundColor Green
} else {
    Write-Host "❌ Deployment failed with exit code $LASTEXITCODE" -ForegroundColor Red
}
