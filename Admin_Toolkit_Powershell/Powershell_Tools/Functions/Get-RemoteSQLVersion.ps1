function Get-RemoteSQLVersion {
    param (
        [string]$remoteServer,      # The remote server name or IP
        [string]$instanceName = "localhost"  # The SQL Server instance name (default: localhost)
    )

    # Define the common SQL Server installation paths on the remote server
    $commonPaths = @(
        "C:\Program Files\Microsoft SQL Server",
        "C:\Program Files (x86)\Microsoft SQL Server",
        "C:\ProgramData\Microsoft SQL Server"
    )

    # Define the file name you're searching for
    $fileName = "configurationfile.ini"

    # Script block to execute remotely
    $scriptBlock = {
        param ($instanceName, $commonPaths, $fileName, $remoteServer)
        
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

        # Convert local drive path to UNC network path
        function ConvertToUNCPath {
            param ($localPath, $remoteServer)

            # Ensure the drive letter and path is converted to UNC format
            if ($localPath -match "^([A-Z]):\\") {
                $driveLetter = $matches[1]
                $networkPath = $localPath -replace "^([A-Z]):\\", "\\$remoteServer\$driveLetter`$\"
            } else {
                $networkPath = $localPath
            }

            return $networkPath
        }

        # Loop through each path and search for the file
        foreach ($path in $commonPaths) {
            if (Test-Path -Path $path) {
                $files = Get-ChildItem -Path $path -Recurse -Filter $fileName -ErrorAction SilentlyContinue
                if ($files) {
                    foreach ($file in $files) {
                        # Get SQL Server version for the instance
                        $sqlVersion = Get-SQLVersionFromSQLCMD -serverInstance $instanceName
                        
                        # Convert local file path to network UNC path
                        $networkPath = ConvertToUNCPath -localPath $file.FullName -remoteServer $remoteServer
                        
                        # Get the directory path minus the file and extension
                        $directoryPath = [System.IO.Path]::GetDirectoryName($networkPath)

                        # Output SQL version, network path, and directory path
                        "SQL Version: $sqlVersion
                        "
                          "Network Path (with file): $networkPath
                          "

                        "(go to this location and copy the ConfigurationFile.ini file) --> Directory Path: $directoryPath "

                      
                    }
                }
            }
        }
    }

    # Execute the script block on the remote server
    Invoke-Command -ComputerName $remoteServer -ScriptBlock $scriptBlock -ArgumentList $instanceName, $commonPaths, $fileName, $remoteServer
}

# Example usage
# Get-RemoteSQLVersion -remoteServer "RemoteServerNameOrIP" -instanceName "SQLInstanceName"

