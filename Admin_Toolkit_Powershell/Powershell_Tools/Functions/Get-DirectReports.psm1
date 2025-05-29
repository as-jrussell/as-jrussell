# Function to get direct reports of a user
function Get-DirectReports {
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserName,
        
        [Parameter(Mandatory = $false)]
        [PSCredential]$Credential,
        
        [Parameter(Mandatory = $false)]
        [string]$OutputFilePath
    )

    # If no credential is provided, use the current user's credentials
    if (-not $Credential) {
        $Credential = Get-Credential
    }

    # Get the distinguished name of the user
    $user = Get-ADUser -Credential $Credential -Identity $UserName -Properties directReports

    if ($user -eq $null) {
        Write-Host "User not found."
        return
    }

    # Get direct reports
    $directReports = $user.directReports

    if ($directReports -eq $null) {
        Write-Host "$UserName has no direct reports."
        return
    }

    # Collect results in an array
    $results = @()

    # Output the direct reports
    foreach ($report in $directReports) {
        $reportUser = Get-ADUser -Credential $Credential -Identity $report -Properties DisplayName, Title, SAMAccountName
        $results += [PSCustomObject]@{
            Name            = $reportUser.DisplayName
            Title           = $reportUser.Title
            SAMAccountName  = "ELDREDGE_A\" + $reportUser.SAMAccountName
        }
    }

    # Check if OutputFilePath is provided
    if ($OutputFilePath) {
        # Export results to CSV
        $results | Export-Csv -Path $OutputFilePath -NoTypeInformation
        Write-Host "Direct reports exported to $OutputFilePath"
    } else {
        # Display results on the screen
        $results | Format-Table -AutoSize
    }
}

# Main script execution
$userName = Read-Host -Prompt "Enter the username of the manager (e.g., jdoe)"
$outputFilePath = Read-Host -Prompt "Enter the path for the output file (leave blank to display on screen) and press Enter"

# Call the function, optionally providing credentials
Get-DirectReports -UserName $userName -OutputFilePath $outputFilePath
