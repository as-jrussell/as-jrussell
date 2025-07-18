# ===============================
# J.C.'s Working Postgres Scanner
# CLI creds must already be set
# Region: us-east-1
# ===============================

# Timestamped output file location
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputFile = "C:\GitHub\as-jrussell\AWS_CLI\postgres_discovery_$timestamp.txt"

# Ensure the directory exists
$folder = [System.IO.Path]::GetDirectoryName($outputFile)
if (-not (Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

# Run the damn thing
Write-Output "Standard PostgreSQL RDS Instances:" | Out-File -FilePath $outputFile
aws rds describe-db-instances `
    --query "DBInstances[?Engine=='postgres'].{Type:'RDS',Identifier:DBInstanceIdentifier,Status:DBInstanceStatus,Endpoint:Endpoint.Address}" `
    --output table | Out-File -FilePath $outputFile -Append

Write-Output "`nAurora PostgreSQL Clusters:" | Out-File -FilePath $outputFile -Append
aws rds describe-db-clusters  `
    --query "DBClusters[?Engine=='aurora-postgresql'].{Type:'Aurora',Identifier:DBClusterIdentifier,Status:Status,Endpoint:Endpoint}" `
    --output table | Out-File -FilePath $outputFile -Append

Write-Output "`n✅ Scan complete. Output saved to: $outputFile" | Out-File -FilePath $outputFile -Append

# Optional: open the result
Invoke-Item $outputFile


