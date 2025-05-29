# Define the common SQL Server installation paths
$commonPaths = @(
    "C:\Program Files\Microsoft SQL Server",
    "C:\Program Files (x86)\Microsoft SQL Server",
    "C:\ProgramData\Microsoft SQL Server"
)

# Define the file name you're searching for
$fileName = "configurationfile.ini"

# Function to get SQL Server version using sqlcmd
function Get-SQLVersionFromSQLCMD {
    param ($serverInstance)
    
    $query = "SELECT @@VERSION;"
    
    try {
        # Execute SQLCMD and capture the result
        $result = sqlcmd -S $serverInstance -Q $query -h -1
        if ($result) {
            return $result
        } else {
            return "Unable to retrieve version"
        }
    } catch {
        return "SQLCMD execution failed"
    }
}

# Loop through each path and search for the file
foreach ($path in $commonPaths) {
    if (Test-Path -Path $path) {
        $files = Get-ChildItem -Path $path -Recurse -Filter $fileName -ErrorAction SilentlyContinue
        if ($files) {
            foreach ($file in $files) {
                # Derive the instance name from the path (customize this part based on your directory structure)
                $instanceName = "localhost"  # You may need to adjust or derive this dynamically
                $sqlVersion = Get-SQLVersionFromSQLCMD -serverInstance $instanceName
                Write-Host "$($file.FullName) - SQL Version: $sqlVersion"
            }
        }
    }
}
