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
        param ($instanceName, $commonPaths, $fileName)


        # Loop through each path and search for the file
        foreach ($path in $commonPaths) {
            if (Test-Path -Path $path) {
                $files = Get-ChildItem -Path $path -Recurse -Filter $fileName -ErrorAction SilentlyContinue
                if ($files) {
                    foreach ($file in $files) {
                        "$($file.FullName) "
                    }
                }
            }
        }
    }

    # Execute the script block on the remote server
    Invoke-Command -ComputerName $remoteServer -ScriptBlock $scriptBlock -ArgumentList $instanceName, $commonPaths, $fileName
}

# Example usage
 Get-RemoteSQLVersion -remoteServer "UTSTAGE-UTL1" -instanceName "SQLInstanceName"
