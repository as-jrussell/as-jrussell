# ===============================================
# 🔍 PostgreSQL RDS Scanner with PGSQL Ingest
# ===============================================

# You need the Npgsql .NET library loaded in PowerShell (use .NET 6+ or PowerShell 7+)
Add-Type -Path "C:\path\to\Npgsql.dll"

# PostgreSQL connection string
$pgConnStr = "Host=localhost;Username=your_user;Password=your_pass;Database=postgres"

# Function to run a SQL command
function Invoke-PgSql {
    param (
        [string]$Query
    )
    $conn = New-Object Npgsql.NpgsqlConnection($pgConnStr)
    $cmd = New-Object Npgsql.NpgsqlCommand($Query, $conn)
    $conn.Open()
    $cmd.ExecuteNonQuery()
    $conn.Close()
}

# Step 1: Create the InventoryDWH database if it doesn't exist
$createDbQuery = @"
DO
$$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'inventorydwh') THEN
      CREATE DATABASE inventorydwh;
   END IF;
END
$$;
"@
Invoke-PgSql -Query $createDbQuery

# Update connection string to point to the new DB
$pgConnStr = "Host=localhost;Username=your_user;Password=your_pass;Database=inventorydwh"

# Step 2: Create RDSInstances table if not exists
$createTableQuery = @"
CREATE TABLE IF NOT EXISTS rdsinstances (
    account TEXT,
    profile TEXT,
    dbinstanceidentifier TEXT,
    engine TEXT,
    dbinstanceclass TEXT,
    region TEXT,
    endpoint TEXT,
    port INT
);
"@
Invoke-PgSql -Query $createTableQuery

# Step 3: Scan AWS CLI profiles
$profiles = aws configure list-profiles
$results = @()

foreach ($profile in $profiles) {
    Write-Host "`n🛰️  Scanning profile: $profile" -ForegroundColor Cyan

    try {
        $callerIdentity = aws sts get-caller-identity --profile $profile | ConvertFrom-Json
        $accountId = $callerIdentity.Account
    } catch {
        Write-Warning "❌ Failed identity check for $profile. Skipping..."
        continue
    }

    try {
        $rdsInstances = aws rds describe-db-instances --profile $profile | ConvertFrom-Json
        foreach ($db in $rdsInstances.DBInstances) {
            if ($db.Engine -like "postgres*") {
                $results += [PSCustomObject]@{
                    Account              = $accountId
                    Profile              = $profile
                    DBInstanceIdentifier = $db.DBInstanceIdentifier
                    Engine               = $db.Engine
                    DBInstanceClass      = $db.DBInstanceClass
                    Region               = $db.AvailabilityZone.Substring(0, $db.AvailabilityZone.Length - 1)
                    Endpoint             = $db.Endpoint.Address
                    Port                 = $db.Endpoint.Port
                }
            }
        }
    } catch {
        Write-Warning "⚠️ No RDS info for $profile"
    }
}

# Step 4: Insert into PostgreSQL
foreach ($row in $results) {
    $insertQuery = @"
INSERT INTO rdsinstances (
    account, profile, dbinstanceidentifier, engine, dbinstanceclass, region, endpoint, port
) VALUES (
    '$($row.Account)', '$($row.Profile)', '$($row.DBInstanceIdentifier)', '$($row.Engine)',
    '$($row.DBInstanceClass)', '$($row.Region)', '$($row.Endpoint)', $($row.Port)
);
"@
    Invoke-PgSql -Query $insertQuery
}