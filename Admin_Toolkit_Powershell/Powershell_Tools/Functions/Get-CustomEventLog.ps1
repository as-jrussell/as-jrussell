function Get-CustomEventLog {
    # Prompt for server name with default
    $Server = Read-Host -Prompt "Enter the server name (default: 'UTPROD-API-01')"
    if ([string]::IsNullOrEmpty($Server)) {
        $Server = "UTPROD-API-01"
    }

    # Prompt for log name with default
    $LogName = Read-Host -Prompt "Enter the Windows Log name (Application, Security, System, Setup) (default: 'Application')"
    if ([string]::IsNullOrEmpty($LogName)) {
        $LogName = "Application"
    }

    # Prompt for entry type with default
    $EntryType = Read-Host -Prompt "Enter the EntryType (Error, FailureAudit, Information, SuccessAudit, Warning) (default: 'Error')"
    if ([string]::IsNullOrEmpty($EntryType)) {
        $EntryType = "Error"
    }

    # Prompt for start date with default
    $StartDate = Read-Host -Prompt "Enter the starting date (e.g., '7/18/2020' or '7/18/2020 12:00:00 AM') (default: 7 days ago)"
    if ([string]::IsNullOrEmpty($StartDate)) {
        $StartDate = (Get-Date).AddDays(-7)
    } else {
        $StartDate = [datetime]::Parse($StartDate)
    }

    # Prompt for end date with default
    $EndDate = Read-Host -Prompt "Enter the ending date (e.g., '7/18/2020' or '7/18/2020 12:00:00 AM') (default: now)"
    if ([string]::IsNullOrEmpty($EndDate)) {
        $EndDate = Get-Date
    } else {
        $EndDate = [datetime]::Parse($EndDate)
    }

    # Construct the script
    $script = @"
Get-EventLog -ComputerName '$Server' -LogName '$LogName' -EntryType '$EntryType' -After '$StartDate' -Before '$EndDate' | Out-GridView -Title 'Event Logs'
"@

    # Output the constructed script
    Write-Output "Constructed PowerShell Script:"
    Write-Output $script

    # Execute the script
    Invoke-Expression $script
}

