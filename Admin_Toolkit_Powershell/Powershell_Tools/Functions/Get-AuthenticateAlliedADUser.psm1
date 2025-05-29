function Get-AuthenticateAlliedADUser {
    param (
        [string]$DomainController = "ADDSASLAWAD02"  # Replace with the actual domain controller or leave empty for automatic selection
    )

    # Prompt the user for credentials using a Windows pop-up dialog (Only username no need for ELDREDGE_A\ or @as.local)
    $Credential = Get-Credential -Message "Enter your AD credentials"

    # Extract the username from the entered credentials
    $Username = $Credential.UserName

    # Use Try-Catch to handle authentication success or failure
    try {
        if ($DomainController) {
            $ADUser = Get-ADUser -Credential $Credential -Server $DomainController -Filter "SamAccountName -eq '$Username'"
        } else {
            $ADUser = Get-ADUser -Credential $Credential -Filter "SamAccountName -eq '$Username'"
        }

        if ($ADUser) {
            Write-Host "Authentication successful for user: $Username"
        } else {
            Write-Host "Authentication failed for user: $Username"
        }
    } catch {
        Write-Host "Authentication failed for user: $Username"
        Write-Host "Error message: $($Error[0].Exception.Message)"
    }
}


