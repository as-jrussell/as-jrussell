# ================================
# 🔍 PostgreSQL & Aurora Scanner
# ================================

# Get all configured AWS CLI profiles
$profiles = aws configure list-profiles

# Store results
$results = @()

foreach ($profile in $profiles) {
    Write-Host "`n🛰️  Scanning profile: $profile" -ForegroundColor Cyan

    try {
        $callerIdentity = aws sts get-caller-identity --profile $profile | ConvertFrom-Json
        $accountId = $callerIdentity.Account
        $userArn = $callerIdentity.Arn
    } catch {
        Write-Warning "❌ Failed identity check for $profile. Skipping..."
        continue
    }

    # 🔍 RDS Instances
    try {
        $rdsInstances = aws rds describe-db-instances --profile $profile | ConvertFrom-Json
        foreach ($db in $rdsInstances.DBInstances) {
            if ($db.Engine -like "postgres*") {
                $results += [PSCustomObject]@{
                    Account     = $accountId
                    Profile     = $profile
                    DBName      = $db.DBInstanceIdentifier
                    Engine      = $db.Engine
                    Status      = $db.DBInstanceStatus
                    Endpoint    = $db.Endpoint.Address
                }
            }
        }
    } catch {
        Write-Warning "⚠️  RDS fetch failed for $profile"
    }

    # 🔍 Aurora Clusters
    try {
        $clusters = aws rds describe-db-clusters --profile $profile | ConvertFrom-Json
        foreach ($cluster in $clusters.DBClusters) {
            if ($cluster.Engine -like "aurora-postgresql") {
                $results += [PSCustomObject]@{
                    Account     = $accountId
                    Profile     = $profile
                    DBName      = $cluster.DBClusterIdentifier
                    Engine      = $cluster.Engine
                    Status      = $cluster.Status
                    Endpoint    = $cluster.Endpoint
                }
            }
        }
    } catch {
        Write-Warning "⚠️  Aurora fetch failed for $profile"
    }
}

# 📊 Show Results
$results | Format-Table -AutoSize

# 💾 Optional: Export to CSV
 $results | Export-Csv -NoTypeInformation -Path "C:\GitHub\as-jrussell\AWS_CLI\aws_postgres_discovery.csv"
